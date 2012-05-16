WelcomeTemplate = require 'templates/welcome'

module.exports = class WelcomeView extends Backbone.View
    el: 'section.welcome'

    events:
        'click a.welcome-start': 'getData'
        'click input.welcome-location': 'clickLocation'
        'keyup input.welcome-location': 'changedLocation'
        'change input.welcome-location': 'changedLocation'
        'blur input.welcome-location': 'changedLocation'
        'paste input.welcome-location': 'changedLocation'

    initialize: ->
        rround.models.user.on 'change:location', @displayLocation
        @render()

    render: ->
        @$el.html(WelcomeTemplate
            geolocation: Modernizr.geolocation
        ).removeClass 'is-loading'

    hide: ->
        @$el.toggleClass 'is-loading-data is-hidden'

    clickLocation: (event) ->
        $input = $ event.currentTarget
        $input.blur() if $input.prop 'readonly'

    displayLocation: =>
        location = rround.models.user.get 'location'
        @$el.find('a.welcome-start').removeClass 'is-disabled'
        @$el.find('input.welcome-location').val(
            "#{location.spot} (#{location.latitude}, #{location.longitude})"
        ).removeClass('is-loading').prop('readonly', no).attr 'placeholder', 'Where are you?'

    focusLocation: ->
        @$el.find('input.welcome-location')
            .attr('readonly', off)
            .attr('placeholder', '(e.g. Cupertino CA 95014 United States)')
            .removeClass('is-loading')
            .addClass('checkLocation')
            .val('')
            .focus()

    changedLocation: (event) ->
        $location = $ event.currentTarget
        $location.addClass 'checkLocation'
        @$el.find('a.welcome-start').toggleClass 'is-disabled', $.trim($location.val()) is ''

    getData: (event) ->
        event.preventDefault()
        $location = @$el.find 'input.welcome-location'
        return false if $(event.currentTarget).hasClass('is-disabled') or $.trim($location.val()) is ''

        if $location.hasClass 'checkLocation'
            $location.removeClass 'checkLocation'
            rround.models.user.geocode($location.val()).done( =>
                @$el.addClass 'is-loading-data'
                rround.views.app.getData()
            ).fail =>
                $location.addClass 'checkLocation'
        else
            @$el.addClass 'is-loading-data'
            rround.views.app.getData()
