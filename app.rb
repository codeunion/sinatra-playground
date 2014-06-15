require 'json'

require 'sinatra'
require 'simple_oauth'
require 'excon'
begin
require 'dotednv'
Dotenv.load
rescue LoadError
end


def reverse(words)
  words.split(" ").map do |word|
    word.reverse
  end.join(" ")
end


def tweets(screen_name)
  authorization_header = SimpleOAuth::Header.new("get",
                                                 "https://api.twitter.com/1.1/statuses/user_timeline.json",
                                                 { :screen_name => screen_name },
                                                 { :consumer_key => ENV['TWITTER_API_KEY'],
                                                   :consumer_secret => ENV['TWITTER_API_SECRET'] })

  response = Excon.send("get", "https://api.twitter.com/1.1/statuses/user_timeline.json", {
    :query => { :screen_name => screen_name },
    :headers => { "Authorization" => authorization_header.to_s }
  })
  JSON.parse(response.body)
end

QUOTES = ["It's life Jim, but not as we know it!",
          "Safety Dance!",
          "What is the airspeed velocity of a coconut laden swallow?"]
get '/' do
  @words = QUOTES.sample
  erb :home
end

post '/reverse' do
  @words = reverse(params[:words])
  erb :home
end

get '/tweets' do
  if params[:screen_name]
    @tweets = tweets(params[:screen_name])
  else
    @tweets = []
  end

  erb :tweets
end
