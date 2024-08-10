require 'csv'
task scratch: :environment do
  CSV.foreach('db/seeds/doctrineabilities.csv', headers: true) do |row|
    next if row[:description].blank?

    name = row[:internalName]
    puts "name: #{name}, constname: #{row[:CONSTNAME]}"
    Unlock.create!(name: snakecase(name), const_name: row[:CONSTNAME], display_name: name, description: row[:description])
  end
end