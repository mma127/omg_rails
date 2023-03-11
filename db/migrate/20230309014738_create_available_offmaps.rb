class CreateAvailableOffmaps < ActiveRecord::Migration[6.1]
  def change
    create_table :available_offmaps, comment: "Offmap availability per company" do |t|
      t.references :company, index: true, foreign_key: true
      t.references :offmap, index: true, foreign_key: true
      t.integer :available, default: 0, null: false, comment: "Number of this offmap available to purchase for the company"
      t.integer :max, default: 0, null: false, comment: "Max number of this offmap that the company can hold"
      t.integer :mun, default: 0, null: false, comment: "Munitions cost of this offmap"

      t.timestamps
    end
  end
end
