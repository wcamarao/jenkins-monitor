class monitor.Queue
  constructor: (@jobName) ->
    @updateInterval = parseInt $('#update-interval').val()
    @size = parseInt $('#queue-size').val()
    @lastNumber = 0
    @keepFetching()
    @jobs = $([])

  keepFetching: ->
    setInterval @fetch.bind(this), @updateInterval
    @fetch()

  fetch: ->
    $.get @url(), (attributes) =>
      @update(attributes.job.number)

  update: (number) ->
    if @lastNumber < number
      start = if @lastNumber == 0 then (number - @size + 1) else number
      @push(n) for n in [start..number]
      @lastNumber = number
  
  push: (number) ->
    job = new monitor.QueueJob(job: name: "#{@jobName}/#{number}")
    @jobs.push job
    if @sections().size() == 0 then @appendFirst(job) else @appendNext(job)

  appendFirst: (job) ->
    $('body').append job.element
    job.onFirstUpdate -> $('#loading').remove()

  appendNext: (job) ->
    job.onFirstUpdate =>
      @sections().first().before job.element
      @remove(@jobs[0]) if @jobs.size() > @size

  remove: (job) ->
    @jobs.splice $.inArray(job, @jobs), 1
    job.remove()

  sections: ->
    $('section')

  url: ->
    "/#{@jobName}.json"
