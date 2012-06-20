Bundler.require
set :port, 3333

get '/stylesheets/:name.css' do
  begin
    content_type 'text/css', :charset => 'utf-8'
    sass params[:name].to_sym
  rescue
    error 404
  end
end

get '/' do
  slim :index
end
