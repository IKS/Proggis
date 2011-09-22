Proggis = window.Proggis ?= {}
Proggis.db = $.couch.db "default"

Proggis.showEditableDescription = (route) ->
    switch route
        when "route:execution"
            console.log "no editable description for", route
        when "route:home"
            Proggis.description.attr "route", route
            Proggis.description.html "Interactive Knowledge Stack (IKS) is an open source community, whose projects are focused on building an open and flexible technology platform for semantically enhanced Content Management Systems (CMS)."
        else
            Proggis.description.attr "route", route
            Proggis.description.html "The default editable text..."

jQuery(document).ready ->
# Defining parts of the view.
    Proggis.viewName = jQuery "#viewName"
    Proggis.graph = jQuery '.graph'
    Proggis.description = jQuery ".info.description"

    # Set up the spinner
    $('#loadingSpinner')
    # hide it initially
    .hide()
    .ajaxStart ->
        $( @ ).show()
    .ajaxStop ->
        $( @ ).hide()

    # Make description editable
    Proggis.description.hallo
        plugins:
            halloformat: {}
        modified: ->
            console.log "description edited", @

    Proggis.scrollTo = (selector) ->
        obj = jQuery(selector)[0]
        curtop = obj.offsetTop
        while obj = obj.offsetParent
            curtop += obj.offsetTop
        window.scrollTo 0, curtop

