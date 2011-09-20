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
                , "text"
            else
                jQuery("article .data").html ""
