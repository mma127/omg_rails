class CreateRestrictionUpgradeUnits < ActiveRecord::Migration[6.1]
  def change
    create_table :restriction_upgrade_units, comment: "Association between RestrictionUpgrade and Units" do |t|
      t.references :restriction_upgrade, index: true, foreign_key: true
      t.references :unit, index: true, foreign_key: true

      t.timestamps
    end
  end
end
