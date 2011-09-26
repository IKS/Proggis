Proggis = window.Proggis ?= {}
Proggis.Chart =
    chartObject: null
    data: null
    legend: (chart, element) ->
        legend = chart.getLegend()
        listItems = []
        for name of legend
            listItems.push "<span class='box-color' style='background-color:" + legend[name] + "'>&nbsp;</span>" + name
        element.html "<div>" + listItems.join("</div><div>") + "</div>"
    legendClear: (element) ->
        element.html ""
    loadChart: (viewName, groupLevel, filterParam) ->
        uri = "_list/chart/#{viewName}?group=true"
        update = false
        uri += "&group_level=#{groupLevel}"
        if filterParam
            uri += "&task_filter=" + filterParam
            update = true
        else
        $.getJSON uri, (json, textStatus, xhr) =>
            @data = json
            if update
                # @init()
                @chartObject.loadJSON json
            else
                @chartObject.loadJSON json
            @legend @chartObject, $(".legend")
        @legendClear $(".legend")
    loadFlotChart: (viewName, groupLevel, filterParam) ->
        document.getElementById("visualization").innerHTML = ""
        uri = "_list/chart/#{viewName}?group=true"
        update = false
        uri += "&group_level=#{groupLevel}"
        if filterParam
            uri += "&task_filter=" + filterParam
            update = true
        else
        $.getJSON uri, (json, textStatus, xhr) =>
            @data = json
            options =
                lines:
                    show: true
                points:
                    show: true
                xaxis:
                    tickDecimals: 0
                    tickSize: 1
            vals = json.values
            plotOptions =
                series:
                    lines:
                        show: true
                    points:
                        show: true
                legend:
                    show: true
                    container: ".legend"
                    position: "se"
                    labelBoxBorderColor: "white"
                    textColor: "white"
                    backgroundColor: "black"
                grid:
                    color: "#888"
                    hoverable: true
                    clickable: true
                xaxis:
                    ticks: vals.xticks
                yaxis: [{
                    # max: 100
                    position: "right"
                },{
                    position: "left"
                }]
            @chartObject = $.plot jQuery("#visualization"), [
                data: vals.plan
                label: "Planned effort"
                yaxis: 1
            ,
                data: vals.spent
                yaxis: 1
                label: "Spent effort"
            ,
                data: vals.deliverablePlan
                label: "Planned Deliverables"
                yaxis: 2
            ,
                data: vals.deliverableComplete
                label: "Completed Deliverables"
                yaxis: 2
            ], plotOptions

            # Show tooltip at x, y with the given contents
            showTooltip = (x, y, contents) ->
                jQuery("<div id=\"tooltip\">" + contents + "</div>").css(
                    position: "absolute"
                    display: "none"
                    top: y + 5
                    left: x + 5
                    border: "1px solid #fdd"
                    padding: "2px"
                    "background-color": "#322"
                    opacity: 0.80
                ).appendTo("body").fadeIn 200
            previousPoint = null

            # on hover over an item show tooltip, otherwise remove it.
            jQuery("#visualization").bind "plothover", (event, pos, item) ->
                jQuery("#x").text pos.x.toFixed(2)
                jQuery("#y").text pos.y.toFixed(2)
                if item
                    unless previousPoint == item.dataIndex
                        previousPoint = item.dataIndex
                        jQuery("#tooltip").remove()
                        x = item.datapoint[0].toFixed(2)
                        y = item.datapoint[1].toFixed(2)
                        xLabel = if item.series.xaxis.ticks then item.series.xaxis.ticks[Number(x)].label else x
                        showTooltip item.pageX, item.pageY, item.series.label + " of " + xLabel + " = " + y
                else
                    $("#tooltip").remove()
                    previousPoint = null

    init: (chartType, onClickHandler) ->
        document.getElementById("visualization").innerHTML = ""
        config =
            injectInto: "visualization"
            Events: 
                enable: true
                onClick: onClickHandler

            animate: true
            Margin: 
                top: 5
                left: 5
                right: 5
                bottom: 20

            showAggregates: true
            showLabels: true
            type: "stacked:gradient"
            Label: 
                type: "HTML"
                size: 13
                family: "Arial"
                color: "white"
            Tips:
                enable: true
                onShow: (tip, elem) ->
                    tip.innerHTML = "<b>" + elem.name + "</b>: " + elem.value
            restoreOnRightClick: true
        switch chartType
            when "AreaChart"
                config.labelOffset = 10
                @chartObject = new $jit.AreaChart config
            when "BarChart"
                config.labelOffset = 5
                config.orientation = 'vertical'
                @chartObject = new $jit.BarChart config
            when "LineChart"
                @options =
                    lines:
                        show: true
                    points:
                        show: true
                    xaxis:
                        tickDecimals: 0
                        tickSize: 1
                @chartObject = $.plot

