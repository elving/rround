PersonView = require 'views/person'

module.exports = class PeopleView extends Backbone.View
    el: 'ul.people-list'

    initialize: ->
        rround.collections.people = new PeopleCollection = require 'collections/people'
        @collection = rround.collections.people
        @options.firstRender = yes

    render: ->
        if @$el.find('li').length isnt 0
            @$el.parent().toggle()
            @$el.isotope 'reLayout'
        else
            @addAll()

    firstRender: ->
        @$el.removeClass 'is-loading'
        @options.firstRender = no

    addOne: (person) =>
        view = new PersonView model: person
        @$el.prepend view.render().$el

    addAll: =>
        unless @collection.length is 0
            @collection.each @addOne
            @$el.parent().show() if @options.firstRender
            unless rround.models.app.get 'isMobile'
                @$el.isotope
                    itemSelector: @$el.find('li').not '.filtered'
                    hiddenClass: 'filtered'
                    masonry:
                        columnWidth: 305
                        gutterWidth: 20
                    onLayout: =>
                        @firstRender() if @options.firstRender
            else
                @firstRender() if @options.firstRender
        else
            @$el.prepend '<li class="is-empty">There are no people rround you :(</li>'
            if @options.firstRender
                @$el.parent().show()
                @firstRender()

