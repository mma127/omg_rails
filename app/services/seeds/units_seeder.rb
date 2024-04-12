require 'csv'

module Seeds
  class UnitsSeeder < ApplicationService
    UNITS_FILENAME = 'lib/assets/units.csv'.freeze
    TRANSPORT_UNITS_FILENAME = 'lib/assets/transport_allowed_units.csv'.freeze
    UNIT_VET_FILENAME = 'lib/assets/unit_vet.csv'.freeze

    # Use the value's vet for the key's unit
    REPLACEMENT_VET = {
      "PE.TH_VAMPIRE": "PE.VAMPIRE",
    }.with_indifferent_access

    class << self
      def create_or_update_all
        units = create_or_update_units
        create_or_update_transport_allowed_units(units)
        create_or_update_unit_vet(units)
      end

      private

      def units_csv
        CSV.open(UNITS_FILENAME, headers: true)
      end

      def transport_allowed_csv
        CSV.open(TRANSPORT_UNITS_FILENAME, headers: true)
      end

      def unit_vet_csv
        CSV.open(UNIT_VET_FILENAME, headers: true)
      end

      def create_or_update_units
        units = []
        units_csv.each do |row|
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

        units
      end

      def create_or_update_transport_allowed_units(units)
        units_by_name = units.index_by(&:name)

        transport_allowed_units = []
        transport_allowed_csv.each do |row|
          transport_name = row["transport_name"]
          allowed_unit_name = row["allowed_unit_name"]
          transport = units_by_name[transport_name]
          allowed_unit = units_by_name[allowed_unit_name]
          transport_allowed_units << TransportAllowedUnit.new(transport: transport, allowed_unit: allowed_unit)
        end
        TransportAllowedUnit.import! transport_allowed_units, on_duplicate_key_update: { conflict_target: [:transport_id, :allowed_unit_id] }
      end

      def create_or_update_unit_vet(units)
        const_to_vet_hash = {}

        # Generated from query
        # select CONSTNAME, Vet1, Vet2, Vet3, Vet4, Vet5 from units;
        unit_vet_csv.each do |row|
          next if row["CONSTNAME"].blank?

          const = row["CONSTNAME"].strip
          vet1 = row["Vet1"]
          vet2 = row["Vet2"]
          vet3 = row["Vet3"]
          vet4 = row["Vet4"]
          vet5 = row["Vet5"]
          const_to_vet_hash[const] = { vet1: vet1, vet2: vet2, vet3: vet3, vet4: vet4, vet5: vet5 }
        end

        unit_vets = []
        units.each do |unit|
          const = get_unit_const(unit)

          vet_hash = const_to_vet_hash[const]

          raise StandardError.new("no unit vet for const #{const}") if vet_hash.blank?

          vet1_exp = split_vet_string(vet_hash[:vet1])[0]
          vet1_desc = split_vet_string(vet_hash[:vet1])[1]
          vet2_exp = split_vet_string(vet_hash[:vet2])[0]
          vet2_desc = split_vet_string(vet_hash[:vet2])[1]
          vet3_exp = split_vet_string(vet_hash[:vet3])[0]
          vet3_desc = split_vet_string(vet_hash[:vet3])[1]
          vet4_exp = split_vet_string(vet_hash[:vet4])[0]
          vet4_desc = split_vet_string(vet_hash[:vet4])[1]
          vet5_exp = split_vet_string(vet_hash[:vet5])[0]
          vet5_desc = split_vet_string(vet_hash[:vet5])[1]

          values = { unit: unit, vet1_exp: vet1_exp, vet1_desc: vet1_desc, vet2_exp: vet2_exp, vet2_desc: vet2_desc,
                     vet3_exp: vet3_exp, vet3_desc: vet3_desc, vet4_exp: vet4_exp, vet4_desc: vet4_desc,
                     vet5_exp: vet5_exp, vet5_desc: vet5_desc }

          unit_vets << UnitVet.new(values)
        end

        UnitVet.import! unit_vets, on_duplicate_key_update: {
          conflict_target: [:unit_id],
          columns: [:vet1_desc, :vet1_exp, :vet2_desc, :vet2_exp, :vet3_desc, :vet3_exp, :vet4_desc, :vet4_exp, :vet5_desc, :vet5_exp]
        }
      end

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

      def get_unit_const(unit)
        const = unit.const_name

        if REPLACEMENT_VET.keys.include?(const)
          REPLACEMENT_VET[const]
        else
          const
        end
      end

      def split_vet_string(str)
        str.split(';')
      end
    end
  end
end