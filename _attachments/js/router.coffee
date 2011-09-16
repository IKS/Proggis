window.Proggis = {} unless Proggis = window.Proggis
Proggis.RouterClass = Backbone.Router.extend
    routes:
        "": "home"
        "planning/": "planning"
        "planning/task/:task": "planningTask"
        "monitoring/": "monitoring"
    home: ->

    planning: ->
        console.log "mainChart"
    planningTask: (task) ->
        console.log "task #{task}"
    monitoring: ->
        console.log "monitoring"

jQuery(document).ready ->
    Proggis.router = new Proggis.RouterClass
    Proggis.router.bind "all", Proggis.Navigation.handleRouteChange
    do Backbone.history.start

