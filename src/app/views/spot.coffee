SpotTemplate = require 'templates/spot'

module.exports = class SpotView extends Backbone.View
    tagName: 'li'

    className: 'grid-item clearfix'

    render: ->
        @$el
            .attr('data-radius', @model.get('radius'))
            .html SpotTemplate @model.toJSON()
        @
