require 'rubygems'

gem "twitter", "~> 5.0.0.rc.1"
require 'twitter'

require 'time'
require 'yaml'

def log text
  @logfile.write( "\r\n" + Time.new.to_s + ": " + text.to_s())
  puts text;
end
@logfile = File.new('autocorrectbot.txt', "a")


twitter_config = YAML.load_file('config.yml')

#streaming twitter client
streaming_client = Twitter::Streaming::Client.new do |config|
  config.consumer_key = twitter_config["consumer_key"]
  config.consumer_secret = twitter_config["consumer_secret"]
  config.oauth_token = twitter_config["oauth_token"]
  config.oauth_token_secret = twitter_config["oauth_token_secret"]
end

#writing twitter client
write_client = Twitter::REST::Client.new do |config|
  config.consumer_key = twitter_config["consumer_key"]
  config.consumer_secret = twitter_config["consumer_secret"]
  config.oauth_token = twitter_config["oauth_token"]
  config.oauth_token_secret = twitter_config["oauth_token_secret"]
end

def satisfies(text) 
	return true;
end

#throttle tweets to 1 every 90 seconds
timeout = 90;
next_tweet = Time.now;

log("********** starting!");

streaming_client.filter(:track => "aint") do |tweet|

	next unless satisfies(tweet.text)
	
	#check throttle
	if Time.now >= next_tweet then
		response = "@#{tweet.user.handle} \"ain't\" ain't a word!";
		#tweet it
		log("Tweeting: #{response} in response to status id #{tweet.id}");
		#write_client.update(sub, {:in_reply_to_status_id => tweet.id});
		next_tweet = Time.now + timeout;
	end
end