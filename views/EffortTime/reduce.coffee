(keys, values, rereduce) ->
    roundNumber = (rnum, rlength) ->
        Math.round(parseFloat(rnum) * Math.pow(10, rlength)) / Math.pow(10, rlength)
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
            data.planned += roundNumber doc.value, 1
        if doc['@type'] is 'effort'
            data.spent += roundNumber doc.value, 1
    data.left = roundNumber data.planned - data.spent, 1
    return data
