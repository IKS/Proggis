(doc) ->
    return unless doc['@type'] is 'deliverable'
    return if doc['ignore']

    genKey = (doc) ->
        deliverableRegExp = new RegExp "http://iks-project.eu/deliverable/(\\d+)\.(\\d+)\.(\\d*)"
        wbs = deliverableRegExp.exec doc['_id']
        key = [Number(wbs[1]), Number(wbs[2]), Number(wbs[3])]

    emit genKey(doc), doc
