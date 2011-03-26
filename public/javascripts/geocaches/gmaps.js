var map = null;
var geocoder = null;
var markersArray = new Array();
var geocacheArray = new Array();

function initialize() {
      geocoder = new google.maps.Geocoder();
    
      var myOptions = {
        zoom: 4,
        mapTypeControl: true,
        mapTypeControlOptions: {
            style: google.maps.MapTypeControlStyle.DROPDOWN_MENU
        },
        navigationControl: true,
        navigationControlOptions: {
            style: google.maps.NavigationControlStyle.SMALL
        },
        mapTypeId: google.maps.MapTypeId.TERRAIN
      }
 
      map = new google.maps.Map(document.getElementById("map_canvas"), myOptions);

      // Add custom control
      //
      var refreshGeocachesDiv = document.createElement('DIV');
      var refreshGeocaches    = new refreshGeocachesControl(refreshGeocachesDiv, map);
      refreshGeocachesDiv.index = 1;
      map.controls[google.maps.ControlPosition.TOP_RIGHT].push(refreshGeocachesDiv);
      
      getGeocaches(map, parseGeocacheResults);

}

function setBounds(map, locations, centerMarker) {
  var bounds = new google.maps.LatLngBounds();
  for (var i=0; i<locations.length; i++) {
    var geocache = locations[i];
    var geoLatLng = new google.maps.LatLng(geocache[1], geocache[2]);
      bounds.extend(geoLatLng);
  }
  var centerBound = new google.maps.LatLng(centerMarker[0], centerMarker[1]);
  bounds.extend(centerBound);
  map.fitBounds(bounds);
  
  map.setCenter(centerBound);
  var currentZoom = map.getZoom();
  if (locations.length < 1) {
      //no geocaches foudn
      map.setZoom(10);
  } else {
      map.setZoom(currentZoom - 1);
  }
}

function setMarkers(map, locations) {
    for (var i = 0; i < locations.length; i++) {
      var marker = createMarker(locations[i]);
      markersArray.push(marker);
    }
} 

function createMarker(geocache) {
  var image = new google.maps.MarkerImage('/images/icons/ruby.png',
    new google.maps.Size(16,16),
    new google.maps.Point(0,0),
    new google.maps.Point(8,16)
  );
  
  var shadow = new google.maps.MarkerImage('/images/icons/ruby_shadow.png',
      new google.maps.Size(24,16),
      new google.maps.Point(0,32)
  );
  
  var myLatLng = new google.maps.LatLng(geocache[1], geocache[2]);
  var marker   = new google.maps.Marker({
          id: geocache[3],
    position: myLatLng,
         map: map,
      shadow: shadow,
        icon: image,
       title: geocache[4].toString(),
      zIndex: geocache[3]
  });

  google.maps.event.addListener(marker, 'click', function() { window.location="/geocaches/"+geocache[0]; } );

  return marker;
}

function setCenterMarker(map, centerMarker) {
   // clear markers
   clearMarkers();
   var image = new google.maps.MarkerImage('/images/icons/center_marker_male.png',
     new google.maps.Size(16,50),
     new google.maps.Point(0,0),
     new google.maps.Point(16,42)
   );

   var myLatLng = new google.maps.LatLng(centerMarker[0], centerMarker[1]);
   var marker = new google.maps.Marker({
         position: myLatLng,
              map: map,
             icon: image,
            title: "Search center",
           zIndex: 1
   });
   markersArray.push(marker);
}

function locate_geocode(lat,lng) {
      var myLatLng = new google.maps.LatLng(lat,lng);
      map.setZoom(15);
      map.setCenter(myLatLng);
}

function search_by_address() {
    codeAddress(function(result){
        if(result==true){
            $('address_form').submit();
        }
    });
    return false;
}

function codeAddress(callback) {
    var address = document.getElementById("geocache_address").value;
    geocoder.geocode( { 'address': address }, function(results, status) {
        if (status == google.maps.GeocoderStatus.OK) {
            lat = results[0].geometry.location.lat();
            lon = results[0].geometry.location.lng();
            Form.Element.setValue("lat",lat);
            Form.Element.setValue("lon",lon);
            callback(true);
        } else {
            alert("Geocode was not successful for the following reason: "+status);
            callback(false);
        }
    });
}

Event.observe(window, 'load',
    function(){initialize()}
);

function refreshGeocachesControl(controlDiv, map) {

      // Set CSS styles for the DIV containing the control
      // Setting padding to 5 px will offset the control
      // from the edge of the map
      controlDiv.style.padding = '5px';

      // Set CSS for the control border
      var controlUI = document.createElement('DIV');
      controlUI.style.backgroundColor = 'white';
      controlUI.style.borderStyle = 'solid';
      controlUI.style.borderWidth = '2px';
      controlUI.style.cursor = 'pointer';
      controlUI.style.textAlign = 'center';
      controlUI.title = 'Click to show local geocaches';
      controlDiv.appendChild(controlUI);
                   
      // Set CSS for the control border
      controlText = document.createElement('DIV');
      controlText.style.fontFamily = 'Arial,sans-serif';
      controlText.style.fontSize = '12px';
      controlText.style.paddingLeft = '4px';
      controlText.style.paddingRight = '4px';
      controlText.innerHTML = 'Show Geocaches';
      controlUI.appendChild(controlText);
   
      google.maps.event.addDomListener(controlUI, 'click', function() {
          centerMarker=new Array(map.getCenter().lat(), map.getCenter().lng())
          getGeocaches(map, parseGeocacheResults);
      });
}

function clearMarkers() {
    if(markersArray) {
        for (i=0; i < markersArray.length; i++) {
            markersArray[i].setMap(null);
        }
        markersArray.length = 0;
    }
}

function parseGeocacheResults(map, geodata) {
    geocacheArray.length = 0;
    data=geodata.evalJSON();
    data.each(function(geocacheData) {
        geocacheArray.push(new Array(geocacheData.geocache.id, geocacheData.geocache.lat, geocacheData.geocache.lon, geocacheData.geocache.id, geocacheData.geocache.name));
    });
    updateMarkerOnMap(map);
    refreshTable(geodata);
}

function updateMarkerOnMap(map) {
    setCenterMarker(map, centerMarker);
    setMarkers(map, geocacheArray);
    setBounds(map, geocacheArray, centerMarker);
}

function refreshTable(data) {
    new Ajax.Request('/geocaches/get_geocaches_table',
    {
        method: 'post',
        parameters: {points: data},
        onSuccess: function(transport) {
            $('geotable').update(transport.responseText);
        },
        onFailure: function(){ alert('Failed to update geocache table') }
    });
}

function getGeocaches(map, parseGeocacheResults) {
    // if there are hardcoded values on the page then use them, otherwise request them
    //
    if (typeof geocaches != 'undefined') {
        geocacheArray.length = 0;
        geocaches.each(function(geocacheData) {
            geocacheArray.push(new Array(geocacheData[0], geocacheData[1], geocacheData[2], geocacheData[3], geocacheData[4]));
        });
        updateMarkerOnMap(map);
    } else {
        new Ajax.Request('/geocaches/get_'+type,
         {
             method: 'post',
             parameters: {lat: centerMarker[0], lng: centerMarker[1]}, 
             onSuccess: function(transport) {
                 raw_geocache_data = transport.responseText;
                 parseGeocacheResults(map, raw_geocache_data);
             },
             onFailure: function(){ alert('Failed to access geocache database, please try again soon.') }
         });
    }
}
