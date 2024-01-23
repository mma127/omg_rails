module Entities
  class CompanyLeaderboardResponse < Grape::Entity
    expose :top_exp_companies, using: CompanyLeaderboardStats::TopExpEntity, as: :topExpCompanies
    expose :top_wins, using: CompanyLeaderboardStats::TopWinsEntity, as: :topWins
    expose :top_win_streak, using: CompanyLeaderboardStats::TopWinStreakEntity, as: :topWinStreak
    expose :top_unit_killers, using: CompanyLeaderboardStats::TopUnitKillersEntity, as: :topUnitKillers
    expose :top_inf_killers, using: CompanyLeaderboardStats::TopInfKillersEntity, as: :topInfKillers
    expose :top_veh_killers, using: CompanyLeaderboardStats::TopVehKillersEntity, as: :topVehKillers
    expose :top_unit_losers, using: CompanyLeaderboardStats::TopUnitLosersEntity, as: :topUnitLosers
    expose :top_inf_losers, using: CompanyLeaderboardStats::TopInfLosersEntity, as: :topInfLosers
    expose :top_veh_losers, using: CompanyLeaderboardStats::TopVehLosersEntity, as: :topVehLosers
    expose :top_avg_kills, using: CompanyLeaderboardStats::TopAvgKillsEntity, as: :topAvgKills
    expose :top_avg_losses, using: CompanyLeaderboardStats::TopAvgLossesEntity, as: :topAvgLosses
    expose :top_exp_squads, using: Squad::TopExpSquadEntity, as: :topExpSquads
  end
end

