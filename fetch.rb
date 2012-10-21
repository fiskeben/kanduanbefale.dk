require 'net/http'
require 'uri'
require 'json'
require './lib/tweet.rb'
require './lib/oembed.rb'
require './lib/db.rb'

def get_latest_tweet_id
  db = DB.get_instance
  return db.get_single_value "select tweet_id from tweets order by tweet_id desc limit 1"
end

search_url = "http://search.twitter.com/search.json?q=%22Kan%20anbefale%22%20%3F&src=typd"

latest_id = get_latest_tweet_id
unless latest_id == ""
  search_url = "#{search_url}&since_id=#{latest_id}"
end

uri = URI.parse search_url
http = Net::HTTP.new(uri.host, uri.port)
request = Net::HTTP::Get.new(uri.request_uri, {'User-Agent' => 'hvemkananbefale.dk 0.1'})
response = http.request(request)
json = JSON.parse(response.body)

json['results'].each do | tweet_json |
  tweet_id = tweet_json['id']
  oembed_tweet = OEmbed.get(tweet_id)
  html = oembed_tweet.html
  tweet = Tweet.new(tweet_id, html)
  tweet.save
end

DB.close