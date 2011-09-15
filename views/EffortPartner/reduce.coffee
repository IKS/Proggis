(keys, values, rereduce) ->
    data =
        planned: 0.0
        spent: 0.0
        left: 0.0

    if rereduce
        for reducedData in values
            data.planned += reducedData.planned
            data.spent += reducedData.spent
        data.left = data.planned - data.spent
        return data

    for doc in values
        if doc['@type'] is 'effortallocation'
            data.planned += parseFloat doc.value
        if doc['@type'] is 'effort'
            data.spent += parseFloat doc.value
    data.left = data.planned - data.spent
    return data
