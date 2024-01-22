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
    end
  end
end
