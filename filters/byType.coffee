(doc, req) ->
    return false unless req.query.type
    return false unless doc['@type'] is req.query.type

    if req.query.state
        return false unless doc['state'] is req.query.state

    return true
