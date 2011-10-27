var a =  null;
$(document).ready(function() {
  Player.createplayer();

  // Initialize tooltips;
  $("#videos-show .video-pack a.title-tooltip").tooltip({ position: "top center", offset: [15, 40], effect: "slide" });

  $("#main .video-player #info #format .type").bind("click", function(){
    window.location = $(this).children(".format-ico").children("a").attr("href");
  });
})


