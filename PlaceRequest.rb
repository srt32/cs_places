require 'net/http'

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
    httpCall(link)
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
      # puts response.body
    end
    return @resBody
  end

private

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