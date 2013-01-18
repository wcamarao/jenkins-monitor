class App.Issue extends Backbone.Model

class App.Issues extends Backbone.Collection
  model: App.Issue

  amount: =>
    Math.ceil( $(window).outerHeight() / 80 )

  keepFetching: =>
    $.get "/issues/amount/#{@amount()}.json", (issues) =>
      @reset(issues)
      setTimeout(@keepFetching.bind(this), App.config.jira_update_interval)

class App.IssuesView extends Backbone.View
  el: '#jira'

  initialize: =>
    @template = @$el.find('#issue-template').html()
    @template = "{{#issues}} #{@template} {{/issues}}"
    @collection.on 'reset', @render
    @collection.keepFetching()
    @$issues = @$el.find('#issues')

  render: (issues) =>
    return unless issues?
    issuesAttributes = { issues: issues.toArray().map (issue) -> issue.attributes }
    @$issues.html Mustache.render @template, issuesAttributes