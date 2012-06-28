$(document).ready ->
  jobName = $('#job').val()
  queue = new monitor.Queue jobName

  $('body').on 'click', (e) ->
    window.open $(e.srcElement).closest('section').data('url'), '_blank'
