class UpdateTabCategoryInSquads < ActiveRecord::Migration[6.1]
  def up
    change_column :squads, :tab_category, :string
  end

  def down
    change_column :squads, :tab_category, :integer, using: "tab_category::integer"
  end
end
