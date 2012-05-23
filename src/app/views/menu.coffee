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
        location = rround.models.user.get 'location'
        shareText = "#{rround.collections.happenings.length}%20"
        shareText += if rround.collections.happenings.length is 1 then 'Happening,%20' else 'Happenings,%20'
        shareText += "#{rround.collections.people.length}%20"
        shareText += if rround.collections.people.length is 1 then 'person,%20' else 'people,%20'
        shareText += "and%20#{rround.collections.spots.length}%20"
        shareText += if rround.collections.spots.length is 1 then 'spot%20%23rround%20me' else 'spots%20%23rround%20me'
        shareText += "%20@%20#{location.spot}%20(#{location.latitude},%20#{location.longitude})"

        @$el.append(
            MenuTemplate
                location: location
                happenings: rround.collections.happenings.length
                people: rround.collections.people.length
                spots: rround.collections.spots.length
                shareText: shareText
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
