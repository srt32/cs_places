require_relative 'PlaceRequest'
require 'json'
require 'pp'
require 'net/http'

placesOutput = "places.json"
key = "AIzaSyC2aZ5uDR1lR0ucYpo4PTWV_4pXbZPmow4"

if false
	req = PlaceRequest.new(reqType = "place",
							key = "AIzaSyC2aZ5uDR1lR0ucYpo4PTWV_4pXbZPmow4",
							location = '42.448734650355775,-76.47395993447884',
							radius = "1000",
							sensor = "false")

	results = req.callIt

	File.open( placesOutput, "w" ) do |f|
	  f.write(results)
	end
end

#### Parse the results
json = File.read(placesOutput)
parsed = JSON.parse(json)
placesHash = pp parsed

results = placesHash["results"] # array of hashes

# this works but needs to HANDLE REDIRECTS
  # try http://stackoverflow.com/questions/6934185/ruby-net-http-following-redirects
buildings = Hash.new
results.each do |res|
  buildings[res["name"]] = res["photos"] if res["photos"]
  currentBuilding = res["name"]
  currentPhotos = buildings[currentBuilding]
  if !currentPhotos.nil?
    currentPhotos.each do |photo|
      photoRef = photo["photo_reference"]
      link = "https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=" + photoRef + "&sensor=false&key=" + key
      puts "LINK IS" + link
        uri = URI(link)
        Net::HTTP.start(uri.host, uri.port,
              :use_ssl => uri.scheme == 'https') do |http|
          request = Net::HTTP::Get.new uri
          response = http.request request
          @resBody = response.body
          puts @resBody
        end
    end
  end
end

  # take response and rename it (# create image name)
  # download the file