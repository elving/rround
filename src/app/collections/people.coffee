module.exports = class PeopleCollection extends Backbone.Collection
    model: require 'models/person'

    comparator: (person) ->
        -person.get 'radius'
