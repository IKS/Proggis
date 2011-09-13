(doc) ->
    return unless doc['@type'] is 'effortallocation'
    return unless doc['assignee']
    emit [doc['assignee'], doc['task']], doc
