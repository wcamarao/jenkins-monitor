Bundler.require

require 'sinatra/content_for'
require 'open-uri'

Dir["#{File.dirname(__FILE__)}/modules/*.rb"].each { |m| require m }
