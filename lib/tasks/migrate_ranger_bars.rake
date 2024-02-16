task migrate_ranger_bars: :environment do
  ActiveRecord::Base.transaction do
    ruleset = Ruleset.first
    rangers = Unit.find_by(name: "rangers")
    bar = Upgrade.find_by(name: "bar")
    two_bars = Upgrades::SingleWeapon.create!(name: "two_bars", const_name: "ALLY.BAR",
                                              display_name: "Two BARs", description: "Two Browning Automatic Rifles",
                                              model_count: nil, additional_model_count: nil)

    inf = Doctrine.find_by(name: "infantry")
    inf_restriction = Restriction.find_by(doctrine: inf)

    here_to_clean_up = Unlock.find_by(name: "here_to_clean_up_this_mess")
    here_du = DoctrineUnlock.find_by(doctrine: inf, unlock: here_to_clean_up, ruleset: ruleset)
    here_restriction = Restriction.find_by(doctrine_unlock: here_du)

    ## Want to delete these
    ranger_bar_enabled_upgrade = EnabledUpgrade.joins(:restriction_upgrade_units)
                                               .find_by(restriction: inf_restriction, upgrade: bar, ruleset: ruleset,
                                                        restriction_upgrade_units: { unit: rangers })
    ranger_bar_available_upgrades = AvailableUpgrade.where(unit: rangers, upgrade: bar)
    affected_company_ids = ranger_bar_available_upgrades.map(&:company_id)

    ranger_bar_enabled_upgrade.destroy!
    ranger_bar_available_upgrades.destroy_all

    ## Want to create new EnabledUpgrade by doctrine unlock restriction
    ranger_bar_here_to_clean_enabled_upgrade = EnabledUpgrade.create!(restriction: here_restriction, upgrade: two_bars, ruleset: ruleset,
                                                                      man: 0, mun: 70, fuel: 0, pop: 0, uses: 0, max: 1,
                                                                      upgrade_slots: 0, unitwide_upgrade_slots: 0,
                                                                      priority: 1)
    RestrictionUpgradeUnit.create!(restriction_upgrade: ranger_bar_here_to_clean_enabled_upgrade, unit: rangers)

    here_to_clean_company_unlocks = CompanyUnlock.includes(:company).where(doctrine_unlock: here_du)
    companies_with_du = here_to_clean_company_unlocks.map(&:company_id)

    companies_with_du.each do |company_id|
      company = Company.find(company_id)
      aus = AvailableUpgradeService.new(company)
      aus.add_enabled_available_upgrades([ranger_bar_here_to_clean_enabled_upgrade])
    end

    # Companies with squad upgrades we might have deleted and need a company resource update
    affected_company_ids.each do |company_id|
      company = Company.find(company_id)
      company_service = CompanyService.new(nil)
      company_service.recalculate_and_update_resources(company)
    end
  end
end
