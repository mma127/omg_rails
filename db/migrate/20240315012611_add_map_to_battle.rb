class AddMapToBattle < ActiveRecord::Migration[6.1]
  def change
    add_column :battles, :map, :string, comment: "Map name"
  end
end
