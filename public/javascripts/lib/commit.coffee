class monitor.Commit
  constructor: (attributes) ->
    @element = $(@template())
    @update(attributes)

  update: (attributes) ->
    for attr of attributes
      @set attr, attributes[attr]

  template: ->
    return $('#commit-template').html()

  set: (attr, val) ->
    @element.find(".#{attr}").html(val)
