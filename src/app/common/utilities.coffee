module.exports = class Utilities
	setLinks: (text) ->
        text = text.replace /[A-Za-z]+:\/\/[A-Za-z0-9-_]+\.[A-Za-z0-9-_:%&~\?\/.=]+/gim, (url) ->
            "<a rel=\"nofollow\" target=\"_blank\" href=\"#{url}\">#{url}</a>"

        text = text.replace /[@]+[A-Za-z0-9-_]+/gim, (mention) ->
            username = mention.replace '@', ''
            "<a rel=\"nofollow\" target=\"_blank\" href=\"http:\/\/twitter.com\/#{username}\" alt=\"#{username}\">#{mention}</a>"

        text = text.replace /[#]+[A-Za-z0-9-_]+/gim, (hash) ->
            hashtag = hash.replace '#', '%23'
            "<a rel=\"nofollow\" target=\"_blank\" href=\"http:\/\/search.twitter.com\/search?q=#{hashtag}\" alt=\"#{hash}\">#{hash}</a>"

    setTime: (time) ->
        $.timeago new Date time

    setDistance: (model) ->
        modelLocation = model.get 'location'
        userLocation = rround.models.user.get 'location'

        lat1 = userLocation.latitude
        lat2 = modelLocation.latitude
        lon1 = userLocation.longitude
        lon2 = modelLocation.longitude

        R = 6371
        dLat = (lat2 - lat1) * Math.PI / 180
        dLon = (lon2 - lon1) * Math.PI / 180
        lat1 = lat1 * Math.PI / 180
        lat2 = lat2 * Math.PI / 180

        a = Math.sin(dLat / 2) * Math.sin(dLat / 2) +
            Math.sin(dLon / 2) * Math.sin(dLon / 2) * Math.cos(lat1) * Math.cos(lat2)
        c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a))
        d = Math.round((R * c) * 10) / 10

        _distance = if d > 0 then "within #{d} km" else 'rround you'

        if d <= 1
          _radius = 1
        else if d > 1 and d < 3
          _radius = 2
        else if d > 2 and d < 4
          _radius = 3
        else if d > 3 and d < 5
          _radius = 4
        else if d > 4
          _radius = 5

        model.set
            radius: _radius
            distance: _distance
