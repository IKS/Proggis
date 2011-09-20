(doc) ->
    return unless doc['@type'] is 'execution'
    emit [doc.workflow, doc.state, doc["_id"]], doc
