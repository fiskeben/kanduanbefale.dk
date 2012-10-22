require './lib/db.rb'

class TwitterSearch
  def initialize(url, tag)
    @url = url
    @tag = tag
  end
  
  def execute
    search_url = @url
    latest_id = get_latest_tweet_id
    unless latest_id == ""
      search_url = "#{search_url}&since_id=#{latest_id}"
    end

    uri = URI.parse search_url
    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Get.new(uri.request_uri, {'User-Agent' => 'hvemkananbefale.dk 0.2'})
    response = http.request(request)
    JSON.parse(response.body)
  end
  
  def get_latest_tweet_id
    db = DB.get_instance
    return db.get_single_value("select tweet_id from tweets where html like :tag order by tweet_id desc limit 1", @tag)
  end
end