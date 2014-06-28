json.array!(@temperatures) do |temperature|
  json.extract! temperature, :id, :value, :sensor_id
  json.url temperature_url(temperature, format: :json)
end
