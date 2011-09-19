jQuery(document).ready ->
    jQuery('#importSpreadsheetButton').click ->
        jQuery.get "templates/uploadSpreadsheet.tmpl", (importForm) ->
            console.info importForm
            dialogEl = jQuery(document.createElement "div")
            dialogEl.addClass "uploadSpreadsheet"
            dialogEl.attr "title", "Upload Spreadsheet"
            jQuery('body').append dialogEl
            jQuery(dialogEl).html importForm
            jQuery('.uploadSpreadsheet').dialog()

