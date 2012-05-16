ModalTemplate = require 'templates/modal'

module.exports = class ModalView extends Backbone.View
    el: 'section.modal'

    events:
        'click a.modal-discard': 'discard'

    render: (data) ->
        @$el.html ModalTemplate data
        @toggleModal()

    discard: (event) ->
        event.preventDefault()
        @toggleModal()
        rround.views.welcome.focusLocation()

    toggleModal: ->
        @$el.prev('div.modal-overlay').toggleClass 'is-hidden is-visible'
        @$el.toggleClass 'is-hidden is-visible'
