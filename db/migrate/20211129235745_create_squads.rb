class CreateSquads < ActiveRecord::Migration[6.1]
  def change
    create_table :squads do |t|
      t.references :company, index: true, foreign_key: true
      t.references :available_unit, index: true, foreign_key: true
      t.string :tab_category, null: false, comment: "Tab this squad is in"
      t.integer :category_position, null: false, comment: "Position within the tab the squad is in"
      t.decimal :vet, comment: "Squad's veterancy"
      t.string :name, comment: "Squad's custom name"

      t.timestamps
    end
  end
end
