class HistoricalBattlePlayerService
  class HistoricalBattlePlayerValidationError < StandardError; end

  def initialize(battle_id)
    @battle = Battle.includes(battle_players: { company: [:faction, :doctrine, :ruleset], player: :player_rating }).find(battle_id)
  end

  def create_historical_battle_players_for_battle
    info_logger("Begin Create HistoricalBattlePlayers for battle #{@battle.id}")
    validate_battle_final

    date_played = DateTime.now.to_date

    info_logger("Populating HistoricalBattlePlayers")
    hbp = @battle.battle_players.map do |bp|
      populate_new_historical_battle_player(bp, date_played)
    end

    info_logger("Importing HistoricalBattlePlayers")
    HistoricalBattlePlayer.import!(hbp)

    info_logger("[#{self.class.name}] Finished creating HistoricalBattlePlayers for battle #{@battle.id}")
  end

  private

  def validate_battle_final
    raise HistoricalBattlePlayerValidationError.new("Battle #{@battle.id} is not final") unless @battle.final?
  end

  def populate_new_historical_battle_player(battle_player, date_played)
    player = battle_player.player
    player_rating = player.player_rating
    company = battle_player.company
    HistoricalBattlePlayer.new(player: player, player_name: player.name, battle_id: @battle.id,
                               faction: company.faction, doctrine: company.doctrine, is_winner: win?(battle_player),
                               elo: player_rating.elo, mu: player_rating.mu, sigma: player_rating.sigma,
                               wins: player_rating.wins, losses: player_rating.losses, date: date_played,
                               ruleset: company.ruleset)
  end

  def win?(battle_player)
    battle_player.side == @battle.winner
  end

  def info_logger(msg)
    Rails.logger.info(msg)
  end
end
