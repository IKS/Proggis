(head, req) ->
    view = req.path.pop()
    groupLevel = req.query.group_level
    taskFilter = Number req.query.task_filter

    roundNumber = (rnum, rlength) ->
        Math.round(parseFloat(rnum) * Math.pow(10, rlength)) / Math.pow(10, rlength)

    # We fill this structure for a stacked Jit Chart
    # `values` is an array of columns `{label:` column label, `values:` numbers in the column`}`
    # these columns are shown stacked on the chart.
    # `label` is an array of row labels
    chart = {}

    switch view
        # ######################################################################
        # used for planned effort over time
        when "EffortAllocTime"
            chart = {values: [], label: []}
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
        # used for planned effort by partner
        when "EffortAllocPartner"
            chart = {values: [], label: []}
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
                    column.values.push task.value

                # stacked labels in `chart.label` consist of wbs labels 
                # (e.g. "WP 3" or "Task 2.4")
                chart.label = []
                for wbs, task of partnerValue
                    chart.label.push wbsLabel wbs

        # ######################################################################
        # used for monitoring effort over time
        when "EffortTime"
            chart = {values: [], label: []}
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
                    leaf.value = row.value

            # Make dotted label-notation out of the comma-separated one
            wbsLabel = (key) ->
                "#{labelPrefix} #{key.replace ",", "."}"

            # iterate through the tree
            # First is the timeslots
            for timeslotKey, timeslotValue of tree
                # A column object has the label of the timeslot
                columnPlan =
                    label: "#{timeslotKey} planned"
                    values: []
                chart.values.push columnPlan

                columnSpent =
                    label: "#{timeslotKey} spent"
                    values: []
                chart.values.push columnSpent

                for wbs, task of timeslotValue
                    # column.values are the actual numbers in a column.
                    columnPlan.values.push task.value.planned
                    columnSpent.values.push roundNumber task.value.spent, 1

                # stacked labels in `chart.label` consist of wbs labels 
                # (e.g. "WP 3" or "Task 2.4")
                chart.label = []
                for wbs, task of timeslotValue
                    chart.label.push wbsLabel wbs

        # ######################################################################
        # used for monitoring plan and spent efforts on the partners
        when "EffortPartner"
            chart = {values: [], label: []}
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
                columnPlan =
                    # column label
                    label: "#{partnerKey} planned"
                    values: []
                chart.values.push columnPlan

                columnSpent =
                    # column label
                    label: "#{partnerKey} spent"
                    values: []
                chart.values.push columnSpent

                for wbs, task of partnerValue
                    # column.values are the actual numbers in a column.
                    columnPlan.values.push task.value.planned
                    columnSpent.values.push roundNumber task.value.spent, 1

                # stacked (row) labels in `chart.label` consist of wbs labels 
                # (e.g. "WP 3" or "Task 2.4")
                chart.label = []
                for wbs, task of partnerValue
                    chart.label.push wbsLabel wbs

        # ######################################################################
        # used for showing the project performance over the whole period of the 
        # project.
        # The JSON format follows the flot.js plotter data format with 
        # data = [[x1, y1],[x2,y2]..] instead of just [y1, y2, ...] as it is 
        # needed for Jit charts.
        when "ProjectOverTime"
            chart = {values: []}
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
                    leaf.value = row.value

            # Make dotted label-notation out of the comma-separated one
            wbsLabel = (key) ->
                "#{labelPrefix} #{key.replace ",", "."}"

            chart.values =
                xticks: [[0, " "]]
                plan: [[0,0]]
                spent: [[0,0]]
                deliverablePlan: [[0,0]]
                deliverableComplete: [[0,0]]
            i = 0
            # iterate through the tree
            # First is the timeslots
            for timeslotKey, timeslotValue of tree
                i++
                chart.values.xticks.push [i, timeslotKey]
                plan = [i, 0]
                chart.values.plan.push plan

                spent = [i, 0]
                chart.values.spent.push spent

                deliverablePlan = [i, 0]
                chart.values.deliverablePlan.push deliverablePlan

                deliverableComplete = [i, 0]
                chart.values.deliverableComplete.push deliverableComplete

                for wbs, task of timeslotValue
                    # column.values are the actual numbers in a column.
                    plan[1] += task.value.planned
                    spent[1] += roundNumber task.value.spent, 1
                    deliverablePlan[1] += task.value.deliverables
                    deliverableComplete[1] += task.value.completed

                # stacked labels in `chart.label` consist of wbs labels 
                # (e.g. "WP 3" or "Task 2.4")
#                chart.label = []
#                for wbs, task of timeslotValue
#                    chart.label.push wbsLabel wbs
            getSum = (array) ->
                sum = 0
                for valArr in array
                    sum += valArr[1]
                sum
            accumulate = (array, sum) ->
                acc = []
                reached = 0
                for valArr in array
                    reached += valArr[1]
                    acc.push [valArr[0], reached] if valArr[1] or not acc.length
                acc

            chart.values.plan = accumulate chart.values.plan, getSum chart.values.plan
            chart.values.spent = accumulate chart.values.spent, getSum chart.values.plan
            chart.values.deliverablePlan = 
                accumulate chart.values.deliverablePlan, getSum chart.values.deliverablePlan
            chart.values.deliverableComplete = 
                accumulate chart.values.deliverableComplete, getSum chart.values.deliverablePlan


    # Send the actual chart object to the client.
    send JSON.stringify chart

