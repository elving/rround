HappeningView = require 'views/happening'

module.exports = class HappeningsView extends Backbone.View
    el: 'ul.happenings-list'

    initialize: ->
        rround.collections.happenings = new HappeningsCollection = require 'collections/happenings'
        @collection = rround.collections.happenings
        @collection.on 'add', @addOne
        @collection.on 'reset', @addAll
        @options.firstRender = yes

    render: ->
        if @$el.find('li').length isnt 0
            @$el.parent().toggle()
            @$el.isotope 'reLayout'
        else
            @addAll()

    firstRender: ->
        @$el.removeClass 'is-loading'
        rround.views.menu = new MenuView = require 'views/menu'
        @options.firstRender = no

    addOne: (happening) =>
        view = new HappeningView model: happening
        @$el.prepend view.render().$el

    addAll: =>
        unless @collection.length is 0
            @collection.each @addOne
            @$el.parent().show() if @options.firstRender
            @$el.isotope
                itemSelector: @$el.find('li').not '.filtered'
                animationEngine: 'css'
                hiddenClass: 'filtered'
                masonry:
                    columnWidth: 305
                    gutterWidth: 20
                onLayout: =>
                    @firstRender() if @options.firstRender
        else
            @$el.prepend '<li class="is-empty">There are no happenings rround you :(</li>'
            if @options.firstRender
                @$el.parent().show()
                @firstRender()

