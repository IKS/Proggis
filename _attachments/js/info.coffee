Proggis = window.Proggis ?= {}
Proggis.Info =
    show: (route) ->
        console.log "Info routes to", route
        Proggis.description.html ""
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
                doc = {"_id":"637aecf25d75bf378ddadb83ca9bebd3","_rev":"4-e8213d8148076894f6825f710ac5ac4b","@type":"execution","start":"2011-09-21T14:59:07.891Z","state":"data_imported","workflow":"EffortControlling","end":"2011-09-21T15:00:37.740Z","_attachments":{"IKS_effortcontrolling.xlsx":{"content_type":"application/vnd.openxmlformats-officedocument.spreadsheetml.sheet","revpos":2,"length":698793,"stub":true}}}
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

