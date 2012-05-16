module.exports = class HappeningModel extends Backbone.Model
    initialize: ->
        @set timeAgo: rround.utilities.setTime @get 'time'

        if @get('service') is 'twitter'
            @set update:
                tweet: rround.utilities.setLinks @get('update').tweet
                id: @get('update').id

        rround.utilities.setDistance @
