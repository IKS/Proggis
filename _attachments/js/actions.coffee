jQuery(document).ready ->
    Proggis.db = $.couch.db "default"
    jQuery('#importSpreadsheetButton').click ->
        jQuery.get "dialogs/uploadSpreadsheet.html", (importForm) ->
            dialogEl = jQuery(document.createElement "div")
            dialogEl.addClass "uploadSpreadsheet"
            dialogEl.attr "title", "Upload Spreadsheet"
            jQuery('body').append dialogEl
            jQuery(dialogEl).html importForm
            form = jQuery "#upload", dialogEl

            jQuery('.uploadSpreadsheet').dialog
                close: ->
                    console.log "dialog close"
                    console.log "before", jQuery('.uploadSpreadsheet').data "dialog"
                    jQuery('.uploadSpreadsheet').dialog "destroy"
                    console.log "after", jQuery('.uploadSpreadsheet').data "dialog"
                    jQuery('.uploadSpreadsheet').remove()

            doc = null
            submitCallback = ->
                form.ajaxSubmit
                    url: Proggis.db.uri + $.couch.encodeDocId(doc._id)
                    success: (resp) ->
                        # form.find("#progress").css("visibility", "hidden")
                        jQuery(dialogEl).dialog "close"
                    error: (err) ->
                        console.error err
                    beforeSend: ->
                        # if ever, here we could maybe change the file name being uploaded..
                        this.data
                        console.log "beforeSend arguments:", arguments, "this:", @

            $(form).submit (e) ->
                e.preventDefault();
                form.find("div.error").remove().end().find(".error").removeClass "error"
                data = {}
                $.each $("form :input", form).serializeArray(), (i, field) ->
                    data[field.name] = field.value;

                $("form :file", form).each -> 
                    # file inputs need special handling
                    data[this.name] = this.value

                doc = 
                    "@type": "execution"
                    workflow: "EffortControlling"
                    start: (new Date()).toString()
                    state: "data_received"
                Proggis.db.saveDoc doc,
                    success: (newDoc) ->
                        $("input[name='_rev']", form).val(doc._rev);
                        submitCallback data, (errors) ->
                            if $.isEmptyObject errors
                                dismiss()
                            else
                                for name in errors
                                    showError name, errors[name]
                false


