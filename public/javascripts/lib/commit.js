(function () {
  monitor.Commit = Commit;

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
