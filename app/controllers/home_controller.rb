class HomeController < ApplicationController

  def index


  #	@number_of_points = 60 * 60 * 24 / Setting.where("key=?","check_frequency").first.value.to_i
  	#number_of_points = 3001 if number_of_points > 1000

  	view_window = Setting.where("setting=?","view_window_in_hours").first.value.to_f
	@temperatures =	Temperature.where("created_at > ?",Time.now-view_window.hours).order("created_at desc").reverse
	@sensors = Sensor.all





  end


def test
	
end

def latest
	
	@sensors = Sensor.all
	result = {}
	@sensors.each do |sensor|
		temp = sensor.temperatures.last
		result["size"] = @sensors.count
		result["sensor#{sensor.id}"] = {x: temp.created_at.to_i*1000 ,y: ("%.1f" % (temp.value*sensor.calibration/100)).to_f}
	end
	render :json => result.to_json

end
end
