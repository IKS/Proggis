(head, req) ->
    view = req.path.pop()
    groupLevel = req.query.group_level
    taskFilter = Number req.query.task_filter

    # We fill this structure for a stacked Jit Chart
    # `values` is an array of columns `{label:` column label, `values:` numbers in the column`}`
    # these columns are shown stacked on the chart.
    # `label` is an array of row labels
    chart = {values: [], label: []}

    switch view
        # ######################################################################
        when "EffortAllocTime"
            switch groupLevel
                when "3"
                    labelPrefix = "WP"
                when "4"
                    labelPrefix = "Task"
            tree = {}
            while row = getRow()
                # row.key has two parts. The first and second are Year and Quarter 
                # (or month at one point). 
                keyTimeslot = ["Y#{row.key.shift()}Q#{row.key.shift()}"]
                # The rest is WBS, the work breakdown structure.
                keyWbs = row.key
                if taskFilter and keyWbs[0] is taskFilter or not taskFilter
                    # the treeAddress consists of the timeslot (e.g. "Y2Q4") 
                    # and the keyWbs (e.g. "2.3")
                    treeAddress = [keyTimeslot, keyWbs]
                    # Iterate on the tree to find the right place for the row.
                    # row.key
                    leaf = tree
                    for i, keyEl of treeAddress
                        leaf[keyEl] = {} unless leaf[keyEl] instanceof Object
                        leaf = leaf[keyEl]
                    leaf.value = 0 unless leaf.value
                    leaf.value += Number(row.value)

            # Make dotted label-notation out of the comma-separated one
            wbsLabel = (key) ->
                "#{labelPrefix} #{key.replace ",", "."}"

            # iterate through the tree
            # First is the timeslots
            for timeslotKey, timeslotValue of tree
                # A column object has the label of the timeslot
                column =
                    label: timeslotKey
                    values: []
                chart.values.push column

                for wbs, task of timeslotValue
                    # column.values are the actual numbers in a column.
                    column.values.push task.value

                # stacked labels in `chart.label` consist of wbs labels 
                # (e.g. "WP 3" or "Task 2.4")
                chart.label = []
                for wbs, task of timeslotValue
                    chart.label.push wbsLabel wbs

        # ######################################################################
        when "EffortPartner"
            switch groupLevel
                when "2"
                    labelPrefix = "WP"
                when "3"
                    labelPrefix = "Task"

            tree = {}
            while row = getRow()
                # row.key has two parts. The first and second are Year and Quarter 
                # (or month at one point). 
                keyPartner = row.key.shift()
                # The rest is WBS, the work breakdown structure.
                keyWbs = row.key
                if taskFilter and keyWbs[0] is taskFilter or not taskFilter
                    # the treeAddress consists of the timeslot (e.g. "Y2Q4") 
                    # and the keyWbs (e.g. "2.3")
                    treeAddress = [keyPartner, keyWbs]
                    # Iterate on the tree to find the right place for the row.
                    # row.key
                    leaf = tree
                    for i, keyEl of treeAddress
                        leaf[keyEl] = {} unless leaf[keyEl] instanceof Object
                        leaf = leaf[keyEl]
                    leaf.value = row.value
            # send JSON.stringify tree

            # Make dotted label-notation out of the comma-separated one
            wbsLabel = (key) ->
                "#{labelPrefix} #{key.replace ",", "."}"

            # iterate through the tree
            # First is the partners
            for partnerKey, partnerValue of tree
                # A column object has the label of the timeslot
                column =
                    label: partnerKey
                    values: []
                chart.values.push column

                for wbs, task of partnerValue
                    # column.values are the actual numbers in a column.
                    column.values.push task.value.planned

                # stacked labels in `chart.label` consist of wbs labels 
                # (e.g. "WP 3" or "Task 2.4")
                chart.label = []
                for wbs, task of partnerValue
                    chart.label.push wbsLabel wbs

    # Send the actual chart object to the client.
    send JSON.stringify chart

