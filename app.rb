require 'sinatra'
require 'json'
require './lib/tweet.rb'

configure do
  set :public_folder, File.dirname(__FILE__) + '/public'
end
  
get '/' do
  tweets = Tweet.load_tweets
  erb :index, :locals => { :tweets => tweets }
end

get '/api/:page' do
  if params[:page] =~ /[0-9]+/
    page = params[:page].to_i * 10
    tweets = Tweet.load_tweets(10, page)
    tweets.to_json
  else
    500
  end
end