class InitialSchema < ActiveRecord::Migration[6.1]
  def change
    create_table :factions, comment: "Game factions" do |t|
      t.string :name, comment: "Raw name"
      t.string :display_name, comment: "Display name"
      t.string :const_name, comment: "Faction CONST name for battlefile"
      t.string :internal_name, comment: "Name for internal code use, may not be needed"
      t.string :side, comment: "Allied or Axis side"

      t.timestamps
    end

    create_table :players, comment: "Player record" do |t|
      t.string :name, comment: "Player screen name"
      t.text :open_id, comment: "Player open id token"
      t.text :avatar_url, comment: "Player avatar url"
      t.timestamp :last_active_at, comment: "Last active timestamp"

      t.timestamps
    end

    create_table :doctrines, comment: "Faction doctrines" do |t|
      t.string :name, comment: "Raw name"
      t.string :display_name, comment: "Display name"
      t.string :const_name, comment: "Doctrine CONST name for battlefile"
      t.string :internal_name, comment: "Name for internal code use, may not be needed"
      t.references :faction, index: true, foreign_key: true

      t.timestamps
    end
  end
end
