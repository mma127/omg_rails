class CreateCompanyOffmaps < ActiveRecord::Migration[6.1]
  def change
    create_table :company_offmaps do |t|
      t.references :company, index: true, foreign_key: true
      t.references :available_offmap, index: true, foreign_key: true
      t.timestamps
    end
  end
end
