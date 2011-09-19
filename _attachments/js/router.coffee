window.Proggis = {} unless Proggis = window.Proggis
Proggis.RouterClass = Backbone.Router.extend
    routes:
        "": "home"
        "planning/": "planning"
        "planning/partner/": "planningPartner"
        "planning/wbs/:wbs/": "planningWbs"
        "planning/wbs/:wbs/partner/": "planningWbsPartner"

        "monitoring/": "monitoring"
        "monitoring/partner/": "monitoringPartner"
        "monitoring/wbs/:wbs/": "monitoringWbs"
        "monitoring/wbs/:wbs/partner/": "monitoringWbsPartner"

    home: ->
        Proggis.Chart.init "AreaChart", (node) ->
        Proggis.Chart.legendClear $(".legend")

    # ######### Planning Routes ################################################
    planning: ->
        @_setPartnerOption "Time"
        do @_planning
    planningPartner: ->
        @_setPartnerOption "Partner"
        do @_planning
    planningWbs: (wbs) ->
        @_setPartnerOption "Time"
        @_planningWbs wbs
    planningWbsPartner: (wbs) ->
        @_setPartnerOption "Partner"
        @_planningWbs wbs

    # Show Planning data without zooming
    _planning: ->
        chartSelected = @_getPartnerOption()
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
                Proggis.Chart.loadChart "EffortAllocPartner", 2

    # Show Planning data with zooming
    _planningWbs: (wbs) ->
        console.log "planningWbs", wbs
        chartSelected = @_getPartnerOption()

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
                Proggis.Chart.loadChart "EffortAllocPartner", 3, wbs
        console.log "wbs #{wbs}"

    # set radio button
    _setPartnerOption: (byWhat) ->
        jQuery("[name=chartSelector][value=by#{byWhat}]").each ->
            @checked = true
        jQuery("[name=chartSelector][value!=by#{byWhat}]").each ->
            @checked = false
    _getPartnerOption: ->
        jQuery('[name=chartSelector]').filter(-> jQuery(this).is(":checked")).val()

    # ########## Monitoring Routes #############################################
    monitoring: ->
        @_setPartnerOption "Time"
        do @_monitoring
    monitoringPartner: ->
        @_setPartnerOption "Partner"
        do @_monitoring
    monitoringWbs: (wbs) ->
        @_setPartnerOption "Time"
        @_monitoringWbs wbs
    monitoringWbsPartner: (wbs) ->
        @_setPartnerOption "Partner"
        @_monitoringWbs wbs

    _monitoring: ->
        console.log "monitoring"
        chartSelected = @_getPartnerOption()
        switch chartSelected
            when "byTime"
                Proggis.Chart.init "BarChart", (node) ->
                    key = node.name.match( /([0-9]+)/g )[0]
                    console.log "monitoring change to", key
                    Proggis.router.navigate "monitoring/wbs/#{key}/", true
                Proggis.Chart.loadChart "EffortTime", 3
            when "byPartner"
                Proggis.Chart.init "BarChart", (node) ->
                    key = node.name.match( /([0-9]+)/g )[0]
                    console.log "monitoring change to", key
                    Proggis.router.navigate "monitoring/wbs/#{key}/partner/", true
                Proggis.Chart.loadChart "EffortPartner", 2

    _monitoringWbs: (wbs) ->
        console.log "monitoringWbs", wbs
        chartSelected = @_getPartnerOption()

        switch chartSelected
            when "byTime"
                Proggis.Chart.init "BarChart", (node) ->
                    key = node.name.match( /([0-9]+)/g )[0]
                    console.log "planning change to", key
                    route = "planning/wbs/#{key}/"
                    route += "partner" if chartSelected is "isPartner"
                    Proggis.router.navigate route, true
                Proggis.Chart.loadChart "EffortTime", 4, wbs
            when "byPartner"
                Proggis.Chart.init "BarChart", (node) ->
                    key = node.name.match( /([0-9]+)/g )[0]
                    console.log "planning change to", key
                    route = "planning/wbs/#{key}/"
                    route += "partner" if chartSelected is "isPartner"
                    Proggis.router.navigate route, true
                Proggis.Chart.loadChart "EffortPartner", 3, wbs
        console.log "wbs #{wbs}"


jQuery(document).ready ->
    Proggis.router = new Proggis.RouterClass
    Proggis.router.bind "all", Proggis.Navigation.handleRouteChange
    do Backbone.history.start
    jQuery('[name=chartSelector]').change ->
        selected = jQuery('[name=chartSelector]').filter(-> jQuery(this).is(":checked")).val()
        console.log "changed to #{selected}"
        switch selected 
            when "byTime"
                Proggis.router.navigate (window.location.hash.replace "partner/", ""), true
            when "byPartner"
                Proggis.router.navigate "#{window.location.hash}partner/", true

