(doc) ->
    return unless doc['source']
    return unless doc['@type']
    return if doc['@type'] is 'execution'
    return if doc['ignore']

    emit [doc['source'], doc['@type']], doc
