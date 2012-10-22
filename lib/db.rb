require 'sqlite3'

class DB
  def initialize
    begin
      @database = SQLite3::Database.open("tweets.db")
      @database.execute "CREATE TABLE IF NOT EXISTS tweets(id INTEGER PRIMARY KEY, tweet_id INTEGER, html TEXT)"
    rescue SQLite3::Exception => e 
      puts "Exception occured"
      puts e
    end
  end

  @@instance = self.new
  
  def self.get_instance
    return @@instance
  end
  
  def insert(sql, values = {})
    statement = @database.prepare sql
    values.each do | key, value |
      statement.bind_param key, value
    end
    statement.execute
    statement.close
  end
  
  def get(sql, values = {})
    statement = @database.prepare sql
    values.each do | key, value|
      statement.bind_param key, value
    end
    statement.execute
  end
  
  def get_single_value(sql, *values)
    @database.get_first_value(sql, values)
  end
  
  def self.close
    @database.close if @database
  end
end