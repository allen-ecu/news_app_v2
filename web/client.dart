//in order to use google map api dart version, js of client.dart is required that saying ultimately good map dart api is using js.
//generate js as long as client.dart changes
library client;

import 'dart:html';
import 'dart:json' as Json;
import 'dart:async';
import 'dart:uri';

import 'package:google_maps/js_wrap.dart' as jsw;
import 'package:google_maps/google_maps.dart';
import 'package:js/js.dart' as js;

part 'config.dart';

GMap map;
final LatLng centre = jsw.retain(new LatLng(-29.5,132.1));
//var uriXML = 'news.xml';
var markerIMG = 'combined.png';

InputElement usrTitle= query('#title');
TextAreaElement usrDesc = query('#description');
InputElement usrPhoto = query('#photo');
InputElement usrTime = query('#time');
var curTime =new DateTime.now().toLocal().toString();

String title = 'none';
String description = 'none';
String photo = 'none';
String time = 'none';
String ip = 'none';
num lat = 0;
num long = 0;
var uri = 'news.json';

void main() {
  //receive JSON from the server
  ajaxGetJSON();
  
  //load JSON to google map
  
  //load local JSON
  HttpRequest.getString(uri)
  .then(processString)
  .whenComplete(complete)
  .catchError(handleError);

  //submit user input(JSON) to the server
  query('#submit').onClick.listen((e){
  ajaxSendJSON();
  });
  
  //ajaxGetJSON();
  // Read an XML file.
  //receiveXML(uriXML);
  
  // Send JSON
  //ajaxSendJSON();
  
  // Load Google Map
  
}

loadEnd(HttpRequest request) {
  if (request.status != 200) {
    print('Uh oh, there was an error.');
  } else {
    print('Data has been posted');
  }
}

void ajaxSendJSON()
{
 HttpRequest request = new HttpRequest(); // create a new XHR
  
  // add an event handler that is called when the request finishes
  request.onReadyStateChange.listen((_) 
      {
    if (request.readyState == HttpRequest.DONE &&
        (request.status == 200 || request.status == 0)) {
      // data saved OK.
      print(request.responseText); // output the response from the server
      }
                                                         }
  );
  // POST the data to the server
  var url = "/send";
  request.open("POST", url, true);
  request.setRequestHeader("Content-Type", "application/json");
  request.send(mapTOJSON()); // perform the async POST
  //request.onLoadEnd.listen((e) => loadEnd(request));
}

String mapTOJSON()
{
  var obj = new Map();
  obj['title'] = usrTitle.value==null? "none":usrTitle.value;
  obj['description'] = usrDesc.value==null? "none":usrDesc.value;
  obj['photo'] = usrPhoto.value=="none";
  obj['time'] = usrTime==null? "none":usrTime.value; 
  obj['ip']= ip;
  obj['lat'] = lat;
  obj['long'] = long;
  //obj["ip"] = usrTime==null? "none":usrTime; 
  print('Sending JSON to the server...');
  return Json.stringify(obj); // convert map to String i.e. JSON
}

/*
void receiveXML(var xml) {
  HttpRequest.request(xml)
      .then(handleXML)
      .catchError(handleError);
}

void handleXML(HttpRequest request) {
  var xmlDoc = request.responseXml;
  try {
    title = xmlDoc.query('title').text;
    query('#title').$dom_setAttribute('value',title);
    
    description = xmlDoc.query('description').text;
    query('#description').$dom_setAttribute('value',description);
    
    //photo = xmlDoc.query('photo').text;
    time = xmlDoc.query('time').text;
    
  } catch(e) {
    print('$uriXML doesn\'t have correct XML formatting.');
  }
}

void handleError(AsyncError error) {
  print('Sending JSON Failed.');
  print(error.toString());
}
*/

processString(String jsonString) {
  //load local json file
  var news = Json.parse(jsonString);
  
  assert(news is List);
  assert(news[0] is Map);
  
  //set data to variables
  //title = firstNews['title'];
  //description = firstNews['description'];
  //photo = firstNews['photo'];
  //time = firstNews['time'];
  //ip = firstNews['ip'];
  
  //pass data to the map
  loadMap(news, markerIMG);
}

complete()
{
  //to do
  
}

handleError(AsyncError error) {
  print('Uh oh, there was an error.');
  print(error.toString());
}

