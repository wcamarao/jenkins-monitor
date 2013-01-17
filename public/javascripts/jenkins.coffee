# Job Model

class App.Job extends Backbone.Model

# Jobs Collection

class App.Jobs extends Backbone.Collection
  model: App.Job

  keepFetching: =>
    $.get '/jobs.json', (jobs) =>
      @reset(jobs)
      setTimeout(@keepFetching.bind(this), @updateInterval)

# Jobs View

class App.JobsView extends Backbone.View
  el: '#jenkins'

  initialize: =>
    @collection.updateInterval = @$el.data('update-interval')
    @collection.keepFetching()
    @collection.on 'reset', (jobs) =>

# Job View

class App.JobView extends Backbone.View
