class CompanyUnlockService
  class CompanyUnlockValidationError < StandardError; end

  def initialize(company)
    @company = company
  end

  def purchase_doctrine_unlock(doctrine_unlock)
    unlock = doctrine_unlock.unlock

    # Validate company's doctrine matches doctrine unlock's doctrine
    validate_correct_doctrine(doctrine_unlock)
    # Validate company has enough vps to pay the vp cost
    validate_sufficient_vps(doctrine_unlock)
    # Validate company does not already have the doctrine unlock
    validate_unpurchased(doctrine_unlock)

    # Get Restrictions for the doctrineUnlock and associated unlock
    du_restriction = doctrine_unlock.restriction
    u_restriction = unlock.restriction

    # Get EnabledUnits for those restrictions
    enabled_units = EnabledUnit.includes(:unit).where(restriction: [du_restriction, u_restriction])

    # Get DisabledUnits for those restrictions
    disabled_units = DisabledUnit.includes(:unit).where(restriction: [du_restriction, u_restriction])
    # Get Units for the disabled_units
    units_to_remove = disabled_units.map { |du| du.unit }

    # Get UnitSwaps for the unlock
    unit_swaps = UnitSwap.includes(:old_unit, :new_unit).where(unlock: unlock)

    # TODO other RestrictionUnit cases

    # Get EnabledOffmaps for these restrictions
    enabled_offmaps = EnabledOffmap.includes(:offmap).where(restriction: [du_restriction, u_restriction])

    available_units_service = AvailableUnitService.new(@company)
    available_offmaps_service = AvailableOffmapService.new(@company)

    ActiveRecord::Base.transaction do
      # Add available_units for units to add
      available_units_service.create_enabled_available_units(enabled_units) unless enabled_units.blank?

      # Perform any unit swaps
      unless unit_swaps.blank?
        squads = Squad.includes(available_unit: :unit).where(company: @company)
        swap_squad_units(squads, unit_swaps)
      end

      # Destroy available_units of disabled units
      # Destroy squads containing units to disable that weren't swapped
      available_units_service.remove_available_units(units_to_remove) unless units_to_remove.blank?

      # Recalculate company resources when squads might be changed
      if disabled_units.present? || unit_swaps.present?
        update_company_resources
      end

      # add available_offmaps for offmaps to add
      available_offmaps_service.create_enabled_available_offmaps(enabled_offmaps)

      # Create a CompanyUnlock and reduce company vps
      pay_for_company_unlock(doctrine_unlock)
    end
  end

  def refund_company_unlock(company_unlock_id)
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

    # Get EnabledUnits for those restrictions
    previously_enabled_units = EnabledUnit.includes(:unit).where(restriction: [du_restriction, u_restriction])
    # Get Units for the previously_enabled_units
    units_to_remove = previously_enabled_units.map { |eu| eu.unit }

    # Get DisabledUnits for those restrictions
    previously_disabled_units = DisabledUnit.includes(:unit).where(restriction: [du_restriction, u_restriction])
    units_to_add_back = previously_disabled_units.map { |du| du.unit }

    # Get UnitSwaps for the unlock
    unit_swaps = UnitSwap.includes(:old_unit, :new_unit).where(unlock: unlock)

    available_units_service = AvailableUnitService.new(@company)
    ActiveRecord::Base.transaction do
      # Add available_units for previously_disabled_units (we are adding these back)
      available_units_service.recreate_disabled_from_doctrine_unlock(units_to_add_back, doctrine_unlock) unless units_to_add_back.blank?

      # Perform reverse unit swap (assumes each unit is only mapped to 1 other unit)
      unless unit_swaps.blank?
        squads = Squad.includes(available_unit: :unit).where(company: @company)
        swap_squad_units(squads, unit_swaps, reverse: true)
      end

      # Destroy available_units for enabled_units
      # Destroy squads containing units to enable that weren't swapped
      available_units_service.remove_available_units(units_to_remove) unless units_to_remove.blank?

      # Recalculate company resources
      if previously_enabled_units.present? || unit_swaps.present?
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
        Rails.logger.info("Found old unit #{squad.unit} in squad #{squad.id}")
        unit_swap = old_unit_to_unit_swap[squad.unit]

        if reverse
          replacement_unit_id = unit_swap.old_unit_id
        else
          replacement_unit_id = unit_swap.new_unit_id
        end
        au = unit_id_to_available_unit[replacement_unit_id]

        if au.blank?
          Rails.logger.info("AvailableUnit for new unit id #{replacement_unit_id} does not exist for the company, skipping swap")
          next
        end

        squad.update!(available_unit: au)
        new_available = [au.available - 1, 0].max
        au.update!(available: new_available)
      end
    end
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
