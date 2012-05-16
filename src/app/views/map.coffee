module.exports = class MapView extends Backbone.View
    el: 'section.map'

    initialize: ->
        rround.models.map = new Backbone.Model
        @model = rround.models.map

    render: ->
        if @$el.find('div.map-container').hasClass 'leaflet-container'
            @$el.toggle()
        else
            @$el.show()
            @createMap()
            @createRadius()
            @mapPeople()
            @mapSpots()

    createMap: ->
        location = rround.models.user.get 'location'
        _map = new L.Map(@$el.find('div.map-container')[0],
            center: new L.LatLng(location.latitude, location.longitude)
            zoom: 14
        )
        _cloudmade = new L.TileLayer(
            "http://{s}.tile.cloudmade.com/#{rround.keys.cloudmade}/997/256/{z}/{x}/{y}.png",
            maxZoom: 18
        )
        _userMarker = new L.Marker new L.LatLng location.latitude, location.longitude

        @model.set
            map: _map
            cloudmade: _cloudmade
            userMarker: _userMarker

        _map.addLayer(_cloudmade).addLayer _userMarker

    createRadius: ->
        _map = @model.get 'map'
        _location = rround.models.user.get 'location'
        coords = new L.LatLng _location.latitude, _location.longitude
        options =
            color: '#184879'
            fillColor: '#0095D1'
            fillOpacity: 0.2

        radius = new L.Circle coords, 5000, options
        _map.addLayer radius

    mapPeople: ->
        _map = @model.get 'map'
        rround.collections.people.each (person) ->
            _icon = L.Icon.extend
                iconUrl: person.get 'image'
                iconSize: new L.Point 42, 42
                iconAnchor: new L.Point 0, 0
                shadowUrl: null
                shadowSize: null
                createIcon: ->
                    $(document.createElement 'div')
                        .attr('title', person.get 'name')
                        .css('marginLeft': -(Math.floor(Math.random() * (150 - 42 + 1)) + 42), 'marginTop': -(Math.floor(Math.random() * (150 - 42 + 1)) + 42))
                        .addClass('map-marker-wrapper')
                        .html(@._createIcon 'icon')[0]

            _map.addLayer(
                new L.Marker(
                    new L.LatLng(person.get('location').latitude, person.get('location').longitude)
                    icon: new _icon()
                )
            )

    mapSpots: ->
        _map = @model.get 'map'
        rround.collections.spots.each (spot) ->
            _icon = L.Icon.extend
                iconUrl: spot.get 'image'
                iconSize: new L.Point 42, 42
                iconAnchor: new L.Point 0, 0
                shadowUrl: null
                shadowSize: null
                createIcon: ->
                    $(document.createElement 'div')
                        .attr('title', spot.get 'name')
                        .addClass('map-marker-wrapper')
                        .html(@._createIcon 'icon')[0]

            _map.addLayer(
                new L.Marker(
                    new L.LatLng(spot.get('location').latitude, spot.get('location').longitude)
                    icon: new _icon()
                )
            )

