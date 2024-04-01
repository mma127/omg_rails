class AddRulesetToOffmapAndUnlock < ActiveRecord::Migration[6.1]
  def change
    add_reference :unlocks, :ruleset, index: true, foreign_key: true, null: false
    add_reference :offmaps, :ruleset, index: true, foreign_key: true, null: false
  end
end
