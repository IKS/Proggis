(head, req) ->
    send "<table><thead>"
    send "<tr>"
    send "<th>Workflow</th>"
    send "<th>State</th>"
    send "<th>Start</th>"
    send "<th>End</th>"
    send "</thead></tr><tbody>"
    while row = getRow()
        send "<tr about='#{row.value._id}'>"
        send "<td>#{row.value.workflow}</td>"
        send "<td>#{row.value.state}</td>"
        send "<td>#{row.value.start}</td>"
        send "<td>#{row.value.end}</td>"
        send "</tr>"
    send "</tbody></table>"

