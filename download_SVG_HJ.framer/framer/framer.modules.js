require=(function e(t,n,r){function s(o,u){if(!n[o]){if(!t[o]){var a=typeof require=="function"&&require;if(!u&&a)return a(o,!0);if(i)return i(o,!0);var f=new Error("Cannot find module '"+o+"'");throw f.code="MODULE_NOT_FOUND",f}var l=n[o]={exports:{}};t[o][0].call(l.exports,function(e){var n=t[o][1][e];return s(n?n:e)},l,l.exports,e,t,n,r)}return n[o].exports}var i=typeof require=="function"&&require;for(var o=0;o<r.length;o++)s(r[o]);return s})({"SVGLayer":[function(require,module,exports){
"SVGLayer class\n\nproperties\n- linecap <string> (\"round\" || \"square\" || \"butt\")\n- fill <string> (css color)\n- stroke <string> (css color)\n- strokeWidth <number>\n- dashOffset <number> (from -1 to 1, defaults to 0)";
var extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

exports.SVGLayer = (function(superClass) {
  extend(SVGLayer, superClass);

  function SVGLayer(options) {
    var cName, d, footer, header, path, t;
    if (options == null) {
      options = {};
    }
    options = _.defaults(options, {
      dashOffset: 1,
      strokeWidth: 2,
      stroke: "#28affa",
      backgroundColor: null,
      clip: false,
      fill: "transparent",
      linecap: "round"
    });
    SVGLayer.__super__.constructor.call(this, options);
    if (options.fill === null) {
      this.fill = null;
    }
    this.width += options.strokeWidth / 2;
    this.height += options.strokeWidth / 2;
    d = new Date();
    t = d.getTime();
    cName = "c" + t;
    header = "<svg class='" + cName + "' x='0px' y='0px' width='" + this.width + "' height='" + this.height + "' viewBox='-" + (this.strokeWidth / 2) + " -" + (this.strokeWidth / 2) + " " + (this.width + this.strokeWidth / 2) + " " + (this.height + this.strokeWidth / 2) + "'>";
    path = options.path;
    footer = "</svg>";
    this.html = header + path + footer;
    Utils.domComplete((function(_this) {
      return function() {
        var domPath;
        domPath = document.querySelector('.' + cName + ' path');
        _this._pathLength = domPath.getTotalLength();
        _this.style = {
          "stroke-dasharray": _this.pathLength
        };
        return _this.dashOffset = options.dashOffset;
      };
    })(this));
  }

  SVGLayer.define("pathLength", {
    get: function() {
      return this._pathLength;
    },
    set: function(value) {
      return print("SVGLayer.pathLength is readonly");
    }
  });

  SVGLayer.define("linecap", {
    get: function() {
      return this.style.strokeLinecap;
    },
    set: function(value) {
      return this.style.strokeLinecap = value;
    }
  });

  SVGLayer.define("strokeLinecap", {
    get: function() {
      return this.style.strokeLinecap;
    },
    set: function(value) {
      return this.style.strokeLinecap = value;
    }
  });

  SVGLayer.define("fill", {
    get: function() {
      return this.style.fill;
    },
    set: function(value) {
      if (value === null) {
        value = "transparent";
      }
      return this.style.fill = value;
    }
  });

  SVGLayer.define("stroke", {
    get: function() {
      return this.style.stroke;
    },
    set: function(value) {
      return this.style.stroke = value;
    }
  });

  SVGLayer.define("strokeColor", {
    get: function() {
      return this.style.stroke;
    },
    set: function(value) {
      return this.style.stroke = value;
    }
  });

  SVGLayer.define("strokeWidth", {
    get: function() {
      return Number(this.style.strokeWidth.replace(/[^\d.-]/g, ''));
    },
    set: function(value) {
      return this.style.strokeWidth = value;
    }
  });

  SVGLayer.define("dashOffset", {
    get: function() {
      return this._dashOffset;
    },
    set: function(value) {
      var dashOffset;
      this._dashOffset = value;
      if (this.pathLength != null) {
        dashOffset = Utils.modulate(value, [0, 1], [this.pathLength, 0]);
        return this.style.strokeDashoffset = dashOffset;
      }
    }
  });

  return SVGLayer;

})(Layer);


},{}]},{},[])
//# sourceMappingURL=data:application/json;charset:utf-8;base64,eyJ2ZXJzaW9uIjozLCJzb3VyY2VzIjpbIm5vZGVfbW9kdWxlcy9icm93c2VyLXBhY2svX3ByZWx1ZGUuanMiLCIvVXNlcnMvZHVlZHVlL0Ryb3Bib3gvMDAwMDBfZnJhbWVyLzAwMF/hhILhhaLhhIzhhaHhhqjhhJHhha7hhrcvMDEvZG93bmxvYWRfU1ZHX0hKLmZyYW1lci9tb2R1bGVzL1NWR0xheWVyLmNvZmZlZSJdLCJuYW1lcyI6W10sIm1hcHBpbmdzIjoiQUFBQTtBQ0FBO0FBQUEsSUFBQTs7O0FBV00sT0FBTyxDQUFDOzs7RUFFQSxrQkFBQyxPQUFEO0FBQ1osUUFBQTs7TUFEYSxVQUFVOztJQUN2QixPQUFBLEdBQVUsQ0FBQyxDQUFDLFFBQUYsQ0FBVyxPQUFYLEVBQ1Q7TUFBQSxVQUFBLEVBQVksQ0FBWjtNQUNBLFdBQUEsRUFBYSxDQURiO01BRUEsTUFBQSxFQUFRLFNBRlI7TUFHQSxlQUFBLEVBQWlCLElBSGpCO01BSUEsSUFBQSxFQUFNLEtBSk47TUFLQSxJQUFBLEVBQU0sYUFMTjtNQU1BLE9BQUEsRUFBUyxPQU5UO0tBRFM7SUFRViwwQ0FBTSxPQUFOO0lBRUEsSUFBRyxPQUFPLENBQUMsSUFBUixLQUFnQixJQUFuQjtNQUNDLElBQUMsQ0FBQSxJQUFELEdBQVEsS0FEVDs7SUFHQSxJQUFDLENBQUEsS0FBRCxJQUFVLE9BQU8sQ0FBQyxXQUFSLEdBQXNCO0lBQ2hDLElBQUMsQ0FBQSxNQUFELElBQVcsT0FBTyxDQUFDLFdBQVIsR0FBc0I7SUFHakMsQ0FBQSxHQUFRLElBQUEsSUFBQSxDQUFBO0lBQ1IsQ0FBQSxHQUFJLENBQUMsQ0FBQyxPQUFGLENBQUE7SUFDSixLQUFBLEdBQVEsR0FBQSxHQUFNO0lBQ2QsTUFBQSxHQUFTLGNBQUEsR0FBZSxLQUFmLEdBQXFCLDJCQUFyQixHQUFnRCxJQUFDLENBQUEsS0FBakQsR0FBdUQsWUFBdkQsR0FBbUUsSUFBQyxDQUFBLE1BQXBFLEdBQTJFLGNBQTNFLEdBQXdGLENBQUMsSUFBQyxDQUFBLFdBQUQsR0FBYSxDQUFkLENBQXhGLEdBQXdH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LElBQUMsQ0FBQSxLQUFLLENBQUMsV0FBUCxHQUFxQjtJQURqQixDQURMO0dBREQ7O0VBS0EsUUFBQyxDQUFBLE1BQUQsQ0FBUSxZQUFSLEVBQ0M7SUFBQSxHQUFBLEVBQUssU0FBQTthQUFHLElBQUMsQ0FBQTtJQUFKLENBQUw7SUFDQSxHQUFBLEVBQUssU0FBQyxLQUFEO0FBQ0osVUFBQTtNQUFBLElBQUMsQ0FBQSxXQUFELEdBQWU7TUFDZixJQUFHLHVCQUFIO1FBQ0MsVUFBQSxHQUFhLEtBQUssQ0FBQyxRQUFOLENBQWUsS0FBZixFQUFzQixDQUFDLENBQUQsRUFBSSxDQUFKLENBQXRCLEVBQThCLENBQUMsSUFBQyxDQUFBLFVBQUYsRUFBYyxDQUFkLENBQTlCO2VBQ2IsSUFBQyxDQUFBLEtBQUssQ0FBQyxnQkFBUCxHQUEwQixXQUYzQjs7SUFGSSxDQURMO0dBREQ7Ozs7R0FyRThCIiwiZmlsZSI6ImdlbmVyYXRlZC5qcyIsInNvdXJjZVJvb3QiOiIiLCJzb3VyY2VzQ29udGVudCI6WyIoZnVuY3Rpb24gZSh0LG4scil7ZnVuY3Rpb24gcyhvLHUpe2lmKCFuW29dKXtpZighdFtvXSl7dmFyIGE9dHlwZW9mIHJlcXVpcmU9PVwiZnVuY3Rpb25cIiYmcmVxdWlyZTtpZighdSYmYSlyZXR1cm4gYShvLCEwKTtpZihpKXJldHVybiBpKG8sITApO3ZhciBmPW5ldyBFcnJvcihcIkNhbm5vdCBmaW5kIG1vZHVsZSAnXCIrbytcIidcIik7dGhyb3cgZi5jb2RlPVwiTU9EVUxFX05PVF9GT1VORFwiLGZ9dmFyIGw9bltvXT17ZXhwb3J0czp7fX07dFtvXVswXS5jYWxsKGwuZXhwb3J0cyxmdW5jdGlvbihlKXt2YXIgbj10W29dWzFdW2VdO3JldHVybiBzKG4/bjplKX0sbCxsLmV4cG9ydHMsZSx0LG4scil9cmV0dXJuIG5bb10uZXhwb3J0c312YXIgaT10eXBlb2YgcmVxdWlyZT09XCJmdW5jdGlvblwiJiZyZXF1aXJlO2Zvcih2YXIgbz0wO288ci5sZW5ndGg7bysrKXMocltvXSk7cmV0dXJuIHN9KSIsIlwiXCJcIlxuU1ZHTGF5ZXIgY2xhc3NcblxucHJvcGVydGllc1xuLSBsaW5lY2FwIDxzdHJpbmc+IChcInJvdW5kXCIgfHwgXCJzcXVhcmVcIiB8fCBcImJ1dHRcIilcbi0gZmlsbCA8c3RyaW5nPiAoY3NzIGNvbG9yKVxuLSBzdHJva2UgPHN0cmluZz4gKGNzcyBjb2xvcilcbi0gc3Ryb2tlV2lkdGggPG51bWJlcj5cbi0gZGFzaE9mZnNldCA8bnVtYmVyPiAoZnJvbSAtMSB0byAxLCBkZWZhdWx0cyB0byAwKVxuXCJcIlwiXG5cbmNsYXNzIGV4cG9ydHMuU1ZHTGF5ZXIgZXh0ZW5kcyBMYXllclxuXG5cdGNvbnN0cnVjdG9yOiAob3B0aW9ucyA9IHt9KSAtPlxuXHRcdG9wdGlvbnMgPSBfLmRlZmF1bHRzIG9wdGlvbnMsXG5cdFx0XHRkYXNoT2Zmc2V0OiAxXG5cdFx0XHRzdHJva2VXaWR0aDogMlxuXHRcdFx0c3Ryb2tlOiBcIiMyOGFmZmFcIlxuXHRcdFx0YmFja2dyb3VuZENvbG9yOiBudWxsXG5cdFx0XHRjbGlwOiBmYWxzZVxuXHRcdFx0ZmlsbDogXCJ0cmFuc3BhcmVudFwiXG5cdFx0XHRsaW5lY2FwOiBcInJvdW5kXCJcblx0XHRzdXBlciBvcHRpb25zXG5cblx0XHRpZiBvcHRpb25zLmZpbGwgPT0gbnVsbFxuXHRcdFx0QGZpbGwgPSBudWxsXG5cblx0XHRAd2lkdGggKz0gb3B0aW9ucy5zdHJva2VXaWR0aCAvIDJcblx0XHRAaGVpZ2h0ICs9IG9wdGlvbnMuc3Ryb2tlV2lkdGggLyAyXG5cblx0XHQjIEhUTUwgZm9yIHRoZSBTVkcgRE9NIGVsZW1lbnQsIG5lZWQgdW5pcXVlIGNsYXNzIG5hbWVzXG5cdFx0ZCA9IG5ldyBEYXRlKClcblx0XHR0ID0gZC5nZXRUaW1lKClcblx0XHRjTmFtZSA9IFwiY1wiICsgdFxuXHRcdGhlYWRlciA9IFwiPHN2ZyBjbGFzcz0nI3tjTmFtZX0nIHg9JzBweCcgeT0nMHB4JyB3aWR0aD0nI3tAd2lkdGh9JyBoZWlnaHQ9JyN7QGhlaWdodH0nIHZpZXdCb3g9Jy0je0BzdHJva2VXaWR0aC8yfSAtI3tAc3Ryb2tlV2lkdGgvMn0gI3tAd2lkdGggKyBAc3Ryb2tlV2lkdGgvMn0gI3tAaGVpZ2h0ICsgQHN0cm9rZVdpZHRoLzJ9Jz5cIlxuXHRcdHBhdGggPSBvcHRpb25zLnBhdGhcblx0XHRmb290ZXIgPSBcIjwvc3ZnPlwiXG5cdFx0QGh0bWwgPSBoZWFkZXIgKyBwYXRoICsgZm9vdGVyXG5cblx0XHQjIHdhaXQgd2l0aCBxdWVyeWluZyBwYXRobGVuZ3RoIGZvciB3aGVuIGRvbSBpcyBmaW5pc2hlZFxuXHRcdFV0aWxzLmRvbUNvbXBsZXRlID0+XG5cdFx0XHRkb21QYXRoID0gZG9jdW1lbnQucXVlcnlTZWxlY3RvcignLicrY05hbWUrJyBwYXRoJylcblx0XHRcdEBfcGF0aExlbmd0aCA9IGRvbVBhdGguZ2V0VG90YWxMZW5ndGgoKVxuXHRcdFx0QHN0eWxlID0ge1wic3Ryb2tlLWRhc2hhcnJheVwiOkBwYXRoTGVuZ3RoO31cblx0XHRcdEBkYXNoT2Zmc2V0ID0gb3B0aW9ucy5kYXNoT2Zmc2V0XG5cblx0QGRlZmluZSBcInBhdGhMZW5ndGhcIixcblx0XHRnZXQ6IC0+IEBfcGF0aExlbmd0aFxuXHRcdHNldDogKHZhbHVlKSAtPiBwcmludCBcIlNWR0xheWVyLnBhdGhMZW5ndGggaXMgcmVhZG9ubHlcIlxuXG5cdEBkZWZpbmUgXCJsaW5lY2FwXCIsXG5cdFx0Z2V0OiAtPiBAc3R5bGUuc3Ryb2tlTGluZWNhcFxuXHRcdHNldDogKHZhbHVlKSAtPlxuXHRcdFx0QHN0eWxlLnN0cm9rZUxpbmVjYXAgPSB2YWx1ZVxuXG5cdEBkZWZpbmUgXCJzdHJva2VMaW5lY2FwXCIsXG5cdFx0Z2V0OiAtPiBAc3R5bGUuc3Ryb2tlTGluZWNhcFxuXHRcdHNldDogKHZhbHVlKSAtPlxuXHRcdFx0QHN0eWxlLnN0cm9rZUxpbmVjYXAgPSB2YWx1ZVxuXG5cdEBkZWZpbmUgXCJmaWxsXCIsXG5cdFx0Z2V0OiAtPiBAc3R5bGUuZmlsbFxuXHRcdHNldDogKHZhbHVlKSAtPlxuXHRcdFx0aWYgdmFsdWUgPT0gbnVsbFxuXHRcdFx0XHR2YWx1ZSA9IFwidHJhbnNwYXJlbnRcIlxuXHRcdFx0QHN0eWxlLmZpbGwgPSB2YWx1ZVxuXG5cdEBkZWZpbmUgXCJzdHJva2VcIixcblx0XHRnZXQ6IC0+IEBzdHlsZS5zdHJva2Vcblx0XHRzZXQ6ICh2YWx1ZSkgLT4gQHN0eWxlLnN0cm9rZSA9IHZhbHVlXG5cblx0QGRlZmluZSBcInN0cm9rZUNvbG9yXCIsXG5cdFx0Z2V0OiAtPiBAc3R5bGUuc3Ryb2tlXG5cdFx0c2V0OiAodmFsdWUpIC0+IEBzdHlsZS5zdHJva2UgPSB2YWx1ZVxuXG5cdEBkZWZpbmUgXCJzdHJva2VXaWR0aFwiLFxuXHRcdGdldDogLT4gTnVtYmVyKEBzdHlsZS5zdHJva2VXaWR0aC5yZXBsYWNlKC9bXlxcZC4tXS9nLCAnJykpXG5cdFx0c2V0OiAodmFsdWUpIC0+XG5cdFx0XHRAc3R5bGUuc3Ryb2tlV2lkdGggPSB2YWx1ZVxuXG5cdEBkZWZpbmUgXCJkYXNoT2Zmc2V0XCIsXG5cdFx0Z2V0OiAtPiBAX2Rhc2hPZmZzZXRcblx0XHRzZXQ6ICh2YWx1ZSkgLT5cblx0XHRcdEBfZGFzaE9mZnNldCA9IHZhbHVlXG5cdFx0XHRpZiBAcGF0aExlbmd0aD9cblx0XHRcdFx0ZGFzaE9mZnNldCA9IFV0aWxzLm1vZHVsYXRlKHZhbHVlLCBbMCwgMV0sIFtAcGF0aExlbmd0aCwgMF0pXG5cdFx0XHRcdEBzdHlsZS5zdHJva2VEYXNob2Zmc2V0ID0gZGFzaE9mZnNldFxuIl19
