class CreateSquadUpgrades < ActiveRecord::Migration[6.1]
  def change
    create_table :squad_upgrades, comment: "Upgrades purchased for squad" do |t|
      t.references :squad, index: true, foreign_key: true
      t.references :available_upgrade, index: true, foreign_key: true
      t.boolean :is_free, comment: "Flag for whether this upgrade is free for the squad and has no availability cost"

      t.timestamps
    end
  end
end
