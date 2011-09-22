(doc) ->
    return unless doc['@type'] is 'effortallocation' or doc['@type'] is 'effort' or doc['@type'] is 'deliverable'
    return if doc['ignore']

    if doc['@type'] is 'deliverable'
        return unless doc['milestone']
    if doc['@type'] is 'effortallocation' or doc['@type'] is 'effort'
        return unless doc['timeslot']

    genKeyDeliverable = (doc) ->
        # We need to map a Mxx month number to year and quarter
        monthRegExp = new RegExp('M(\\d+)');
        monthParts = monthRegExp.exec doc['milestone']
        monthNumber = parseInt monthParts[1]
        year = Math.floor monthNumber / 12
        quarter = Math.ceil (monthNumber - year * 12) / 3
        year++ unless year is 4
        quarter = 4 if quarter is 0

        deliverableRegExp = new RegExp "http://iks-project.eu/deliverable/(\\d+)\.(\\d+)\.(\\d*)"
        wbs = deliverableRegExp.exec doc['_id']

        key = [year, quarter, Number(wbs[1]), Number(wbs[2]), Number(wbs[3])]

    genKey = (doc) ->
        return genKeyDeliverable doc if doc['@type'] is 'deliverable'

        timeRegExp = new RegExp "Y(\\d)Q(\\d)"
        taskRegExp = new RegExp "http://iks-project.eu/task/(\\d+)\.(\\d+)"
        timeUnits = timeRegExp.exec doc['timeslot']
        wbs = taskRegExp.exec doc['task']
        key = [Number(timeUnits[1]), Number(timeUnits[2]), Number(wbs[1]), Number(wbs[2])]

    emit genKey(doc), doc
