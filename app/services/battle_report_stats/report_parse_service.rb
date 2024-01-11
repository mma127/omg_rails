module BattleReportStats
  class ReportParseService < ApplicationService
    def initialize(battle_id, battle_stats_string)
      @battle = Battle.includes(battle_players: :company).find_by!(id: battle_id)
      @battle_stats_string = battle_stats_string
    end

    def process_battle_stats
      info_logger("Begin processing battle stats for battle #{@battle.id}: #{@battle_stats_string}")
      stats_by_company_id = parse_stats

      @battle.battle_players.each do |bp|
        company_id = bp.company_id
        stats = stats_by_company_id[company_id]
        save_company_stats(company_id, stats, @battle.final?, bp.win?)
      end
    end

    private

    "Razor,CompanyId:13,Inf Lost:3 ,Vehicles Lost:0 ,Inf Killed:1 ,Vehicles Killed:0;UnLimiTeD,CompanyId:11,Inf Lost:1 ,Vehicles Lost:0 ,Inf Killed:3 ,Vehicles Killed:0;"
    def parse_stats
      stats_by_player = @battle_stats_string.split(";")
      stats_by_player.reduce({}) do |acc, player_stats_string|
        elements = player_stats_string.split(",")
        company_id = get_value_from_stat_string(elements[1])
        acc[company_id] = {
          inf_lost: get_value_from_stat_string(elements[2]),
          vehicles_lost: get_value_from_stat_string(elements[3]),
          inf_killed: get_value_from_stat_string(elements[4]),
          vehicles_killed: get_value_from_stat_string(elements[5])
        }
        acc
      end
    end

    def save_company_stats(company_id, new_stats, is_final, is_winner)
      UpdateService.new(company_id).update_company_stats(@battle.size, new_stats, is_final, is_winner)
    end

    def get_value_from_stat_string(stat_string)
      stat_string.split(":").second.to_i
    end
  end
end
