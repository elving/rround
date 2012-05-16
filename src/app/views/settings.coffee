module.exports = class SettingsView extends Backbone.View
    el: 'section.settings'

    events:
        'click label.settings-service-toggle': 'toggleService'
        'keyup input.settings-search': 'search'

    initialize: ->
        @$el.find('div.settings-radiusControl').slider
            range: 'min'
            value: 5
            min: 1
            max: 5
            slide: (event, ui) =>
                rround.views.app.filterRadius ui.value

        @toggleSettings()

    toggleSettings: ->
        @$el.toggleClass 'is-visible'

    toggleService: (event) ->
        rround.views.app.filterService $(event.currentTarget).data('service'), $(event.currentTarget).prev('input.settings-service-check').is(':checked')

    reset: ->
        @$el.find('''
            #settings-service-twitter,
            #settings-service-instagram,
            #settings-service-youtube,
            #settings-service-foursquare
        ''').prop 'checked', yes

    search: (event) ->
        rround.views.app.search $.trim $(event.currentTarget).val().toLowerCase()
