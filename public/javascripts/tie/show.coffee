$(document).ready ->
  jobName = $('#job').val()
  queue = new monitor.Queue jobName
