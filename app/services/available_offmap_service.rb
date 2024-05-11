class AvailableOffmapService
  class AvailableOffmapValidationError < StandardError; end

  def initialize(company)
    @company = company
    @player = company.player
    @faction = company.faction
    @doctrine = company.doctrine
    @ruleset = company.ruleset
  end

  # Given a new company, determine the available offmaps for that company
  # Taking into account
  def build_new_company_available_offmaps
    validate_empty_available_offmaps

    enabled_offmaps_hash = get_base_faction_doctrine_offmap_hash

    # Create available offmaps with the filtered collection of restriction offmaps
    create_enabled_available_offmaps(enabled_offmaps_hash.values)
  end

  def create_enabled_available_offmaps(enabled_offmaps)
    available_offmaps = enabled_offmaps.map do |offmap_data|
      instantiate_base_available_offmap(offmap_data)
    end
    AvailableOffmap.import!(available_offmaps)
  end

  # Given offmaps to remove, remove all AvailableOffmaps (all types) from the company associated with those offmaps.
  # Destroy CompanyOffmaps using those AvailableOffmaps
  def remove_available_offmaps(offmaps_to_remove)
    available_offmaps = AvailableOffmap.where(company: @company, offmap: offmaps_to_remove)
    available_offmaps.destroy_all # CompanyOffmaps destroyed via dependent destroy
  end

  private

  # NOTE: Only adds additional offmaps as there is not currently a case for disabling offmaps at the faction/doctrine level
  def get_base_faction_doctrine_offmap_hash
    # Get restriction for Faction, then find all faction allowed offmaps
    faction_restriction = Restriction.find_by(faction: @faction)
    faction_allowed_offmaps = get_enabled_offmap_hash faction_restriction

    # Get restriction for Doctrine, then find all doctrine allowed offmaps
    doctrine_restriction = Restriction.find_by(doctrine: @doctrine)
    doctrine_allowed_offmaps = get_enabled_offmap_hash doctrine_restriction

    allowed_offmaps_hash = faction_allowed_offmaps
    merge_allowed_offmaps(allowed_offmaps_hash, doctrine_allowed_offmaps)
  end

  def get_enabled_offmap_hash(restriction)
    EnabledOffmap.where(restriction: restriction, ruleset: @ruleset).index_by(&:offmap_id)
  end

  def merge_allowed_offmaps(existing_offmaps_hash, restricted_offmaps_hash)
    # NOTE: This only works for EnabledOffmap where more specific ones replace the more general one
    if restricted_offmaps_hash.present?
      existing_offmaps_hash = existing_offmaps_hash.merge(restricted_offmaps_hash)
    end
    existing_offmaps_hash
  end

  def instantiate_base_available_offmap(restriction_offmap)
    BaseAvailableOffmap.new(offmap: restriction_offmap.offmap, company: @company, available: restriction_offmap.max,
                            max: restriction_offmap.max, mun: restriction_offmap.mun)
  end

  def validate_empty_available_offmaps
    raise AvailableOffmapValidationError.new("Company #{@company.id} has existing AvailableOffmaps") unless AvailableOffmap.where(company: @company).empty?
  end
end
