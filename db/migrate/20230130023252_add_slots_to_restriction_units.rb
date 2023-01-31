class AddSlotsToRestrictionUnits < ActiveRecord::Migration[6.1]
  def change
    # Not removing from units table yet as want to keep reference number
    # remove_column :units, :upgrade_slots, :integer, default: 0, null: false, comment: "Slots used for per model weapon upgrades"
    # remove_column :units, :unitwide_upgrade_slots, :integer, default: 0, null: false, comment: "Unit wide weapon replacement slot"

    add_column :restriction_units, :upgrade_slots, :integer, default: 0, null: false, comment: "Slots used for per model weapon upgrades"
    add_column :restriction_units, :unitwide_upgrade_slots, :integer, default: 0, null: false, comment: "Unit wide weapon replacement slot"
  end
end
