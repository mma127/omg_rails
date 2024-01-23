# == Schema Information
#
# Table name: company_leaderboard_stats
#
#  avg_kills_1v1         :float
#  avg_kills_2v2         :float
#  avg_kills_3v3         :float
#  avg_kills_4v4         :float
#  avg_losses_1v1        :float
#  avg_losses_2v2        :float
#  avg_losses_3v3        :float
#  avg_losses_4v4        :float
#  combined_avg_kills    :float
#  combined_avg_losses   :float
#  company_name          :string
#  doctrine_display_name :string
#  doctrine_name         :string
#  faction_display_name  :string
#  faction_name          :string
#  infantry_kills_1v1    :integer
#  infantry_kills_2v2    :integer
#  infantry_kills_3v3    :integer
#  infantry_kills_4v4    :integer
#  infantry_losses_1v1   :integer
#  infantry_losses_2v2   :integer
#  infantry_losses_3v3   :integer
#  infantry_losses_4v4   :integer
#  losses_1v1            :integer
#  losses_2v2            :integer
#  losses_3v3            :integer
#  losses_4v4            :integer
#  player_name           :string
#  streak_1v1            :integer
#  streak_2v2            :integer
#  streak_3v3            :integer
#  streak_4v4            :integer
#  total_exp             :decimal(, )
#  total_infantry_kills  :integer
#  total_infantry_losses :integer
#  total_losses          :integer
#  total_streak          :integer
#  total_unit_kills      :integer
#  total_unit_losses     :integer
#  total_vehicle_kills   :integer
#  total_vehicle_losses  :integer
#  total_wins            :integer
#  unit_kills_1v1        :integer
#  unit_kills_2v2        :integer
#  unit_kills_3v3        :integer
#  unit_kills_4v4        :integer
#  unit_losses_1v1       :integer
#  unit_losses_2v2       :integer
#  unit_losses_3v3       :integer
#  unit_losses_4v4       :integer
#  vehicle_kills_1v1     :integer
#  vehicle_kills_2v2     :integer
#  vehicle_kills_3v3     :integer
#  vehicle_kills_4v4     :integer
#  vehicle_losses_1v1    :integer
#  vehicle_losses_2v2    :integer
#  vehicle_losses_3v3    :integer
#  vehicle_losses_4v4    :integer
#  wins_1v1              :integer
#  wins_2v2              :integer
#  wins_3v3              :integer
#  wins_4v4              :integer
#  company_id            :bigint
#  player_id             :bigint
#
class CompanyLeaderboardStats < ApplicationRecord
  belongs_to :company

  def readonly?
    false
  end

  def entity
    Entity.new(self)
  end

  class Entity < Grape::Entity
    expose :company_id, as: :companyId
    expose :company_name, as: :companyName
    expose :player_name, as: :playerName
    expose :faction_name, as: :factionName
    expose :faction_display_name, as: :factionDisplayName
    expose :doctrine_name, as: :doctrineName
    expose :doctrine_display_name, as: :doctrineDisplayName

    expose :infantry_kills_1v1, as: :infantryKills1v1, if: { type: :top_inf_killers }
    expose :infantry_kills_2v2, as: :infantryKills2v2, if: { type: :top_inf_killers }
    expose :infantry_kills_3v3, as: :infantryKills3v3, if: { type: :top_inf_killers }
    expose :infantry_kills_4v4, as: :infantryKills4v4, if: { type: :top_inf_killers }
    expose :total_infantry_kills, as: :totalInfantryKills, if: { type: :top_inf_killers }

    expose :vehicle_kills_1v1, as: :vehicleKills1v1, if: { type: :top_veh_killers }
    expose :vehicle_kills_2v2, as: :vehicleKills2v2, if: { type: :top_veh_killers }
    expose :vehicle_kills_3v3, as: :vehicleKills3v3, if: { type: :top_veh_killers }
    expose :vehicle_kills_4v4, as: :vehicleKills4v4, if: { type: :top_veh_killers }
    expose :total_vehicle_kills, as: :totalVehicleKills, if: { type: :top_veh_killers }

    expose :infantry_losses_1v1, as: :infantryLosses1v1, if: { type: :top_inf_losers }
    expose :infantry_losses_2v2, as: :infantryLosses2v2, if: { type: :top_inf_losers }
    expose :infantry_losses_3v3, as: :infantryLosses3v3, if: { type: :top_inf_losers }
    expose :infantry_losses_4v4, as: :infantryLosses4v4, if: { type: :top_inf_losers }
    expose :total_infantry_losses, as: :totalInfantryLosses, if: { type: :top_inf_losers }

    expose :vehicle_losses_1v1, as: :vehicleLosses1v1, if: { type: :top_veh_losers }
    expose :vehicle_losses_2v2, as: :vehicleLosses2v2, if: { type: :top_veh_losers }
    expose :vehicle_losses_3v3, as: :vehicleLosses3v3, if: { type: :top_veh_losers }
    expose :vehicle_losses_4v4, as: :vehicleLosses4v4, if: { type: :top_veh_losers }
    expose :total_vehicle_losses, as: :totalVehicleLosses, if: { type: :top_veh_losers }

    expose :unit_kills_1v1, as: :unitKills1v1, if: { type: :top_unit_killers }
    expose :unit_kills_2v2, as: :unitKills2v2, if: { type: :top_unit_killers }
    expose :unit_kills_3v3, as: :unitKills3v3, if: { type: :top_unit_killers }
    expose :unit_kills_4v4, as: :unitKills4v4, if: { type: :top_unit_killers }
    expose :total_unit_kills, as: :totalUnitKills, if: { type: :top_unit_killers }

    expose :unit_losses_1v1, as: :unitLosses1v1, if: { type: :top_unit_losers }
    expose :unit_losses_2v2, as: :unitLosses2v2, if: { type: :top_unit_losers }
    expose :unit_losses_3v3, as: :unitLosses3v3, if: { type: :top_unit_losers }
    expose :unit_losses_4v4, as: :unitLosses4v4, if: { type: :top_unit_losers }
    expose :total_unit_losses, as: :totalUnitLosses, if: { type: :top_unit_losers }

    expose :wins_1v1, as: :wins1v1, if: { type: :top_wins }
    expose :wins_2v2, as: :wins2v2, if: { type: :top_wins }
    expose :wins_3v3, as: :wins3v3, if: { type: :top_wins }
    expose :wins_4v4, as: :wins4v4, if: { type: :top_wins }
    expose :total_wins, as: :totalWins, if: { type: :top_wins }

    expose :losses_1v1, as: :losses1v1, if: { type: :top_losses }
    expose :losses_2v2, as: :losses2v2, if: { type: :top_losses }
    expose :losses_3v3, as: :losses3v3, if: { type: :top_losses }
    expose :losses_4v4, as: :losses4v4, if: { type: :top_losses }
    expose :total_losses, as: :totalLosses, if: { type: :top_losses }

    expose :streak_1v1, as: :streak1v1, if: { type: :top_win_streak }
    expose :streak_2v2, as: :streak2v2, if: { type: :top_win_streak }
    expose :streak_3v3, as: :streak3v3, if: { type: :top_win_streak }
    expose :streak_4v4, as: :streak4v4, if: { type: :top_win_streak }
    expose :total_streak, as: :totalStreak, if: { type: :top_win_streak }
  end

  class TopExpEntity < Grape::Entity
    expose :company_id, as: :companyId
    expose :company_name, as: :companyName
    expose :player_name, as: :playerName
    expose :player_id, as: :playerId
    expose :faction_name, as: :factionName
    expose :faction_display_name, as: :factionDisplayName
    expose :doctrine_name, as: :doctrineName
    expose :doctrine_display_name, as: :doctrineDisplayName
    expose :total_exp, as: :totalExp
  end

  class TopWinsEntity < Grape::Entity
    expose :company_id, as: :companyId
    expose :company_name, as: :companyName
    expose :player_name, as: :playerName
    expose :player_id, as: :playerId
    expose :faction_name, as: :factionName
    expose :faction_display_name, as: :factionDisplayName
    expose :doctrine_name, as: :doctrineName
    expose :doctrine_display_name, as: :doctrineDisplayName

    expose :wins_1v1, as: :wins1v1
    expose :wins_2v2, as: :wins2v2
    expose :wins_3v3, as: :wins3v3
    expose :wins_4v4, as: :wins4v4
    expose :total_wins, as: :totalWins
  end

  class TopWinStreakEntity < Grape::Entity
    expose :company_id, as: :companyId
    expose :company_name, as: :companyName
    expose :player_name, as: :playerName
    expose :player_id, as: :playerId
    expose :faction_name, as: :factionName
    expose :faction_display_name, as: :factionDisplayName
    expose :doctrine_name, as: :doctrineName
    expose :doctrine_display_name, as: :doctrineDisplayName

    expose :streak_1v1, as: :streak1v1
    expose :streak_2v2, as: :streak2v2
    expose :streak_3v3, as: :streak3v3
    expose :streak_4v4, as: :streak4v4
    expose :total_streak, as: :totalStreak
  end
  
  class TopUnitKillersEntity < Grape::Entity
    expose :company_id, as: :companyId
    expose :company_name, as: :companyName
    expose :player_name, as: :playerName
    expose :player_id, as: :playerId
    expose :faction_name, as: :factionName
    expose :faction_display_name, as: :factionDisplayName
    expose :doctrine_name, as: :doctrineName
    expose :doctrine_display_name, as: :doctrineDisplayName

    expose :unit_kills_1v1, as: :unitKills1v1
    expose :unit_kills_2v2, as: :unitKills2v2
    expose :unit_kills_3v3, as: :unitKills3v3
    expose :unit_kills_4v4, as: :unitKills4v4
    expose :total_unit_kills, as: :totalUnitKills
  end
  
  class TopInfKillersEntity < Grape::Entity
    expose :company_id, as: :companyId
    expose :company_name, as: :companyName
    expose :player_name, as: :playerName
    expose :player_id, as: :playerId
    expose :faction_name, as: :factionName
    expose :faction_display_name, as: :factionDisplayName
    expose :doctrine_name, as: :doctrineName
    expose :doctrine_display_name, as: :doctrineDisplayName

    expose :infantry_kills_1v1, as: :infantryKills1v1
    expose :infantry_kills_2v2, as: :infantryKills2v2
    expose :infantry_kills_3v3, as: :infantryKills3v3
    expose :infantry_kills_4v4, as: :infantryKills4v4
    expose :total_infantry_kills, as: :totalInfantryKills
  end
  
  class TopVehKillersEntity < Grape::Entity
    expose :company_id, as: :companyId
    expose :company_name, as: :companyName
    expose :player_name, as: :playerName
    expose :player_id, as: :playerId
    expose :faction_name, as: :factionName
    expose :faction_display_name, as: :factionDisplayName
    expose :doctrine_name, as: :doctrineName
    expose :doctrine_display_name, as: :doctrineDisplayName

    expose :vehicle_kills_1v1, as: :vehicleKills1v1
    expose :vehicle_kills_2v2, as: :vehicleKills2v2
    expose :vehicle_kills_3v3, as: :vehicleKills3v3
    expose :vehicle_kills_4v4, as: :vehicleKills4v4
    expose :total_vehicle_kills, as: :totalVehicleKills
  end
  
  class TopUnitLosersEntity < Grape::Entity
    expose :company_id, as: :companyId
    expose :company_name, as: :companyName
    expose :player_name, as: :playerName
    expose :player_id, as: :playerId
    expose :faction_name, as: :factionName
    expose :faction_display_name, as: :factionDisplayName
    expose :doctrine_name, as: :doctrineName
    expose :doctrine_display_name, as: :doctrineDisplayName

    expose :unit_losses_1v1, as: :unitLosses1v1
    expose :unit_losses_2v2, as: :unitLosses2v2
    expose :unit_losses_3v3, as: :unitLosses3v3
    expose :unit_losses_4v4, as: :unitLosses4v4
    expose :total_unit_losses, as: :totalUnitLosses
  end
  
  class TopInfLosersEntity < Grape::Entity
    expose :company_id, as: :companyId
    expose :company_name, as: :companyName
    expose :player_name, as: :playerName
    expose :player_id, as: :playerId
    expose :faction_name, as: :factionName
    expose :faction_display_name, as: :factionDisplayName
    expose :doctrine_name, as: :doctrineName
    expose :doctrine_display_name, as: :doctrineDisplayName

    expose :infantry_losses_1v1, as: :infantryLosses1v1
    expose :infantry_losses_2v2, as: :infantryLosses2v2
    expose :infantry_losses_3v3, as: :infantryLosses3v3
    expose :infantry_losses_4v4, as: :infantryLosses4v4
    expose :total_infantry_losses, as: :totalInfantryLosses
  end
  
  class TopVehLosersEntity < Grape::Entity
    expose :company_id, as: :companyId
    expose :company_name, as: :companyName
    expose :player_name, as: :playerName
    expose :player_id, as: :playerId
    expose :faction_name, as: :factionName
    expose :faction_display_name, as: :factionDisplayName
    expose :doctrine_name, as: :doctrineName
    expose :doctrine_display_name, as: :doctrineDisplayName

    expose :vehicle_losses_1v1, as: :vehicleLosses1v1
    expose :vehicle_losses_2v2, as: :vehicleLosses2v2
    expose :vehicle_losses_3v3, as: :vehicleLosses3v3
    expose :vehicle_losses_4v4, as: :vehicleLosses4v4
    expose :total_vehicle_losses, as: :totalVehicleLosses
  end
  
  class TopAvgKillsEntity < Grape::Entity
    expose :company_id, as: :companyId
    expose :company_name, as: :companyName
    expose :player_name, as: :playerName
    expose :player_id, as: :playerId
    expose :faction_name, as: :factionName
    expose :faction_display_name, as: :factionDisplayName
    expose :doctrine_name, as: :doctrineName
    expose :doctrine_display_name, as: :doctrineDisplayName

    expose :avg_kills_1v1, as: :avgKills1v1
    expose :avg_kills_2v2, as: :avgKills2v2
    expose :avg_kills_3v3, as: :avgKills3v3
    expose :avg_kills_4v4, as: :avgKills4v4
    expose :combined_avg_kills, as: :combinedAvgKills
  end
  
  class TopAvgLossesEntity < Grape::Entity
    expose :company_id, as: :companyId
    expose :company_name, as: :companyName
    expose :player_name, as: :playerName
    expose :player_id, as: :playerId
    expose :faction_name, as: :factionName
    expose :faction_display_name, as: :factionDisplayName
    expose :doctrine_name, as: :doctrineName
    expose :doctrine_display_name, as: :doctrineDisplayName

    expose :avg_losses_1v1, as: :avgLosses1v1
    expose :avg_losses_2v2, as: :avgLosses2v2
    expose :avg_losses_3v3, as: :avgLosses3v3
    expose :avg_losses_4v4, as: :avgLosses4v4
    expose :combined_avg_losses, as: :combinedAvgLosses
  end
end
