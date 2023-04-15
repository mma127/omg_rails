# == Schema Information
#
# Table name: company_callin_modifiers
#
#  id                 :bigint           not null, primary key
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  callin_modifier_id :bigint
#  company_id         :bigint
#
# Indexes
#
#  index_company_callin_modifiers_on_callin_modifier_id  (callin_modifier_id)
#  index_company_callin_modifiers_on_company_id          (company_id)
#
# Foreign Keys
#
#  fk_rails_...  (callin_modifier_id => callin_modifiers.id)
#  fk_rails_...  (company_id => companies.id)
#
class CompanyCallinModifier < ApplicationRecord
  belongs_to :company
  belongs_to :callin_modifier
end
