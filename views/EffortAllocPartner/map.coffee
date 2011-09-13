(doc) ->
    return unless doc['@type'] is 'effortallocation'
    return unless doc['assignee']
    return if doc['ignore']

    emit [doc['assignee'], doc['task']], doc
