require 'csv'
task battle_frequency_old: :environment do
  CSV.open("lib/tasks/battle_data_out.csv", "w") do |csv|
    csv << ["Player Count", "Start Date Time", "Start Time", "End Date Time", "End Time", "Length"]
    CSV.foreach('lib/tasks/battlecreation.csv', headers: true) do |row|
      player_ids_string = row["player_ids"]
      start_time = row["start_time"].to_i
      end_time = row["end_time"].to_i

      player_count = player_ids_string.split(";").size

      start_date_time = Time.at(start_time).in_time_zone("CET")
      start_time = start_date_time.strftime("%H:%M:%S")
      end_date_time = Time.at(end_time).in_time_zone("CET")
      end_time = end_date_time.strftime("%H:%M:%S")
      length = end_date_time - start_date_time

      puts "#{player_count} players starting #{start_date_time} [#{start_time}] to #{end_date_time} [#{end_time}] of #{length}"
      csv << [player_count, start_date_time, start_time, end_date_time, end_time, length]
    end
  end
end
