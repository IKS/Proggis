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
#    send JSON.stringify values
    json =
        label: ("WP#{n}" for n in [1..10])
        # TODO make it nicer
        values: []
    for timeslotKey, timeslotValue of values
        vals = []
#        send "#{JSON.stringify(Object.keys(timeslotValue))}\n\n"
        for key, task of timeslotValue
            vals.push task.value
        json.values.push
            label: timeslotKey
            values: vals
    send JSON.stringify json

