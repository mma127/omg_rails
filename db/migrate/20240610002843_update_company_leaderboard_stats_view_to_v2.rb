class UpdateCompanyLeaderboardStatsViewToV2 < ActiveRecord::Migration[7.0]
  def change
    replace_view :company_leaderboard_stats, version: 2, revert_to_version: 1
  end
end
