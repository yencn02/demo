$(document).ready(function() {
  Cart.bindNumericInput();
  Cart.bindButtons();
})
var Cart = {
  bindNumericInput: function(){
    $(".numeric").numeric(false);
  },
  bindButtons: function(){
    $("#user-id").bind("click", function(){
      window.location = "/account/billing_address";
      return false;
    });
    $("#save_changes").bind("click", function(){
      $("#action").val("save_changes");
    });
    $("#continue").bind("click", function(){
      $("#action").val("continue");
    });
  }
}