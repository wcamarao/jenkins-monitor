get '/' do
  @update_interval = config[:jenkins][:update_interval]
  slim :dashboard
end

get '/jobs' do
  respond_to do |content|
    content.json { config[:jenkins][:jobs].to_json }
  end
end

get '/:job' do
  respond_to do |content|
    content.html do
      @job = params[:job]
      @update_interval = config[:jenkins][:update_interval]
      @queue_size = 8
      slim :show
    end
    content.json { fetch(params[:job]).to_json }
  end
end

get '/:job/:number' do
  respond_to do |content|
    content.json { fetch(params[:job], params[:number]).to_json }
  end
end
