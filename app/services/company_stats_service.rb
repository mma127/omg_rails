class CompanyStatsService < ApplicationService
  def initialize(limit)
    @limit = limit
  end

  # Expect to return the follow stats
  # Top XP companies    |     Top Winners         |     Top Longest Winning Streak
  # Top Killers         |     Top Inf Killers     |     Top Vehicle Killers
  # Top Losers          |     Top Inf Losers      |     Top Vehicle Losers
  # Top Avg Kills/Game  |     Top Avg Losses/Game |     Top XP Squads
  def get_leaderboard_stats
    {
      top_exp_companies: get_top_exp_companies,
      top_wins: get_top_winners,
      top_win_streak: get_top_win_streak,
      top_unit_killers: get_top_killers,
      top_inf_killers: get_top_inf_killers,
      top_veh_killers: get_top_veh_killers,
      top_unit_losers: get_top_losers,
      top_inf_losers: get_top_inf_losers,
      top_veh_losers: get_top_veh_losers,
      top_avg_kills: get_top_avg_kills,
      top_avg_losses: get_top_avg_losses,
      top_exp_squads: get_top_exp_squads,
    }
  end

  private

  def get_top_exp_companies
    CompanyLeaderboardStats.order(total_exp: :desc).limit(@limit)
  end

  def get_top_winners
    CompanyLeaderboardStats.order(total_wins: :desc).limit(@limit)
  end

  def get_top_win_streak
    CompanyLeaderboardStats.order(total_streak: :desc).limit(@limit)
  end

  def get_top_killers
    CompanyLeaderboardStats.order(total_unit_kills: :desc).limit(@limit)
  end

  def get_top_inf_killers
    CompanyLeaderboardStats.order(total_infantry_kills: :desc).limit(@limit)
  end

  def get_top_veh_killers
    CompanyLeaderboardStats.order(total_vehicle_kills: :desc).limit(@limit)
  end

  def get_top_losers
    CompanyLeaderboardStats.order(total_unit_losses: :desc).limit(@limit)
  end

  def get_top_inf_losers
    CompanyLeaderboardStats.order(total_infantry_losses: :desc).limit(@limit)
  end

  def get_top_veh_losers
    CompanyLeaderboardStats.order(total_vehicle_losses: :desc).limit(@limit)
  end

  def get_top_avg_kills
    CompanyLeaderboardStats.order(combined_avg_kills: :desc).limit(@limit)
  end

  def get_top_avg_losses
    CompanyLeaderboardStats.order(combined_avg_losses: :desc).limit(@limit)
  end

  def get_top_exp_squads
    Squad.includes(company: [:player, :faction, :doctrine], available_unit: { unit: :unit_vet }).joins(:company).where(company: { type: "ActiveCompany" }).order(vet: :desc).limit(@limit)
  end
end
