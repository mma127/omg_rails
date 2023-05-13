class AvailableUpgradeService
  class AvailableUpgradesValidationError < StandardError; end

  class EnabledUpgradeNotFoundError < StandardError; end

  class UnsupportedModificationError < StandardError; end

  def initialize(company)
    @company = Company.includes(:player, :faction, :doctrine, doctrine_unlocks: :unlock).find(company.id)
    @player = company.player
    @faction = company.faction
    @doctrine = company.doctrine
  end

  # Given a new company, determine the available upgrades for the company
  # Taking into account:
  #   Faction upgrades
  #   Doctrine upgrades
  #
  #   and the units that may use them
  def build_new_company_available_upgrades
    validate_empty_available_upgrades

    allowed_upgrades_hash = get_base_faction_doctrine_upgrade_hash

    # Create available upgrades with the filtered collection of restriction upgrades
    create_enabled_available_upgrades(allowed_upgrades_hash)
  end

  # Create BaseAvailableUpgrades for the given enabled_upgrades
  # Will OVERRIDE conflicting BaseAvailableUpgrade if exists already, acting like a modify replace
  def add_enabled_available_upgrades(enabled_upgrades)
    enabled_upgrades_hash = build_enabled_upgrades_hash(enabled_upgrades)
    create_enabled_available_upgrades(enabled_upgrades_hash)
  end

  # Add available_upgrades for previously_disabled_upgrades (adding these back)
  # When refunding a doctrine unlock, it's possible to reenable previously disabled upgrades
  # IMPORTANT: Only handles 1 enabled_upgrade per upgrade (and unit????todo) for company unlocks
  def recreate_disabled_from_doctrine_unlock(previously_disabled_upgrades, doctrine_unlock)
    upgrade_ids = previously_disabled_upgrades.map { |pdu| pdu.upgrade_id }
    # Cannot validate there are no current available_upgrades for the given upgrade and unit as it's possible
    # that two different doctrine unlocks make available the same upgrade/unit combination
    # Instead, overwrite the MODIFY_FIELDS of the available_upgrade

    # Start with basic upgrades available for faction and doctrine
    # upgrade_id -> unit_id -> enabled_upgrade
    allowed_upgrades_hash = get_base_faction_doctrine_upgrade_hash

    # Filter to only the upgrades/units that were previously disabled
    allowed_upgrades_hash = allowed_upgrades_hash.slice(*previously_disabled_upgrades.map { |u| u.upgrade_id })
    possible_unit_ids = Set.new
    previously_disabled_upgrades.each do |pdu|
      next unless allowed_upgrades_hash.include? pdu.upgrade_id

      # keep only units in the allowed_upgrades_hash that are in the pdu list of units
      unit_ids = pdu.units.pluck(:id)
      possible_unit_ids.merge unit_ids
      allowed_upgrades_hash[pdu.upgrade_id].keys.each do |potential_unit_id|
        next if unit_ids.include? potential_unit_id

        allowed_upgrades_hash[pdu.upgrade_id].delete(potential_unit_id)
      end
    end

    # Apply all company unlocks except the given doctrine_unlock (that is being refunded)
    company_unlocks = CompanyUnlock.where(company: @company).where.not(doctrine_unlock: doctrine_unlock)
    restrictions = company_unlocks.map do |cu|
      [cu.doctrine_unlock.restriction, cu.doctrine_unlock.unlock.restriction]
    end.flatten
    # Get only enabled_upgrades for the company unlock restrictions and the upgrades/units that were disabled
    # Can use all possible_unit_ids since RestrictionUpgrade is uniq index on restriction + upgrade + type
    enabled_upgrades = EnabledUpgrade.joins(:restriction_upgrade_units)
                                     .where(restriction: restrictions, upgrade_id: upgrade_ids,
                                            restriction_upgrade_units: { unit_id: possible_unit_ids })
    enabled_upgrades_by_upgrade_unit_id = build_enabled_upgrades_hash(enabled_upgrades)
    # Filter for only units associated with the disabled upgrades
    previously_disabled_upgrades.each do |pdu|
      next unless enabled_upgrades_by_upgrade_unit_id.include? pdu.upgrade_id

      unit_ids = pdu.units.pluck(:id)
      enabled_upgrades_by_upgrade_unit_id[pdu.upgrade_id].keys.each do |potential_unit_id|
        next if unit_ids.include? potential_unit_id

        enabled_upgrades_by_upgrade_unit_id[pdu.upgrade_id].delete(potential_unit_id)
      end
    end

    # Merge
    enabled_upgrades_by_upgrade_unit_id = merge_allowed_upgrades(allowed_upgrades_hash, enabled_upgrades_by_upgrade_unit_id)

    # Get disabled_upgrades for the company_unlock restrictions and upgrades/units that were disabled (in the unlikely case
    # that multiple unlocks disable the same upgrade/unit)
    disabled_upgrades = DisabledUpgrade.joins(:restriction_upgrade_units)
                                       .where(restriction: restrictions, upgrade_id: upgrade_ids,
                                              restriction_upgrade_units: { unit_id: possible_unit_ids })
    disabled_upgrade_id_to_unit_ids = build_disabled_upgrades_hash(disabled_upgrades)
    enabled_upgrades_by_upgrade_unit_id = remove_disabled_upgrades(enabled_upgrades_by_upgrade_unit_id, disabled_upgrade_id_to_unit_ids)

    if enabled_upgrades_by_upgrade_unit_id.blank?
      Rails.logger.info("No enabled upgrades found to recreate that were disabled by doctrineUnlock #{doctrine_unlock.id} for company #{@company.id}")
    else
      Rails.logger.info("Found #{enabled_upgrades_by_upgrade_unit_id.size} upgrades, creating available upgrades that were disabled "\
        "by doctrineUnlock #{doctrine_unlock.id} for company #{@company.id}")
      create_enabled_available_upgrades(enabled_upgrades_by_upgrade_unit_id)
    end
  end

  # Destroy available_upgrades of disabled upgrades & associated units (this may not be all units for the upgrade)
  # Destroy squad_upgrades containing upgrades to destroy that weren't swapped
  def remove_available_upgrades(disabled_upgrades)
    disabled_upgrades_hash = build_disabled_upgrades_hash(disabled_upgrades)
    disabled_upgrades_hash.each do |upgrade_id, unit_ids|
      available_upgrades = AvailableUpgrade.where(company: @company, upgrade_id: upgrade_id, unit_id: unit_ids)
      available_upgrades.destroy_all # squad_upgrades destroyed via dependent destroy
    end
  end

  def add_upgrade_modifications(modified_upgrades_to_apply, doctrine_unlock)
    # build a hash of upgrade to unit ids
    upgrade_to_unit_id = build_upgrade_to_unit_hash(modified_upgrades_to_apply)

    # Get all restrictions for all doctrine unlocks and unlocks of the company
    doctrine_unlock_ids = @company.doctrine_unlocks.pluck(:id) << doctrine_unlock.id
    unlock_ids = @company.unlocks.pluck(:id) << doctrine_unlock.unlock_id
    du_u_restrictions = Restriction.where(doctrine_unlock_id: doctrine_unlock_ids)
                                   .or(Restriction.where(unlock_id: unlock_ids))

    reapply_upgrade_modifications(upgrade_to_unit_id, du_u_restrictions)
  end

  def remove_upgrade_modifications(modified_upgrades_to_remove, doctrine_unlock)
    # build a hash of upgrade to unit ids
    upgrade_to_unit_id = build_upgrade_to_unit_hash(modified_upgrades_to_remove)

    # Get all restrictions for all doctrine unlocks and unlocks of the company without the doctrine unlock being removed
    doctrine_unlock_ids = @company.doctrine_unlocks.pluck(:id).without(doctrine_unlock.id)
    unlock_ids = @company.unlocks.pluck(:id).without(doctrine_unlock.unlock_id)
    du_u_restrictions = Restriction.where(doctrine_unlock_id: doctrine_unlock_ids)
                                   .or(Restriction.where(unlock_id: unlock_ids))

    reapply_upgrade_modifications(upgrade_to_unit_id, du_u_restrictions)
  end

  private

  # OVERRIDES conflicting BaseAvailableUpgrade if exists already, acting like a modify replace
  def create_enabled_available_upgrades(enabled_upgrades_hash)
    available_upgrades = []
    enabled_upgrades_hash.values.each do |unit_id_hash|
      unit_id_hash.each do |unit_id, enabled_upgrade|
        available_upgrades << instantiate_base_available_upgrade(enabled_upgrade, unit_id)
      end
    end.flatten
    BaseAvailableUpgrade.import!(available_upgrades,
                                 on_duplicate_key_update: { conflict_target: [:company_id, :upgrade_id, :unit_id, :type],
                                                            columns: [:pop, :man, :mun, :fuel, :uses, :max] })
  end

  # Calculates the basic set of upgrades available for the company's faction and doctrine
  def get_base_faction_doctrine_upgrade_hash
    # Get restriction for Faction, then find all faction allowed upgrades
    faction_restriction = Restriction.find_by(faction: @faction)
    faction_allowed_upgrades = get_enabled_upgrade_hash faction_restriction

    # Get restriction for Doctrine, then find all doctrine allowed upgrades
    doctrine_restriction = Restriction.find_by(doctrine: @doctrine)
    doctrine_allowed_upgrades = get_enabled_upgrade_hash doctrine_restriction
    doctrine_disabled_upgrades = get_disabled_upgrade_hash doctrine_restriction

    allowed_upgrades_hash = faction_allowed_upgrades
    allowed_upgrades_hash = merge_allowed_upgrades(allowed_upgrades_hash, doctrine_allowed_upgrades)
    remove_disabled_upgrades(allowed_upgrades_hash, doctrine_disabled_upgrades)
  end

  # Create multi-level hash of
  # upgrade_id
  #   -> unit_id
  #     -> enabled_upgrade (this can be replaced when merging a more specific upgrade hash ie, doctrine upgrade hash)
  def get_enabled_upgrade_hash(restriction)
    enabled_upgrades = EnabledUpgrade.includes(:units).where(restriction: restriction, ruleset: @company.ruleset)
    build_enabled_upgrades_hash(enabled_upgrades)
  end

  def build_enabled_upgrades_hash(enabled_upgrades)
    result = Hash.new { |hash, key| hash[key] = {} }
    enabled_upgrades.each do |enabled_upgrade|
      upgrade_id = enabled_upgrade.upgrade_id
      enabled_upgrade.units.each do |unit|
        result[upgrade_id][unit.id] = enabled_upgrade
      end
    end
    result
  end

  # Creates hash of
  # upgrade_id -> Set of unit_id
  def get_disabled_upgrade_hash(restriction)
    disabled_upgrades = DisabledUpgrade.includes(:units).where(restriction: restriction, ruleset: @company.ruleset)
    build_disabled_upgrades_hash(disabled_upgrades)
  end

  def build_disabled_upgrades_hash(disabled_upgrades)
    result = Hash.new { |hash, key| hash[key] = Set.new }
    disabled_upgrades.each do |disabled_upgrade|
      upgrade_id = disabled_upgrade.upgrade_id
      disabled_upgrade.units.each do |unit|
        result[upgrade_id].add(unit.id)
      end
    end
    result
  end

  def merge_allowed_upgrades(existing_upgrades_hash, restricted_upgrades_hash)
    if restricted_upgrades_hash.present?
      existing_upgrades_hash = existing_upgrades_hash.deep_merge(restricted_upgrades_hash)
    end
    existing_upgrades_hash
  end

  def remove_disabled_upgrades(existing_upgrades_hash, disabled_upgrades_hash)
    if disabled_upgrades_hash.present?
      # existing_upgrades_hash = existing_upgrades_hash.except(*disabled_upgrades_hash.keys)
      disabled_upgrades_hash.each do |upgrade_id, unit_id_set|
        next unless existing_upgrades_hash.include? upgrade_id

        unit_id_set.each do |unit_id|
          next unless existing_upgrades_hash[upgrade_id].include? unit_id

          existing_upgrades_hash[upgrade_id].delete(unit_id)
        end

        existing_upgrades_hash.delete(upgrade_id) if existing_upgrades_hash[upgrade_id].empty?
      end
    end
    existing_upgrades_hash
  end

  def instantiate_base_available_upgrade(restriction_upgrade, unit_id)
    BaseAvailableUpgrade.new(upgrade: restriction_upgrade.upgrade, unit_id: unit_id, company: @company,
                             pop: restriction_upgrade.pop, man: restriction_upgrade.man, mun: restriction_upgrade.mun,
                             fuel: restriction_upgrade.fuel, uses: restriction_upgrade.uses, max: restriction_upgrade.max)
  end

  # Apply any modification RestrictionUpgrades associated with the given restrictions against any BaseAvailableUpgrades
  # for the hash of upgrades to list of unit_ids
  # Since we expect there will be pre-existing BaseAvailableUpgrades, we want to calculate from scratch what the state
  # of the BaseAvailableUpgrade is, then overwrite the existing BaseAvailableUpgrade's fields with those values
  def reapply_upgrade_modifications(upgrades_to_unit_ids, restrictions)
    # Get all modified upgrades for the given restrictions of the company
    all_modified_upgrades = RestrictionUpgrade.modified.where(restriction: restrictions)

    # For each upgrade and unit combination
    upgrades_to_unit_ids.each do |upgrade, unit_ids|
      unit_ids.each do |unit_id|
        # Recalculate unmodified BaseAvailableUpgrade
        new_base_available_upgrade = get_unmodified_base_available_upgrade(upgrade, unit_id, restrictions)

        # Ordered list of modified upgrades for the upgrade and unit, ascending priority order
        ordered_modified_upgrades = all_modified_upgrades.joins(:restriction_upgrade_units)
                                                         .where(upgrade: upgrade, restriction_upgrade_units: { unit_id: unit_id })
                                                         .order(:priority)

        # Apply modifications to the unmodified BaseAvailableUpgrade, in priority order ascending
        new_base_available_upgrade = apply_modified_upgrades(new_base_available_upgrade, ordered_modified_upgrades)

        # Get existing BaseAvailableUpgrade
        existing_base_available_upgrade = BaseAvailableUpgrade.find_by!(company: @company, upgrade: upgrade, unit_id: unit_id)

        # Apply modify field attributes to the existing BaseAvailableUpgrade
        overwrite_modify_upgrade_fields(existing_base_available_upgrade, new_base_available_upgrade)
      end
    end
  end

  def build_upgrade_to_unit_hash(restriction_upgrades)
    upgrades_to_unit_ids = Hash.new { |hash, key| hash[key] = Set.new }
    restriction_upgrades.each do |modified_upgrade|
      upgrade = modified_upgrade.upgrade
      modified_upgrade.units.each do |unit|
        upgrades_to_unit_ids[upgrade].add(unit.id)
      end
    end
    upgrades_to_unit_ids
  end

  def get_unmodified_base_available_upgrade(upgrade, unit_id, du_u_restrictions)
    du_u_enabled_upgrade = find_enabled_upgrade(du_u_restrictions, upgrade, unit_id)
    return instantiate_base_available_upgrade(du_u_enabled_upgrade, unit_id) if du_u_enabled_upgrade.present?

    doctrine_enabled_upgrade = find_enabled_upgrade(@doctrine.restriction, upgrade, unit_id)
    return instantiate_base_available_upgrade(doctrine_enabled_upgrade, unit_id) if doctrine_enabled_upgrade.present?

    faction_enabled_upgrade = find_enabled_upgrade(@faction.restriction, upgrade, unit_id)
    return instantiate_base_available_upgrade(faction_enabled_upgrade, unit_id) if faction_enabled_upgrade.present?

    raise EnabledUpgradeNotFoundError.new("Could not determine an unmodified EnabledUpgrade for upgrade #{upgrade.id} "\
      "and unit #{unit_id} in company #{@company.id}")
  end

  def apply_modified_upgrades(new_base_available_upgrade, ordered_modified_upgrades)
    ordered_modified_upgrades.each do |mu|
      apply_modified_upgrade(new_base_available_upgrade, mu)
    end
    new_base_available_upgrade
  end

  def apply_modified_upgrade(new_base_available_upgrade, modified_upgrade)
    case modified_upgrade.class.name
    when ModifiedReplaceUpgrade.name
      apply_modified_replace_upgrade(new_base_available_upgrade, modified_upgrade)
    when ModifiedAddUpgrade.name
      apply_modified_add_upgrade(new_base_available_upgrade, modified_upgrade)
    else
      raise UnsupportedModificationError.new("Unsupported upgrade modification for class #{modified_upgrade&.class} and id #{modified_upgrade&.id}")
    end
  end

  def apply_modified_replace_upgrade(new_base_available_upgrade, modified_replace_upgrade)
    RestrictionUpgrade::MODIFY_FIELDS.each do |attr|
      next unless modified_replace_upgrade[attr].present?

      new_base_available_upgrade[attr] = modified_replace_upgrade[attr]
    end
    new_base_available_upgrade
  end

  def apply_modified_add_upgrade(new_base_available_upgrade, modified_add_upgrade)
    RestrictionUpgrade::MODIFY_FIELDS.each do |attr|
      next unless modified_add_upgrade[attr].present?

      new_value = [new_base_available_upgrade[attr] + modified_add_upgrade[attr], 0].max # Don't want negative costs
      new_base_available_upgrade[attr] = new_value
    end
    new_base_available_upgrade
  end

  def overwrite_modify_upgrade_fields(existing_base_available_upgrade, new_base_available_upgrade)
    RestrictionUpgrade::MODIFY_FIELDS.each do |attr|
      next if existing_base_available_upgrade[attr] == new_base_available_upgrade[attr]

      existing_base_available_upgrade[attr] = new_base_available_upgrade[attr]
    end
    existing_base_available_upgrade.save!
  end

  def find_enabled_upgrade(restrictions, upgrade, unit_id)
    EnabledUpgrade.joins(:restriction_upgrade_units)
                  .find_by(restriction: restrictions, upgrade: upgrade, ruleset: @company.ruleset,
                           restriction_upgrade_units: { unit_id: unit_id })
  end

  def validate_empty_available_upgrades
    raise AvailableUpgradesValidationError.new("Company #{@company.id} has existing AvailableUpgrades") unless AvailableUpgrade.where(company: @company).empty?
  end

  def validate_no_base_available_units_for_given(upgrades)
    unless BaseAvailableUpgrade.where(company: @company, upgrade: upgrades).empty?
      raise AvailableUpgradesValidationError.new("Company #{company.id} already has existing base available upgrades for a subset of #{upgrades.pluck(:id)}")
    end
  end
end