window.Proggis = {} unless Proggis = window.Proggis
Proggis.RouterClass = Backbone.Router.extend
    routes:
        "": "home"
        "planning/": "planning"
        "planning/partner/": "planningPartner"
        "planning/wbs/:wbs/": "planningWbs"
        "planning/wbs/:wbs/partner/": "planningWbsPartner"
        "monitoring/": "monitoring"

    home: ->
        Proggis.Chart.init "AreaChart", (node) ->
        Proggis.Chart.legendClear $(".legend")

    # Planning Routes
    planning: ->
        @_setPlanningPartnerOption "Time"
        do @_planning
    planningPartner: ->
        @_setPlanningPartnerOption "Partner"
        do @_planning
    planningWbs: (wbs) ->
        @_setPlanningPartnerOption "Time"
        @_planningWbs wbs
    planningWbsPartner: (wbs) ->
        @_setPlanningPartnerOption "Partner"
        @_planningWbs wbs

    # Show Planning data without zooming
    _planning: ->
        chartSelected = @_getPlanningPartnerOption()
        switch chartSelected
            when "byTime"
                Proggis.Chart.init "AreaChart", (node) ->
                    key = node.name.match( /([0-9]+)/g )[0]
                    console.log "planning change to", key
                    Proggis.router.navigate "planning/wbs/#{key}/", true
                Proggis.Chart.loadChart "EffortAllocTime", 3
            when "byPartner"
                Proggis.Chart.init "BarChart", (node) ->
                    key = node.name.match( /([0-9]+)/g )[0]
                    console.log "planning change to", key
                    Proggis.router.navigate "planning/wbs/#{key}/partner/", true
                Proggis.Chart.loadChart "EffortPartner", 2

    # Show Planning data with zooming
    _planningWbs: (wbs) ->
        console.log "planningWbs", wbs
        chartSelected = @_getPlanningPartnerOption()

        switch chartSelected
            when "byTime"
                Proggis.Chart.init "AreaChart", (node) ->
                    key = node.name.match( /([0-9]+)/g )[0]
                    console.log "planning change to", key
                    route = "planning/wbs/#{key}/"
                    route += "partner" if chartSelected is "isPartner"
                    Proggis.router.navigate route, true
                Proggis.Chart.loadChart "EffortAllocTime", 4, wbs
            when "byPartner"
                Proggis.Chart.init "BarChart", (node) ->
                    key = node.name.match( /([0-9]+)/g )[0]
                    console.log "planning change to", key
                    route = "planning/wbs/#{key}/"
                    route += "partner" if chartSelected is "isPartner"
                    Proggis.router.navigate route, true
                Proggis.Chart.loadChart "EffortPartner", 3, wbs
        console.log "wbs #{wbs}"

    # set radio button
    _setPlanningPartnerOption: (byWhat) ->
        jQuery("[name=planningChartSelector][value=by#{byWhat}]").each ->
            @checked = true
        jQuery("[name=planningChartSelector][value!=by#{byWhat}]").each ->
            @checked = false
    _getPlanningPartnerOption: ->
        jQuery('[name=planningChartSelector]').filter(-> jQuery(this).is(":checked")).val()

    monitoring: ->
        console.log "monitoring"
        Proggis.Chart.init "BarChart", (node) ->
            key = node.name.match( /([0-9]+)/g )[0]
            console.log "monitoring change to", key
            Proggis.router.navigate "monitoring/wbs/#{key}/", true
        Proggis.Chart.loadChart "EffortPartner", 2
    monitoringWbs: (wbs) ->
        console.log "monitoringWbs", wbs
        Proggis.Chart.init "BarChart", (node) ->
            key = node.name.match( /([0-9]+)/g )[0]
            console.log "monitoring change to", key
            Proggis.router.navigate "monitoring/wbs/#{key}/", true
        Proggis.Chart.loadChart "EffortPartner", 3, wbs
        console.log "wbs #{wbs}"
        
jQuery(document).ready ->
    Proggis.router = new Proggis.RouterClass
    Proggis.router.bind "all", Proggis.Navigation.handleRouteChange
    do Backbone.history.start
    jQuery('[name=planningChartSelector]').change ->
        selected = jQuery('[name=planningChartSelector]').filter(-> jQuery(this).is(":checked")).val()
        console.log "changed to #{selected}"
        switch selected 
            when "byTime"
                Proggis.router.navigate (window.location.hash.replace "partner/", ""), true
            when "byPartner"
                Proggis.router.navigate "#{window.location.hash}partner/", true

