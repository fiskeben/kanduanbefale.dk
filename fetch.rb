require 'net/http'
require 'uri'
require 'json'
require './lib/tweet.rb'
require './lib/oembed.rb'
require './lib/twittersearch.rb'

def handle_search_results(json)
  json['results'].each do | tweet_json |
    tweet_id = tweet_json['id']
    oembed_tweet = OEmbed.get(tweet_id)
    html = oembed_tweet.html
    tweet = Tweet.new(tweet_id, html)
    tweet.save
  end
end

word_search = TwitterSearch.new("http://search.twitter.com/search.json?q=%22Kan%20anbefale%22%20%3F&src=typd", "anbefale")
word_results = word_search.execute
puts "Handling #{word_results.inspect} results"
handle_search_results word_results

twitterhjerne_search = TwitterSearch.new("http://search.twitter.com/search.json?q=%23twitterhjerne&src=typd", "#twitterhjerne")
twitterhjerne_results = twitterhjerne_search.execute
puts "Handling #{twitterhjerne_results.length} results"
handle_search_results twitterhjerne_results