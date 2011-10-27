$(document).ready(function() {
  GymLocation.bindCountryChange();
});

GymLocation = {
  bindCountryChange: function(){
    jQuery("select.country-input").bind("change", function(){
      var country = jQuery(this).val();
      GymLocation.populateState(country);
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


