require 'net/http'
require 'json'
require 'pp'

class PlaceRequest
  def initialize(reqType, key, location, radius, sensor, placesOutput)
    @reqType = reqType
    @key = key
    @location = location
    @radius = radius
    @sensor = sensor
    @placesOutput = placesOutput
  end

  def callIt
    base = baseURL(@reqType)
    link = buildLink(base)
    results = httpCall(link)
    # outputResults(results)
    results = parseResults(results)
    getPhotos(results)
  end

  def buildLink(base)
    base = base
    link = base + "key=" + @key + 
    "&location=" + @location + "&radius=" + @radius + "&sensor=" + @sensor
    puts link
    return link
  end

  def httpCall(link)
    link = link
    uri = URI(link)
    Net::HTTP.start(uri.host, uri.port,
            :use_ssl => uri.scheme == 'https') do |http|
      request = Net::HTTP::Get.new uri
      response = http.request request
      @resBody = response.body
    end
    return @resBody
  end

  def parseResults(results)
    results = results
    parsed = JSON.parse(results)
    placesHash = pp parsed

    @results = placesHash["results"] # array of hashes
    return @results
  end

  def getPhotos(results)
    results = results
    buildings = Hash.new
    @results.each do |res|
      buildings[res["name"]] = res["photos"] if res["photos"]
      currentBuilding = res["name"]
      currentPhotos = buildings[currentBuilding]
      if !currentPhotos.nil?
        currentPhotos.each do |photo|
          photoRef = photo["photo_reference"]
          link = "https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=" + photoRef + "&sensor=false&key=" + @key
          fetchPhotos(link)
        end
      end
    end
  end

private

  def fetchPhotos(link)
    uri = URI(link)
    Net::HTTP.start(uri.host, uri.port,
          :use_ssl => uri.scheme == 'https') do |http|
      request = Net::HTTP::Get.new uri
      response = http.request request
      @resBody = response.body
      puts @resBody
    end
  end

  def baseURL(reqType)
    if reqType == "place"
      base = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?"
    elsif reqType == "photo"
      base = "https://maps.googleapis.com/maps/api/place/photo?"
    else
      base = ''
      errMessage = "Invalid request type (reqType) -- " + reqType + ".  Try again."
      abort(errMessage)
    end 
    return base
  end

end