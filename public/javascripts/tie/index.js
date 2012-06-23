$(document).ready(function () {

  $.get('/jobs.json', function (jobs) {
    $(jobs).each(function (i, jobName) {
      var job = new monitor.Job({ job: { name: jobName }});
      $('body').append(job.element);
    });
  });

});
