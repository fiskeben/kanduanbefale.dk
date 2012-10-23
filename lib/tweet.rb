require './lib/db.rb'
require 'json'

class Tweet
  attr_accessor :id, :html
  def initialize(id, html)
    @id = id
    @html = html
  end
  
  def save
    db = DB.get_instance
    unless incomplete?
      sql = "INSERT INTO tweets(tweet_id, html) VALUES(:id, :html)"
      db.insert(sql, { :id => @id, :html => @html})
    end
  end
  
  def to_json(*args)
    { :id => @id, :html => @html }.to_json
  end
  
  def self.load_tweets(limit = 10, start = 0)
    db = DB.get_instance
    tweets = []
    sql = "SELECT tweet_id, html FROM tweets ORDER BY tweet_id DESC limit :start, :limit"
    list = db.get(sql, {:start => start, :limit => limit})
    list.each do | sql_tweet |
      tweet = Tweet.new(sql_tweet[0], sql_tweet[1])
      tweets.push tweet
    end
    tweets
  end
  
  def incomplete?
    tweet_exists? or @id.nil? or @html.nil?
  end
  
  def tweet_exists?
    db = DB.get_instance
    sql = "SELECT count(*) FROM tweets where tweet_id = :id"
    db.get_single_value(sql, @id) >= 1
  end
end