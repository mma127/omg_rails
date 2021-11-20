class CreateCompanyResourceBonuses < ActiveRecord::Migration[6.1]
  def change
    create_table :company_resource_bonuses do |t|
      t.references :company, index: true, foreign_key: true
      t.references :resource_bonus, index: true, foreign_key: true
      t.integer :level, comment: "Number of this bonus taken"
      t.timestamps
    end
  end
end
