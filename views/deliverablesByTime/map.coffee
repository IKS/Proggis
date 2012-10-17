(doc) ->
  return unless doc['@type'] is 'deliverable'
  return if doc['ignore']

  genKeyDeliverable = (doc) ->
    # We need to map a Mxx month number to year and quarter
    monthRegExp = new RegExp('M(\\d+)');
    monthParts = monthRegExp.exec doc['milestone']
    monthNumber = parseInt monthParts[1]
    year = Math.floor monthNumber / 12
    quarter = Math.ceil (monthNumber - year * 12) / 3
    year++ unless year is 4
    quarter = 4 if quarter is 0

    deliverableRegExp = new RegExp "http://iks-project.eu/deliverable/(\\d+)\.(\\d+)\.(\\d*)"
    wbs = deliverableRegExp.exec doc['_id']
    key = [year, quarter, Number(wbs[1]), Number(wbs[2]), Number(wbs[3])]


  emit genKeyDeliverable(doc), doc
