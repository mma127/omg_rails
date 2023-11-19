class RestrictionsService
  def initialize(ruleset_id, faction_id, doctrine_id)
    @ruleset_id = ruleset_id
    @faction_id = faction_id
    @doctrine_id = doctrine_id # optional
  end

  private

  def base_restriction
    if doctrine_restriction.present?
      doctrine_restriction
    else
      faction_restriction
    end
  end

  def ruleset
    @_ruleset ||= Ruleset.find_by(id: @ruleset_id)
  end

  def faction_restriction
    @_faction_restriction ||= Restriction.find_by(faction_id: @faction_id, doctrine_id: nil, doctrine_unlock_id: nil)
  end

  def doctrine_restriction
    @_doctrine_restriction ||= Restriction.find_by(doctrine_id: @doctrine_id, faction_id: nil, doctrine_unlock_id: nil)
  end
end
