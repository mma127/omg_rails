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

  def create_enabled_available_upgrades(enabled_upgrades_hash)
    available_upgrades = []
    enabled_upgrades_hash.values.each do |unit_id_hash|
      unit_id_hash.each do |unit_id, enabled_upgrade|
        available_upgrades << instantiate_base_available_upgrade(enabled_upgrade, unit_id)
      end
    end.flatten
    AvailableUpgrade.import! available_upgrades
  end

  private

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

  def validate_empty_available_upgrades
    raise AvailableUpgradesValidationError.new("Company #{@company.id} has existing AvailableUpgrades") unless AvailableUpgrade.where(company: @company).empty?
  end

  def validate_no_base_available_units_for_given(upgrades)
    unless BaseAvailableUpgrade.where(company: @company, upgrade: upgrades).empty?
      raise AvailableUpgradesValidationError.new("Company #{company.id} already has existing base available upgrades for a subset of #{upgrades.pluck(:id)}")
    end
  end
end