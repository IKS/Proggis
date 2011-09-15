(doc) ->
    return unless doc['@type'] is 'effortallocation'
    return unless doc['timeslot']
    return if doc['ignore']

    genKey = (doc) ->
        timeRegExp = new RegExp "Y(\\d)Q(\\d)"
        taskRegExp = new RegExp "http://iks-project.eu/task/(\\d+)\.(\\d+)"
        timeUnits = timeRegExp.exec doc['timeslot']
        wbs = taskRegExp.exec doc['task']
        key = [Number(timeUnits[1]), Number(timeUnits[2]), Number(wbs[1]), Number(wbs[2])]

    emit genKey(doc), doc
