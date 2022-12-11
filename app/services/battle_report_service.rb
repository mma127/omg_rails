class BattleReportService
  class BattleReportValidationError < StandardError; end

  RUBBERBAND_VET = 5

  def initialize(battle_id)
    @battle = Battle.includes(players: :companies, companies: [:squads, :available_units]).find_by!(id: battle_id)
  end

  def self.enqueue_report(battle_id, is_final, reporting_player_name, time_elapsed, race_winner, map_name,
                          dead_squads, surviving_squads, dropped_players, battle_stats)
    Rails.logger.info("Enqueuing BattleReportJob for battle #{battle_id} with params:")
    Rails.logger.info("is_final #{is_final}, reporting player #{reporting_player_name}, time_elapsed #{time_elapsed}, winner #{race_winner}")
    Rails.logger.info("dead_squads #{dead_squads}, surviving_squads #{surviving_squads}")
    BattleReportJob.perform_async(battle_id, is_final, reporting_player_name, time_elapsed, race_winner, map_name,
                                  dead_squads, surviving_squads, dropped_players, battle_stats)
  end

  def process_report(battle_id, is_final, reporting_player_name, time_elapsed, race_winner, map_name,
                     dead_squads, surviving_squads, dropped_players, battle_stats)
    # Get lock on battle to prevent duplicate updates to associated companies
    # Just lock the read of the battle's state and update of the battle's state to reporting
    Rails.logger.info("Starting processing of battle report for Battle #{battle_id}")
    @battle.with_lock do
      if @battle.reporting? || @battle.final?
        Rails.logger.info("Battle #{battle_id} is already in '#{@battle.state}' state, skipping battle report processing")
        return
      end
      validate_battle_ingame

      # Transition battle to reporting
      Rails.logger.info("Transitioning battle #{battle_id} state to reporting")
      @battle.reporting!

      ## Update squads
      # Update surviving squads with vet
      # Add resupply availability
      # Auto rebuild
      # Remove dead squads
      starting_squads_by_id = @battle.squads.index_by(&:id)
      starting_squads_by_id = update_surviving_squads(starting_squads_by_id, surviving_squads)
      add_rubberband_vet(starting_squads_by_id)

      @battle.companies.each do |c|
        add_company_availability(c)
      end

      autorebuild_dead_squads(dead_squads)

      ## Update company resources after rebuild
      recalculate_company_resources

      ## Update company and player VPs
      add_company_vps
      add_player_vps

      # TODO Update battle stats
      # TODO Reset squad stats after autorebuild

      # BattleReports table to hold historical?

      finalize_battle(race_winner)

      Rails.logger.info("Finished processing battle report for battle #{battle_id}")
    rescue StandardError => e
      Rails.logger.error("Failed to process battle report for battle #{battle_id}, error: #{e.message}")
      raise
    end

    begin
      Rails.logger.info("Attempting to send battle_finalized cable")
      service = BattleService.new(nil)
      service.finalize_battle(@battle)
    rescue StandardError => e
      # Catch but don't raise again
      Rails.logger.error("Failed to broadcast battle_finalized cable for battle #{@battle.id}, error: #{e.full_message}")
    end
  end

  private

  def validate_battle_ingame
    # Validate it is still in "ingame" state
    raise BattleReportValidationError.new "Invalid battle state '#{@battle.state}', expected 'ingame'" unless @battle.ingame?
  end

  # surviving_squads is a string in the format [squad_id],[experience];[squad_id],[experience];...
  def update_surviving_squads(starting_squads_by_id, surviving_squads)
    # From these starting squads, they will either be surviving squads with exp, dead squads to delete, or if neither
    # they are not called in. TODO do we give exp for squads not called in?
    squad_exp_pairs = surviving_squads.split(';')
    Rails.logger.info("Updating exp for #{squad_exp_pairs.size} surviving squads")
    squads_to_update = []
    # For all surviving squads with exp, remove from the starting_squads_by_id hash and update the squad vet value
    squad_exp_pairs.each do |squad_exp_str|
      squad_id, exp = squad_exp_str.split(',')
      squad = starting_squads_by_id.delete(squad_id.to_i)
      squad.vet = exp.to_f
      squads_to_update << squad
    end
    Squad.import!(squads_to_update, on_duplicate_key_update: { conflict_target: [:id], columns: [:vet] })
    starting_squads_by_id
  end

  def add_rubberband_vet(starting_squads_by_id)
    # Add 5xp TODO rubber band
    Rails.logger.info("Adding rubberband exp for #{starting_squads_by_id.size} squads")
    starting_squads_by_id.values.each do |squad|
      squad.vet += RUBBERBAND_VET
    end
    Squad.import!(starting_squads_by_id.values.to_a, on_duplicate_key_update: { conflict_target: [:id], columns: [:vet] })
    starting_squads_by_id
  end

  # For a company, update available_unit available value
  # This is the minimum of available + resupply and the resupply_max
  def add_company_availability(company)
    Rails.logger.info("Adding available_unit resupply for company #{company.id}")
    available_units_update = []
    company.available_units.each do |au|
      new_availability = [au.available + au.resupply, au.resupply_max].min
      if new_availability != au.available
        au.available = new_availability
        available_units_update << au
      end
    end

    Rails.logger.info("Saving #{available_units_update.size} available_unit updates")
    AvailableUnit.import!(available_units_update, on_duplicate_key_update: { conflict_target: [:id], columns: [:available] })
  end

  # Attempt to autorebuild dead squads
  # available_unit.available has already been updated, we are reconciling squads against that value
  # dead_squads_str is a string in the format [squad_id];[squad_id];...
  def autorebuild_dead_squads(dead_squads_str)
    dead_squad_ids = dead_squads_str.split(";")
    dead_squads_by_available_unit = Squad.includes(:available_unit).where(id: dead_squad_ids).group_by(&:available_unit_id)
    squads_to_update = []
    dead_squads_by_available_unit.each do |available_unit_id, squads|
      # Per available_unit, can get the available_unit available value at the start and update for all squads before saving
      available_unit = squads.first.available_unit
      available = available_unit.available
      Rails.logger.info("Available_unit #{available_unit_id} with #{squads.size} squads to rebuild, #{available} available")
      squads.each do |squad|
        if available > 0
          Rails.logger.info("Available #{available} > 0 for Squad #{squad.id}, rebuilding")
          squad.vet = 0
          squad.name = nil
          available -= 1
          squads_to_update << squad
          # TODO Reset squad stats
        else
          # Not enough availability to autorebuild, remove the dead squad
          Rails.logger.info("Available #{available} is 0 for Squad #{squad.id}, deleting")
          squad.destroy!
        end
      end
    end
    Rails.logger.info("Saving auto rebuilt squads")
    Squad.import!(squads_to_update, on_duplicate_key_update: { conflict_target: [:id], columns: [:vet, :name] })
  end

  # squads have been reconciled,
  def recalculate_company_resources
    @battle.companies.each do |c|
      man, mun, fuel, pop, _ = CompanyService.new(c.player).recalculate_resources(c)
      c.update!(pop: pop, man: man, mun: mun, fuel: fuel)
    end
  end

  def add_company_vps
    player_ids = @battle.players.pluck(:id)
    ruleset_id = @battle.ruleset_id
    Rails.logger.info("Start adding VPs to Companies for players #{player_ids} in ruleset #{ruleset_id}")
    companies = Company.where(player_id: player_ids, ruleset_id: ruleset_id)
    companies_to_update = []
    companies.each do |c|
      if c.vps_earned >= Company::MAX_VP
        Rails.logger.info("Company #{c.id} has #{c.vps_earned} VPs and cannot exceed #{Company::MAX_VP}")
      else
        Rails.logger.info("Adding 1 VP to Company #{c.id}")
        c.vps_earned += 1
        companies_to_update << c
      end
    end
    Company.import!(companies_to_update, on_duplicate_key_update: { conflict_target: [:id], columns: [:vps_earned] })
  end

  # Player VPs are used to repopulate
  def add_player_vps
    Rails.logger.info("Adding player VPs as necessary")
    players = @battle.players.to_a
    players.each do |p|
      if p.vps < Company::MAX_VP
        Rails.logger.info("Adding 1 VP to Player #{p.id}")
        p.vps += 1
      end
    end
    Player.import!(players, on_duplicate_key_update: { conflict_target: [:id], columns: [:vps] })
  end

  def finalize_battle(winner)
    # Update battle with winning side
    Rails.logger.info("Marking battle #{@battle.id} winner as #{winner}")
    @battle.update!(winner: winner)
    # Transition battle to final
    Rails.logger.info("Transitioning battle #{@battle.id} state to final")
    @battle.finalize!
  end
end
