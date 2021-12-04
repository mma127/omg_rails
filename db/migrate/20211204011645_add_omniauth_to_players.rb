class AddOmniauthToPlayers < ActiveRecord::Migration[6.1]
  def change
    add_column :players, :provider, :string, comment: "Omniauth provider"
    add_column :players, :uid, :string, comment: "Omniauth uid"
  end
end
