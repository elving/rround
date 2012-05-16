$ ->
    window.rround = rround ? {}
    rround.models = rround.models ? {}
    rround.collections = rround.collections ? {}
    rround.views = rround.views ? {}
    rround.keys = rround.keys ? {}

    rround.views.app = new AppView = require 'views/app'
