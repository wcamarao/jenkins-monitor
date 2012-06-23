$(document).ready(function () {

  var jobName = $('#job').val();
  var job = new monitor.Job({ job: { name: jobName }});
  $('body').append(job.element);

});
