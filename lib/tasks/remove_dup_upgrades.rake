# The old upgrade seed created duplicate upgrades as upgrade name was not a unique constraint.
# Now that name should be unique, we need to dedupe upgrades and leave only the upgrade that is associated with
# restriction upgrades and available upgrades. Expect there should be only 1 upgrade per unique name used
task remove_dup_upgrades: :environment do
  counter = 0
  ActiveRecord::Base.transaction do
    dup_upgrade_names = Upgrade.all.group(:name).count.filter { |name, count| count > 1 }.keys
    dup_upgrade_names.each do |name|
      # All Upgrade records with this name
      all_upgrades_with_name = Upgrade.where(name: name)

      # Find RestrictionUpgrades using any of the upgrades
      restriction_upgrades = RestrictionUpgrade.where(upgrade: all_upgrades_with_name)
      uniq_upgrade_ids_ru = restriction_upgrades.map { |ru| ru.upgrade_id }.uniq.sort
      is_only_one_upgrade_id_ru = uniq_upgrade_ids_ru.length == 1
      raise StandardError.new("Upgrade #{name} has restriction upgrades using more than one upgrade id [#{uniq_upgrade_ids_ru}]") unless is_only_one_upgrade_id_ru

      # Find AvailableUpgrades using any of the upgrades
      available_upgrades = AvailableUpgrade.where(upgrade: all_upgrades_with_name)
      uniq_upgrade_ids_au = available_upgrades.map { |au| au.upgrade_id }.uniq.sort
      is_only_one_upgrade_id_au = uniq_upgrade_ids_au.length == 1
      raise StandardError.new("Upgrade #{name} has available upgrades using more than one upgrade id [#{uniq_upgrade_ids_au}]") unless is_only_one_upgrade_id_au

      if uniq_upgrade_ids_ru != uniq_upgrade_ids_au
        raise StandardError.new("Upgrade #{name} restriction upgrades #{uniq_upgrade_ids_ru} is different from available upgrades #{uniq_upgrade_ids_au}")
      end

      ## We are clear, keep the upgrade that's used
      upgrade_to_keep = restriction_upgrades.first.upgrade

      upgrades_to_delete = Upgrade.where(name: name).where.not(id: upgrade_to_keep.id)

      raise StandardError.new("Upgrade #{name} deleting #{upgrades_to_delete.count} but expect to delete #{all_upgrades_with_name.count - 1}") unless all_upgrades_with_name.count - 1 == upgrades_to_delete.count

      counter += upgrades_to_delete.count
      upgrades_to_delete.destroy_all
    end
  end

  puts "Removed #{counter} duplicate upgrades"
end