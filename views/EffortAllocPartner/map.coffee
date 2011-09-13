(doc) ->
  return unless doc['@type'] is 'effortallocation'
  emit [doc['assignee'], doc['task']], doc
