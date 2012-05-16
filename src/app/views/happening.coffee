HappeningTemplate = require 'templates/happening'

module.exports = class HappeningView extends Backbone.View
    tagName: 'li'

    className: 'grid-item clearfix'

    render: ->
        @$el
            .addClass(@model.get('service'))
            .attr('data-radius', @model.get('radius'))
            .html HappeningTemplate @model.toJSON()
        @
