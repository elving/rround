module.exports = class PersonModel extends Backbone.Model
    initialize: ->
        @set timeAgo: rround.utilities.setTime @get 'time'
        rround.utilities.setDistance @
