# == Schema Information
#
# Table name: units
#
#  id                                                                     :bigint           not null, primary key
#  const_name(Const name of the unit for the battle file)                 :string           not null
#  description(Display description of the unit)                           :text
#  disabled(override that disables the unit from being purchased or used) :boolean          default(FALSE), not null
#  display_name(Display name)                                             :string           not null
#  is_airdrop(Is this unit airdroppable?)                                 :boolean          default(FALSE), not null
#  is_infiltrate(Is this unit able to infiltrate?)                        :boolean          default(FALSE), not null
#  model_count(How many model entities this base unit consists of)        :integer
#  name(Unique unit name)                                                 :string           not null
#  retreat_name(Name for retreating unit)                                 :string
#  transport_model_slots(How many models this unit can transport)         :integer
#  transport_squad_slots(How many squads this unit can transport)         :integer
#  type(Unit type)                                                        :string           not null
#  unitwide_upgrade_slots(Unit wide weapon replacement slot)              :integer          default(0), not null
#  upgrade_slots(Slots used for per model weapon upgrades)                :integer          default(0), not null
#  created_at                                                             :datetime         not null
#  updated_at                                                             :datetime         not null
#
# Indexes
#
#  index_units_on_name  (name) UNIQUE
#
class Emplacement < Unit
  def sort_priority
    5
  end
end
