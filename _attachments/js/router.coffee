window.Proggis = {} unless Proggis = window.Proggis
Proggis.RouterClass = Backbone.Router.extend
    routes:
        "": "home"
        "planning/": "planning"
        "planning/task/:task": "planningTask"
        "monitoring/": "monitoring"
    home: ->

    planning: ->
        Proggis.Chart.init (node) ->
            selected = Proggis.Chart.data.label.indexOf node.name
            key = node.name.match( /([0-9]+)/g )[0]
            console.log "change to", key
            Proggis.router.navigate "planning/task/#{key}", true
        Proggis.Chart.loadChart "EffortAllocTime", 3

    planningTask: (task) ->
        console.log "planningTask", task
        Proggis.Chart.init (node) ->
            selected = Proggis.Chart.data.label.indexOf node.name
            key = node.name.match( /([0-9]+)/g )[0]
            console.log "change to", key
            Proggis.router.navigate "planning/task/#{key}", true
        Proggis.Chart.loadChart "EffortAllocTime", 4, task
        console.log "task #{task}"
    monitoring: ->
        console.log "monitoring"

jQuery(document).ready ->
    Proggis.router = new Proggis.RouterClass
    Proggis.router.bind "all", Proggis.Navigation.handleRouteChange
    do Backbone.history.start

