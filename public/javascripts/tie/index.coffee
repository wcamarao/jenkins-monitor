$(document).ready ->
  $.get '/jobs.json', (jobs) ->
    return unless jobs?
    for jobName in jobs
      job = new monitor.Job(job: name: jobName)
      $('body').append job.element
