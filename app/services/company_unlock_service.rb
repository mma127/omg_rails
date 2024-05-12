class CompanyUnlockService
  class CompanyUnlockValidationError < StandardError; end

  def initialize(company)
    @company = company
    @ruleset = company.ruleset
  end

  def purchase_doctrine_unlock(doctrine_unlock)
    unlock = doctrine_unlock.unlock

    # Validate company not in battle
    validate_company_not_in_battle
    # Validate company's doctrine matches doctrine unlock's doctrine
    validate_correct_doctrine(doctrine_unlock)
    # Validate company has enough vps to pay the vp cost
    validate_sufficient_vps(doctrine_unlock)
    # Validate company does not already have the doctrine unlock
    validate_unpurchased(doctrine_unlock)

    # Get Restrictions for the doctrineUnlock and associated unlock
    du_restriction = doctrine_unlock.restriction
    u_restriction = unlock.restriction
    restriction_params = { restriction: [du_restriction, u_restriction], ruleset: @ruleset }

    # Get EnabledUnits for those restrictions
    enabled_units = EnabledUnit.includes(:unit).where(restriction_params)
    # Get DisabledUnits for those restrictions
    disabled_units = DisabledUnit.includes(:unit).where(restriction_params)
    # Get Units for the disabled_units
    units_to_remove = disabled_units.map { |du| du.unit }

    # Get UnitSwaps for the unlock
    unit_swaps = UnitSwap.includes(:old_unit, :new_unit).where(unlock: unlock)

    # Get ModifiedReplaceUnits for the unlock
    modified_units_to_apply = RestrictionUnit.modified.where(restriction_params)

    # TODO other RestrictionUnit cases

    # Get EnabledOffmaps for these restrictions
    enabled_offmaps = EnabledOffmap.includes(:offmap).where(restriction_params)

    # Get EnabledCallinModifiers for those restrictions
    enabled_callin_modifiers = EnabledCallinModifier.includes(:callin_modifier).where(restriction_params)

    # Get EnabledUpgrades for those restrictions
    enabled_upgrades = EnabledUpgrade.includes(:upgrade, :units).where(restriction_params)
    # Get DisabledUpgrades for those restrictions
    disabled_upgrades = DisabledUpgrade.includes(:upgrade, :units).where(restriction_params)

    # Get UpgradeSwaps for the unlock
    upgrade_swaps = UpgradeSwap.includes(:old_upgrade, :new_upgrade, :upgrade_swap_units).where(unlock: unlock)

    # Get Modified Upgrades for the unlock
    modified_upgrades_to_apply = RestrictionUpgrade.modified.where(restriction_params)

    available_unit_service = AvailableUnitService.new(@company)
    available_offmaps_service = AvailableOffmapService.new(@company)
    company_callin_modifier_service = CompanyCallinModifierService.new(@company)
    available_upgrade_service = AvailableUpgradeService.new(@company)

    ActiveRecord::Base.transaction do
      # Add available_units for units to add
      available_unit_service.create_enabled_available_units(enabled_units) unless enabled_units.blank?

      # Perform any unit swaps
      unless unit_swaps.blank?
        squads = Squad.includes(available_unit: :unit).where(company: @company)
        swap_squad_units(squads, unit_swaps)
      end

      # Destroy available_units of disabled units
      # Destroy squads containing units to disable that weren't swapped
      available_unit_service.remove_available_units(units_to_remove) unless units_to_remove.blank?

      # Reapply unit modifications
      available_unit_service.add_unit_modifications(modified_units_to_apply, doctrine_unlock) unless modified_units_to_apply.blank?

      # Add available_upgrades
      available_upgrade_service.add_enabled_available_upgrades(enabled_upgrades) unless enabled_upgrades.blank?

      # Perform any upgrade swaps
      unless upgrade_swaps.blank?
        squad_upgrades = SquadUpgrade.includes(available_upgrade: :upgrade).where(company: @company)
        swap_squad_upgrades(upgrade_swaps)
      end

      # Destroy available_upgrades of disabled upgrades & associated units (this may not be all units for the upgrade)
      # Destroy squad_upgrades containing upgrades to destroy that weren't swapped
      available_upgrade_service.remove_available_upgrades(disabled_upgrades) unless disabled_upgrades.blank?

      # Reapply upgrade modifications
      available_upgrade_service.add_upgrade_modifications(modified_upgrades_to_apply, doctrine_unlock) unless modified_upgrades_to_apply.blank?

      # Recalculate company resources when squads might be changed
      if disabled_units.present? || unit_swaps.present? || modified_units_to_apply.present? ||
        disabled_upgrades.present? || upgrade_swaps.present? || modified_upgrades_to_apply.present?
        update_company_resources
      end

      #####! Anything below here must not impact company resources !#####

      # add available_offmaps for offmaps to add
      available_offmaps_service.create_enabled_available_offmaps(enabled_offmaps)

      # create company_callin_modifiers for callin_modifiers enabled
      company_callin_modifier_service.create_company_callin_modifiers(enabled_callin_modifiers)

      # Create a CompanyUnlock and reduce company vps
      pay_for_company_unlock(doctrine_unlock)
    end
  end

  def refund_company_unlock(company_unlock_id)
    # Validate company not in battle
    validate_company_not_in_battle
    # Validate company owns this company unlock
    validate_purchased(company_unlock_id)

    # Fetch CompanyUnlock
    company_unlock = CompanyUnlock.includes(doctrine_unlock: [:restriction, unlock: :restriction]).find(company_unlock_id)
    # Get doctrineUnlock for the company unlock
    doctrine_unlock = company_unlock.doctrine_unlock
    unlock = doctrine_unlock.unlock
    # Get Restrictions for the DoctrineUnlock and Unlock
    du_restriction = doctrine_unlock.restriction
    u_restriction = unlock.restriction
    restriction_params = { restriction: [du_restriction, u_restriction], ruleset: @ruleset }

    # Get EnabledUnits for those restrictions
    previously_enabled_units = EnabledUnit.includes(:unit).where(restriction_params)
    # Get Units for the previously_enabled_units
    units_to_remove = previously_enabled_units.map { |eu| eu.unit }

    # Get DisabledUnits for those restrictions
    previously_disabled_units = DisabledUnit.includes(:unit).where(restriction_params)
    units_to_add_back = previously_disabled_units.map { |du| du.unit }

    # Get UnitSwaps for the unlock
    unit_swaps = UnitSwap.includes(:old_unit, :new_unit).where(unlock: unlock)

    # Get ModifiedReplaceUnits for the unlock
    modified_units_to_remove = RestrictionUnit.modified.where(restriction_params)

    # Get EnabledOffmaps for those restrictions
    previously_enabled_offmaps = EnabledOffmap.includes(:offmap).where(restriction_params)
    # Get Offmaps for the previously_enabled_offmaps
    offmaps_to_remove = previously_enabled_offmaps.map { |eo| eo.offmap }

    # Get EnabledCallinModifiers for those restrictions
    previously_enabled_callin_modifiers = EnabledCallinModifier.includes(:callin_modifier).where(restriction_params)
    # Get CallinModifiers for the previously_enabled_callin_modifiers
    callin_modifiers_to_remove = previously_enabled_callin_modifiers.map { |ecm| ecm.callin_modifier }

    # Get EnabledUpgrades for those restrictions
    previously_enabled_upgrades = EnabledUpgrade.includes(:upgrade, :units).where(restriction_params)
    # Get DisabledUpgrades for those restrictions
    previously_disabled_upgrades = DisabledUpgrade.includes(:upgrade, :units).where(restriction_params)
    # Get UpgradeSwaps for the unlock
    upgrade_swaps = UpgradeSwap.includes(:old_upgrade, :new_upgrade, :upgrade_swap_units).where(unlock: unlock)
    # Get Modified Upgrades for the unlock
    modified_upgrades_to_remove = RestrictionUpgrade.modified.where(restriction_params)

    available_unit_service = AvailableUnitService.new(@company)
    available_offmap_service = AvailableOffmapService.new(@company)
    company_callin_modifier_service = CompanyCallinModifierService.new(@company)
    available_upgrade_service = AvailableUpgradeService.new(@company)

    ActiveRecord::Base.transaction do
      # Add available_units for previously_disabled_units (we are adding these back)
      available_unit_service.recreate_disabled_from_doctrine_unlock(units_to_add_back, doctrine_unlock) unless units_to_add_back.blank?

      # Perform reverse unit swap (assumes each unit is only mapped to 1 other unit)
      unless unit_swaps.blank?
        squads = Squad.includes(available_unit: :unit).where(company: @company)
        swap_squad_units(squads, unit_swaps, reverse: true)
      end

      # Destroy available_units for enabled_units
      # Destroy squads containing units to enable that weren't swapped
      available_unit_service.remove_available_units(units_to_remove) unless units_to_remove.blank?

      # Reapply unit modifications
      available_unit_service.remove_unit_modifications(modified_units_to_remove, doctrine_unlock) unless modified_units_to_remove.blank?

      # Add available_upgrades for previously_disabled_upgrades (adding these back)
      available_upgrade_service.recreate_disabled_from_doctrine_unlock(previously_disabled_upgrades, doctrine_unlock) unless previously_disabled_upgrades.blank?
      # Perform reverse upgrade swap (assumes each unit is only mapped to 1 other unit)
      unless upgrade_swaps.blank?
        swap_squad_upgrades(upgrade_swaps, reverse: true)
      end
      # Destroy available_upgrades for enabled_upgrades
      # Destroy squad_upgrades containing upgrades to enable that weren't swapped
      available_upgrade_service.remove_available_upgrades(previously_enabled_upgrades) unless previously_enabled_upgrades.blank?
      # Reapply upgrade modifications
      available_upgrade_service.remove_upgrade_modifications(modified_upgrades_to_remove, doctrine_unlock) unless modified_upgrades_to_remove.blank?

      # Destroy available_offmaps for enabled_offmaps
      # Destroy CompanyOffmaps containing offmaps to enable
      available_offmap_service.remove_available_offmaps(offmaps_to_remove) unless offmaps_to_remove.blank?

      # Destroy CompanyCallinModifiers containing callin_mdifiers_to_remove
      company_callin_modifier_service.remove_callin_modifiers(callin_modifiers_to_remove) unless callin_modifiers_to_remove.blank?

      # Recalculate company resources
      if previously_enabled_units.present? || unit_swaps.present? || modified_units_to_remove.present? ||
        previously_enabled_upgrades.present? || upgrade_swaps.present? || modified_upgrades_to_remove.present? ||
        previously_enabled_offmaps.present?
        update_company_resources
      end

      # Refund company vps_current
      # Destroy company_unlock
      refund_cost_for_company_unlock(company_unlock)
    end
  end

  private

  # For the given squads, determines if the squad's unit is in the list of units to swap.
  # If so, replaces the squad's available_unit with that of the replacement unit
  # Adjusts down the replacement available_unit.available by 1 for each squad swapped
  #
  # NOTE: Does not look at upgrades purchased for the Squad previously.
  def swap_squad_units(squads, unit_swaps, reverse: false)
    if reverse
      old_unit_to_unit_swap = unit_swaps.index_by(&:new_unit) # Unit swap is uniquely indexed on [unlock, new_unit]
    else
      old_unit_to_unit_swap = unit_swaps.index_by(&:old_unit) # Unit swap is uniquely indexed on [unlock, old_unit]
    end
    old_units = old_unit_to_unit_swap.keys

    # Query for the company's base_available_unit as a unit swap does not necessarily need to be tied to enabling/disabling units
    unit_id_to_available_unit = BaseAvailableUnit.where(company: @company).index_by(&:unit_id)

    squads.each do |squad|
      if old_units.include? squad.unit
        # Found a squad with an old unit, replace with new unit
        # Rails.logger.info("Found old unit #{squad.unit_id} in squad #{squad.id}")
        unit_swap = old_unit_to_unit_swap[squad.unit]

        if reverse
          replacement_unit_id = unit_swap.old_unit_id
        else
          replacement_unit_id = unit_swap.new_unit_id
        end
        au = unit_id_to_available_unit[replacement_unit_id]

        if au.blank?
          # Rails.logger.info("AvailableUnit for new unit id #{replacement_unit_id} does not exist for the company, skipping swap")
          next
        end

        squad.update!(available_unit: au)
        new_available = [au.available - 1, 0].max
        au.update!(available: new_available)
      end
    end
  end

  # For the company's squad_upgrades with upgrade in the list of old_upgrades from upgrade_swaps,
  # replaces the SquadUpgrade's AvailableUpgrade with that of the replacement upgrade
  #
  # NOTE: Looks at BaseAvailableUpgrade. Will update all SquadUpgrades for the upgrade regardless of unit
  # If there isn't a BaseAvailableUpgrade for the company with the upgrade/unit combination, skips the swap. If the current
  # upgrade is then disabled, the SquadUpgrade will be destroyed
  def swap_squad_upgrades(upgrade_swaps, reverse: false)
    if reverse
      old_upgrade_to_upgrade_swap = upgrade_swaps.index_by(&:new_upgrade)
    else
      old_upgrade_to_upgrade_swap = upgrade_swaps.index_by(&:old_upgrade)
    end
    old_upgrades = old_upgrade_to_upgrade_swap.keys

    # Query for the company's base_available_upgrade as an upgrade swap does not necessarily need to be tied to enabling/disabling upgrades
    upgrade_id_to_available_upgrade = build_available_upgrades_hash
    squad_upgrades = SquadUpgrade.joins(:squad, :available_upgrade)
                                 .includes(available_upgrade: :upgrade, squad: :available_unit)
                                 .where(squad: { company: @company },
                                        available_upgrades: { upgrade: old_upgrades })
    squad_upgrades.each do |squad_upgrade|
      next unless old_upgrades.include? squad_upgrade.upgrade

      # Found a squad upgrade with an old upgrade, replace with new upgrade
      # Rails.logger.info("Found old upgrade #{squad_upgrade.upgrade.id} in squad_upgrade #{squad_upgrade.id}")
      upgrade_swap = old_upgrade_to_upgrade_swap[squad_upgrade.upgrade]
      unit_ids = upgrade_swap.unit_ids
      squad_unit_id = squad_upgrade.squad.available_unit.unit_id

      next unless unit_ids.include? squad_unit_id

      if reverse
        replacement_upgrade_id = upgrade_swap.old_upgrade_id
      else
        replacement_upgrade_id = upgrade_swap.new_upgrade_id
      end
      au = upgrade_id_to_available_upgrade.dig(replacement_upgrade_id, squad_unit_id)
      if au.blank?
        # Rails.logger.info("AvailableUpgrade for new upgrade id #{replacement_upgrade_id} and unit id #{squad_unit_id} does not exist for the company, skipping swap")
        next
      end

      squad_upgrade.update!(available_upgrade: au)
    end
  end

  def build_available_upgrades_hash
    result = Hash.new { |hash, key| hash[key] = {} }
    BaseAvailableUpgrade.where(company: @company).each do |bau|
      upgrade_id = bau.upgrade_id
      unit_id = bau.unit_id
      result[upgrade_id][unit_id] = bau
    end
    result
  end

  def update_company_resources
    company_service = CompanyService.new(nil)
    company_service.recalculate_and_update_resources(@company)
  end

  # Already validated VPs available and not duplicative company_unlock
  def pay_for_company_unlock(doctrine_unlock)
    CompanyUnlock.create!(company: @company, doctrine_unlock: doctrine_unlock)
    new_vps = @company.vps_current - doctrine_unlock.vp_cost
    @company.update!(vps_current: new_vps)
  end

  def refund_cost_for_company_unlock(company_unlock)
    new_vps = @company.vps_current + company_unlock.doctrine_unlock.vp_cost
    @company.update!(vps_current: new_vps)
    company_unlock.destroy!
  end

  def validate_company_not_in_battle
    if @company.active_battle_id.present?
      raise CompanyUnlockValidationError.new("Company #{@company.id} is in an active battle and cannot be updated")
    end
  end

  def validate_correct_doctrine(doctrine_unlock)
    if @company.doctrine.name != doctrine_unlock.doctrine.name
      raise CompanyUnlockValidationError.new("Company #{@company.id} has doctrine #{@company.doctrine.name} but doctrine unlock #{doctrine_unlock.id} "\
        "belongs to doctrine #{doctrine_unlock.doctrine.name}")
    end
  end

  def validate_sufficient_vps(doctrine_unlock)
    if @company.vps_current < doctrine_unlock.vp_cost
      raise CompanyUnlockValidationError.new("Company #{@company.id} has insufficient VPs to purchase doctrine unlock #{doctrine_unlock.id}, have "\
        "#{@company.vps_current} need #{doctrine_unlock.vp_cost}")
    end
  end

  def validate_unpurchased(doctrine_unlock)
    if @company.company_unlocks.exists?(doctrine_unlock: doctrine_unlock)
      raise CompanyUnlockValidationError.new("Company #{@company.id} already owns doctrine unlock #{doctrine_unlock.id}")
    end
  end

  def validate_purchased(company_unlock_id)
    unless @company.company_unlocks.exists?(id: company_unlock_id)
      raise CompanyUnlockValidationError.new("Company #{@company.id} does not have a company_unlock with id #{company_unlock_id}")
    end
  end
end
