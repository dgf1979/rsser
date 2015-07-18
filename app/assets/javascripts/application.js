//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require bootstrap-sprockets
//= require_tree .

var ready;
ready = function() {
  setNavBuffer();
};

function setNavBuffer() {
  var ht = ($(".navbar-header").height() + 4) + "px";
  var hb = ($("footer.footer").height() + 4) + "px";
  console.log("set nav buffers to " + ht + " and " + hb);
  $("#top-buffer").height(ht);
  $("#bottom-buffer").height(hb);
}

$(document).ready(ready);
$(document).on('page:load', ready);
