Proggis = window.Proggis ?= {}
Proggis.Info =
    show: (route) ->
        console.log "Info routes to", route
        switch route
            when "route:home"
                jQuery.get "_list/tables/execDocs", (tableHtml) ->
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
        Proggis.db.openDoc execId, 
            success: (doc) ->
                tmpl = """
                    <div>
                        <p>The execution of the workflow <b>${workflow}</b> begun <b class="date">${start}</b>
                        and ended <b class="date">${start}</b>. The current state is <b>"${state}"</b>.</p>
                        <p>The imported data objects were the following:</p>
                    <div>
                """
                Proggis.description.html ""
                jQuery(tmpl).tmpl(doc).appendTo Proggis.description
                jQuery(".date", Proggis.description).prettyDate()
                console.log doc
        Proggis.viewName.html "Execution document"
        jQuery.get "_list/tables/DocumentsByExecution?startkey=[\"#{execId}\"]&endkey=[\"#{execId}a\"]", (tablesHtml) ->
            jQuery('.graph').hide()
            if tablesHtml.length
                jQuery("article .data").html tablesHtml
            else
                jQuery("article .data").html "<h1>No documents in the list</h1>"
        , "text"

