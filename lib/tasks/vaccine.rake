require 'net/https'

namespace :vaccine do

  desc "Vaccine Availability"
  task availability: [:environment] do
    uri = URI.parse("https://cdn-api.co-vin.in/api/v2/appointment/sessions/public/calendarByPin?pincode=421302&date=#{Date.today.strftime('%d-%m-%Y')}")

    results = Net::HTTP.get(uri)
    results = JSON.parse(results).with_indifferent_access

    availability = {}
    results[:centers].select{ |c| c['fee_type'] == "Free" }.each do |center|
      sessions = center[:sessions]
      sessions_with_availability = sessions.select{ |s| s[:available_capacity] > 0 }

      if sessions_with_availability.any?

        sessions_with_availability.each do |s|
          age_limit = if s[:min_age_limit] == 18 && s[:max_age_limit] == 44
            '18 - 44'
          elsif s[:min_age_limit] == 45
            '45+'
          elsif s[:min_age_limit] == 18 && s[:max_age_limit].blank?
            '18+'
          end
          message = "Slot Available for date #{s[:date]} at #{center[:name]}, #{center[:address]}, #{center[:state_name]}, #{center[:block_name]}, Pincode - #{center[:pincode]}%0aAge Group - #{age_limit}%0aTotal Slot Available for Dose 1 - #{s[:available_capacity_dose1]}%0aTotal Slot Available for Dose 2 - #{s[:available_capacity_dose2]}"
          p message
          uri = URI.parse("https://api.telegram.org/bot1785013706:AAE6UO15kbWyulGbUtb2_4SgM4dlnBSikwA/sendMessage?chat_id=@bhiwandi_slots_notifier&parse_mode=HTML&text=#{message}")
          results = Net::HTTP.get(uri)
          p results
        end
      end
    end


    [180001, 180002, 180003, 180004, 180005, 180006, 180007, 180009, 180010, 180011].each do |pincode|
      uri = URI.parse("https://cdn-api.co-vin.in/api/v2/appointment/sessions/public/calendarByPin?pincode=#{pincode}&date=#{Date.today.strftime('%d-%m-%Y')}")

      results = Net::HTTP.get(uri) 
      results = JSON.parse(results).with_indifferent_access

      availability = {}
      results[:centers].select{ |c| c['fee_type'] == "Free" }.each do |center|
        sessions = center[:sessions]
        sessions_with_availability = sessions.select{ |s| s[:available_capacity] > 0 }

        if sessions_with_availability.any?

          sessions_with_availability.each do |s|
            age_limit = if s[:min_age_limit] == 18 && s[:max_age_limit] == 44
              '18 - 44'
            elsif s[:min_age_limit] == 45
              '45+'
            elsif s[:min_age_limit] == 18 && s[:max_age_limit].blank?
              '18+'
            end
            message = "Slot Available for date #{s[:date]} at #{center[:name]}, #{center[:address]}, #{center[:state_name]}, #{center[:block_name]}, Pincode - #{center[:pincode]}%0aAge Group - #{age_limit}%0aTotal Slot Available for Dose 1 - #{s[:available_capacity_dose1]}%0aTotal Slot Available for Dose 2 - #{s[:available_capacity_dose2]}"
            p message
            uri = URI.parse("https://api.telegram.org/bot1785013706:AAE6UO15kbWyulGbUtb2_4SgM4dlnBSikwA/sendMessage?chat_id=@bhiwandi_slots_notifier&parse_mode=HTML&text=#{message}")
            results = Net::HTTP.get(uri)
            p results
          end
        end
      end
    end
  end

end