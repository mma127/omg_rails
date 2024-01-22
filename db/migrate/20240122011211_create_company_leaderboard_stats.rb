class CreateCompanyLeaderboardStats < ActiveRecord::Migration[6.1]
  def change
    create_view :company_leaderboard_stats
  end
end
