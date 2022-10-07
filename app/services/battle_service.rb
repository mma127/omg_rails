class BattleService
  class BattleValidationError < StandardError; end

  # Cable message types
  CREATED_BATTLE = "created_battle".freeze
  PLAYER_JOINED = "player_joined".freeze
  PLAYER_JOINED_FULL = "player_joined_full".freeze
  PLAYER_READY = "player_ready".freeze
  PLAYER_ALL_READY = "player_all_ready".freeze
  BATTLEFILE_GENERATED = "battlefile_generated".freeze
  PLAYER_LEFT = "player_left".freeze
  REMOVE_BATTLE = "removed_battle".freeze

  def initialize(player)
    @player = player
  end

  def create_battle(name, size, ruleset_id, initial_company_id)
    # Validate the player is not already in a non-final battle
    validate_player_can_create_battle

    # Validate the given company id matches a company belonging to the player and ruleset
    ruleset = validate_ruleset(ruleset_id)
    company = validate_company(initial_company_id, ruleset)
    # Validate player owns company
    validate_player_company(company)

    # Validate company has all valid platoons
    validate_company_platoons(company)

    ActiveRecord::Base.transaction do
      # Create new Battle for the ruleset, of name and size, and add the player's company to it
      battle = Battle.create!(name: name, size: size, ruleset: ruleset)
      BattlePlayer.create!(battle: battle, player: @player, company: company, side: company.side)

      # Broadcast
      message_hash = { type: CREATED_BATTLE, battle: battle.reload }
      # battle_message = Battle::Entity.represent(battle, type: :include_players)
      battle_message = Entities::BattleMessage.represent message_hash, type: :include_players
      broadcast_cable(battle_message)
    end
  end

  def join_battle(battle_id, company_id)
    # Validate battle exists
    battle = validate_battle(battle_id)
    # Validate battle is joinable
    validate_battle_joinable(battle)

    # Validate company exists and is of the same ruleset as the battle
    company = validate_company(company_id, battle.ruleset)
    # Validate player owns company
    validate_player_company(company)

    # Validate Battle has open slot on side of the company's faction
    validate_battle_has_open_spot(battle, company)

    # Validate company has all valid platoons
    validate_company_platoons(company)

    # Add company to battle
    ActiveRecord::Base.transaction do
      BattlePlayer.create!(battle: battle, player: @player, company: company, side: company.side)

      # If this causes the battle to be full, make that change
      if battle.reload.players_full?
        battle.full!
        type = PLAYER_JOINED_FULL
      else
        type = PLAYER_JOINED
      end

      # Broadcast battle update
      message_hash = { type: type, battle: battle.reload }
      battle_message = Entities::BattleMessage.represent message_hash, type: :include_players
      broadcast_cable(battle_message)
    end
  end

  def ready_player(battle_id)
    # Validate battle exists
    battle = validate_battle(battle_id)

    # Validate battle is readyable
    validate_battle_readyable(battle)

    # Validate the player is in the battle
    validate_player_in_battle(battle)

    BattlePlayer.find_by(battle: battle, player: @player).update!(ready: true)

    # If the battle has all players ready, move to generating state
    if battle.reload.players_ready?
      battle.ready!
      type = PLAYER_ALL_READY
      BattlefileGenerationJob.perform_async(battle_id)
    else
      type = PLAYER_READY
    end

    # Broadcast battle update
    message_hash = { type: type, battle: battle }
    battle_message = Entities::BattleMessage.represent message_hash, type: :include_players
    broadcast_cable(battle_message)
  end

  def leave_battle(battle_id)
    # Validate battle exists
    battle = validate_battle(battle_id)

    # Validate battle is leavable
    validate_battle_leavable(battle)

    # Validate the player is in the battle
    validate_player_in_battle(battle)

    # Attempt to remove player from battle
    BattlePlayer.find_by(battle: battle, player: @player).destroy

    if battle.full?
      battle.not_full!
    end

    if battle.reload.battle_players.count == 0
      # Deleted the last player, delete the battle
      battle.destroy
      message_hash = { type: REMOVE_BATTLE, battle: battle }
    else
      message_hash = { type: PLAYER_LEFT, battle: battle.reload }
    end

    # Broadcast battle update
    battle_message = Entities::BattleMessage.represent message_hash, type: :include_players
    broadcast_cable(battle_message)
  end

  private

  def broadcast_cable(message)
    ActionCable.server.broadcast BattlesChannel::CHANNEL, message
  end

  def validate_battle(battle_id)
    battle = Battle.find(battle_id)
    raise BattleValidationError.new "Invalid battle #{battle_id}" unless battle.present?
    battle
  end

  def validate_battle_leavable(battle)
    raise BattleValidationError.new "Cannot leave battle in #{battle.state} state" unless battle.leavable
  end

  def validate_battle_joinable(battle)
    raise BattleValidationError.new "Cannot join battle in #{battle.state} state" unless battle.joinable
  end

  def validate_battle_readyable(battle)
    raise BattleValidationError.new "Cannot ready up in a battle in #{battle.state} state" unless battle.full?
  end

  def validate_player_in_battle(battle)
    raise BattleValidationError.new "Player #{@player.name} is not in battle #{battle.id}" unless battle.battle_players.find_by(player: @player).present?
  end

  def validate_ruleset(ruleset_id)
    ruleset = Ruleset.find(ruleset_id)
    raise BattleValidationError.new "Invalid Ruleset id #{ruleset_id}" unless ruleset.present?
    ruleset
  end

  # Validate the given company id matches a company belonging to the player and ruleset
  def validate_company(company_id, ruleset)
    company = Company.find(company_id)
    raise BattleValidationError.new "Invalid Company id #{company_id}" unless company.present?
    raise BattleValidationError.new "Company #{company_id} has mismatched ruleset, expected #{ruleset.id} got #{company.ruleset.id}" unless company.ruleset == ruleset
    company
  end

  # Validate the player owns the company
  def validate_player_company(company)
    raise BattleValidationError.new "Player #{@player.id} does not own company #{company.id}" unless company.player == @player
  end

  # Validate the player is not already in a non-final battle
  def validate_player_can_create_battle
    unless BattlePlayer.in_active_battle.where(player: @player).count == 0
      raise BattleValidationError.new "Player #{@player.id} cannot create a new game while in an existing game"
    end
  end

  # Validate Battle has open slot on side of the company's faction
  def validate_battle_has_open_spot(battle, company)
    unless BattlePlayer.where(battle: battle, side: company.side).count < battle.size
      raise BattleValidationError.new "Battle #{battle.id} has no available #{company.side} spots"
    end
  end

  def validate_company_platoons(company)
    categories_by_platoons = get_company_squads_by_platoon(company)

    raise BattleValidationError.new "Company cannot be empty" if categories_by_platoons.empty?

    categories_by_platoons.each do |category, category_platoons|
      # Category_platoons is a hash of category_position (platoon index) to an array of squads
      category_platoons.each do |position, squads|
        platoon_pop = squads.sum { |s| s.pop }
        unless platoon_pop == 0 || (CompanyService::MIN_POP_PER_PLATOON <= platoon_pop && platoon_pop <= CompanyService::MAX_POP_PER_PLATOON)
          raise BattleValidationError.new "Platoon at #{category} #{position} has invalid pop #{platoon_pop}"
        end
      end
    end
  end

  def get_company_squads_by_platoon(company)
    categories_hash = company.squads.group_by { |s| s[:tab_category] }
    categories_hash.transform_values { |category_squads| category_squads.group_by { |s| s[:category_position]} }
  end
end
