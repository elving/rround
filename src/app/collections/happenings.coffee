module.exports = class HappeningsCollection extends Backbone.Collection
    model: require 'models/happening'

    comparator: (happening) ->
        new Date happening.get 'time'
