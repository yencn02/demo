$(document).ready(function() {
  $('input.default-value').focus(function() {
    if ($(this).val() == $(this).attr('alt')) {
      $(this).val('');
    }
  }).blur(function() {
    if ($(this).val() == '') {
      $(this).val($(this).attr('alt'));
    }
  });

  setTimeout(function(){
    $(window).resize();
  }, 1000);
});


var Player = {
  createplayer: function createplayer()
  {    
    if ($('#video_howto').text() == "true") {
      jwplayer("video").setup({
        flashplayer: "../swf/player.swf",
        file: $('#video_url').text(),
        image: $('#image_url').text(),        
        buffering: 25,        
        height: 335,
        width: 592,
        skin: '/../swf/skin/vafitness.xml'                
      });
    }
    else {
      try{
        jwplayer("video").setup({
          flashplayer: "../swf/player.swf",
          file: $('#video_url').text(),
          image: $('#image_url').text(),
          buffering: 25,
          height: 380,
          width: 672,
          skin: '/../swf/skin/vafitness.xml'
        });
      }catch(ex){}
    }    
  }
  ,
  playlist:  function createplayerPlaylist()
  {
    if ($('#video_home').text() == "true") {
      jwplayer("video").setup({
        flashplayer: "../swf/player.swf",
        playlistfile: '/pages/playlist',
        buffering: 25,
        height: 380,
        width: 672,
        skin: '/../swf/skin/vafitness.xml',
        repeat: 'always'
      });
    }
    else {
      jwplayer("video").setup({
        flashplayer: "../swf/player.swf",
        playlistfile: '/video_packs/playlist?id=' + $("#video_id").text(),
        buffering: 25,
        height: 380,
        width: 672,
        skin: '/../swf/skin/vafitness.xml',
        repeat: 'always'
      });
    }
  }  
}
