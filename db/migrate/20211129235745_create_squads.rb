class CreateSquads < ActiveRecord::Migration[6.1]
  def change
    create_table :squads do |t|
      t.references :company, index: true, foreign_key: true
      t.references :available_unit, index: true, foreign_key: true
      t.string :tab_category, null: false, comment: "Tab this squad is in"
      t.integer :category_position, null: false, comment: "Position within the tab the squad is in"
      t.string :uuid, null: false, comment: "Unique uuid"
      t.decimal :vet, comment: "Squad's veterancy"
      t.string :name, comment: "Squad's custom name"
      t.decimal :total_pop, comment: "Total pop of the unit and all upgrades"
      t.integer :total_model_count, comment: "Total model count of the unit and all upgrades"

      t.timestamps
    end

    add_index :squads, :uuid, unique: true
  end
end
