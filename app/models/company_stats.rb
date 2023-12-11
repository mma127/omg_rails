# == Schema Information
#
# Table name: company_stats
#
#  id                         :bigint           not null, primary key
#  infantry_kills_1v1         :integer          default(0), not null
#  infantry_kills_2v2         :integer          default(0), not null
#  infantry_kills_3v3         :integer          default(0), not null
#  infantry_kills_4v4         :integer          default(0), not null
#  infantry_losses_1v1        :integer          default(0), not null
#  infantry_losses_2v2        :integer          default(0), not null
#  infantry_losses_3v3        :integer          default(0), not null
#  infantry_losses_4v4        :integer          default(0), not null
#  losses_1v1                 :integer          default(0), not null
#  losses_2v2                 :integer          default(0), not null
#  losses_3v3                 :integer          default(0), not null
#  losses_4v4                 :integer          default(0), not null
#  streak_1v1(win streak 1v1) :integer          default(0), not null
#  streak_2v2(win streak 2v2) :integer          default(0), not null
#  streak_3v3(win streak 3v3) :integer          default(0), not null
#  streak_4v4(win streak 4v4) :integer          default(0), not null
#  vehicle_kills_1v1          :integer          default(0), not null
#  vehicle_kills_2v2          :integer          default(0), not null
#  vehicle_kills_3v3          :integer          default(0), not null
#  vehicle_kills_4v4          :integer          default(0), not null
#  vehicle_losses_1v1         :integer          default(0), not null
#  vehicle_losses_2v2         :integer          default(0), not null
#  vehicle_losses_3v3         :integer          default(0), not null
#  vehicle_losses_4v4         :integer          default(0), not null
#  wins_1v1                   :integer          default(0), not null
#  wins_2v2                   :integer          default(0), not null
#  wins_3v3                   :integer          default(0), not null
#  wins_4v4                   :integer          default(0), not null
#  created_at                 :datetime         not null
#  updated_at                 :datetime         not null
#  company_id                 :bigint           not null
#
# Indexes
#
#  idx_company_stats_company_id_uniq  (company_id) UNIQUE
#  index_company_stats_on_company_id  (company_id)
#
class CompanyStats < ApplicationRecord
  belongs_to :company

  def entity
    Entity.new(self)
  end

  class Entity < Grape::Entity
    expose :id
    expose :company_id, as: :companyId
    
    expose :infantry_kills_1v1, as: :infantryKills1v1
    expose :infantry_kills_2v2, as: :infantryKills2v2
    expose :infantry_kills_3v3, as: :infantryKills3v3
    expose :infantry_kills_4v4, as: :infantryKills4v4
    
    expose :vehicle_kills_1v1, as: :vehicleKills1v1
    expose :vehicle_kills_2v2, as: :vehicleKills2v2
    expose :vehicle_kills_3v3, as: :vehicleKills3v3
    expose :vehicle_kills_4v4, as: :vehicleKills4v4
    
    expose :infantry_losses_1v1, as: :infantryLosses1v1
    expose :infantry_losses_2v2, as: :infantryLosses2v2
    expose :infantry_losses_3v3, as: :infantryLosses3v3
    expose :infantry_losses_4v4, as: :infantryLosses4v4
    
    expose :vehicle_losses_1v1, as: :vehicleLosses1v1
    expose :vehicle_losses_2v2, as: :vehicleLosses2v2
    expose :vehicle_losses_3v3, as: :vehicleLosses3v3
    expose :vehicle_losses_4v4, as: :vehicleLosses4v4
    
    expose :wins_1v1, as: :wins1v1
    expose :wins_2v2, as: :wins2v2
    expose :wins_3v3, as: :wins3v3
    expose :wins_4v4, as: :wins4v4
    
    expose :losses_1v1, as: :losses1v1
    expose :losses_2v2, as: :losses2v2
    expose :losses_3v3, as: :losses3v3
    expose :losses_4v4, as: :losses4v4
    
    expose :streak_1v1, as: :streak1v1
    expose :streak_2v2, as: :streak2v2
    expose :streak_3v3, as: :streak3v3
    expose :streak_4v4, as: :streak4v4
  end
end
