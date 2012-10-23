couchapp_load_scripts = (scripts) ->
  for script in scripts
    document.write "<script src=\"" + script + "\"></script>"

couchapp_load_css = (stylesheets) ->
  for css in stylesheets
    document.write "<link rel='stylesheet' href='#{css}' />"

couchapp_load_scripts [
  "/_utils/script/sha1.js"
  "/_utils/script/json2.js"
  "/_utils/script/jquery.js"
  "/_utils/script/jquery.couch.js"
  "vendor/couchapp/jquery.form.js"
  "vendor/couchapp/jquery-ui.js"
  "vendor/couchapp/jquery.prettyDate.js"
  "vendor/couchapp/jquery.flot.js"
  "vendor/couchapp/jquery.couch.app.js"
  "vendor/couchapp/jquery.couch.app.util.js"
  "vendor/couchapp/jquery.mustache.js"
  "vendor/couchapp/jquery.tmpl.js"
  "vendor/couchapp/jquery.evently.js"
  "vendor/couchapp/jquery.dataTables.js"
  "vendor/couchapp/underscore.js"
  "vendor/couchapp/backbone.js"
  "vendor/couchapp/backbone-couchdb.js"
  "vendor/couchapp/hallo/rangy-core-1.2.3.js"
  "vendor/couchapp/hallo/hallo.js"
  "js/jit.js"
]

couchapp_load_css [
  "vendor/couchapp/hallo/jquery-ui-1.8.16.custom.css"
#  "vendor/couchapp/hallo/jquery.ui-1.8.16.ie.css"
  "vendor/couchapp/hallo/hallo.css"
#  "vendor/couchapp/hallo/overlay.css"
  "vendor/couchapp/hallo/fontawesome/css/font-awesome.css"
#  "vendor/couchapp/hallo/fontawesome/css/font-awesome-ie7.css"
]