class monitor.Queue
  constructor: (@jobName) ->
    @lastNumber = 0
    @keepFetching()

  keepFetching: ->
    setInterval @fetch.bind(this), 5000
    @fetch()

  fetch: ->
    $.get @url(), (attributes) =>
      @update(attributes.job.number)

  update: (number) ->
    if @lastNumber < number
      start = if @lastNumber == 0 then (number - 4) else number
      @render(n) for n in [start..number]
      @lastNumber = number

  render: (number) ->
    job = new monitor.Job(job: name: @jobName)
    job.number = number
    @append job
  
  append: (job) ->
    sections = $('section')
    if sections.size() == 0
      $('body').append job.element
      job.onUpdate -> $('#loading').remove()
    else
      sections.first().before job.element

  url: ->
    "/#{@jobName}.json"
