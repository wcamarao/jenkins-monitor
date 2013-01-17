window.App = {}

$ ->
  App.jobs = new App.Jobs
  App.jobsView = new App.JobsView(collection: App.jobs)
  App.jobsView.render()
