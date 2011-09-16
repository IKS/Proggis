(doc, req) ->
    return false unless req.query.type
    return false unless doc['@type'] is req.query.type

    if req.query.state
        return false unless doc['state'] is req.query.state

    if req.query.attachment
        return false unless doc['_attachments']
        return false unless doc['_attachments'][req.query.attachment]

    return true
