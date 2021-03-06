require 'net/http'
require 'json'
require 'pp'

class PlaceRequest
  def initialize(reqType, key, location, radius, sensor)
    @reqType = reqType
    @key = key
    @location = location
    @radius = radius
    @sensor = sensor
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

  def getPhotos(results) # NEED TO FIGURE OUT IMAGE NAMING
    results = results
    buildings = Hash.new
    makeAndChangeDirs("downloads")
    @results.each do |res|
      buildings[res["name"]] = res["photos"] if res["photos"]
      currentBuilding = res["name"]
      currentPhotos = buildings[currentBuilding]
      if !currentPhotos.nil?
        currentPhotos.each do |photo|
          count = 0
          photoRef = photo["photo_reference"]
          link = "https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=" + photoRef + "&sensor=false&key=" + @key
          @photoName = currentBuilding + count.to_s
          count = count + 1
          fetchPhotos(link, @photoName)
        end
      end
    end
  end

private

  def makeAndChangeDirs(name = "downloads")
    Dir.mkdir(name)
    Dir.chdir("./" + name)
  end

  def fetchPhotos(link, limit = 10, photoName)
    @currentName = photoName
    @currentFileName = @currentName.to_s.gsub(/\s+/, "") + ".png"
    raise ArgumentError, 'These redirects are crazy (too many)' if limit == 0

    uri = URI(link)
    Net::HTTP.start(uri.host, uri.port,
          :use_ssl => uri.scheme == 'https') do |http|
      request = Net::HTTP::Get.new uri
      response = http.request request

      case response
      when Net::HTTPSuccess then
        @resBody = response.body
        file = File.new(@currentFileName, 'w') # TAKE PHOTO NAME FROM INPUT
        File.open(file.path,'w') do |f|
          f.write response.body
        end
        file.close
      when Net::HTTPRedirection then
        location = response['location']
        warn "redirected to #{location}"
        fetchPhotos(location, limit - 1, @currentName)
      else
        response.value
      end
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
