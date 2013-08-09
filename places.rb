require 'net/http'

key = "AIzaSyC2aZ5uDR1lR0ucYpo4PTWV_4pXbZPmow4"
term = "CornellUniversity"
location = '42.448734650355775,-76.47395993447884'
radius = "1000"
sensor = "false"

# GET PLACES
## WANT TO LOOP THROUGH AND GRAB EACH PLACE THAT HAS PHOTOS
link = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?key=" + key + # "&keyword=" + term + 
    "&location=" + location + "&radius=" + radius + "&sensor=" + sensor

# GET PHOTO
plantations_ref = "CnRqAAAAq9Ow5AVTAiE_EDI3MSilzLKf0w6-a6BcUnlEwWfteVzkcPYPa3keDX90zZnTmO4BtsM2aY2KQnqxZ4bb1O3YtQWuK7Z-z09e2VZPe1kWw5lbuOQ_Q9CtLB3pXlnl2HU1DsOkKnSa-r0A6lpPvZhLLhIQbNUYRxBFf2MJmy4juYvAjxoUiHMrquHGLsivNBNuNnI51IIbPto"

## WANT TO LOOP THROUGH EACH PLACE AND SEND THE PHOTOREFERENCE INTO HERE
link = "https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=" + plantations_ref + "&sensor=false&key=" + key

puts link

uri = URI(link)
Net::HTTP.start(uri.host, uri.port,
				:use_ssl => uri.scheme == 'https') do |http|
  request = Net::HTTP::Get.new uri
  response = http.request request
  puts response.body
end

## DOWNLOAD THE PHOTOS