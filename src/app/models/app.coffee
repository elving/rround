module.exports = class AppModel extends Backbone.Model
    defaults:
        serviceFails: 0
        happenings: []
        people: []
        spots: []

    getData: ->
        serviceFails = @get 'serviceFails'
        location = rround.models.user.get 'location'
        services =
            twitter: $.getJSON(
                'http://search.twitter.com/search.json?callback=?'
                geocode: "#{location.latitude},#{location.longitude},5km"
            )

            instagram: $.getJSON(
                'https://api.instagram.com/v1/media/search?callback=?'
                lat: location.latitude
                lng: location.longitude
                distance: 5000
                client_id: rround.keys.instagram
            )

            youtube: $.getJSON(
                'http://gdata.youtube.com/feeds/api/videos?callback=?'
                alt: 'json'
                location: "#{location.latitude},#{location.longitude}!"
                'location-radius': '5000m'
                time: 'this_week'
            )

            foursquare: $.getJSON(
                'https://api.foursquare.com/v2/venues/search?callback=?'
                v: '20120514'
                ll: "#{location.latitude},#{location.longitude}"
                client_id: rround.keys.foursquare.clientId
                client_secret: rround.keys.foursquare.clientSecret
            )

        $.when(
            services.twitter, services.instagram, services.youtube, services.foursquare
        ).done(
            (twitter, instagram, youtube, foursquare) =>
                @set serviceFails: 0

                @foursquare foursquare[0].response.venues, foursquare[1], location
                @twitter twitter[0].results, twitter[1], location
                @instagram instagram[0].data, instagram[1], location
                @youtube youtube[0].feed.entry, youtube[1], location

                rround.views.welcome.hide()

                rround.collections.happenings.reset @get 'happenings'
                rround.collections.people.reset @get 'people'
                rround.collections.spots.reset @get 'spots'

                rround.views.menu = new MenuView = require 'views/menu'

        ).fail(
            (error) =>
                @set serviceFails: serviceFails += 1
                @getData() if @get('serviceFails') <= 3
        )

    twitter: (data, xhr, location) ->
        _happenings = @get 'happenings'
        if data? and xhr is 'success'
            for own key, item of data
                _happenings.push
                    twitter: yes
                    service: 'twitter'
                    type: 'tweeted'
                    name: item.from_user
                    userId: item.from_user_id_str
                    image: item.profile_image_url
                    url: "http://twitter.com/#{item.from_user}"
                    update:
                        tweet: item.text
                        tweetId: item.id_str
                    updateUrl: "http://twitter.com/#{item.from_user}/status/#{item.id_str}"
                    time: item.created_at
                    location:
                        if item.geo is null then latitude: location.latitude, longitude: location.longitude
                        else latitude: item.geo.coordinates[0], longitude: item.geo.coordinates[1]

                @setPeople
                    service: 'twitter'
                    name: item.from_user
                    image: item.profile_image_url
                    url: "http://twitter.com/#{item.from_user}"
                    time: item.created_at
                    location:
                        if item.geo is null then latitude: location.latitude, longitude: location.longitude
                        else latitude: item.geo.coordinates[0], longitude: item.geo.coordinates[1]

            @set happenings: _happenings

    instagram: (data, xhr, location) ->
        _happenings = @get 'happenings'
        if data? and xhr is 'success'
            for own key, item of data
                _location = if item.location.latitude and item.location.longitude then yes else no

                _happenings.push
                    instagram: yes
                    service: 'instagram'
                    type: 'shared a photo'
                    name: item.user.username
                    image: item.user.profile_picture
                    url: item.link
                    update:
                        photo: item.images.low_resolution.url
                        photoDimensions:
                            width: item.images.low_resolution.width
                            height: item.images.low_resolution.height
                        caption: if item.caption is null then no else item.caption.text
                        likes: item.likes.count
                    updateUrl: item.link
                    time: new Date(parseInt(item.created_time * 1000, 10))
                    location:
                        latitude: if _location then item.location.latitude else location.latitude
                        longitude: if _location then item.location.longitude else location.longitude

                @setPeople
                    service: 'instagram'
                    name: item.user.username
                    image: item.user.profile_picture
                    url: "http://ink361.com/#{item.user.username}"
                    time: new Date(parseInt(item.created_time * 1000, 10))
                    location:
                        latitude: if _location then item.location.latitude else location.latitude
                        longitude: if _location then item.location.longitude else location.longitude

            @set happenings: _happenings

    youtube: (data, xhr, location) ->
        _happenings = @get 'happenings'
        if data? and xhr is 'success'
            for own key, item of data
                _location = item.georss$where.gml$Point.gml$pos.$t.split ' '

                _happenings.push
                    youtube: yes
                    service: 'youtube'
                    type: 'shared a video'
                    name: item.author[0].name.$t
                    image: item.media$group.media$thumbnail[0].url
                    url: "http://youtube.com/user/#{item.author[0].name.$t}"
                    update:
                        video: item.id.$t.replace('http://gdata.youtube.com/feeds/api/videos/', '')
                        title: item.media$group.media$title.$t
                    updateUrl: item.link[0].href
                    time: item.published.$t
                    location:
                        latitude: _location[0]
                        longitude: _location[1]

                @setPeople
                    service: 'youtube'
                    name: item.author[0].name.$t
                    image: item.media$group.media$thumbnail[0].url
                    url: "http://youtube.com/user/#{item.author[0].name.$t}"
                    time: item.published.$t
                    location:
                        latitude: _location[0]
                        longitude: _location[1]

            @set happenings: _happenings

    foursquare: (data, xhr, location) ->
        _happenings = @get 'happenings'
        _spots = @get 'spots'
        if data? and xhr is 'success'
            for own key, item of data
                hereNow = if item.hereNow.count > 0 then yes else no

                _spots.push
                    name: item.name
                    image: if item.categories.length then item.categories[0].icon.prefix.substring(0, item.categories[0].icon.prefix.length - 1) + item.categories[0].icon.name else ''
                    url: "https://foursquare.com/venue/#{item.id}"
                    checkins: item.stats.checkinsCount
                    location:
                        latitude: item.location.lat
                        longitude: item.location.lng

                if hereNow
                    _happenings.push
                        foursquare: yes
                        service: 'foursquare'
                        type: ' '
                        image: if item.categories.length then item.categories[0].icon else 'img/place.png'
                        name: item.name
                        url: "http://foursquare.com/venue/#{item.id}"
                        update: if item.hereNow.count is 1 then '1 person checked in @ ' else "#{item.hereNow.count} people checked in @ "
                        updateUrl: "http://foursquare.com/venue/#{item.id}"
                        time: new Date()
                        location:
                            latitude: item.location.lat
                            longitude: item.location.lng

            @set
                spots: _spots
                happenings: _happenings

    setPeople: (person) ->
        _people = @get 'people'
        return false for _person in _people when _person.name is person.name
        _people.push person
        @set people: _people


