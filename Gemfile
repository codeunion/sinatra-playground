source "https://rubygems.org"

gem "sinatra"
# Sinatra is a pretty sweet web application framework:
# https://github.com/codeunion/sinatra-playground/wiki/Working-with-Sinatra

gem "simple_oauth"
# simple_oauth generates authorization headers for web services that use the
# OAuth protocol for authorization and authentication.

gem "excon"
# excon helps you send http requests in ruby. Perfect for
# working with web services!

group :development, :test do
# We use groups to prevent us from using `dotenv` on Heroku, since heroku
# manages environment variables for us.
# See: https://blog.heroku.com/archives/2011/2/15/using-bundler-groups-on-heroku
# and: https://devcenter.heroku.com/articles/config-vars#setting-up-config-vars-for-a-deployed-application

  gem "dotenv"
  # dotenv helps you load information into your app as environment variables.
end
