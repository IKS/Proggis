noflo = require "noflo"

class QCountToYQ extends noflo.Component
    constructor: ->
        @data = []
        @property = null
        @inPorts =
            in: new noflo.Port()
            property: new noflo.Port()
        @outPorts =
            out: new noflo.Port()

        @inPorts.in.on "data", (data) =>
            return @fixYQ data if @property
            @data.push data
        @inPorts.in.on "disconnect", =>
            return @fixYQAll() if @property and @data.length
            @outPorts.out.disconnect()

        @inPorts.property.on "data", (data) =>
            @property = data

    fixYQ: (object) ->
        return unless object[@property]

        if object[@property] % 4 is 0
            year = Math.floor object[@property] / 4
            quarter = 4
        else
            year = Math.floor object[@property] / 4 + 1
            quarter = object[@property] % 4
        
        object[@property] = "Y#{year}Q#{quarter}"
        @outPorts.out.send object

exports.getComponent = -> new QCountToYQ
