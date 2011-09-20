window.Proggis = {} unless Proggis = window.Proggis
Proggis.Info =
    show: (route) ->
        console.log "Info routes to", route
        switch route
            when "route:home"
                window.getReq = jQuery.get "_list/processTable/execDocs", (tableHtml) ->
                    jQuery("article .data")
                    .html(tableHtml)
                    jQuery("article .data tr").click ->
                        id = jQuery(@).attr "about"
                        console.log "user clicked", id
                        Proggis.Info.showDocsByExecId id
                , "text"
            else
                jQuery("article .data").html ""
    showDocsByExecId: (id) ->
        @_getDocumentsByExecution id, (docs) ->
            console.log docs
    _getDocumentsByExecution: (execId, cb) ->
        jQuery.getJSON "_view/DocumentsByExecution?startkey=[\"#{execId}\"]&endkey=[\"#{execId}a\"]", (res) ->
            cb res
