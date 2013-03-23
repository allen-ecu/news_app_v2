function getGps()
		{
		  if (navigator.geolocation)
		    {
		    navigator.geolocation.getCurrentPosition(getPosition,showError);
		    return true;
		    }
		  else{
		  	x.innerHTML="Geolocation is not supported by this browser.";
		    return false;
		  	}
		}

function getPosition(position)
		{
		sessionStorage.localLat = position.coords.latitude;
		sessionStorage.localLon = position.coords.longitude;
		}
		
		function showError(error)
		{
		  switch(error.code) 
		    {
		    case error.PERMISSION_DENIED:
		      x.innerHTML="User denied the request for Geolocation."
		      break;
		    case error.POSITION_UNAVAILABLE:
		      x.innerHTML="Location information is unavailable."
		      break;
		    case error.TIMEOUT:
		      x.innerHTML="The request to get user location timed out."
		      break;
		    case error.UNKNOWN_ERROR:
		      x.innerHTML="An unknown error occurred."
		      break;
		    }
		}

function getAddress()
{
		  //reverseGeocoding
		  geocoder = new google.maps.Geocoder();
		  
		  //showPosition
		  var lat = sessionStorage.localLat;
		  var lon = sessionStorage.localLon;
		  var des = new google.maps.LatLng(parseFloat(lat),parseFloat(lon));

		  geocoder.geocode({'latLng': des}, function(results, status) {
          if (status == google.maps.GeocoderStatus.OK) {
            if (results[1]) {
              sessionStorage.address = results[0].formatted_address;
            } else {
              sessionStorage.address = 'No results found';
            }
          } else {
            sessionStorage.address = 'Geocoder failed due to: ' + status;
          }
          });

}

function loadMap()
		{
		  //reverseGeocoding
		  geocoder = new google.maps.Geocoder();
		  
		  //showPosition
		  var lat = sessionStorage.localLat;
		  var lon = sessionStorage.localLon;
		  var des = new google.maps.LatLng(parseFloat(lat),parseFloat(lon));
		  var cen = new google.maps.LatLng(parseFloat(-29.5),parseFloat(132.1));
		  var infowindow = new google.maps.InfoWindow();

		  var mapOptions = {
    		zoom: 4,
    		center: cen,
    		mapTypeId: google.maps.MapTypeId.ROADMAP
  			}
  		  
  		  map = new google.maps.Map(document.getElementById("mapholder"), mapOptions);
		  

		  //draw marker of one point
		  markerA = new google.maps.Marker({
    	  map:map,
    	  draggable:false,
   		  animation: google.maps.Animation.DROP,
   		  position: des
 		  });
 		  
		  
		  //listener
  		  google.maps.event.addListener(markerA, 'click', toggleBounce);
  		  
  		  //get address as well
  		  geocoder.geocode({'latLng': des}, function(results, status) {
          if (status == google.maps.GeocoderStatus.OK) {
            if (results[1]) {
              sessionStorage.address = results[0].formatted_address;
            } else {
              sessionStorage.address = 'No results found';
            }
          } else {
            sessionStorage.address = 'Geocoder failed due to: ' + status;
          }
          });

  		    		  
  		  google.maps.event.trigger(map, 'resize');
  		}
  		  
	// marker animation
	function toggleBounce() {
 			 if (marker.getAnimation() != null) 
 			 {marker.setAnimation(null);} 
   			 else {marker.setAnimation(google.maps.Animation.BOUNCE);}
		}
		  

    //<-- Google Relocation -->
    var x=document.getElementById("info");  
    var marker;
    var map;
    
    $(document).ready(function() {
    //it will load as soon as the DOM is loaded and before the page contents are loaded.
    getGps();
    });

    $(window).load(function() {
    //it will load many functions after the DOM and page contents are loaded.
    });
    
    //google.maps.event.addDomListener(window, 'load', loadMap);
    window.onload = loadMap;