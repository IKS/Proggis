window.Proggis = {} unless Proggis = window.Proggis
Proggis.Navigation =
    getIds: (callback) ->
        ids = []
        jQuery("header nav ol li a").each ->
            return unless jQuery(this).attr "id"
            ids.push jQuery(this).attr "id"
        callback ids

    handleRouteChange: (route) ->
        nav = Proggis.Navigation
        jQuery("header nav ol li a").removeClass "active"
        nav.getIds (ids) ->
            for id in ids
                continue if route.indexOf(id) is -1
                jQuery("#" + id).addClass "active"
