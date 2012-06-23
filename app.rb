Bundler.require

configure do
  Sinatra::Application.register Sinatra::RespondTo
  set :port, 3333
end

get '/' do
  slim :index
end

get '/stylesheets/monitor' do
  sass :monitor
end

get '/jobs' do
  respond_to do |content|
    content.json { config[:jobs].to_json }
  end
end

get '/:job' do
  respond_to do |content|
    content.json { fetch_job(params[:job]).to_json }
  end
end

private

def fetch_job name
  url = config[:jenkins][:url]
  job = sym_keys JSON.parse open("#{url}/job/#{name}/api/json").read
  return {
    :job => {
      :number => job[:lastBuild][:number]
    }
  }
end

def config
  sym_keys YAML::load File.open 'config.yml'
end

def sym_keys hash
  hash.inject({}) do |h, (k,v)|
    h[k.to_sym] = v.is_a?(Hash) ? sym_keys(v) : v; h
  end
end
