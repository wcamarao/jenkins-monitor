get '/' do
  slim :dashboard
end

get '/config' do
  respond_to do |content|
    content.json { {
      :jenkins_update_interval => config[:jenkins][:update_interval],
      :jira_update_interval => config[:jira][:update_interval]
    }.to_json }
  end
end

get '/jobs/amount/:amount' do
  respond_to do |content|
    content.json { fetch_recent(params[:amount].to_i).to_json }
  end
end

get '/issues/amount/:amount' do
  respond_to do |content|
    content.json { fetch_jiras(params[:amount].to_i).to_json }
  end
end