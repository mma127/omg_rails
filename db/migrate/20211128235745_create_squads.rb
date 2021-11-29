class CreateSquads < ActiveRecord::Migration[6.1]
  def change
    create_table :squads do |t|
      t.references :company, index: true, foreign_key: true
      t.references :unit, index: true, foreign_key: true
      t.integer :tab_category, comment: "Tab this squad is in"
      t.integer :category_position, comment: "Position within the tab the squad is in"
      t.decimal :vet, comment: "Squad's veterancy"
      t.string :name, comment: "Squad's custom name"

      t.timestamps
    end
  end
end
