class AddRulesetToCompany < ActiveRecord::Migration[6.1]
  def change
    add_reference :companies, :ruleset, null: false
  end
end
