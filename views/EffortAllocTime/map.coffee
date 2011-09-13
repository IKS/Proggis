(doc) ->
    return unless doc['@type'] is 'effortallocation'
    return unless doc['timeslot']
    emit [doc['timeslot'], doc['task']], doc
