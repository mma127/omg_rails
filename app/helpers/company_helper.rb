module CompanyHelper
  # For a given company, return a table of squads arranged by tab_categories > category_position
  # Tab_categories from Squad.tab_categories, but EXCLUDING holding
  # Category_positions are 0..7
  def self.get_platoon_table(company)
    table = Hash.new

    company.squads.each do |squad|
      next if squad.holding? # squads in holding cannot be spawned

      tab_category = squad.tab_category
      if table.has_key?(tab_category)
        tab = table[tab_category]
      else
        tab = {}
      end

      add_squad_to_platoon(tab, squad)

      table[tab_category] = tab
    end

    table
  end

  def self.add_squad_to_platoon(tab, squad)
    tab_category = squad.tab_category
    category_position = squad.category_position
    if tab.has_key?(category_position)
      platoon = tab[category_position]
      platoon.add_squad(squad)
    else
      platoon = Platoon.new(tab_category, category_position)
      platoon.add_squad(squad)
      tab[category_position] = platoon
    end
  end
end
