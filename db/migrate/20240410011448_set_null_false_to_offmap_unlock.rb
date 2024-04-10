class SetNullFalseToOffmapUnlock < ActiveRecord::Migration[6.1]
  def change
    change_column_null :unlocks, :ruleset_id, false
    change_column_null :offmaps, :ruleset_id, false
  end
end
