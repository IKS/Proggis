(doc, req) ->
    return false unless req.query.type
    return false unless doc['@type'] is req.query.type

    if req.query.state
        return false unless doc['state'] is req.query.state

    if req.query.workflow
        return false unless doc['workflow'] is req.query.workflow

    return true
