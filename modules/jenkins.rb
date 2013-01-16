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
