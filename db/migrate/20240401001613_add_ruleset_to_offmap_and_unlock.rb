class AddRulesetToOffmapAndUnlock < ActiveRecord::Migration[6.1]
  def change
    add_reference :unlocks, :ruleset, index: true, foreign_key: true
    add_reference :offmaps, :ruleset, index: true, foreign_key: true
  end
end
