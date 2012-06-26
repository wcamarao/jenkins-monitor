class monitor.Job
  constructor: (attributes) ->
    @element = $(@template())
    @update(attributes)
    @keepFetching()

  keepFetching: ->
    setInterval @fetch.bind(this), 5000

  fetch: ->
    $.get @url(), @update.bind(this)

  update: (attributes) ->
    @updateAttributes attributes.job
    @updateClassNames attributes.job
    @updateCommits attributes.commits
    @updateCallback?()

  onUpdate: (callback) ->
    @updateCallback = callback

  updateAttributes: (attributes) ->
    return unless attributes?
    @lastStatus = @get 'status'
    for attr of attributes
      @set attr, attributes[attr]
    if attributes.building == 'building'
      @set 'status', attributes.building

  updateClassNames: (attributes) ->
    if attributes? && @lastStatus != @get 'status'
      @element.removeClass().addClass(attributes.building).addClass attributes.status
      @body().append(@body().find('section').remove())

  updateCommits: (commits) ->
    return unless commits?
    @element.find('.commit').remove()
    for attributes in commits
      commit = new monitor.Commit attributes
      @element.find('.commits').append commit.element

  body: ->
    $('body')

  template: ->
    $('#job-template').html()

  get: (attr) ->
    @element.find(".job .#{attr}").html()

  set: (attr, val) ->
    @element.find(".job .#{attr}").html(val)

  url: ->
    numberPath = if @number then "/#{@number}" else ''
    "/#{@get('name') + numberPath}.json"
