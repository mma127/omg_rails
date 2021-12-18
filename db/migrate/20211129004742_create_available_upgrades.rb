class CreateAvailableUpgrades < ActiveRecord::Migration[6.1]
  def change
    create_table :available_upgrades, comment: "Upgrade availability per company" do |t|
      t.references :company, index: true, foreign_key: true
      t.references :upgrade, index: true, foreign_key: true
      t.integer :available, comment: "Number of this upgrade available to purchase for the company"

      t.timestamps
    end
  end
end
