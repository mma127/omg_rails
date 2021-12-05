class RemoveOpenIdEmailFromPlayers < ActiveRecord::Migration[6.1]
  def change
    remove_column :players, :open_id
    remove_column :players, :last_active_at
    rename_column :players, :avatar_url, :avatar
  end
end
