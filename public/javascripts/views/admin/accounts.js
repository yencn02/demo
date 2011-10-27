$(document).ready(function() {
  Account.bindCountryChange();
});

Account = {
  bindCountryChange: function(){
    jQuery("select.country-input").bind("change", function(){
      var country = jQuery(this).val();
      Account.populateState(country);
    });
  },
  populateState: function(country){
    var country_states = states[country];
    if(!country_states){
      country_states = states["Default"];
    }
    jQuery("select.state-input").html(country_states);
  }
}