require 'active_record'

require 'net/ssh'

@config = YAML::load(File.open(File.join(Rails.root.to_s, 'config', 'database.yml')))[Rails.env.to_s.downcase]


namespace :temperature do

  desc "get latest data point"
  task :test => :environment do |task, args|

       @sensors = Sensor.all


      while true do 
        wait_time = Setting.where("setting=?","check_frequency").first.value.to_i
        
       @sensors.each do |sensor|
          puts "Created: #{Temperature.create(sensor_id: sensor.id, value: rand(210..230)/10.to_f).inspect} Next one in #{wait_time} seconds"
        end
        sleep wait_time
      end

  end


  desc "get latest data point"
  task :sensor => :environment do |task, args|


  def cat( session, sensor )
    begin
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
  rescue
    puts "Error in cat method"
  end


  end


    @sensors = Sensor.all
  	
  	while true do 
  	
      @sensors.where(pi: "pi").each do |sensor|
        begin
            command = "ssh #{sensor.pi} cat /root/sensors/#{sensor.unique_id}/w1_slave"
            sensor_file = "/root/sensors/#{sensor.unique_id}/w1_slave"

            puts "Command (1): #{command}"

            Net::SSH.start( 'pi','root' ) do |session|
              cat session, sensor
              session.loop
            end
        rescue
          puts "Recovering from an issue"
        end
      end


      @sensors.where(pi: "pi2").each do |sensor|
        begin
            command = "ssh #{sensor.pi} cat /root/sensors/#{sensor.unique_id}/w1_slave"
            sensor_file = "/root/sensors/#{sensor.unique_id}/w1_slave"

            puts "Command (2): #{command}"

            Net::SSH.start( 'pi','root' ) do |session|
              cat session, sensor
              session.loop
            end
        rescue
          puts "Recovering from an issue"
        end
      end








      sleep Setting.where("setting=?","check_frequency").first.value.to_i

    end

  end






end