module.exports = class UserModel extends Backbone.Model
    initialize: ->
        @bind 'error', @error
        @locate()

    validate: (attributes) ->
        if attributes.location is null
            message: attributes.message
            tip: attributes.tip

    locate: ->
        rround.models.app.set locationWatcher: navigator.geolocation.watchPosition(
            (position) =>
                hasSpot = if position.address? and position.address.city? and position.address.countryCode? then yes else no
                location =
                    latitude: position.coords.latitude
                    longitude: position.coords.longitude
                    spot: if hasSpot then "#{position.address.city}, #{position.address.countryCode}" else null

                if hasSpot then @set location: location else @checkLocation location
            (error) =>
                if error.code is 1
                    @set
                        message: 'You didn\'t share your location.'
                        tip: 'Check your browser settings to see if this app is allowed to get your location.'
                        location: null
                else if error.code is 2
                    @set
                        message: 'Couldn\'t detect your current location.'
                        tip: 'Try entering a location manually (city, zipcode, latitude and longitude, etc.)'
                        location: null
                else if error.code is 3
                    @set
                        message: 'Retrieving position timed out.'
                        tip: 'Please, try again.'
                        location: null
                else
                    @set
                        message: 'Unknown error.'
                        tip: 'Something went terribly wrong. Please, try again.'
                        location: null
            maximumAge: 0
            timeout: 60000
            enableHighAccuracy: yes
        )

    geocode: (location, type) ->
        options =
            q: if type is 'latLong' then "#{location.latitude}, #{location.longitude}" else location
            flags: 'J'
            gflags: 'R'
            appid: 'dj0yJmk9TnV6MUVwSm9Qc3liJmQ9WVdrOVNtWkVRa2h2Tm0wbWNHbzlNVFU0TURNNE1UYzJNZy0tJnM9Y29uc3VtZXJzZWNyZXQmeD1hYQ--'
            callback: '?'

        $.getJSON(
            'http://where.yahooapis.com/geocode'
            options
            (res, textStatus, xhr) =>
                data = res.ResultSet

                if data.Results
                    results = data.Results[0]

                    if results.city is '' and results.countrycode is '' and results.statecode is ''
                        @set
                            location:
                                latitude: results.latitude
                                longitude: results.longitude
                                spot: null
                    else
                        code = if results.statecode is '' then results.countrycode else results.statecode
                        @set
                            location:
                                latitude: results.latitude
                                longitude: results.longitude
                                spot: "#{results.city}, #{code}"
                else
                    if type is 'latLong'
                        @set
                            location:
                                latitude: results.latitude
                                longitude: results.longitude
                                spot: null
                    else
                        @set
                            message: 'Couldn\'t detect your current position.'
                            tip: 'Try to be more specific.'
                            location: null
                        xhr.reject()
        ).fail =>
            if type is 'latLong'
                @set
                    location:
                        latitude: results.latitude
                        longitude: results.longitude
                        spot: null
            else
                @set
                    message: 'Couldn\'t detect your current position.'
                    tip: 'Try to be more specific.'
                    location: null

    checkLocation: (location) ->
        if location.spot is null
            @geocode location, 'latLong'
        else
            @geocode location, 'spot'

    error: (user, error) ->
        rround.views.modal.render error
