Proggis = window.Proggis ?= {}
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

        "execution/:execId/": "execution"

    home: ->
        Proggis.viewName.html "IKS Project controlling Dashboard"
        Proggis.graph.hide()
        Proggis.Chart.init "AreaChart", (node) ->
        Proggis.Chart.legendClear $(".legend")

    # ######### Planning Routes ################################################
    planning: ->
        Proggis.viewName.html "Project plan over time"
        Proggis.graph.show()
        @_setPartnerOption "Time"
        do @_planning
    planningPartner: ->
        Proggis.viewName.html "Project plan over partners"
        Proggis.graph.show()
        @_setPartnerOption "Partner"
        do @_planning
    planningWbs: (wbs) ->
        Proggis.viewName.html "Project plan over time for WP #{wbs}"
        Proggis.graph.show()
        @_setPartnerOption "Time"
        @_planningWbs wbs
    planningWbsPartner: (wbs) ->
        Proggis.viewName.html "Project plan over partners for WP #{wbs}"
        Proggis.graph.show()
        @_setPartnerOption "Partner"
        @_planningWbs wbs

    # Show Planning data without zooming
    _planning: ->
        console.log "planning"
        chartSelected = @_getPartnerOption()
        switch chartSelected
            when "byTime"
                Proggis.Chart.init "AreaChart", (node) ->
                    return unless node
                    key = node.name.match( /([0-9]+)/g )[0]
                    console.log "planning change to", key
                    Proggis.router.navigate "planning/wbs/#{key}/", true
                Proggis.Chart.loadChart "EffortAllocTime", 3
            when "byPartner"
                Proggis.Chart.init "BarChart", (node) ->
                    return unless node
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
                    return unless node
                    key = node.name.match( /([0-9]+)/g )[0]
                    console.log "planning change to", key
                    route = "planning/wbs/#{key}/"
                    route += "partner" if chartSelected is "isPartner"
                    Proggis.router.navigate route, true
                Proggis.Chart.loadChart "EffortAllocTime", 4, wbs
            when "byPartner"
                Proggis.Chart.init "BarChart", (node) ->
                    return unless node
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
        Proggis.viewName.html "Project monitoring over time"
        Proggis.graph.show()
        @_setPartnerOption "Time"
        do @_monitoring
    monitoringPartner: ->
        Proggis.viewName.html "Project monitoring over partners"
        Proggis.graph.show()
        @_setPartnerOption "Partner"
        do @_monitoring
    monitoringWbs: (wbs) ->
        Proggis.viewName.html "Project monitoring over time for WP #{wbs}"
        Proggis.graph.show()
        @_setPartnerOption "Time"
        @_monitoringWbs wbs
    monitoringWbsPartner: (wbs) ->
        Proggis.viewName.html "Project monitoring over partners for WP #{wbs}"
        Proggis.graph.show()
        @_setPartnerOption "Partner"
        @_monitoringWbs wbs

    _monitoring: ->
        console.log "monitoring"
        chartSelected = @_getPartnerOption()
        switch chartSelected
            when "byTime"
                Proggis.Chart.init "BarChart", (node) ->
                    return unless node
                    key = node.name.match( /([0-9]+)/g )[0]
                    console.log "monitoring change to", key
                    Proggis.router.navigate "monitoring/wbs/#{key}/", true
                Proggis.Chart.loadChart "EffortTime", 3
            when "byPartner"
                Proggis.Chart.init "BarChart", (node) ->
                    return unless node
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
                    return unless node
                    key = node.name.match( /([0-9]+)/g )[0]
                    console.log "monitoring change to", key
                    route = "monitoring/wbs/#{key}/"
                    route += "partner" if chartSelected is "isPartner"
                    Proggis.router.navigate route, true
                Proggis.Chart.loadChart "EffortTime", 4, wbs
            when "byPartner"
                Proggis.Chart.init "BarChart", (node) ->
                    return unless node
                    key = node.name.match( /([0-9]+)/g )[0]
                    console.log "monitoring change to", key
                    route = "monitoring/wbs/#{key}/"
                    route += "partner" if chartSelected is "isPartner"
                    Proggis.router.navigate route, true
                Proggis.Chart.loadChart "EffortPartner", 3, wbs
        console.log "wbs #{wbs}"

    # ########## Execution Document#############################################
    execution: (execId) ->
        Proggis.Info.showDocsByExecId execId

jQuery(document).ready ->
    # Router initialization
    Proggis.router = new Proggis.RouterClass
    Proggis.router.bind "all", Proggis.Navigation.handleRouteChange
    Proggis.router.bind "all", Proggis.Info.show
    Proggis.router.bind "all", Proggis.showEditableDescription
    do Backbone.history.start
    # Initialize the chartselector option
    jQuery('[name=chartSelector]').change ->
        selected = jQuery('[name=chartSelector]').filter(-> jQuery(this).is(":checked")).val()
        console.log "changed to #{selected}"
        switch selected 
            when "byTime"
                Proggis.router.navigate (window.location.hash.replace "partner/", ""), true
            when "byPartner"
                Proggis.router.navigate "#{window.location.hash}partner/", true

