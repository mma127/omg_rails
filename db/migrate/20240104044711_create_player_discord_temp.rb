class CreatePlayerDiscordTemp < ActiveRecord::Migration[6.1]
  def change
    create_table :player_discord_temp, comment: "Temporary table for migrating player discord ids" do |t|
      t.string :player_name
      t.string :discord_id
    end
  end
end
