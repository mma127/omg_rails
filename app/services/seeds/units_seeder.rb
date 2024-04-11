require 'csv'

module Seeds
  class UnitsSeeder < ApplicationService
    UNITS_FILENAME = 'lib/assets/units.csv'.freeze
    TRANSPORT_UNITS_FILENAME = 'lib/assets/transport_allowed_units.csv'.freeze

    class << self
      def create_or_update_all
        units = []
        CSV.foreach(UNITS_FILENAME, headers: true) do |row|
          name = row["name"]
          type = row["type"]
          unit_class = get_unit_class(type)
          const_name = row["const_name"]
          display_name = row["display_name"]
          description = row["description"]
          upgrade_slots = row["upgrade_slots"]
          unitwide_upgrade_slots = row["unitwide_upgrade_slots"]
          model_count = row["model_count"]
          transport_squad_slots = row["transport_squad_slots"]
          transport_model_slots = row["transport_model_slots"]
          is_airdrop = row["is_airdrop"]
          is_infiltrate = row["is_infiltrate"]
          retreat_name = row["retreat_name"]

          units << unit_class.new(name: name, const_name: const_name, display_name: display_name, description: description,
                                  upgrade_slots: upgrade_slots, unitwide_upgrade_slots: unitwide_upgrade_slots, model_count: model_count,
                                  transport_squad_slots: transport_squad_slots, transport_model_slots: transport_model_slots,
                                  is_airdrop: is_airdrop, is_infiltrate: is_infiltrate, retreat_name: retreat_name)
        end
        Unit.import! units, on_duplicate_key_update: {
          conflict_target: [:name],
          columns: [:const_name, :display_name, :description, :upgrade_slots, :unitwide_upgrade_slots, :model_count,
                    :transport_squad_slots, :transport_model_slots, :is_airdrop, :is_infiltrate, :retreat_name]
        }

        units_by_name = units.index_by(&:name)

        transport_allowed_units = []
        CSV.foreach(TRANSPORT_UNITS_FILENAME, headers: true) do |row|
          transport_name = row["transport_name"]
          allowed_unit_name = row["allowed_unit_name"]
          transport = units_by_name[transport_name]
          allowed_unit = units_by_name[allowed_unit_name]
          transport_allowed_units << TransportAllowedUnit.new(transport: transport, allowed_unit: allowed_unit)
        end
        TransportAllowedUnit.import! transport_allowed_units, on_duplicate_key_update: { conflict_target: [:transport_id, :allowed_unit_id] }
      end

      private

      def get_unit_class(type)
        case type
        when "Infantry"
          Infantry
        when "SupportTeam"
          SupportTeam
        when "LightVehicle"
          LightVehicle
        when "Tank"
          Tank
        when "Emplacement"
          Emplacement
        when "Glider"
          Glider
        else
          raise ArgumentError.new "Unknown unit type #{type}"
        end
      end
    end
  end
end