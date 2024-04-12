after :rulesets do
  # Create RestrictionUnits to associate Units with Restrictions and their costs per restriction
  # This associates Units with a Faction, Doctrine, or Unlock, and allows them to be priced separately
  # For example, a Riflemen unit in the Infantry doctrine can have different pricing and resupply than the
  # generic American faction Riflemen unit

  def doctrine_unlock_name(doctrine_name, unlock_name)
    "#{doctrine_name}|#{unlock_name}"
  end

  war_ruleset = Ruleset.find_by(ruleset_type: Ruleset.ruleset_types[:war], is_active: true)

  @units_by_name = Unit.all.index_by(&:name)

  @factions_by_name = Faction.all.index_by(&:name)
  @doctrines_by_name = Doctrine.all.index_by(&:name)
  @unlocks_by_name = Unlock.where(ruleset: war_ruleset).all.index_by(&:name)
  @doctrine_unlocks_by_names = DoctrineUnlock.includes(:doctrine, :unlock).where(ruleset: war_ruleset).all.index_by { |du| doctrine_unlock_name(du.doctrine.name, du.unlock.name) }

  @faction_restrictions_by_name = {}
  @doctrine_restrictions_by_name = {}
  @unlock_restrictions_by_name = {}
  @doctrine_unlock_restrictions_by_names = {}

  def get_unit(unit_name)
    if @units_by_name.include? unit_name
      @units_by_name[unit_name]
    else
      raise StandardError.new("Unknown unit name #{unit_name}")
    end
  end

  def get_unlock(unlock_name)
    if @unlocks_by_name.include? unlock_name
      @unlocks_by_name[unlock_name]
    else
      raise StandardError.new("Unknown unlock name #{unlock_name}")
    end
  end

  def get_restriction(faction_name, doctrine_name, unlock_name)
    if faction_name.present?
      if @faction_restrictions_by_name.include? faction_name
        @faction_restrictions_by_name[faction_name]
      else
        faction = @factions_by_name[faction_name]
        restriction = Restriction.find_by!(faction: faction)
        @faction_restrictions_by_name[faction_name] = restriction
        restriction
      end
    elsif doctrine_name.present? && unlock_name.present?
      du_name = doctrine_unlock_name(doctrine_name, unlock_name)
      if @doctrine_unlock_restrictions_by_names.include? du_name
        @doctrine_unlock_restrictions_by_names[du_name]
      else
        doctrine_unlock = @doctrine_unlocks_by_names[du_name]
        restriction = Restriction.find_by!(doctrine_unlock: doctrine_unlock)
        @doctrine_unlock_restrictions_by_names[du_name] = restriction
        restriction
      end
    elsif doctrine_name.present?
      if @doctrine_restrictions_by_name.include? doctrine_name
        @doctrine_restrictions_by_name[doctrine_name]
      else
        doctrine = @doctrines_by_name[doctrine_name]
        restriction = Restriction.find_by!(doctrine: doctrine)
        @doctrine_restrictions_by_name[doctrine_name] = restriction
        restriction
      end
    elsif unlock_name.present?
      if @unlock_restrictions_by_name.include? unlock_name
        @unlock_restrictions_by_name[unlock_name]
      else
        unlock = @unlocks_by_name[unlock_name]
        restriction = Restriction.find_by!(unlock: unlock)
        @unlock_restrictions_by_name[unlock_name] = restriction
        restriction
      end
    else
      raise StandardError.new("Unknown restriction: faction name #{faction_name}, doctrine name: #{doctrine_name}, unlock name: #{unlock_name}")
    end
  end

  def get_type_class(type)
    class_type = type.constantize
    if class_type < RestrictionUnit
      return class_type
    else
      raise StandardError.new("Class name #{type} is not a subclass of RestrictionUnit")
    end
  end

  CSV.foreach("db/seeds/unit_restrictions.csv", headers: true) do |row|
    unit_name = row["unit_name"]
    type = row["type"]
    faction_name = row["faction_name"]
    doctrine_name = row["doctrine_name"]
    unlock_name = row["unlock_name"]
    pop = row["pop"]
    man = row["man"]
    mun = row["mun"]
    fuel = row["fuel"]
    resupply = row["resupply"]
    resupply_max = row["resupply_max"]
    company_max = row["company_max"]
    callin_modifier = row["callin_modifier"]
    priority = row["priority"]
    upgrade_slots = row["upgrade_slots"]
    unitwide_upgrade_slots = row["unitwide_upgrade_slots"]

    unit = get_unit(unit_name)
    restriction = get_restriction(faction_name, doctrine_name, unlock_name)
    type_class = get_type_class(type)

    restriction_unit = type_class.create!(restriction: restriction, unit: unit, ruleset: war_ruleset,
                                          man: man, mun: mun, fuel: fuel, pop: pop,
                                          resupply: resupply, resupply_max: resupply_max, company_max: company_max, priority: priority,
                                          upgrade_slots: upgrade_slots, unitwide_upgrade_slots: unitwide_upgrade_slots)
  end

  unit_swaps = []
  CSV.foreach("db/seeds/unit_swaps.csv", headers: true) do |row|
    unlock_name = row["unlock_name"]
    old_unit_name = row["old_unit_name"]
    new_unit_name = row["new_unit_name"]

    unlock = get_unlock(unlock_name)
    old_unit = get_unit(old_unit_name)
    new_unit = get_unit(new_unit_name)
    unit_swaps << UnitSwap.new(unlock: unlock, old_unit: old_unit, new_unit: new_unit)
  end
  UnitSwap.import! unit_swaps
end
