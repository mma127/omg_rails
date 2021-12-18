class AddTypeToRestrictionUnits < ActiveRecord::Migration[6.1]
  def change
    add_column :restriction_units, :type, :string, null: false, comment: "What effect this restriction has on the unit"
  end
end
