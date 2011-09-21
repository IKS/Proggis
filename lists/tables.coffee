(head, req) ->
# Rendering a view as tables for each document @type
    types =
        # List and order of the defined tables. An element here has to show on 
        # a table definition
        tables: [
            "organization"
            "task"
            "timeslot"
            "effortallocation"
            "effort"
            "execution"
        ]

        # Table definitions
        effortallocation:
            label: "Effort allocation documents"
            # The about tag is on each <tr> tag
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
                label: "Effort allocated (PM)"
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
        execution:
            label: "Execution documents"
            about: "_id"
            fields: [
                key: "workflow"
                label: "Workflow"
            ,
                key: "state"
                label: "State"
            ,
                key: "start"
                label: "Start"
                styleClass: "date"
            ,
                key: "end"
                label: "End"
                styleClass: "date"
            ]
        effort:
            label: "Spent efforts"
            about: "_id"
            fields: [
                key: "timeslot"
                label: "Time slot"
            ,
                key: "assignee"
                label: "Assignee"
            ,
                key: "value"
                label: "Amount (PM)"
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
        continue unless typeObj.instances
        send "<h1>#{typeObj.label}</h1>"
        send "<table><thead><tr>"
        for field in typeObj.fields
            send "<th>#{field.label}</th>"
        send "</tr></thead><tbody>"
        for instance in typeObj.instances
            send "<tr about='#{instance[typeObj.about]}'>"
            for field in typeObj.fields
                styleClass = ""
                styleClass = "class='#{field.styleClass}'" if field.styleClass
                send "<td #{styleClass}>#{instance[field.key] or ''}</td>"
            send "</tr>"
            send "\n<!-- #{JSON.stringify instance}-->"
        send "</tbody></table>"
    return

