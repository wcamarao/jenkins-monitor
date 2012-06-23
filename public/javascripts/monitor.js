$(document).ready(function () {

  $.get('/jobs.json', function (jobs) {
    $(jobs).each(function (i, jobName) {
      var job = new Job({ job: { name: jobName }});
      $('body').append(job.element);
    });
  });

  function Job(attributes) {
    this.element = $(this.template);
    this.update(attributes);
    this.keep(this.fetch);
  }

  Job.prototype.template = $('#job-template').html();

  Job.prototype.keep = function(callback) {
    setInterval(callback.bind(this), 5000);
  };

  Job.prototype.fetch = function() {
    $.get(this.url(), this.update.bind(this));
  };

  Job.prototype.update = function(attributes) {
    this.updateAttributes(attributes.job);
    this.updateClassNames(attributes.job);
    this.updateCommits(attributes.commits);
    return this;
  };

  Job.prototype.updateAttributes = function(attributes) {
    for (attr in attributes) {
      this.element.find('.job .' + attr).html(attributes[attr]);
    }
    return this;
  };

  Job.prototype.updateClassNames = function(attributes) {
    this.element.removeClass().addClass(attributes.status).addClass(attributes.building);
  };

  Job.prototype.updateCommits = function(commits) {
    this.element.find('.commit').remove();
    $(commits).each(function (i, attributes) {
      var commit = new Commit().update(attributes);
      this.element.find('.commits').append(commit.element);
    }.bind(this));
    return this;
  };

  Job.prototype.get = function(attr) {
    return this.element.find('.' + attr).html();
  };

  Job.prototype.url = function() {
    return '/' + this.get('name') + '.json';
  };

  function Commit(attributes) {
    this.element = $(this.template);
    this.update(attributes);
  }

  Commit.prototype.template = $('#commit-template').html();

  Commit.prototype.update = function(attributes) {
    for (attr in attributes) {
      this.element.find('.' + attr).html(attributes[attr]);
    }
    return this;
  };
});
