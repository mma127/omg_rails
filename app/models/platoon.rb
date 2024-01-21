class Platoon
  attr_reader :tab_category, :category_position, :squads, :pop

  TAB_TO_INDEX = {
    core: 1,
    assault: 2,
    infantry: 3,
    armour: 4,
    anti_armour: 5,
    support: 6,
    holding: 0
  }.with_indifferent_access

  def initialize(tab_category, category_position)
    @tab_category = tab_category
    @category_position = category_position
    @squads = []
    @pop = 0.0
  end

  def add_squad(squad)
    @squads << squad
    @pop += squad.pop
  end

  def platoon_index
    TAB_TO_INDEX[@tab_category]
  end

  def display_position
    @category_position + 1
  end

  def suffix
    case display_position
    when 1
      "st"
    when 2
      "nd"
    when 3
      "rd"
    else
      "th"
    end
  end

  def unique_unit_counts
    name_to_count = {}
    @squads.each do |squad|
      unit_name = squad.unit.display_name
      if name_to_count.has_key?(unit_name)
        name_to_count[unit_name] += 1
      else
        name_to_count[unit_name] = 1
      end
    end
    name_to_count
  end

  def unit_count_string
    name_to_count = unique_unit_counts
    counts = []
    name_to_count.each do |name, count|
      counts << "#{count}x #{name}"
    end
    counts.join(", ")
  end

  def ucs_string(team_index, player_index)
    header = "150#{team_index}#{player_index}#{platoon_index}#{display_position}"
    <<-UCS
#{header}1\t#{display_position}#{suffix} #{@tab_category.titleize}\r
#{header}2\t#{@pop.to_i} Population\r
#{header}3\t#{unit_count_string}\r
    UCS
  end
end
