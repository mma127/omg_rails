module OMG
  class Leaderboard < Grape::API
    helpers OMG::Helpers::RequestHelpers

    resource :leaderboard do
      desc "get leaderboard data"
      params do
        optional :limit, type: Integer, default: 10, desc: "number of entries to retrieve per stat"
      end
      get do
        declared_params = declared(params)
        present CompanyStatsService.new(declared_params[:limit]).get_leaderboard_stats, with: Entities::CompanyLeaderboardResponse
      end

      desc "get battle history"
      params do
        requires :ruleset_id, type: Integer, desc: "Ruleset to find battles for"
      end
      get "battles_history" do
        declared_params = declared(params)
        present BattlesHistoryService.fetch_battles_history(declared_params[:ruleset_id]), with: Entities::BattleHistoryResponse
      end
    end
  end
end
