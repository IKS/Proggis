Proggis = window.Proggis ?= {}
Proggis.Info =
    show: (route) ->
        console.log "Info routes to", route
        switch route
            when "route:home"
                jQuery.get "_list/processTable/execDocs", (tableHtml) ->
                    jQuery("article .data")
                    .html(tableHtml)
                    jQuery('.data table td.date').each ->
                        jQuery( @ ).attr 'title', jQuery( @ ).text()
                        jQuery( @ ).prettyDate()
                    jQuery("article .data tr").click ->
                        id = jQuery(@).attr "about"
                        console.log "user clicked", id
                        Proggis.router.navigate "execution/#{id}/", true
                , "text"
            else
                jQuery("article .data").html ""
    showDocsByExecId: (execId) ->
        jQuery.getJSON "_view/DocumentsByExecution?startkey=[\"#{execId}\"]&endkey=[\"#{execId}a\"]", (docs) ->
            jQuery('.graph').hide()
            jQuery("article .data").html JSON.stringify docs
            console.log docs

