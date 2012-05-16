module.exports = class SpotsCollection extends Backbone.Collection
    model: require 'models/spot'

    comparator: (spot) ->
        -spot.get 'distance'
