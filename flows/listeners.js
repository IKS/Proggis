/*
 * Start the NoFlo listeners
 *
 * Usage:
 * $ forever start -o listeners.log listeners.js 
 */
var createNetwork, noflo;
noflo = require("noflo");
createNetwork = function(file) {
  return noflo.loadFile(file, function(network) {
    return console.log("NoFlo network " + file + " created with " + network.graph.nodes.length + " nodes");
  });
};
createNetwork("ReadEffortControlling.fbp");
createNetwork("ReadDeliverables.fbp");
