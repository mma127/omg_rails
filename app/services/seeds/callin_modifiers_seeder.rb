require 'csv'

module Seeds
  class CallinModifiersSeeder < ApplicationService
    FILENAME = 'lib/assets/callin_modifiers.csv'.freeze

    class << self
      def create_for_ruleset(ruleset)
        restriction_by_name = {}

        callin_modifiers_csv.each do |row|
          modifier = row["modifier"]
          modifier_type = get_modifier_type(row["modifier_type"])
          priority = row["priority"]
          description = row["description"]
          display_unlock_name = row["display_unlock_name"]
          required_unit = row["required_unit"]
          allowed_unit = row["allowed_unit"]
          doctrine_name = row["doctrine_name"] # NOTE: Callin modifiers currently are only associated with doctrine unlocks
          unlock_name = row["unlock_name"]

          callin_modifier = CallinModifier.find_or_create_by!(modifier: modifier, modifier_type: modifier_type, priority: priority,
                                                              description: description, unlock_name: display_unlock_name)

          create_callin_modifier_unit(callin_modifier, required_unit, CallinModifierRequiredUnit) if required_unit.present?
          create_callin_modifier_unit(callin_modifier, allowed_unit, CallinModifierAllowedUnit) if allowed_unit.present?

          restriction = get_restriction(doctrine_name, unlock_name, restriction_by_name, ruleset)
          EnabledCallinModifier.find_or_create_by!(restriction: restriction, callin_modifier: callin_modifier, ruleset: ruleset)
        end
      end

      private

      def callin_modifiers_csv
        CSV.open(FILENAME, headers: true)
      end

      def get_modifier_type(modifier_type)
        case modifier_type
        when CallinModifier::modifier_types[:multiplicative]
          CallinModifier::modifier_types[:multiplicative]
        else
          raise ArgumentError.new "Unknown callin modifier type #{modifier_type}"
        end
      end

      def create_callin_modifier_unit(callin_modifier, unit_name, class_name)
        unit = Unit.find_by!(name: unit_name)
        class_name.find_or_create_by!(callin_modifier: callin_modifier, unit: unit)
      end

      def get_restriction(doctrine_name, unlock_name, restriction_by_name, ruleset)
        key = "#{doctrine_name}|#{unlock_name}"
        if restriction_by_name.include? key
          restriction_by_name[key]
        else
          doctrine = Doctrine.find_by!(name: doctrine_name)
          unlock = Unlock.find_by!(name: unlock_name, ruleset: ruleset)
          doctrine_unlock = DoctrineUnlock.find_by!(doctrine: doctrine, unlock: unlock, ruleset: ruleset)
          du_restriction = Restriction.find_by!(doctrine_unlock: doctrine_unlock)
          restriction_by_name[key] = du_restriction
          du_restriction
        end
      end
    end
  end
end
