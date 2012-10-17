Proggis = window.Proggis ?= {}
Proggis.Info =
  init: ->
    Proggis.router.on 'route:deliverableDoc', (doc) =>
      debugger
      console.info 'deliverablesDoc', doc#
    Proggis.router.on "route:home", =>
      jQuery.get "_list/tables/execDocs", (tableHtml) ->
        jQuery("article .data")
          .html(tableHtml)
        jQuery('.data table td.date').each ->
          jQuery( @ ).attr 'title', jQuery( @ ).text()
          jQuery( @ ).prettyDate()
        jQuery("article .data tr").click ->
          id = jQuery(@).attr "about"
          Proggis.router.navigate "execution/#{id}/", true
      , "text"
    Proggis.router.on "route:deliverables", =>
      jqXhr = jQuery.get "_list/tables/deliverablesByWbs", (tableHtml) =>
        jQuery("article .data")
          .html(tableHtml)
        jQuery('.data table td.date').each ->
          jQuery( @ ).attr 'title', jQuery( @ ).text()
          jQuery( @ ).prettyDate()
        jQuery('.deliverable tr[about]').each ->
          jQuery(@).click ->
            id = jQuery(@).attr 'about'
            wbs = _(id.split('/')).last()
            Proggis.router.navigate "deliverables/d/#{wbs}/", true
        jQuery("article .data table").first()
        .dataTable
          bSort: true
          bPaginate: false
      , "text"
    Proggis.router.on "route:deliverablesTime", (time) =>
      console.info 'deliverablesTime', time
      startTimeslot = time.split('.')
      endTimeslot = _.clone startTimeslot
      endTimeslot[endTimeslot.length-1]++
      url = "_list/tables/deliverablesByTime?startkey=[#{startTimeslot.join ','}]&endkey=[#{endTimeslot.join ','}]"
      jqXhr = jQuery.get url, (tableHtml) =>
        jQuery("article .data")
          .html(tableHtml)
          .find('table').first().dataTables()
        jQuery('.data table td.date').each ->
          jQuery( @ ).attr 'title', jQuery( @ ).text()
          jQuery( @ ).prettyDate()
        jQuery('.deliverable tr[about]').each ->
          jQuery(@).click ->
            id = jQuery(@).attr 'about'
            wbs = _(id.split('/')).last()
            Proggis.router.navigate "deliverables/d/#{wbs}/", true
        jQuery("article .data table").first()
          .dataTable
            bSort: true
            bPaginate: false

      , "text"

    Proggis.router.on 'all', =>
      jQuery("article .data").html ""
  showDocsByExecId: (execId) ->
    Proggis.db.openDoc execId,
      success: (doc) ->
        tmpl = """
                            <div>
                                <p>The execution of the workflow <b>${workflow}</b> begun <b class="date">${start}</b>
                                and ended <b class="date">${start}</b>. The current state is <b>"${state}"</b>.</p>
                                <p>The imported data objects were the following:</p>
                                <button id="accept">Accept</button>
                                <button id="decline">Decline</button>
                            <div>
                        """
        Proggis.description.html ""
        jQuery(tmpl).tmpl(doc).appendTo Proggis.description
        jQuery(".date", Proggis.description).prettyDate()
        jQuery("button", Proggis.description).button()
        jQuery("#accept").click (e) ->
          # TODO change exec doc workflow state
          console.log "accepted"
        jQuery("#decline").click (e) ->
          console.log "declined"

    Proggis.viewName.html "Execution document"
    jQuery.get "_list/tables/DocumentsByExecution?startkey=[\"#{execId}\"]&endkey=[\"#{execId}a\"]", (tablesHtml) ->
      jQuery('.graph').hide()
      if tablesHtml.length
        jQuery("article .data").html tablesHtml
      else
        jQuery("article .data").html "<h1>No documents in the list</h1>"
    , "text"

  showDeliverables: ->

