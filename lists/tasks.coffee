(head, req) ->
    rows = []
    values = {}
    while row = getRow()
        keyTimeslot = ["Y#{row.key.shift()}Q#{row.key.shift()}"]
        keyTask = row.key
        key = [keyTimeslot, keyTask]
        o = values
        for i, keyEl of key
            o[keyEl] = {} unless o[keyEl] instanceof Object
            o=o[keyEl]
        o.value = 0 unless o.value
        o.value += Number(row.value)
    json =
        # labels: ("WP#{n}" in n of [1..10]) 
        # TODO make it nicer
        values: []
    for timeslotKey, timeslotValue of values
        vals = []
        for key, task of timeslotValue
            vals.push task.value
        json.values.push
            label: timeslotKey
            values: vals
    send JSON.stringify json

