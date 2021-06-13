require 'net/https'

namespace :vaccine do

  desc "Vaccine Availability"
  task availability: [:environment] do
    [180002, 180003, 180004, 180005].each do |pincode|
      uri = URI.parse("https://cdn-api.co-vin.in/api/v2/appointment/sessions/public/calendarByPin?pincode=#{pincode}&date=#{Date.today.strftime('%d-%m-%Y')}")

      results = Net::HTTP.get(uri) 
      results = JSON.parse(results).with_indifferent_access

      availability = {}
      results[:centers].each do |center|
        sessions = center[:sessions].select{ |c| c[:min_age_limit] == 18 }
        sessions_with_availability = sessions.select{ |s| s[:available_capacity] > 0 && s[:available_capacity_dose1] > 0 }

        if sessions_with_availability.any?
          puts sessions_with_availability
          sessions_with_availability.each do |s|
            message =  "Slot Available for date #{s[:date]} at #{center[:name]}, #{center[:address]}, #{center[:state_name]}, #{center[:block_name]}, Pincode - #{center[:pincode]}, Total Slot Available - #{s[:available_capacity_dose1]}"
            uri = URI.parse("https://api.telegram.org/bot1894280304:AAFjbMv3R-Hn_WVWCU5g_Ye1fvR90gCHm8I/sendMessage?chat_id=@vaccine_slots&parse_mode=HTML&text=#{message}")
            results = Net::HTTP.get(uri)
          end
        end
      end
    end

    uri = URI.parse("https://cdn-api.co-vin.in/api/v2/appointment/sessions/public/calendarByPin?pincode=421302&date=#{Date.yesterday.strftime('%d-%m-%Y')}")

    results = Net::HTTP.get(uri)
    results = JSON.parse(results).with_indifferent_access

    availability = {}
    results[:centers].each do |center|
      sessions = center[:sessions].select{ |c| c[:min_age_limit] == 45 }
      sessions_with_availability = sessions.select{ |s| s[:available_capacity] >= 0 && s[:available_capacity_dose1] >= 0 }

      if sessions_with_availability.any?
        puts sessions_with_availability
        sessions_with_availability.each do |s|
          message =  "Slot Available for date #{s[:date]} at #{center[:name]}, #{center[:address]}, #{center[:state_name]}, #{center[:block_name]}, Pincode - #{center[:pincode]}, Total Slot Available - #{s[:available_capacity_dose1]}"
          uri = URI.parse("https://api.telegram.org/bot1785013706:AAE6UO15kbWyulGbUtb2_4SgM4dlnBSikwA/sendMessage?chat_id=@bhiwandi_slots_notifier&parse_mode=HTML&text=#{message}")
          results = Net::HTTP.get(uri)
        end
      end
    end
  end

end