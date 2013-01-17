get '/' do
  @config = {
    :jenkins_update_interval => config[:jenkins][:update_interval],
    :jira_update_interval => config[:jira][:update_interval]
  }
  slim :dashboard
end

get '/jobs' do
  respond_to do |content|
    content.json { fetch_jobs('ui.apollo-gerrit').to_json }
  end
end
