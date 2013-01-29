require 'active_support/all'

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

  jql = 'project = RFI AND labels = "q&e" AND resolution = Unresolved ORDER BY priority DESC, created ASC'

  @jira_service.issues_from_jql_search(jql, amount.to_i).map do |jira|
    {
        :key => jira.key,
        :assignee => jira.assignee_username,
        :summary => jira.summary[0..55],
        :create_time => jira.create_time.ago_in_words,
        :age => ((Time.now - jira.create_time) <= 3.weeks) ? 'new' : 'old',
        :issueType => (jira.type_id == '5') ? 'troubleTicket' : 'other',
        :url => "#{config[:jira][:url]}/browse/#{jira.key}"
    }
  end
end