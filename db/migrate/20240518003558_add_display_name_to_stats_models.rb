class AddDisplayNameToStatsModels < ActiveRecord::Migration[7.0]
  def change
    add_column :stats_units, :display_name, :string
    add_column :stats_entities, :display_name, :string
    add_column :stats_weapons, :display_name, :string
    add_column :stats_upgrades, :display_name, :string
    add_column :stats_slot_items, :display_name, :string
    add_column :stats_abilities, :display_name, :string
  end
end
