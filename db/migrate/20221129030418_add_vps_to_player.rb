class AddVpsToPlayer < ActiveRecord::Migration[6.1]
  def change
    add_column :players, :vps, :integer, default: 0, null: false, comment: "War VPs earned"
  end
end
