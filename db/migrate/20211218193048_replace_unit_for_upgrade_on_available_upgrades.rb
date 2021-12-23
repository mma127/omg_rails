class ReplaceUnitForUpgradeOnAvailableUpgrades < ActiveRecord::Migration[6.1]
  def change
    add_reference :available_upgrades, :upgrade, index: true, foreign_key: true
  end
end
