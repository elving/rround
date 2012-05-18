SpotView = require 'views/spot'

module.exports = class SpotsView extends Backbone.View
    el: 'ul.spots-list'

    initialize: ->
        rround.collections.spots = new SpotsCollection = require 'collections/spots'
        @collection = rround.collections.spots
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

    addOne: (spot) =>
        view = new SpotView model: spot
        @$el.prepend view.render().$el

    addAll: =>
        unless @collection.length is 0
            @collection.each @addOne
            @$el.parent().show()
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
            @$el.prepend '<li class="is-empty">There are no spots rround you :(</li>'
            if @options.firstRender
                @$el.parent().show()
                @firstRender()
