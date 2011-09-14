(function() {
  var QCountToYQ, noflo;
  var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
    for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
    function ctor() { this.constructor = child; }
    ctor.prototype = parent.prototype;
    child.prototype = new ctor;
    child.__super__ = parent.prototype;
    return child;
  }, __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
  noflo = require("noflo");
  QCountToYQ = (function() {
    __extends(QCountToYQ, noflo.Component);
    function QCountToYQ() {
      this.data = [];
      this.property = null;
      this.inPorts = {
        "in": new noflo.Port(),
        property: new noflo.Port()
      };
      this.outPorts = {
        out: new noflo.Port()
      };
      this.inPorts["in"].on("data", __bind(function(data) {
        if (this.property) {
          return this.fixYQ(data);
        }
        return this.data.push(data);
      }, this));
      this.inPorts["in"].on("disconnect", __bind(function() {
        if (this.property && this.data.length) {
          return this.fixYQAll();
        }
        return this.outPorts.out.disconnect();
      }, this));
      this.inPorts.property.on("data", __bind(function(data) {
        return this.property = data;
      }, this));
    }
    QCountToYQ.prototype.fixYQ = function(object) {
      var quarter, year;
      if (!object[this.property]) {
        return;
      }
      if (object[this.property] % 4 === 0) {
        year = Math.floor(object[this.property] / 4);
        quarter = 4;
      } else {
        year = Math.floor(object[this.property] / 4 + 1);
        quarter = object[this.property] % 4;
      }
      object[this.property] = "Y" + year + "Q" + quarter;
      return this.outPorts.out.send(object);
    };
    return QCountToYQ;
  })();
  exports.getComponent = function() {
    return new QCountToYQ;
  };
}).call(this);
