# fs = require "fs"
# _  = require 'underscore'

class Project
  constructor: ->
    @prefix = 'http://iks-project.eu'
    @transactionID = 'asdfqwerDFHG2345'
    @clear()

  clear: ->
    @project = undefined
    @effortunit = '' # PM
    @projectstart = '' # 01-01-2009
    @timeunit = '' # quarters
    @projectduration = '' #16

    @timeslots = []
    @partners = []
    @tasks = []
    @taskpartnereffortallocations = []
    @tasktimeeffortallocations = []
    @spentefforttaskpartnertime = []
    @deliverables = []

  validate: ->
    # validate taskpartnereffortallocations
    for alloc in @taskpartnereffortallocations
      unless alloc[1] in @getPartnerInitials()
        @validationError ["Undefined partner '#{alloc[1]}' in taskpartnereffortallocations", alloc]

    # validate spentefforttaskpartnertime
    for alloc in @spentefforttaskpartnertime
      unless alloc[1] in @getPartnerInitials()
        @validationError ["Undefined partner '#{alloc[1]}' in spentefforttaskpartnertime", alloc]

    # validate deliverables
    for alloc in @deliverables
      unless alloc[3] in @getPartnerInitials()
        @validationError ["Undefined partner '#{alloc[3]}' in deliverables", alloc]

  getCouchdbDocuments: ->
    res = {}
    # partners
    for partner in @partners
      res[partner[0]] =
        "@type": "organization"
        "_id": partner[0]
        "foaf:country": partner[1]
        "foaf:name": partner[0]
        "source": @transactionID

    # timeslots
    for timeslot in @timeslots
      res[timeslot] =
        "@type": "timeslot",
        "_id": timeslot
        "name": timeslot
        "source": @transactionID

    # tasks
    for task in @tasks
      wbs = task[0]
      res["#{@prefix}/task/#{wbs}"] =
        "@type": "task",
        "_id": "#{@prefix}/task/#{wbs}"
        "name": task[1]
        "source": @transactionID

    # taskpartnereffortallocations
    for alloc in @taskpartnereffortallocations # 1.1 SRFG 4
      wbs = alloc[0]
      partner = alloc[1]
      effort = alloc[2]
      res["#{@prefix}/task/#{wbs}/#{partner}"] =
        "@type": "effortallocation"
        "_id": "#{@prefix}/task/#{wbs}/#{partner}"
        "value": effort
        "task": "#{@prefix}/task/#{wbs}"
        "assignee": partner
        "source": @transactionID

    # tasktimeeffortallocations
    for alloc in @tasktimeeffortallocations # 1.1 Y1Q1 2
      wbs = alloc[0]
      timeslot = alloc[1]
      effort = alloc[2]
      res["#{@prefix}/task/#{wbs}/#{timeslot}"] =
        "@type": "effortallocation"
        "_id": "#{@prefix}/task/#{wbs}/#{timeslot}"
        "value": effort
        "task": "#{@prefix}/task/#{wbs}"
        "timeslot": timeslot
        "source": @transactionID

    # spentefforttaskpartnertime
    for spentEntry in @spentefforttaskpartnertime # 1.1 SRFG Y1Q1 1.3 1.4 0 3.5
      wbs = spentEntry[0]
      partner = spentEntry[1]
      firstTimeslot = spentEntry[2]
      efforts = spentEntry.splice 3
      for effort, i in efforts
        timeslot = @timeslots[@timeslots.indexOf(firstTimeslot) + i]
        res["#{@prefix}/task/#{wbs}/#{partner}/#{timeslot}"] =
          "@type": "effort"
          "_id": "#{@prefix}/task/#{wbs}/#{partner}/#{timeslot}"
          "value": effort
          "task": "#{@prefix}/task/#{wbs}"
          "timeslot": timeslot
          "assignee": partner
          "source": @transactionID


    # deliverables
    for deliv in @deliverables # wbs name description assignee milestone effort dissem nature rdivm
      wbs = deliv[0]
      name = deliv[1]
      description = deliv[2]
      assignee = deliv[3]
      milestone = deliv[4]
      effort = deliv[5]
      dissem = deliv[6]
      nature = deliv[7]
      rdivm = deliv[8]

      res["#{@prefix}/deliverable/#{wbs}"] =
        "@type": "deliverable"
        "_id": "#{@prefix}/deliverable/#{wbs}"
        "name": name
        "assignee": assignee
        "milestone": milestone
        "dissem": dissem
        "nature": nature
        "effort": effort
        "description": description
        "rdivm": rdivm
        "source": @transactionID

    return res

  getTaskWbss: ->
    _(@tasks).map (t) -> t[0]

  getPartnerInitials: ->
    _(@partners).map (p) -> p[0]

  parse: (projectDefinition) ->
    lines = projectDefinition.split '\n'
    for line, lineNr in lines
      @lineNr = lineNr
      splitArray = line.match(/[\w\d\.]+|"[^"]+"/g)
      splitArray = _(splitArray).map (s) -> s.replace(/^["']|["']$/g, '')
      # console.info "splitArray", splitArray
      @parseLine(splitArray)
    console.info "Parsing complete."

    # Fill timeslots
    if @timeunit is 'quarters'
      # distance = new Date('01-04-2000') - new Date('01-01-2000')
      for timeslot in [0 .. Number(@projectduration) - 1]
        @timeslots.push "Y#{Math.floor(timeslot / 4) + 1}Q#{timeslot % 4 + 1}"

    # Validate data
    @validate()

  # Gets an array of words/strings
  parseLine: (line) ->
    # console.info "Parsing the line ", line
    if line.length is 0
      @reset()
      return
    if @mode
      @[@mode].push line
      # console.info "New element in #{@mode}: ", line
      return
    switch line[0].toLowerCase()
      when "set"
        # Do set the project property
        @[line[1]] = line[2]
        # console.info "Setting #{line[1]} to #{line[2]}"
        return
      when "insert"
        unless line[1]
          console.info "SET needs a parameter (e.g. PARTNERS)"
        @setMode line[1].toLowerCase()
        return
    console.info "Nothing is matching the line", line


  setMode: (newMode) ->
    if typeof @[newMode] is 'undefined'
      @parseError "Mode '#{newMode}' is not defined!"
    # console.info "set mode to #{newMode}"
    @mode = newMode

  reset: ->
    # console.info "reset"
    @mode = ""

  parseError: (msg) ->
    console.error "Line #{@lineNr+1}", "PARSE ERROR: ", msg

  validationError: (args) ->
    console.error.apply @, ["Validation ERROR:"].concat args

  list: ->
    console.info "Listing project #{@project}"
    console.info "Partners:"
    for p in @partners
      console.info p
      # console.info "Partner '#{p[0]}' (#{p[2]}) from #{p[1]}"
    console.info "tasks:"
    for p in @tasks
      console.info p
    console.info "taskpartnereffortallocations:"
    for p in @taskpartnereffortallocations
      console.info p
    console.info "tasktimeeffortallocations:"
    for p in @tasktimeeffortallocations
      console.info p
    console.info "spentefforttaskpartnertime:"
    for p in @spentefforttaskpartnertime
      console.info p
    console.info "deliverables:"
    for p in @deliverables
      console.info p

  saveData: (log) ->
    @getDB (db) =>
      console.info "this is our db", db
      data = @getCouchdbDocuments()
      for key, doc of data
        db.saveDoc doc,
          success: (res) =>
            console.info "#{key} saved successfully", res
            console.info "Replicate"
            jQuery.couch.replicate 'proggis20', @project,
              success: (res) =>
                console.info "Replication is also done", res
                log "Now you can visit <a href='#{db.uri}_design/Proggis2/index.html' target='_blank'>Proggis #{@project}</a> "
            ,
              doc_ids: ['_design/Proggis2']

  getDB: (cb) ->
    db = jQuery.couch.db @project
    db.info
      success: (info) =>
        console.info "DB exists already:", @project, info
        cb db
      error: (err, msg) =>
        if err is 404
          console.info "DB #{@id} doesn't exist yet, creating"
          db.create
            success: (info) =>
              cb db
  deleteDB: (log) ->
    db = jQuery.couch.db @project
    db.drop
      success: (res) ->
        console.info 'Deleting DB ' + db.name + ' successfully.', res
        log?('Deleting DB ' + db.name + ' successfully.');
      error: (code, msg) ->
        log? "Error deleting: '#{msg}'"

###
project = new Project
fs.readFile process.argv[2], 'utf-8', (err, text) =>
  if err
    console.error err

  # Parse, then list parsed information
  project.parse text
  project.list()
  console.info project.getCouchdbDocuments()
  project.saveData()

###
@Project = Project