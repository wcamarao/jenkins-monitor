def login()
  @jira_service ||= JIRA::JIRAService.new(config[:jira][:url])

  if (@jira_service.auth_token.nil?)
    name = config[:jira][:login]
    pswd = config[:jira][:password]
    @jira_service.login name, pswd
  end
end

def fetch_jiras(amount)
  login()

  jql = 'project = RFI AND labels = "q&e" ORDER BY priority DESC'

  @jira_service.issues_from_jql_search(jql, amount.to_i).map do |jira|
    {
        :key => jira.key,
        :summary => jira.summary[0..55],
        :create_time => jira.create_time.strftime('%b %-d, %Y')
    }
  end
end