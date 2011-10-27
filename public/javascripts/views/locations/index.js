$(document).ready(function() {
  Location.bindWebSiteLink();
});

var Location = {
  latlng: null,
  bindWebSiteLink: function(){
    $(".website").bind("click", function(){
      window.open(this.href);
      return false;
    });
  },
  showDistance: function(location1, location2, center, zoom){
    map.clearOverlays();
    var dir_div = document.getElementById('route_div');
    dir_div.innerHTML = "";
    var directions = new GDirections(map, dir_div);
    var dir_point_array = new Array;
    dir_point_array.push(location1[2]);
    dir_point_array.push(location2[2]);
    directions.loadFromWaypoints(dir_point_array);map.addControl(new GLargeMapControl());
    map.addControl(new GMapTypeControl());
    map.addOverlay(new GPolyline([new GLatLng(location1[0],location1[1]),new GLatLng(location2[0], location2[1])],"#ff0000",3,1.0));
    map.setCenter(new GLatLng(center[0],center[1]), zoom);
    map.addOverlay(addInfoWindowToMarker(new GMarker(new GLatLng(location1[0],location1[1]),{title : "Location 1"}), location1[2],{}));
    map.addOverlay(addInfoWindowToMarker(new GMarker(new GLatLng(location2[0],location2[1]),{title : "Location 2"}), location2[2],{}));
  },
  showSpinner: function(){
    $("#spinner").show();
  },
  hideSpinner: function(){
    $("#spinner").hide();
  }
}