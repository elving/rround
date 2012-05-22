# rround

rround is a simple and fun way to discover people and things happening around you.

## How it works

rround uses 

* Client - [Brunch (0.8.1)](http://brunch.io)
	* [Coffeescript](https://github.com/jashkenas/coffee-script)
	* [Eco](https://github.com/sstephenson/eco)
	* [Stitch](https://github.com/sstephenson/stitch)
	* [Stylus](https://github.com/learnboost/stylus)
	* [Underscore](https://github.com/documentcloud/underscore)
	* [Backbone](https://github.com/documentcloud/backbone)
	* [Jquery](https://github.com/jquery/jquery)
* Other
	* [Isotope](https://github.com/desandro/isotope)
	* [Leaflet](https://github.com/CloudMade/Leaflet)
* Server - [Node.js](http://nodejs.org/)
	* [Express](https://github.com/visionmedia/express)
* APIs
	* [Google Maps](https://developers.google.com/maps/)
	* [Yahoo Places](http://developer.yahoo.com/geo/placefinder/)
	* [Cloudmade](http://developers.cloudmade.com/projects/show/web-maps-studio)
	* [Twitter](https://dev.twitter.com/)
	* [Youtube](https://developers.google.com/youtube/)
	* [Instagram](http://instagram.com/developer/)
	* [Foursquare](https://developer.foursquare.com/)
	

## Contributing
You'll need [node.js](http://nodejs.org/) 0.6.17+

Install dependencies

	npm install
	
Run Brunch

	brunch watch ./ -m
	
Run Server

	foreman start
	
or

	coffee server

### APIs
You'll need to have a file name keys.coffee in the app/common folder. It needs to look like this:

	module.exports =
	    instagram: '0000' #Instagram API KEY
	    cloudmade: '0000' #Cloudmade API KEY
	    foursquare:
	        clientId: '0000' #Foursquare Client ID
	        clientSecret: '0000' #Foursquare Client Secret
