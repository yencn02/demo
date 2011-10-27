$(document).ready(function() {
  Address.bindSubmitButton();
  Address.bindCardTypeImages();
  //  Address.bindCountryChange();
  Address.setFocus();
});
var Address = {
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
  setFocus: function(){
    $("#credit_card_card_type_id").focus();
  },
  bindSubmitButton: function(){
    $("#new_address_book input[type=button]").bind("click", function(){      
      $("#new_address_book").trigger('onsubmit');
      return false;
    });
  },
  bindCardTypeImages: function(){
    $("a.card_type").bind("click", function(){
      var select_tag = $("#creadit_card_card_type_id")[0];
      var options = select_tag.options;
      for (var i = 0; i< options.length; i ++){
        var option = options[i];
        if (option.text == this.title){
          select_tag.value = option.value;
        }
      }
    });
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
  }
}