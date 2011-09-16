window.Proggis = {} unless Proggis = window.Proggis
Proggis.Chart =
    areaChart: null
    data: null
    legend: (chart, element) ->
        legend = chart.getLegend()
        listItems = []
        for name of legend
            listItems.push "<span class='box-color' style='background-color:" + legend[name] + "'>&nbsp;</span>" + name
        element.html "<div>" + listItems.join("</div><div>") + "</div>"
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
                @init()
                @areaChart.loadJSON json
            else
                @areaChart.loadJSON json
                @legend @areaChart, $(".legend")
    init: (onClickHandler) ->
        document.getElementById("visualization").innerHTML = ""
        useGradients = true
        labelType = "HTML"
        @areaChart = new $jit.AreaChart
            injectInto: "visualization"
            Events: 
                enable: true
                onClick: onClickHandler

            animate: true
            Margin: 
                top: 5
                left: 5
                right: 5
                bottom: 5

            labelOffset: 10
            showAggregates: true
            showLabels: true
            type: (if useGradients then "stacked:gradient" else "stacked")
            Label: 
                type: labelType
                size: 13
                family: "Arial"
                color: "white"

            Tips:
                enable: true
                onShow: (tip, elem) ->
                    tip.innerHTML = "<b>" + elem.name + "</b>: " + elem.value
            restoreOnRightClick: true
