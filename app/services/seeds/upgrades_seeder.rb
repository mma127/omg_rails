require 'csv'

module Seeds
  class UpgradesSeeder < ApplicationService
    class << self
      def create_or_update_all
        upgrades = []
        upgrade_names = Set.new
        csv_paths.each do |path|
          CSV.foreach(path, headers: true) do |row|
            name = row['upgrade']
            next if upgrade_names.include? name

            const = row['const']
            display_name = row['display_name']
            description = row['description']
            model_count = row['model_count']
            add_model_count = row['add_model_count']
            type = row['type']
            upgrade_class = get_upgrade_class(type)
            # puts "#{name} | #{const} | #{display_name} | #{model_count} | #{add_model_count} | #{type}"

            upgrades << upgrade_class.new(name: name, const_name: const, display_name: display_name, description: description,
                                          model_count: model_count, additional_model_count: add_model_count)
            upgrade_names.add(name)
          end
        end
        Upgrade.import! upgrades, on_duplicate_key_update: {
          conflict_target: [:name],
          columns: [:const_name, :display_name, :description, :model_count, :additional_model_count]
        }
      end

      private

      def csv_paths
        %w[lib/assets/enabled_upgrades_ame.csv lib/assets/enabled_upgrades_cmw.csv lib/assets/enabled_upgrades_wehr.csv lib/assets/enabled_upgrades_pe.csv]
      end

      def get_upgrade_class(type)
        case type
        when "single_weapon"
          Upgrades::SingleWeapon
        when "consumable"
          Upgrades::Consumable
        when "ability"
          Upgrades::Ability
        when "building"
          Upgrades::Building
        when "passive"
          Upgrades::Passive
        when "squad_weapon"
          Upgrades::SquadWeapon
        when "unit_replacement"
          Upgrades::UnitReplacement
        else
          raise StandardError.new "Unknown upgrade type #{type}"
        end
      end
    end
  end
end
