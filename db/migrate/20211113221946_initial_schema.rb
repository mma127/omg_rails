class InitialSchema < ActiveRecord::Migration[6.1]
  def change
    create_table :factions, comment: "Game factions" do |t|
      t.string :name, null: false, comment: "Raw name"
      t.string :display_name, null: false, comment: "Display name"
      t.string :const_name, null: false, comment: "Faction CONST name for battlefile"
      t.string :internal_name, null: false, comment: "Name for internal code use, may not be needed"
      t.string :side, null: false, comment: "Allied or Axis side"
      t.integer :race, comment: "In-game race id"

      t.timestamps
    end

    add_index :factions, :name, unique: true
    add_index :factions, :const_name, unique: true

    create_table :players, comment: "Player record" do |t|
      t.string :name, comment: "Player screen name"
      t.text :avatar, comment: "Player avatar url"
      t.string :provider, comment: "Omniauth provider"
      t.string :uid, comment: "Omniauth uid"
      t.string :discord_id, comment: "Discord id"
      t.integer :vps, default: 0, null: false, comment: "WAR VPs earned up to ruleset max"
      t.integer :total_vps_earned, default: 0, null: false, comment: "Total WAR VPs earned, not capped"

      t.timestamps
    end

    add_index :players, [:provider, :uid], unique: true

    create_table :doctrines, comment: "Faction doctrines" do |t|
      t.string :name, null: false, comment: "Raw name"
      t.string :display_name, null: false, comment: "Display name"
      t.string :const_name, null: false, comment: "Doctrine CONST name for battlefile"
      t.string :internal_name, null: false, comment: "Name for internal code use, may not be needed"
      t.references :faction, index: true, foreign_key: true

      t.timestamps
    end

    add_index :doctrines, :name, unique: true
    add_index :doctrines, :const_name, unique: true

    create_table :rulesets do |t|
      t.string :name, null: false, comment: "Ruleset name"
      t.string :description, comment: "Description"
      t.integer :starting_man, null: false, comment: "Company starting manpower"
      t.integer :starting_mun, null: false, comment: "Company starting muntions"
      t.integer :starting_fuel, null: false, comment: "Company starting fuel"
      t.integer :starting_vps, null: false, comment: "Company starting vps"
      t.integer :max_vps, null: false, comment: "Company max vps"
      t.integer :max_resource_bonuses, null: false, comment: "Company maximum number of resource bonuses"

      t.timestamps
    end
  end
end
