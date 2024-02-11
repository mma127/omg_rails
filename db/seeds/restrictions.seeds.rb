after :unlocks do
  # Factions and Doctrines already have their standard Restriction created
  # This should contain unlock restrictions

  DoctrineUnlock.includes(:doctrine, :unlock).each do |du|
    doctrine = du.doctrine
    unlock = du.unlock
    Restriction.create!(doctrine_unlock: du,
                        name: "#{doctrine.display_name} | #{unlock.display_name}",
                        description: "#{doctrine.display_name} Doctrine Unlock Restriction - #{unlock.display_name}")
    Restriction.create!(unlock: unlock, name: unlock.display_name, description: "#{unlock.display_name} - Unlock Restriction")
  end

end
