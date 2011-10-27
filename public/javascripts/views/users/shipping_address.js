$(document).ready(function() {
  Address.bindSubmitButton();
  Address.bindShippingButton();
  Address.bindDeleteButton();
  Address.bindEitButton();
  Address.bindCheckBox();
  Address.setFocus();
//  Address.bindCountryChange();
});
var Address = {
  deleteUrl: "/account/remove_address?address_id=",
  shipUrl: "/cart/set_shipping_info?address_id=",
  setFocus: function(){
    $("#address_book_first_name").focus();
  },
  resizeWindow: function(){
    if($.browser.msie){
      if (typeof(window.rounded_elements) == 'undefined') {
        return(false);
      }
      for (var i in window.rounded_elements) {
        var el = window.rounded_elements[i];
        if(el.id == "wrapper"){
          el.vml.style.height = $("#wrapper").height() + 40 +'px';
        }
      }
    }
  },
  bindSubmitButton: function(){
    $("input.submit").bind("click", function(){
      $("#new_address_book").trigger('onsubmit');
      return false;
    });
  },
  bindShippingButton: function(){
    $("input.ship").bind("click", function(){
      var id = this.id.replace("ship", "");
      var url = Address.shipUrl + id;
      window.location = url;
      return false;
    });
  },
  bindDeleteButton: function(){
    $("input.delete").bind("click", function(){
      var id = this.id.replace("delete", "");
      var url = Address.deleteUrl + id;
      window.location = url;
      return false;
    });
  },
  bindEitButton: function(){
    $("input.edit").bind("click", function(){
      var id = this.id.replace("edit", "");
      var address = Address.findAddress(id);
      var excepted_fields = ["account_id", "created_at", "updated_at", "email", "phone", "nick_name"].join(" ");
      if(address){
        for (var key in address.address_book){
          if (excepted_fields.indexOf(key) == -1){
            if (key != "state"){
              $("#address_book_" + key).val(address.address_book[key]);
            }else{
              $("#address_book_state").html(states[address.address_book["country"]]);
              $("#address_book_state").val(address.address_book[key]);
            }
          }
        }
      }
      return false;
    });
  },
  findAddress: function(id){
    var address = null;
    for(var i = 0; i < addressBooks.length; i ++){
      if(addressBooks[i].address_book.id.toString() == id){
        address = addressBooks[i];
      }
    }
    return address;
  },
  bindCountryChange: function(){
    $("#address_book_country").bind("change", function(){
      var country = $(this).val();
      Address.populateState(country);
    });
  },
  populateState: function(country){
    var country_states = states[country];
    if(!country_states){
      country_states = states["Default"];
    }
    $("#address_book_state").html(country_states);
  },
  bindCheckBox: function(){
    $("#use_billing_address").bind("change", function(){
      var except_fields = ["id", "account_id", "created_at", "updated_at"].join(" ");
      if (this.checked){
        for (var key in billing_address.address_book){
          if (except_fields.indexOf(key) == -1){
            if (key != "state"){
              $("#address_book_" + key).val(billing_address.address_book[key]);
            }else{
              $("#address_book_state").html(states[billing_address.address_book["country"]]);
              $("#address_book_state").val(billing_address.address_book[key]);
            }
          }
        }
      }else{
        for (var key in billing_address.address_book){
          if (except_fields.indexOf(key) == -1){
            $("#address_book_" + key).val("");
          }
        }
        $("#address_book_country").val("US");
        $("#address_book_state").html(states["US"]);
      }
    });
  }
}