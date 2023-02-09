class CreateCompanyUnlocks < ActiveRecord::Migration[6.1]
  def change
    create_table :company_unlocks do |t|
      t.references :company, index: true, foreign_key: true
      t.references :doctrine_unlock, index: true, foreign_key: true

      t.timestamps
    end
  end
end
