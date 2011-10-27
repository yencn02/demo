$(document).ready(function() {
  $("#billing-address").bind("click", function(){
    window.location = "/account/billing_address?edit=address";
    return false;
  });

  $("#shipping-address").bind("click", function(){
    window.location = "/account/shipping_address";
    return false;
  });

  $("#card-info").bind("click", function(){
    window.location = "/account/billing_address?edit=card";
    return false;
  });
});
