var html_login = null;
$(document).ready(function() {
  $('a[rel*=facebox]').facebox();
  LoginBox.bindProceedToCheckout();

  $(document).bind('reveal.facebox', function() {
    NoDownloadBox.bindButtons();
    LoginBox.bindSubmit();
  });
  if($.browser.msie){
    html_login = $("#login-box").html();
    $(document).bind('close.facebox', function() {
      $("#login-box").html(html_login);
    });
    $(document).bind('reveal.facebox', function() {
      if($("#facebox .login-box").length != 0){
        $("#login-box").html("");
      }else{
        $("#login-box").html(html_login);
      }
    });
  }
});

var LoginBox = {
  bindProceedToCheckout: function(){
    $('a[title=Proceed to Checkout]').bind("click", function(){
      setTimeout(function(){
        $("#facebox .login_checkout").val("true");
      }, 100);
    });
  },
  bindSubmit: function(){
    if($("#facebox .login-box").length != 0){
      if($.browser.msie){
        $("#facebox .user_session_email").bind("submit", function(){
          LoginBox.submit();
        });

        $("#facebox .user_session_password").bind("submit", function(){
          LoginBox.submit();
        });
      }
      $("#facebox .user_session_email").focus();
    }
  },
  submit: function(){
    $("#facebox form").trigger("onsubmit");
  }
}
var NoDownloadBox = {
  bindButtons: function() {
    if($("#facebox .login-no-download").length != 0){
      $("#facebox .anonymously-user").click(function() {
        window.location = "/account/billing_address";
      });
      $("#facebox .new-user").click(function() {
        window.location = "/account/new?return=checkout";
      })
      $('#facebox a[rel*=facebox]').facebox();
    }
  }
}