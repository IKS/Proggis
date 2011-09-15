(head, req) ->
    rows = []
    values = {}
    view = req.path.pop()
    groupLevel = req.query.group_level
    json = {}
    keyLabel = (key) ->
        key.replace ",", "."

    switch view
        when "EffortAllocTime"
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
            json.values = []
            switch groupLevel
                when "3"
                    for timeslotKey, timeslotValue of values
                        vals = []
                        json.label = []
                        for key, task of timeslotValue
                            vals.push task.value
                            json.label.push "WP #{keyLabel key}"
                        json.values.push
                            label: timeslotKey
                            values: vals
                when "4"
                    for timeslotKey, timeslotValue of values
                        vals = []
                        json.label = []
                        for key, task of timeslotValue
                            vals.push task.value
                            json.label.push "Task #{keyLabel key}"
                        json.values.push
                            label: timeslotKey
                            values: vals
    send JSON.stringify json

