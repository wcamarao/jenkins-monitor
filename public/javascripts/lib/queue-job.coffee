class monitor.QueueJob extends monitor.Job
  constructor: (attributes) ->
    @firstUpdateCallbacks = []
    super attributes

  keepFetching: ->
    @intervalId = super()

  update: (attributes) ->
    super attributes
    @element.attr 'data-url', attributes.job.url
    callback() for callback in @firstUpdateCallbacks
    @firstUpdateCallbacks.length = 0

  onFirstUpdate: (callback) ->
    @firstUpdateCallbacks.push callback

  remove: ->
    @element.remove()
    clearInterval @intervalId
