require 'active_record'

@config = YAML::load(File.open(File.join(Rails.root.to_s, 'config', 'database.yml')))[Rails.env.to_s.downcase]


namespace :temperature do

  desc "get latest data point"
  task :test => :environment do |task, args|

      while true do 
        wait_time = Setting.where("setting=?","check_frequency").first.value.to_i
        
        (1..5).each do |index|
          puts "Created: #{Temperature.create(sensor_id: index, value: rand(210..250)/10.to_f).inspect} Next one in #{wait_time} seconds"
        end
        sleep wait_time
      end

  end


  desc "get latest data point"
  task :sensor => :environment do |task, args|

    @sensors = Sensor.all
  	
  	while true do 
  	
      @sensors.each do |sensor|
        filename = "/sys/bus/w1/devices/#{sensor.unique_id}/w1_slave"
      	f = File.read(filename)
    		temp =  f[f.index("t=")+2,7].to_f/1000
        if temp > 0 && temp < 50
    		  t = Temperature.create(value: temp, sensor_id: sensor.id)
          puts "Created: #{t.inspect}"
        end
      end

      sleep Setting.where("setting=?","check_frequency").first.value.to_i
    end



  end






end