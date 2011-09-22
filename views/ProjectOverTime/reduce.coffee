(keys, values, rereduce) ->
    data =
        planned: 0.0
        spent: 0.0
        left: 0.0
        deliverables: 0
        completed: 0
        pending: 0

    if rereduce
        for reducedData in values
            data.planned += reducedData.planned
            data.spent += reducedData.spent
            data.deliverables += reducedData.deliverables
            data.completed += reducedData.completed
        data.left = data.planned - data.spent
        data.pending = data.deliverables - data.completed
        return data

    for doc in values
        if doc['@type'] is 'effortallocation'
            data.planned += parseFloat doc.value
        if doc['@type'] is 'effort'
            data.spent += parseFloat doc.value
        if doc['@type'] is 'deliverable'
            data.deliverables++
            data.completed++ if doc['completed']
    data.left = data.planned - data.spent
    data.pending = data.deliverables - data.completed
    return data
