class SassHandler < Sinatra::Base
  set :views, File.dirname(__FILE__) + '/../public/stylesheets'
  get '/stylesheets/*.css' do
    sass params[:splat].first.to_sym
  end
end

class CoffeeHandler < Sinatra::Base
  set :views, File.dirname(__FILE__) + '/../public/javascripts'
  get '/javascripts/*.js' do
    coffee params[:splat].first.to_sym
  end
end

configure do
  use SassHandler
  use CoffeeHandler
  Sinatra::Application.register Sinatra::RespondTo
  set :port, 3333
end
