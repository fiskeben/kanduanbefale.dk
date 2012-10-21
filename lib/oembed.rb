require 'net/http'
require 'uri'
require 'json'

class OEmbed
  def initialize(oembed_json)
    @json = oembed_json
  end
  
  def method_missing(method, *args, &block)
    return @json[method.to_s]
  end
  
  def self.get(tweet_id)
    oembed_url = "https://api.twitter.com/1/statuses/oembed.json?id=#{tweet_id}&align=center&omit_script=true"
    oembed_uri = URI.parse oembed_url

    http = Net::HTTP.new(oembed_uri.host, oembed_uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    request = Net::HTTP::Get.new(oembed_uri.request_uri)
    response = http.request(request)
    self.new(JSON.parse(response.body))
  end
end