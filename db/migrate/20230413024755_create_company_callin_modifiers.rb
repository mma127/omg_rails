class CreateCompanyCallinModifiers < ActiveRecord::Migration[6.1]
  def change
    create_table :company_callin_modifiers, comment: "Mapping of company to available callin modifiers" do |t|
      t.references :company, index: true, foreign_key: true
      t.references :callin_modifier, index: true, foreign_key: true

      t.timestamps
    end
  end
end
