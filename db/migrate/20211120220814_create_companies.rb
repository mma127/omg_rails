class CreateCompanies < ActiveRecord::Migration[6.1]
  def change
    create_table :companies do |t|
      t.string :name, comment: "Company name"
      t.references :player, index: true, foreign_key: true
      t.references :doctrine, index: true, foreign_key: true
      t.references :faction, index: true, foreign_key: true
      t.integer :vps_earned, comment: "VPs earned by this company"
      t.integer :man, comment: "Manpower available to this company"
      t.integer :mun, comment: "Munitions available to this company"
      t.integer :fuel, comment: "Fuel available to this company"
      t.integer :pop, comment: "Population cost of this company"

      t.timestamps
    end
  end
end
