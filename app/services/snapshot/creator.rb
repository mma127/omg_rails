require 'securerandom'

module Snapshot
  class Creator < ApplicationService
    class SnapshotCreatorValidationError < StandardError; end

    def initialize(player, source_company_id)
      @player = player
      @source_company_id = source_company_id
    end

    # Clone the source Company and associated
    # CompanyStats
    #
    # AvailableUnit
    # AvailableOffmap
    # AvailableUpgrade
    #
    # Squad
    # TransportedSquad
    # SquadUpgrade
    #
    # CompanyCallinModifier
    # CompanyUnlock
    # CompanyOffmap
    # CompanyResourceBonus
    def create
      validate_can_create_snapshot

      @new_company = build_new_company
      new_company_stats = dup_company_stats

      # Need to create these maps so we can associate the new available entities with the new squad/squadUpgrade/CompanyOffmap entities
      old_available_unit_id_to_new_available_unit = map_available_unit_id_to_dup_available_unit
      old_available_offmap_id_to_new_available_offmap = map_available_offmap_id_to_dup_available_offmap
      old_available_upgrade_id_to_new_available_upgrade = map_available_upgrade_id_to_dup_available_upgrade

      old_squad_id_to_new_squad = map_squad_id_to_dup_squad(old_available_unit_id_to_new_available_unit)
      new_transported_squads = build_transported_squads(old_squad_id_to_new_squad)
      new_squad_upgrades = build_squad_upgrades(old_squad_id_to_new_squad, old_available_upgrade_id_to_new_available_upgrade)

      new_company_callin_modifiers = build_company_callin_modifiers
      new_company_unlocks = build_company_unlocks
      new_company_offmaps = build_company_offmaps(old_available_offmap_id_to_new_available_offmap)
      new_company_resource_bonuses = build_company_resource_bonuses

      ActiveRecord::Base.transaction do
        @new_company.save!
        new_company_stats.save!

        AvailableUnit.import! old_available_unit_id_to_new_available_unit.values
        AvailableOffmap.import! old_available_offmap_id_to_new_available_offmap.values
        AvailableUpgrade.import! old_available_upgrade_id_to_new_available_upgrade.values

        Squad.import! old_squad_id_to_new_squad.values
        TransportedSquad.import! new_transported_squads
        SquadUpgrade.import! new_squad_upgrades

        CompanyCallinModifier.import! new_company_callin_modifiers
        CompanyUnlock.import! new_company_unlocks
        CompanyOffmap.import! new_company_offmaps
        CompanyResourceBonus.import! new_company_resource_bonuses
      end
    end

    private

    def validate_can_create_snapshot
      unless SnapshotCompany.where(player: @player).count < SnapshotCompany::LIMIT
        raise SnapshotCreatorValidationError.new("Player #{player.name} has the limit of #{SnapshotCompany::LIMIT} Snapshot Companies and cannot create another one.")
      end
    end

    def source_company
      @source_company ||= Company.includes(
        :available_units,
        :available_offmaps,
        :available_upgrades,
        squads: [:transporting_transported_squads, :squad_upgrades],
      ).find(@source_company_id)
    end

    def build_new_company
      new_company = source_company.dup
      new_company.type = SnapshotCompany.class_name
      new_company
    end

    def dup_company_stats
      new_company_stats = source_company.company_stats.dup
      new_company_stats.company = @new_company
      new_company_stats
    end

    def map_available_unit_id_to_dup_available_unit
      source_company.available_units.map do |au|
        dup = au.dup
        dup.company = @new_company
        [au.id, dup]
      end.to_h
    end

    def map_available_offmap_id_to_dup_available_offmap
      source_company.available_offmaps.map do |ao|
        dup = ao.dup
        dup.company = @new_company
        [ao.id, dup]
      end.to_h
    end

    def map_available_upgrade_id_to_dup_available_upgrade
      source_company.available_upgrades.map do |ao|
        dup = ao.dup
        dup.company = @new_company
        [ao.id, dup]
      end.to_h
    end

    def map_squad_id_to_dup_squad(old_available_unit_id_to_new_available_unit)
      source_company.squads.map do |s|
        dup = s.dup
        dup.available_unit = old_available_unit_id_to_new_available_unit[s.available_unit_id]
        dup.company = @new_company
        dup.uuid = SecureRandom.uuid
        [s.id, dup]
      end.to_h
    end

    def build_transported_squads(old_squad_id_to_new_squad)
      source_company.transporting_transported_squads.map do |ts|
        old_transport_id = ts.transport_squad_id
        embarked_squad_id = ts.embarked_squad_id
        TransportedSquad.new(transport_squad: old_squad_id_to_new_squad[old_transport_id],
                             embarked_squad: old_squad_id_to_new_squad[embarked_squad_id])
      end
    end

    def build_squad_upgrades(old_squad_id_to_new_squad, old_available_upgrade_id_to_new_available_upgrade)
      source_company.squad_upgrades.map do |su|
        dup = su.dup
        dup.squad = old_squad_id_to_new_squad[su.squad_id]
        dup.available_upgrade = old_available_upgrade_id_to_new_available_upgrade[su.available_upgrade_id]
        dup
      end
    end

    def build_company_callin_modifiers
      source_company.company_callin_modifiers.map do |ccm|
        dup = ccm.dup
        dup.company = @new_company
        dup
      end
    end

    def build_company_unlocks
      source_company.company_unlocks.map do |cu|
        dup = cu.dup
        dup.company = @new_company
        dup
      end
    end

    def build_company_offmaps(old_available_offmap_id_to_new_available_offmap)
      source_company.company_offmaps.map do |co|
        dup = co.dup
        dup.company = @new_company
        dup.available_offmap = old_available_offmap_id_to_new_available_offmap[co.available_offmap_id]
        dup
      end
    end

    def build_company_resource_bonuses
      source_company.company_resource_bonuses.map do |crb|
        dup = crb.dup
        dup.company = @new_company
        dup
      end
    end
  end
end
