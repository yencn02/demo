$(document).ready(function() {
//  Address.bindCountryChange();
  Address.setFocus();
});
var Address = {
  setFocus: function(){
    $("#user_email").focus();
  },
  bindCountryChange: function(){
    $("#user_account_attributes_country").bind("change", function(){
      var country = $(this).val();
      Address.populateState(country);
    });
  },
  populateState: function(country){
    var country_states = states[country];
    if(!country_states){
      country_states = states["Default"];
    }
    $("#user_account_attributes_state").html(country_states);
  }
}