MenuTemplate = require 'templates/menu'
AboutTemplate = require 'templates/about'

module.exports = class MenuView extends Backbone.View
    el: 'div.menu'

    events:
        'click a.menu-link': 'clickMenuItem'
        'click a.menu-about': 'about'

    initialize: ->
        @render()

    render: ->
        @$el.append(
            MenuTemplate
                location: rround.models.user.get 'location'
                happenings: rround.collections.happenings.length
                people: rround.collections.people.length
                spots: rround.collections.spots.length
        ).animate
            top: 0, 500, -> rround.views.settings = new SettingsView = require 'views/settings'

    clickMenuItem: (event) ->
        event.preventDefault()
        $button = $ event.currentTarget

        unless $button.is '.is-selected'
            $('a.menu-link').removeClass 'is-selected'
            $button.toggleClass 'is-selected'
            rround.views.app.toggleSection $button.data 'section'

    about: (event) ->
        event.preventDefault()
        rround.views.modal.render
            message: 'About'
            tip: AboutTemplate()
