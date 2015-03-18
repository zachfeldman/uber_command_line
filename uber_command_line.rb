# Request an Uber programatically with Ruby

require 'uber_api'
require 'geocoder'


# If set to "true", will actually request a cab
p "Do you want to really request a ride or just test this out? Say true if you really want a ride or anything else just to try it."
real_ride = gets.chomp == "true" ? true : false

# You'll need an UBER_SERVER_TOKEN and an UBER_BEARER_TOKEN
# Don't know how to set environment variables? See:
# http://nycda.com/blog/using-environment-variables-to-safely-store-api-credentials/
client = Uber::Client.new(
  :server_token => ENV['UBER_SERVER_TOKEN'],
  :bearer_token => ENV['UBER_BEARER_TOKEN'],
  :sandbox => !real_ride
)


# Geocode the pickup location into latitude and longitude
def get_location
  location_request = Geocoder.search(gets)
  if location_request.count != 1
    "Whoops, we couldn't pinpoint your exact location with that address. Please try again."
    get_location
  else
    location_lat = location_request[0].data["geometry"]["location"]["lat"]
    location_lon = location_request[0].data["geometry"]["location"]["lng"]
    {lat: location_lat, lon: location_lon}
  end
end

puts "Where are you leaving from tonight? Please enter a full address."
location_1 = get_location

puts "Where are you going tonight? Please enter a full address."
location_2 = get_location


# Let the user select the Uber product they'd like
puts "Please choose an Uber product by entering a single number.\n"
product_choices = client.products(location_1[:lat].to_f, location_1[:lon].to_f)
product_choices.each_with_index do |product, index|
  puts "#{index + 1}) #{product['display_name']}"
end
product_id = product_choices[gets.to_i-1]["product_id"]


# Create the ride request
ride = client.request({
  :product_id => product_id,
  :start_latitude => location_1[:lat],
  :start_longitude => location_1[:lon],
  :end_latitude => location_2[:lat],
  :end_longitude => location_2[:lon]
})

# Update status of the ride request
while true
  p client.request_status(ride["request_id"])
  p "Press Control + C to quit this session. (This will not cancel your ride)"
  counter = 9
  while counter > 0 do
    p "#{counter} seconds until next update."
    sleep 1
    counter -= 1
  end
end