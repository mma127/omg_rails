class CreateCompanies < ActiveRecord::Migration[6.1]
  def change
    create_table :companies do |t|
      t.string :uuid, null: false, comment: "Uuid"
      t.string :name, comment: "Company name"
      t.string :type, null: false, comment: "Company type"
      t.references :player, index: true, foreign_key: true, null: false
      t.references :doctrine, index: true, foreign_key: true, null: false
      t.references :faction, index: true, foreign_key: true, null: false
      t.references :ruleset, index: true, foreign_key: true, null: false
      t.integer :vps_earned, default: 0, null: false, comment: "VPs earned by this company"
      t.integer :vps_current, default: 0, null: false, comment: "VPs available to spend"
      t.integer :man, null: false, default: 0, comment: "Manpower available to this company"
      t.integer :mun, null: false, default: 0, comment: "Munitions available to this company"
      t.integer :fuel, null: false, default: 0, comment: "Fuel available to this company"
      t.integer :pop, null: false, default: 0, comment: "Population cost of this company"

      t.timestamps
    end

    add_index :companies, :uuid, unique: true
  end
end
