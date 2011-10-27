$(document).ready(function() {
  $("#main .video-player #info #format .type").bind("click", function(){
    window.location = $(this).children(".format-ico").children("a").attr("href");
  });
  
 Player.playlist();

 // Initialize tooltips;
  $(".list a").tooltip({ position: "top center", offset: [-6, 75], effect: "slide" });
})
