module HomeHelper


def sensor_data(sensor_id)


"{
                name: '#{@sensors.select{|s| s.id==sensor_id}.first.name}',
                marker: {
                    enabled: false
                },
                data: (function() {
                    var data = [], time = (new Date()).getTime(), i;
    				var data=[
								#{@temperatures.select{|s| s.sensor_id == sensor_id}.map{|s| {y: s.value*@sensors.select{|s| s.id==sensor_id}.first.calibration/100, x: s.created_at.to_i*1000 }.to_json}.join(",") }
							]	
                    return data;
                })(),
                turboThreshold: 200000
            }"

	
end



end
