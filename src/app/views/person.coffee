PersonTemplate = require 'templates/person'

module.exports = class PersonView extends Backbone.View
    tagName: 'li'

    className: 'grid-item clearfix'

    render: ->
        @$el
            .addClass(@model.get('service'))
            .attr('data-radius', @model.get('radius'))
            .html PersonTemplate @model.toJSON()
        @