/*
void changeInputElemPlaceHolder(String eid, String evalue){
var elem = new InputElement();
elem.id = eid;
elem.name =eid;
elem.value = evalue;
query('#$eid').replaceWith(elem);
}

void changeTxtAreaElemPlaceHolder(String eid, String evalue){
var elem = new TextAreaElement();
elem.id = eid;
elem.name = eid;
elem.cols = 38;
elem.rows = 5;
elem.placeholder = evalue;
query('#$eid').replaceWith(elem);
}

void changeInputElemValue(String eid, String evalue){
var elem = new LocalDateTimeInputElement();
elem.id = eid;
elem.name =eid;
elem.value = evalue;
query('#$eid').replaceWith(elem);
}
*/

void loadMap(List<Map> data, var MarkerImage) {
  
  /*
  
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
    
    //reverseGeocoding
      geocoder = new google.maps.Geocoder();
      
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
   */
  
  js.scoped((){
    //map options
    final mapOptions = new MapOptions()
      ..zoom = 4
      ..center = centre
      ..mapTypeId = MapTypeId.ROADMAP
      ;
    
    //var myLayer = new GLayer("org.wikipedia.en");
    map = jsw.retain(new GMap(query("#mapholder"), mapOptions));
    
    //clickable area
    var makerShape = new MarkerShape();
    makerShape.coords = [20,6,22,7,23,8,24,9,25,10,25,11,25,12,25,13,25,14,25,15,25,16,25,17,25,18,25,19,24,20,23,21,22,22,20,23,19,24,8,24,5,23,4,22,4,21,4,20,4,19,10,18,9,17,8,16,8,15,7,14,7,13,7,12,8,11,8,10,8,9,9,8,10,7,11,6,20,6];
    makerShape.type = MarkerShapeType.POLY;
    
    //set marker icon
    final markerIcon = new Icon()
    ..url = MarkerImage;
    
    //set popup contents

    List<DivElement> divEle= new List<DivElement>();
    List<InfoWindow> infoWind= new List<InfoWindow>();
    List<Marker> gooMarker= new List<Marker>();
    List<LatLng> latLongs = new List<LatLng>();
    
    for (int i = 0; i< data.length; i++)
    {
      //setup all lat long coordinates
      LatLng latlong = new LatLng(data[i]['lat'],data[i]['long']);
      latLongs.add(latlong);
      
      String vTitle = data[i]['title'];
      String vDescription = data[i]['description'];
      String vPhoto = data[i]['photo'];
      String vUserTime = data[i]['time'];
      
      //setup info windows
      var content = new DivElement();
      content.innerHtml='''
          <div id="news" style="width=5px">
          <b>$vTitle</b>
          <p>$vDescription</p>
          <p>$vPhoto</p>
          <b>$vUserTime</b>
          </div>
          ''';
      divEle.add(content);
      
      var infoWindow = new InfoWindow(
          new InfoWindowOptions()
          ..content = divEle[i]
      );
      infoWind.add(infoWindow);
      
      
      //initialize marker1
      var marker = new Marker(new MarkerOptions()
      ..position = latLongs[i] //ip address
      ..map = map
      ..draggable = false
      ..shape = makerShape
      ..animation = Animation.DROP
      ..icon = markerIcon
      );
      
      gooMarker.add(marker);
      
      //mouseover trigger contents window pops up
      gooMarker[i].on.mouseover.add((e) {
        infoWind[i].open(map, gooMarker[i]);
      });
      
      //mouseout trigger contents window closed
      gooMarker[i].on.mouseout.add((e) {
        infoWind[i].close();
      });
      
      //keep objects live
      jsw.retainAll([map, gooMarker[i], makerShape, infoWind[i]]);
      
    }
  });
}

//get json data from server
void ajaxGetJSON(){
 
  var url = "/receive";
  // call the web server asynchronously
  var request = HttpRequest.getString(url).then(processString);
}

// analysing json data sent from server
void onDataLoaded(String responseText) {
  var news = Json.parse(responseText);
  print('client: received json:');
  print('responseText $responseText');
  print('Json.parse $news');
  
  assert(news is List);
  var firstNews = news[0];
  assert(news[0] is Map);
  
  title = firstNews['title'];
  description = firstNews['description'];
  photo = firstNews['photo'];
  time = firstNews['time'];
  lat = firstNews['lat'];
  long = firstNews['long'];
  ip = firstNews['ip'];
  print(title);
  print('analysing okay...');
}
