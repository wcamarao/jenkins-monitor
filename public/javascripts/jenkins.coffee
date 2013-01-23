# Job Model

class App.Job extends Backbone.Model
  initialize: ->
    @set 'name', @get('name').replace(/ui\.|-gerrit/g, '')

# Jobs Collection

class App.Jobs extends Backbone.Collection
  model: App.Job

  amount: =>
    Math.ceil($(window).outerHeight() / 80)

  keepFetching: =>
    $.get "/jobs/amount/#{@amount()}.json", (jobs) =>
      @reset(jobs)
      setTimeout(@keepFetching.bind(this), App.config.jenkins_update_interval)

# Jobs View

class App.JobsView extends Backbone.View
  el: '#jenkins'

  initialize: =>
    @template = @$el.find('#job-template').html()
    @template = "{{#jobs}} #{@template} {{/jobs}}"
    @collection.on 'reset', @render
    @collection.keepFetching()
    @$jobs = @$el.find('#jobs')

  render: (jobs) =>
    return unless jobs?
    jobsAttributes = jobs: jobs.toArray().map (job) -> job.attributes
    @$jobs.html Mustache.render @template, jobsAttributes
