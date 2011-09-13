(doc) ->
    return unless doc['@type'] is 'effortallocation'
    return unless doc['timeslot']
    return if doc['ignore']

    emit [doc['timeslot'], doc['task']], doc
