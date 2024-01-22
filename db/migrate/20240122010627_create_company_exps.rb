class CreateCompanyExps < ActiveRecord::Migration[6.1]
  def change
    create_view :company_exps
  end
end
