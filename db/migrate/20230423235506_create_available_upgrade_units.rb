class CreateAvailableUpgradeUnits < ActiveRecord::Migration[6.1]
  def change
    create_table :available_upgrade_units, comment: "Association between AvailableUpgrade and Units that may purchase them" do |t|
      t.references :available_upgrade, index: true, foreign_key: true
      t.references :unit, index: true, foreign_key: true

      t.timestamps
    end
  end
end
