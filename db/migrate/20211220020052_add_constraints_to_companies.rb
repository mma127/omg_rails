class AddConstraintsToCompanies < ActiveRecord::Migration[6.1]
  def change
    change_column_null :companies, :player_id, false
    change_column_null :companies, :faction_id, false
    change_column_null :companies, :doctrine_id, false

    change_column_default :companies, :vps_earned, 0
    change_column_default :companies, :pop, 0
    change_column_default :companies, :man, 0
    change_column_default :companies, :mun, 0
    change_column_default :companies, :fuel, 0
  end
end
