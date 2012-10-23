Backbone.couch_connector.config.db_name = "proggis20";
Backbone.couch_connector.config.ddoc_name = "Proggis2";

Proggis.Deliverable = Backbone.Model.extend
  initialize: ->
    console.info "New Delverable initialized", @toJSON()
    @set
  url: ->
    "http://iks-project.eu/deliverable/#{@get 'id'}"
  getStatusDocs: (cb) ->
    jQuery.couch.db(Backbone.couch_connector.config.db_name).view "#{Backbone.couch_connector.config.ddoc_name}/deliverableStatus",
      key: @get 'id'
      success: (res) =>
        console.info 'statusDocs', res
        cb (new Proggis.DeliverableStatus hash.value for hash in res.rows)
  getTitle: ->
    deliverableRegex = new RegExp /([.|\d]*).$/
    properties = @toJSON()
    shortName = deliverableRegex.exec(properties.id)?[1]
    return "D #{shortName} #{properties.name}"


Proggis.DeliverableView = Backbone.View.extend
  initialize: ->
    console.info "DeliverableView initialized"
    @render()
  template: """
    <h1 class="title"><%= title %></h1>
    <div class="description"><%= description %></div>
    <div class="details">
    </div>
    <h2>Status</h2>
    <div class='status'/>
    <div class='newStatus'/>
    """

  render: ->
    deliverableHash = @model.toJSON()
    deliverableHash.title = @model.getTitle()
    console.info "deliverable hash", deliverableHash

    tmpl = _.template @template, deliverableHash
    @$el.html tmpl

    jQuery('.details', @$el).append renderDetails deliverableHash, [
        ["Assignee", "assignee"]
        ['Due', 'milestone']
      ], [
        ['Dissemination', 'dissem']
        ['Nature', 'nature']
        ['RDIVM', 'rdivm']
      ]
    statusEl = jQuery('.status', @$el)
    @model.getStatusDocs (statusModels) =>
      console.info "Status models", statusModels
      statusModels = _(statusModels).sortBy (model) ->
        model.get 'timestamp'
      statusModels = statusModels.reverse()
      @newStatusView.load statusModels[0] if statusModels[0]
      statusModelTemplate = _.template """
        <p>The Status of <strong><%= title %> is <strong><%= statusLabel %></strong> since <span class="date" title="<%= statusAwarded %>"><%= statusAwarded %></span>. See the <a href="<%= location %>" target="_blank">repository</a>.</p>
      """
      deliverableHash = @model.toJSON()

      for status in statusModels
        statusHash = status.toJSON()
        statusHash.statusLabel = _.detect(Proggis.deliveryStatusValues, (stat) -> stat.value is statusHash.status).label
        statusHash.title = @model.getTitle()
        statusEl.append statusModelTemplate statusHash
      jQuery('.date', statusEl).each ->
        jQuery( @ ).prettyDate()


    newStatusEl = jQuery('.newStatus', @$el)
    @newStatusView = new Proggis.DeliverableStatusEditorView
      el: newStatusEl
    @newStatusView.deliverableView = @




Proggis.DeliverableStatus = Backbone.Model.extend
  initialize: ->
    console.info "DeliverableStatus created"
    @bind "error", (model, error) =>
      console.error "DeliverableStatus error", model, error
  url: ->
    "http://iks-project.eu/deliverablestatus/#{@id}"
  defaults:
    '@type': 'deliverableStatus'
    timestamp: new Date()

  validate: (attributes) ->
    if attributes.status not in @_getAcceptedStatuses()
      return "'#{attributes.status}' isn not an allowed value for delivery status"

  _getAcceptedStatuses: ->
    _.pluck Proggis.deliveryStatusValues, 'value'


Proggis.deliveryStatusValues = [
    value: "wip"
    label: "Work in Progress"
  ,
    value: "due"
    label: "Delivery Due"
  ,
    value: "overdue"
    label: "Delivery Overdue"
  ,
    value: "submitted"
    label: "Submitted for Review"
  ,
    value: "accepted"
    label: "Reviewed and Signed Off"
  ,
    value: "accepttedsubjectto"
    label: "Reviewed and Accepted Subject to Modifications"
  ,
    value: "rejected"
    label: "Reviewed and Rejected"
  ]

Proggis.DeliverableStatusEditorView = Backbone.View.extend
  initialize: ->
    @render()
  render: ->
    console.info 'render in', @$el
    template = """
    <table>
      <tr>
        <td>
          <span><strong>Status *</strong></span>
        </td><td>
          <select class='status'>
            <option value=''/>
            <% _.each(Proggis.deliveryStatusValues, function(statusValue){ %> <option value="<%= statusValue.value %>"><%= statusValue.label %> </option> <% }); %>
          </select>
        </td>
      </tr>
        <tr>
          <td>
            Deliverable location
          </td><td>
            <input class='location'/>
          </td>
        </tr>
        <tr>
          <td>
            Status awarded
          </td><td>
            <input class='status-date' type='date'/>
          </td>
        </tr>
      <tr>
        <td>
          Further Information
        </td><td>
          <div class='further-information'/>
        </td>
      </tr>
      <tr>
        <td></td>
        <td class="save">
          <button class='save'>Save</button>
        </td>
      </tr>
    </table>
    """
    compiled = _.template template

    @$el.html compiled() # @model.toJSON()
    jQuery('.further-information', @$el).hallo
      'halloformat': {}
      'hallolink': {}
    jQuery('button', @$el).button()
  events:
    "click button.save": 'save'
  save: (e) ->
    obj=
      status: jQuery('.status option:selected', @$el).val()
      location: jQuery('.location', @$el).val()
      furtherInformation: jQuery('.further-information').hallo('getContents')
      deliverable: @deliverableView.model.id
      timestamp: new Date()
      statusAwarded: new Date(jQuery('.status-date', @$el).val())
    @deliverableView.model.set()
    console.info "Save", obj
    model = new Proggis.DeliverableStatus obj
    model.save {},
      success: (e) =>
        console.info "status saved!", e, model
        @deliverableView.render()
      error: (e) =>
        console.error "Save error", e
  load: (statusModel) ->
    jQuery(".status option:[value=#{statusModel.get "status"}]", @$el).attr "selected", "selected"
    jQuery('.location', @$el).val statusModel.get "location"
    jQuery('.further-information').hallo 'setContents', statusModel.get "furtherInformation"

renderDetails = (hash, fields, moreFields) ->
  res = jQuery "<table class='details'></table><div class='more'/>"
  for field in fields
    res.append "<tr><td>#{field[0]}</td><td class='assignee'>#{hash[field[1]]}</td></tr>"
  more = res.filter('.more')
  if moreFields
    more.append "<p><a class='more'>more</a></p><table class='details more' style='display:none;'></table>"
    jQuery('a.more', more).data('more', more).click (e) =>
      more = jQuery(e.target).data 'more'
      jQuery('.details.more', more).toggle()
    for field in moreFields
      table = jQuery('table.details.more', more)
      table.append "<tr><td>#{field[0]}</td><td class='assignee'>#{hash[field[1]]}</td></tr>"
      jQuery('.details.more', more)
  res
