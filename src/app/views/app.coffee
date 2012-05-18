module.exports = class AppView extends Backbone.View
    el: 'body'

    initialize: ->
        rround.keys = require 'common/keys'
        rround.models.app = new AppModel = require 'models/app'
        rround.models.user = new UserModel = require 'models/user'
        rround.views.modal = new ModalView = require 'views/modal'
        rround.views.welcome = new WelcomeView = require 'views/welcome'
        rround.views.happenings = new HappeningsView = require 'views/happenings'
        rround.views.people = new PeopleView = require 'views/people'
        rround.views.spots = new SpotsView = require 'views/spots'
        rround.views.map = new MapView = require 'views/map'
        rround.utilities = new Utilities = require 'common/utilities'

        @model = rround.models.app

        @model.set isMobile: Modernizr.mq 'only screen and (max-width: 480px)'

    getData: =>
        navigator.geolocation.clearWatch @model.get 'locationWatcher'
        @model.getData()

    toggleSection: (section) ->
        @$el.find('section.data > section').hide()

        if section is 'happenings'
            rround.views.happenings.render()
        else if section is 'people'
            rround.views.people.render()
        else if section is 'spots'
            rround.views.spots.render()
        else if section is 'map'
            rround.views.map.render()

        rround.views.settings.toggleSettings() unless $('section.settings').hasClass('is-visible') and section isnt 'map'

    filterService: (service) ->
        $list = @$el.find 'section.data > section:visible > ul'
        $items = $list.find('li').not '.filteredRadius, .filteredSearch'
        $items.each ->
            $this = $ this
            $this.toggleClass('filtered filteredService') if $this.is ".#{service}"

        $list.isotope filter: $items.not '.filtered'

    filterRadius: (radius) ->
        $list = @$el.find 'section.data > section:visible > ul'
        $items = $list.find('li').not '.filteredService, .filteredSearch'

        $items.removeClass 'filtered filteredRadius'

        unless radius is 5
            $items.each ->
                $this = $ this
                $this.addClass('filtered filteredRadius') if $this.data('radius') > radius

        $list.isotope filter: $items.not '.filtered'

    search: (query) ->
        $list = @$el.find 'section.data > section:visible > ul'
        $items = $list.find('li').not '.filteredRadius, .filteredService'

        $items.removeClass 'filtered filteredSearch'

        if query
            $items.each ->
                $this = $ this
                content = $.trim($this.text()).toLowerCase()
                $this.addClass('filtered filteredSearch') if not content.match query

        $list.isotope filter: $items.not '.filtered'



