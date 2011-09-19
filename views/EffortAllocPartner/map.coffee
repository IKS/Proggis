(doc) ->
    return unless doc['@type'] is 'effortallocation'
    return unless doc['assignee']
    return if doc['ignore']

    genKey = (doc) ->
        taskRegExp = new RegExp "http://iks-project.eu/task/(\\d+)\.(\\d+)"
        wbs = taskRegExp.exec doc['task']
        key = [doc['assignee'], Number(wbs[1]), Number(wbs[2])]

    emit genKey(doc), doc
