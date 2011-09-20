couchapp_load = (scripts) ->
  for script in scripts
    document.write "<script src=\"" + script + "\"></script>"

couchapp_load [
    "/_utils/script/sha1.js",
    "/_utils/script/json2.js",
    "/_utils/script/jquery.js",
    "/_utils/script/jquery.couch.js",
    "vendor/couchapp/jquery.form.js",
    "vendor/couchapp/jquery-ui.js",
    "vendor/couchapp/jquery.couch.app.js",
    "vendor/couchapp/jquery.couch.app.util.js",
    "vendor/couchapp/jquery.mustache.js",
    "vendor/couchapp/jquery.evently.js",
    "vendor/couchapp/underscore.js",
    "vendor/couchapp/backbone.js",
    "js/jit.js"
]
