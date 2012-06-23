var monitor = {};

(function () {
  monitor.Job = Job;
  monitor.Commit = Commit;

  function Job(attributes) {
    this.element = $(this.template());
    this.update(attributes);
    this.keep(this.fetch);
  }

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
    this.lastStatus = this.get('status');
    for (attr in attributes) {
      this.set(attr, attributes[attr]);
    }
    if (attributes.building === 'building') {
      this.set('status', attributes.building);
    }
    return this;
  };

  Job.prototype.updateClassNames = function(attributes) {
    if (this.lastStatus !== this.get('status')) {
      this.element.removeClass().addClass(attributes.building).addClass(attributes.status);
      this.body().append(this.body().find('section').remove());
    }
  };

  Job.prototype.updateCommits = function(commits) {
    this.element.find('.commit').remove();
    $(commits).each(function (i, attributes) {
      var commit = new Commit().update(attributes);
      this.element.find('.commits').append(commit.element);
    }.bind(this));
    return this;
  };

  Job.prototype.body = function() {
    return $('body');
  };

  Job.prototype.template = function() {
    return $('#job-template').html();
  };

  Job.prototype.get = function(attr) {
    return this.element.find('.job .' + attr).html();
  };

  Job.prototype.set = function(attr, val) {
    this.element.find('.job .' + attr).html(val);
  };

  Job.prototype.url = function() {
    return '/' + this.get('name') + '.json';
  };

  function Commit(attributes) {
    this.element = $(this.template());
    this.update(attributes);
  }

  Commit.prototype.update = function(attributes) {
    for (attr in attributes) {
      this.set(attr, attributes[attr]);
    }
    return this;
  };

  Commit.prototype.template = function() {
    return $('#commit-template').html();
  };

  Commit.prototype.set = function(attr, val) {
    this.element.find('.' + attr).html(val);
  }
})();
