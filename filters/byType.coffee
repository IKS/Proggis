(doc, req) ->
    return false unless req.query.type
    return false unless doc['@type'] is req.query.type
    return true
