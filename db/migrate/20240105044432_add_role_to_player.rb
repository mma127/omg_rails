class AddRoleToPlayer < ActiveRecord::Migration[6.1]
  def change
    add_column :players, :role, :string, null: false, comment: "Player role for permissions"
  end
end
