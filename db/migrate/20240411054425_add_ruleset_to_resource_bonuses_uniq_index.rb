class AddRulesetToResourceBonusesUniqIndex < ActiveRecord::Migration[6.1]
  def change
    remove_index :resource_bonuses, :resource, unique: true
    add_index :resource_bonuses, [:resource, :ruleset_id], unique: true
  end
end
