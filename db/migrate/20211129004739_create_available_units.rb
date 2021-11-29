class CreateAvailableUnits < ActiveRecord::Migration[6.1]
  def change
    create_table :available_units, comment: "Unit availability per company" do |t|
      t.references :company, index: true, foreign_key: true
      t.references :unit, index: true, foreign_key: true
      t.integer :available, comment: "Number of this unit available to purchase for the company"

      t.timestamps
    end
  end
end
