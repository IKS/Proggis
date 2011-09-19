window.Proggis = {} unless Proggis = window.Proggis
Proggis.RouterClass = Backbone.Router.extend
    routes:
        "": "home"
        "planning/": "planning"
        "planning/wbs/:wbs": "planningWbs"
        "monitoring/": "monitoring"
    home: ->
        Proggis.Chart.init "AreaChart", (node) ->
        Proggis.Chart.legendClear $(".legend")

    planning: ->
        Proggis.Chart.init "AreaChart", (node) ->
            key = node.name.match( /([0-9]+)/g )[0]
            console.log "planning change to", key
            Proggis.router.navigate "planning/wbs/#{key}", true
        Proggis.Chart.loadChart "EffortAllocTime", 3

    planningWbs: (wbs) ->
        console.log "planningWbs", wbs
        Proggis.Chart.init "AreaChart", (node) ->
            key = node.name.match( /([0-9]+)/g )[0]
            console.log "planning change to", key
            Proggis.router.navigate "planning/wbs/#{key}", true
        Proggis.Chart.loadChart "EffortAllocTime", 4, wbs
        console.log "wbs #{wbs}"
    monitoring: ->
        console.log "monitoring"
        Proggis.Chart.init "BarChart", (node) ->
            key = node.name.match( /([0-9]+)/g )[0]
            console.log "monitoring change to", key
            Proggis.router.navigate "monitoring/wbs/#{key}", true
        Proggis.Chart.loadChart "EffortPartner", 2
    monitoringWbs: (wbs) ->
        console.log "monitoringWbs", wbs
        Proggis.Chart.init "BarChart", (node) ->
            key = node.name.match( /([0-9]+)/g )[0]
            console.log "monitoring change to", key
            Proggis.router.navigate "monitoring/wbs/#{key}", true
        Proggis.Chart.loadChart "EffortPartner", 3, wbs
        console.log "wbs #{wbs}"

jQuery(document).ready ->
    Proggis.router = new Proggis.RouterClass
    Proggis.router.bind "all", Proggis.Navigation.handleRouteChange
    do Backbone.history.start

