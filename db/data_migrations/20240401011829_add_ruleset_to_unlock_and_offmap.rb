class AddRulesetToUnlockAndOffmap < ActiveRecord::DataMigration
  def up
    # put your code here
    ruleset = Ruleset.find_by(ruleset_type: Ruleset.ruleset_types[:war], is_active: true)
    ruleset_id = ruleset.id

    Unlock.where(ruleset_id: nil).update_all(ruleset_id: ruleset_id)
    Offmap.where(ruleset_id: nil).update_all(ruleset_id: ruleset_id)
  end
end