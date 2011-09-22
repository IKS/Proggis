jQuery(document).ready ->
    # Button fires showing a dialog
    jQuery('#importSpreadsheetButton').click ->
        # Getting the dialog html
        jQuery.get "dialogs/uploadSpreadsheet.html", (importForm) ->
            dialogEl = jQuery(document.createElement "div")
            dialogEl.addClass "uploadSpreadsheet"
            dialogEl.attr "title", "Upload data"
            jQuery('body').append dialogEl
            jQuery(dialogEl).html importForm
            form = jQuery "#upload", dialogEl

            jQuery('.uploadSpreadsheet').dialog
                width: 400
                close: ->
                    console.log "dialog close"
                    console.log "before", jQuery('.uploadSpreadsheet').data "dialog"
                    jQuery('.uploadSpreadsheet').dialog "destroy"
                    console.log "after", jQuery('.uploadSpreadsheet').data "dialog"
                    jQuery('.uploadSpreadsheet').remove()

            submitCallback = (form) ->
                doc = 
                    "@type": "execution"
                    start: (new Date()).toJSON()
                    state: "data_received"
                # Save plain document without attachment and workflow
                Proggis.db.saveDoc doc,
                    success: (newDoc) ->
                        $("input[name='_rev']", form).val(doc._rev);
                        # Then upload attachment
                        form.ajaxSubmit
                            url: Proggis.db.uri + $.couch.encodeDocId(doc._id)
                            success: (resp) ->
                                console.log resp
                                # Reopen after file submit
                                Proggis.db.openDoc doc._id, 
                                    success: (newDoc) ->
                                        newDoc.workflow = $('#workflowSelector').val()
                                        # Save and fire noflo
                                        Proggis.db.saveDoc newDoc, 
                                            success: (res) ->
                                                console.log "Workflow set with result", res
                                                jQuery(dialogEl).dialog "close"
                    error: (err) ->
                        console.error err
                        callback(err)
                    beforeSend: ->
                        # if ever, here we could maybe change the file name being uploaded..
                        this.data
                        console.log "beforeSend arguments:", arguments, "this:", @

            # Defining the form submit event handler
            $(form).submit (e) ->
                # Don't fire a Post request with page reload
                e.preventDefault();
                form.find("div.error").remove().end().find(".error").removeClass "error"
                data = {}
                $.each $("form :input", form).serializeArray(), (i, field) ->
                    data[field.name] = field.value;

                $("form :file", form).each -> 
                    # file inputs need special handling
                    data[this.name] = this.value

                submitCallback form
                false


