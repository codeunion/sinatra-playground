require 'json'

require 'sinatra'
require 'simple_oauth'
require 'excon'

begin
require 'dotenv'
Dotenv.load ".env"
rescue LoadError
end
# Because `dotenv` is not installed on heroku, any attempt to require it will
# raise an error. To prevent our app from crashing; we're going to rescue the
# error and carry on merrily.


def reverse(words)
  words.split(" ").map do |word|
    word.reverse
  end.join(" ")
  # This highly complex encryption algorithm will surely dupe the NSA!
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
  # If only it were possible to re-use code without copying and pasting...
  # http://guides.rubygems.org/make-your-own-gem/
end

QUOTES = ["It's life Jim, but not as we know it!",
          "Safety Dance!",
          "What is the airspeed velocity of a coconut laden swallow?"]

# Truly, some of the great wisdom of the ages...

get '/' do
# `get` is a sinatra method that lets you define a `route`.
# The block gets called when a GET request for the `path`
# specified.

# When the block returns a string that string becomes the `body` of
# the `http response` sent to the `client`

  @words = QUOTES.sample
  # The `@` sign denotes an `instance variable`. This is how we share `data`
  # between a route and a view.

  erb :home
  # `erb` is a method that takes a symbol that corresponds to a file named in
  # the `views` folder.

  # In this case, we're saying "load the template file called `views/home.erb`,
  # process it with whatever `instance variables` are defined; and return the
  # result as a string.
end

post '/reverse' do
# `post` is similar to `get`, except it responds only to `POST` requests.

  unreversed_words = params[:words]
  # `params` is a hash provided by Sinatra that includes any `query variables`
  # or `form variables` sent with the request.
  #
  # Take the following form:
  # <form method="POST" action ="/reverse">
  # <textarea name="words"><%= @words %></textarea>
  # <button>Reversify!</button>
  # </form>
  #
  # When a visitor fills in the text box and clicks the "Reversify!" button it
  # will send an HTTP Post request to the '/reverse` path on whatever `server`
  # is running the app. The request will include a form variable named `words`
  # with a value of whatever the user put in.

  @words = reverse(unreserved_words)
  erb :home
  # We can call methods we defined earlier in the file from within a route
  # Because we're re-using the `home` template; we want to re-use the `@words`
  # instance variable; since it's being used to pre-fill the words textarea.
end

get '/tweets' do
  if params[:screen_name]
    @tweets = tweets(params[:screen_name])
  else
    @tweets = []
  end
  # If someone requests this page without passing in a `screen_name` variable;
  # we want to default to an empty list of tweets.
  #
  # Don't believe me? Delete 94 and 96 - 98 and read the error message!
  # Why do you think that is there?

  erb :tweets
  # Which file do you think this is using?
end
