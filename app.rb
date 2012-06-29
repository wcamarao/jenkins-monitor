Bundler.require

class SassHandler < Sinatra::Base
  set :views, File.dirname(__FILE__) + '/public/stylesheets'
  get '/stylesheets/*.css' do
    sass params[:splat].first.to_sym
  end
end

class CoffeeHandler < Sinatra::Base
  set :views, File.dirname(__FILE__) + '/public/javascripts'
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

get '/' do
  @update_interval = config[:update_interval]
  slim :index
end

get '/jobs' do
  respond_to do |content|
    content.json { config[:jobs].to_json }
  end
end

get '/:job' do
  respond_to do |content|
    content.html do
      @job = params[:job]
      @update_interval = config[:update_interval]
      @queue_size = config[:queue_size]
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

private

def fetch name, number = nil
  url = config[:jenkins][:url]
  number = (number || last_job_number(name)).to_i
  job = get_json "#{url}/job/#{name}/#{number}/api/json"
  return {
    :job => {
      :number => job[:number],
      :status => job[:result].nil? ? job_result(name, number - 1) : job[:result].downcase,
      :building => job[:building] ? 'building' : '',
      :url => job[:url]
    },
    :commits => commits(job)
  }
end

def last_job_number name
  url = config[:jenkins][:url]
  job = get_json "#{url}/job/#{name}/api/json"
  job[:lastBuild][:number]
end

def job_result name, number
  url = config[:jenkins][:url]
  job = get_json "#{url}/job/#{name}/#{number}/api/json"
  job[:result].nil? ? job_result(name, number - 1) : job[:result].downcase
end

def commits job
  commits = []
  job[:changeSet][:items].each do |item|
    commits.push({
      :hash => item[:id][0..6],
      :author => item[:author][:fullName].split.first.downcase,
      :message => item[:msg]
    })
  end
  commits.push({ :hash => nil, :author => nil, :message => first_cause(job) }) if commits.empty?
  commits
end

def first_cause job
  found = job[:actions].find { |action| action.key? :causes }
  found[:causes].first[:shortDescription]
end

def get_json url
  sym_keys JSON.parse open(url).read
end

def config
  sym_keys YAML::load File.open 'config.yml'
end

def sym_keys hash
  return hash unless hash.is_a? Hash
  hash.inject({}) do |sym_hash, (key, value)|
    sym_hash[key.to_sym] =
    if value.is_a? Hash; sym_keys value
    elsif value.is_a? Array; value.map { |v| sym_keys v }
    else; value; end
    sym_hash
  end
end
