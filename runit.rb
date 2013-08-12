require_relative 'PlaceRequest'
require 'json'
require 'pp'

placesOutput = "places.json"

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

buildings = Hash.new
results.each do |res|
  buildings[res["name"]] = res["photos"] if res["photos"] 
end

### send each photoRef to PhotoRequest
# make a new dir (or find existing one) for school name

## LOOP
  # through the buildings hash and pull out the NAME and photo reference

  # create http request  

  # take response and rename it (# create image name)

  # download the file 