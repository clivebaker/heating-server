require 'active_record'

require 'net/ssh'

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
      #  filename = "/sys/bus/w1/devices/#{sensor.unique_id}/w1_slave"
        command = "ssh pi cat /root/sensors/#{sensor.unique_id}/w1_slave"
       # puts command
       # response = system(command)

      #  puts(system(command))
     # 	f = File.read(filename)
    	

      #	temp =  response[response.index("t=")+2,7].to_f/1000
      #  if temp > 0 && temp < 50
    #		  t = Temperature.create(value: temp, sensor_id: sensor.id)
     #     puts "Created: #{t.inspect}"
      #  end
      


sensor_file = "/root/sensors/#{sensor.unique_id}/w1_slave"


def cat( session, sensor )
  session.open_channel do |channel|
    channel.on_data do |ch, data|
      #puts "DATA: #{data}"
      temp =  data[data.index("t=")+2,7].to_f/1000
      if temp > 0 && temp < 50
        t = Temperature.create(value: temp, sensor_id: sensor.id)
        puts "Created: #{t.inspect}"
        end
    end
    channel.exec "cat /root/sensors/#{sensor.unique_id}/w1_slave"
  end
end

Net::SSH.start( 'pi','root' ) do |session|
  cat session, sensor
  session.loop
end













      end

      sleep Setting.where("setting=?","check_frequency").first.value.to_i
    end



  end






end