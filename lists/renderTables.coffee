(head, req) ->
    types =
        tables: [ 
            "organization"
            "task"
            "timeslot"
            "effortallocation"
        ]
        effortallocation:
            label: "Effort allocation documents"
            about: "_id"
            fields: [
                key: "task"
                label: "Task"
            ,
                key: "assignee"
                label: "Assignee"
            ,
                key: "timeslot"
                label: "Timeslot"
            ,
                key: "value"
                label: "Effort allocated"
            ]
        organization:
            label: "Organizations"
            about: "_id"
            fields: [
                key: "foaf:name"
                label: "Name"
            ,
                key: "foaf:country"
                label: "Country"
            ]
        task:
            label: "Tasks"
            about: "_id"
            fields: [
                key: "name"
                label: "Task name"
            ,
                key: "_id"
                label: "uri"
            ]
        timeslot:
            label: "Time slots"
            about: "_id"
            fields: [
                key: "name"
                label: "Name"
            ]

    # Put the instances to their types
    while row = getRow()
        entity = row.value
        type = entity["@type"]
        if Object.keys(types).indexOf(type) is -1
            send "<h3>ignoring a #{type}</h3>"
            send JSON.stringify entity
        continue unless Object.keys(types).indexOf(type) isnt -1
        types[type].instances ?= []
        types[type].instances.push entity

    # Draw tables, one for each type
    for tableName in types.tables
        typeObj = types[tableName]
        return unless typeObj.instances.length
        send "<h1>#{typeObj.label}</h1>"
        send "<table><thead><tr>"
        for field in typeObj.fields
            send "<th>#{field.label}</th>"
        send "</tr></thead><tbody>"
        for instance in typeObj.instances
            send "<tr about='#{instance[typeObj.about]}'>"
            for field in typeObj.fields
                send "<td>#{instance[field.key] or ''}</td>"
            send "</tr>"
            send "\n<!-- #{JSON.stringify instance}-->"
        send "</tbody></table>"
    return

