(doc) ->
  return unless doc['@type'] is 'organization'
  return if doc['ignore']
  emit doc._id, doc
