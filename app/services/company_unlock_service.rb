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

    squads = Squad.includes(available_unit: :unit).where(company: @company)

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

    available_units_service = AvailableUnitsService.new(@company)

    ActiveRecord::Base.transaction do
      # Add available_units for units to add
      available_units_service.create_base_available_units(enabled_units) unless enabled_units.blank?

      # Perform any unit swaps
      swap_squad_units(squads, unit_swaps) unless unit_swaps.blank?

      # Destroy available_units of disabled units
      # Destroy squads containing units to disable that weren't swapped
      available_units_service.remove_available_units(units_to_remove) unless units_to_remove.blank?

      # Recalculate company resources when squads might be changed
      if disabled_units.present? || unit_swaps.present?
        company_service = CompanyService.new(nil)
        company_service.recalculate_resources(@company.reload)
      end

      # Create a CompanyUnlock and reduce company vps
      pay_for_company_unlock(doctrine_unlock)
    end
  end

  private

  # For the given squads, determines if the squad's unit is in the list of units to swap.
  # If so, replaces the squad's available_unit with that of the replacement unit
  # Adjusts down the replacement available_unit.available by 1 for each squad swapped
  #
  # NOTE: Does not look at upgrades purchased for the Squad previously.
  def swap_squad_units(squads, unit_swaps)
    old_unit_to_unit_swap = unit_swaps.index_by(&:old_unit) # Unit swap is uniquely indexed on [unlock, old_unit]
    old_units = old_unit_to_unit_swap.keys

    # Query for the company's base_available_unit as a unit swap does not necessarily need to be tied to enabling/disabling units
    unit_id_to_available_unit = BaseAvailableUnit.where(company: @company).index_by(&:unit_id)

    squads.each do |squad|
      if old_units.include? squad.unit
        # Found a squad with an old unit, replace with new unit
        Rails.logger.info("Found old unit #{squad.unit} in squad #{squad.id}")
        unit_swap = old_unit_to_unit_swap[squad.unit]
        au = unit_id_to_available_unit[unit_swap.new_unit_id]

        if au.blank?
          Rails.logger.info("AvailableUnit for new unit id #{unit_swap.new_unit_id} does not exist for the company, skipping swap")
          next
        end

        squad.update!(available_unit: au)
        new_available = [au.available - 1, 0].max
        au.update!(available: new_available)
      end
    end
  end

  # Already validated VPs available and not duplicative company_unlock
  def pay_for_company_unlock(doctrine_unlock)
    CompanyUnlock.create!(company: @company, doctrine_unlock: doctrine_unlock)
    new_vps = @company.vps_current - doctrine_unlock.vp_cost
    @company.update!(vps_current: new_vps)
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
end
