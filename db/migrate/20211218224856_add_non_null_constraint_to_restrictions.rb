class AddNonNullConstraintToRestrictions < ActiveRecord::Migration[6.1]
  def up
    execute "ALTER TABLE restrictions
      ADD CONSTRAINT chk_only_one_is_not_null CHECK (num_nonnulls(faction_id, doctrine_id, doctrine_unlock_id, unlock_id) = 1);"
  end

  def down
    execute "ALTER TABLE restrictions DROP CONSTRAINT chk_only_one_is_not_null"
  end
end
