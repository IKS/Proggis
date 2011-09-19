jQuery(document).ready ->
    jQuery('#importSpreadsheetButton').click ->
        jQuery.get "templates/uploadSpreadsheet.tmpl", (importForm) ->
            console.info importForm
            dialogEl = document.createElement "div"
            dialogEl.addClass "uploadSpreadsheet"
            jQuery('body').append dialogEl
            jQuery(dialogEl).html importForm
            jQuery

