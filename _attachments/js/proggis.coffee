Proggis = window.Proggis ?= {}

jQuery(document).ready ->
# Defining parts of the view.
    Proggis.viewName = jQuery "#viewName"
    Proggis.graph = jQuery '.graph'
    $('#loadingSpinner')
    .hide()  # hide it initially
    .ajaxStart ->
        $( @ ).show()
    .ajaxStop ->
        $( @ ).hide()

