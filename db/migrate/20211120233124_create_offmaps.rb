class CreateOffmaps < ActiveRecord::Migration[6.1]
  def change
    create_table :offmaps do |t|
      t.string :name, null: false, comment: "Offmap name"
      t.string :display_name, null: false, comment: "Offmap display name"
      t.string :const_name, null: false, comment: "Offmap const name for battlefile"
      t.string :description, null: false, comment: "Offmap description"
      t.string :upgrade_rgd, comment: "upgrade rgd name"
      t.string :ability_rgd, comment: "ability_rgd_name"
      t.integer :cooldown, comment: "Cooldown between uses, in seconds"
      t.integer :duration, comment: "Offmap duration in seconds"
      t.boolean :unlimited_uses, null: false, comment: "Whether this offmap has limited or unlimited uses"
      t.string :buffs, comment: "Description of buffs this offmap grants"
      t.string :debuffs, comment: "Description of debuffs this offmap inflicts"
      t.string :weapon_rgd, comment: "Weapon rgd name"
      t.integer :shells_fired, comment: "Number of shells fired during the offmap"

      t.timestamps
    end
  end
end
