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
                bottom: 5

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

