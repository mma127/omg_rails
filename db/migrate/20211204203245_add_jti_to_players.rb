class AddJtiToPlayers < ActiveRecord::Migration[6.1]
  def change
    add_column :players, :jti, :string, null: false
    add_index :players, :jti, unique: true
  end
end
