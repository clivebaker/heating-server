json.array!(@sensors) do |sensor|
  json.extract! sensor, :id, :name, :unique_id, :calibration
  json.url sensor_url(sensor, format: :json)
end
