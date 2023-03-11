require 'csv'

after :units do
  def snake_case(str)
    str.parameterize.underscore
  end

  def title_case(str)
    str.humanize.titleize
  end

  CSV.foreach('db/seeds/offmaps.csv', headers: true) do |row|
    name = snake_case(row["internal_name"])
    display_name = title_case(name)
    Offmap.create!(name: name, display_name: display_name, const_name: row["const_name"])
  end

end
