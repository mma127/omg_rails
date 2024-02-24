task update_ac_scope_price: :environment do
  ActiveRecord::Base.transaction do
    ruleset = Ruleset.first
    ac = Unit.find_by(name: "armored_car")
    improved_scopes = Upgrade.find_by(name: "improved_scopes")

    th = Doctrine.find_by(name: "tank_hunters")
    th_restriction = Restriction.find_by(doctrine: th)
    improved_scopes_unlock = Unlock.find_by(name: "improvised_scopes")
    improved_scopes_doctrine_unlock = DoctrineUnlock.find_by(doctrine: th, unlock: improved_scopes_unlock, ruleset: ruleset)
    du_restriction = Restriction.find_by(doctrine_unlock: improved_scopes_doctrine_unlock)

    # Change EnabledUpgrade cost
    ac_is_enabled_upgrade_50 = EnabledUpgrade.joins(:restriction_upgrade_units)
                                          .find_by(restriction: du_restriction, upgrade: improved_scopes, ruleset: ruleset,
                                                   restriction_upgrade_units: { unit: ac })
    restriction_upgrade_unit = ac_is_enabled_upgrade_50.restriction_upgrade_units.find_by(unit: ac)
    restriction_upgrade_unit.destroy!

    is_enabled_upgrade_30 = EnabledUpgrade.find_by(restriction: du_restriction, upgrade: improved_scopes, ruleset: ruleset, mun: 30)

    RestrictionUpgradeUnit.create!(restriction_upgrade: is_enabled_upgrade_30, unit: ac)

    # Change AvailableUpgrade cost
    ac_is_available_upgrades = AvailableUpgrade.where(unit: ac, upgrade: improved_scopes)

    ac_is_available_upgrades.update_all(mun: 30)

    affected_company_ids = ac_is_available_upgrades.map(&:company_id)

    # Recalculate company resources
    affected_company_ids.each do |company_id|
      company = Company.find(company_id)
      company_service = CompanyService.new(nil)
      company_service.recalculate_and_update_resources(company)
    end
  end
end
