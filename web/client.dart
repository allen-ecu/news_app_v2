//in order to use google map api dart version, js of client.dart is required that saying ultimately good map dart api is using js.
//generate js as long as client.dart changes
library client;

import 'dart:html';
import 'dart:json' as Json;
import 'dart:async';
import 'dart:uri';
import 'package:google_maps/js_wrap.dart' as jsw;
import 'package:google_maps/google_maps.dart' as gm;
import 'package:js/js.dart' as js;

part 'config.dart';

gm.GMap map;
gm.Geocoder geocoder;

final gm.LatLng centre = jsw.retain(new gm.LatLng(-29.5,132.1));
//var uriXML = 'news.xml';
final markerImg = 'markerImg.png';
final markerShadow = 'markerShadow.png';
final int widthIMG = 63;
final int heightIMG = 63;

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
dynamic data;
final num n_pho = 4;
num index = 0;

void main() {
  
  //receive JSON from the server
  ajaxGetJSON();
 
  //load local JSON
  //HttpRequest.getString(uri)
  //.then(processString)
  //.whenComplete(complete)
  //.catchError(handleError);
  
  //validate title input
  query('#title').onKeyPress.listen((e){
  validNumLett(e);
  });
  
  //validate description input
  query('#description').onKeyPress.listen((e){
  validNumLett(e);
  });
  
  //get image from users
  InputElement uploadInput = query('#photo');
  getIMAGE(uploadInput);
  
  /*
  query('#photo2').onMouseOver.listen((e){
    drawCross(e);
  });
  query('#photo3').onMouseOver.listen((e){
    drawCross(e);
  });
  query('#photo4').onMouseOver.listen((e){
    drawCross(e);
  });
  */
  //draggable event
  
  //submit user input(JSON) to the server
  query('#submit').onClick.listen((e){
  ajaxSendJSON();
  ajaxGetJSON();
  });
  
}

void getIMAGE(InputElement uploadInput) {
  uploadInput.onChange.listen((e){
  
    if(index < n_pho)
    {
      final files = uploadInput.files;
      if (files.length == 1) {
        final file = files[0];
        final reader = new FileReader();
        reader.onLoad.listen((e) {
          data = reader.result;
          //print image data
          print(data);
          showIMG('#photo$index');
        });
        reader.readAsDataUrl(file);
      }
    }
    if(index == 3)
    {
      query('#photo').hidden = true;
    }
    index++;
  });
}

void drawCross(e){
  print('#${e.target.id}'); 
 
  CanvasElement canvas = query('#${e.target.id}');
  var context = canvas.context2d;
  //query('#can1').append(canvas);
  canvas.height = widthIMG;
  canvas.width = heightIMG;
  
  //draw red cross
  //context.clearRect(0,0,widthIMG,heightIMG);
  context.strokeStyle = '#ff0000';
  context.beginPath();
  context.moveTo(0, 0);
  context.lineTo(63, 63);
  context.moveTo(63, 0);
  context.lineTo(0, 63);
  context.closePath();
  context.stroke();
  
}

void drawIMG(iD, ImageElement img) {
  CanvasElement canvas = query(iD);
  var context = canvas.context2d;
  canvas.height = widthIMG;
  canvas.width = heightIMG;
  context.drawImage(img, 0,0);
}

//show uploaded image
//show red border when mouse over
//swap images by drag and drop
void showIMG(var iD) {
  
  var sub = iD.substring(6);
  ImageElement old = new ImageElement();
  
  //show red border when mouse over
  showRedBorder(id){
    query('#IMG_$id').classes.remove('greyborder');
    query('#IMG_$id').classes.add('redborder');
  }
  //show grey border when mouse out
  showGreyBorder(id){
    query('#IMG_$id').classes.remove('redborder');
    query('#IMG_$id').classes.add('greyborder');
  }
  
  void dragf(MouseEvent e) {
    //send src and id of photo upon dragging
    ImageElement dragP = e.target;
    e.dataTransfer.setData('Src', dragP.src);
    e.dataTransfer.setData('Text', dragP.id);
  }
  
  void dropf(MouseEvent e) {
    e.preventDefault();
    //receive src and id of photo dragged
    var dragSrc = e.dataTransfer.getData('Src');
    var dragID = e.dataTransfer.getData('Text');
    //save src of photo to drop
    ImageElement drop = e.target;
    old.src = drop.src;
    //change the photo to drop to new src
    drop.src= dragSrc;
    //change the photo dragged to src of dropped photo
    ImageElement dragPP = query('#$dragID');
    dragPP.src = old.src;
  }
    
  var img = new ImageElement()
  ..id = 'IMG_$sub'
  ..src = data
  ..draggable = true
  ..width = widthIMG
  ..height = heightIMG
  ..onMouseOut.listen((e) => showGreyBorder(sub))
  ..onMouseOver.listen((e) => showRedBorder(sub))
  ..onDragStart.listen((e) => dragf(e))
  ..onDragOver.listen((e) => e.preventDefault())
  ..onDrop.listen((e) => dropf(e));
  
  query(iD).replaceWith(img);
}

void validNumLett(KeyboardEvent e) {
  String v = new String.fromCharCode(e.keyCode);
  //a-zA-Z ,. \t "space" \r "enter"
  RegExp exp = new RegExp('[A-Za-z0-9 \x08\t\r.,]');
  if(!exp.hasMatch(v))
  {
    e.returnValue = false;
    e.preventDefault();
  }
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
  String status = mapTOJSON();
  
  if(!(status == 'false'))
  {
    var elem = new LabelElement();
    elem.id = 'ok';
    elem.text = 'Message Successfully Sent!';
    if(query('#error')!=null)
    {
      query('#error').replaceWith(elem);
    }
    if(query('#info')!=null)
    {
    query('#info').replaceWith(elem);
    }
    
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
    // POST the data to the server Async
    var url = "/send";
    request.open("POST", url);
    request.setRequestHeader("Content-Type", "application/json");
    request.send(status);
  }
  else
  {
    var elem = new LabelElement();
    elem.id = 'error';
    elem.text = 'Please enter the title, description, and time!';
    if(query('#ok')!=null)
    {
      query('#ok').replaceWith(elem);
    }
    if(query('#info')!=null)
    {
    query('#info').replaceWith(elem);
    }
  }
}

String mapTOJSON()
{
  if(usrTitle.value.isEmpty || usrDesc.value.isEmpty || usrTime.value.isEmpty)
  {
    return 'false';
  }
  else
  {
    var obj = new Map();
    obj['title'] = usrTitle.value.isEmpty? "none":usrTitle.value;
    obj['description'] = usrDesc.value.isEmpty? "none":usrDesc.value;
    obj['photo'] = usrPhoto.value.isEmpty? "none":usrPhoto.value;
    obj['time'] = usrTime.value.isEmpty? curTime:usrTime.value; 
    obj['ip']= ip;
    obj['lat'] = double.parse(window.localStorage['Lat']);
    obj['long'] = double.parse(window.localStorage['Lng']);
    //obj["ip"] = usrTime==null? "none":usrTime; 
    print('Sending JSON to the server...');
    return Json.stringify(obj); // convert map to String i.e. JSON
  }
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
  loadMap(news, markerImg);
}

/*
complete()
{
  //to do
  
}

handleError(AsyncError error) {
  print('Uh oh, there was an error.');
  print(error.toString());
}
*/
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
  
  js.scoped((){

    //Get latitude and longitude:
    if (window.navigator.geolocation != null) {
      window.navigator.geolocation.getCurrentPosition().then((position) {
        js.scoped(() {
          var pos = new gm.LatLng(position.coords.latitude,position.coords.longitude);
          window.localStorage['Lat'] =pos.lat.toString();
          window.localStorage['Lng'] =pos.lng.toString();
        });
      }, onError : (error) {
        print('Oops, something wrong with geoloation service!');
      });
    } else {
      print('Your browser does not support Google geoloation!');
    }
    
    //Get geographic address from Latitude and Longitude:
    geocoder = jsw.retain(new gm.Geocoder());
    final gm.LatLng latlng = jsw.retain(new gm.LatLng(double.parse(window.localStorage['Lat']), double.parse(window.localStorage['Lng'])));
    final request = new gm.GeocoderRequest()
      ..location = latlng  // TODO bad variable "latlng" in example code
      ;
    
    //call geocoder to fetch address:
    geocoder.geocode(request, (List<gm.GeocoderResult> results, gm.GeocoderStatus status) {
      if (status == gm.GeocoderStatus.OK) {
        if (results[0] != null) {
          jsw.release(latlng);
          window.localStorage['Address'] = results[0].formattedAddress;
        } else {
          window.alert('No results found');
        }
      } else {
        window.alert('Geocoder failed due to: ${status}');
      }
    });
    
    //Google map:
    
    //set map options
    final mapOptions = new gm.MapOptions()
      ..zoom = 4
      ..center = centre
      ..mapTypeId = gm.MapTypeId.ROADMAP
      ;
    
    //var myLayer = new GLayer("org.wikipedia.en");
    map = jsw.retain(new gm.GMap(query("#mapholder"), mapOptions));
    
    //set clickable area
    var makerShape = new gm.MarkerShape();
    makerShape.coords = [20,6,22,7,23,8,24,9,25,10,25,11,25,12,25,13,25,14,25,15,25,16,25,17,25,18,25,19,24,20,23,21,22,22,20,23,19,24,8,24,5,23,4,22,4,21,4,20,4,19,10,18,9,17,8,16,8,15,7,14,7,13,7,12,8,11,8,10,8,9,9,8,10,7,11,6,20,6];
    makerShape.type = gm.MarkerShapeType.POLY;
    
    //set marker icon
    final markerIcon = new gm.Icon()
    ..url = markerImg;
    
    final markerIconShadow = new gm.Icon()
    ..url = markerShadow;
   
    //set popup contents
    List<DivElement> divEle= new List<DivElement>();
    List<gm.InfoWindow> infoWind= new List<gm.InfoWindow>();
    List<gm.Marker> gooMarker= new List<gm.Marker>();
    List<gm.LatLng> latLongs = new List<gm.LatLng>();
    
    for (int i = 0; i< data.length; i++)
    {
      //setup all lat long coordinates
      gm.LatLng latlong = new gm.LatLng(data[i]['lat'],data[i]['long']);
      latLongs.add(latlong);
      
      String vTitle = data[i]['title'];
      String vDescription = data[i]['description'];
      String vPhoto = data[i]['photo'];
      String vUserTime = data[i]['time'];
      
      //setup info windows
      var content = new DivElement();
      
      content.innerHtml='''
<div class="tabs">
  <div class="tab">
    <input id="tab-1" checked="checked" name="tab-group-1" type="radio"></input>
    <label for="tab-1">Overview</label>
    <div class="content">
      <table id="infotable">
                <tr>
                  <td colspan="2" id="infotitle">$vTitle</td>
                </tr>
                <tr>
                  <td id="infotime">$vUserTime</td>
                  <td rowspan="2" id="infodesc"><div>$vDescription</div></td>
                </tr>
                <tr>
                  <td>$vPhoto</td>
                </tr>
        </table>
    </div>
  </div>
  <div class="tab">
    <input id="tab-2" name="tab-group-1" type="radio"></input>
    <label for="tab-2">Details</label>
    <div class="content">
      Details </div>
  </div>
  <div class="tab">
    <input id="tab-3" name="tab-group-1" type="radio"></input>
    <label for="tab-3">Photos</label>
    <div id="carousel"class="content">
      <div id="carousel">
      <img src="photo1.fw.png" alt="1">
      <img src="photo2.fw.png" alt="2">
      <img src="photo3.fw.png" alt="3">
      <img src="photo4.fw.png" alt="4">
      <img src="photo5.fw.png" alt="5">
      </div>
    </div>
  </div>
  <div class="tab">
    <input id="tab-4" name="tab-group-1" type="radio"></input>
    <label for="tab-4">Comments</label>
    <div class="content">
      <div>User: </div>
      <div id="opinions">Comment:</div>
      <textarea class="text" id="comment" name="comment" placeholder= "Enter your news comments here" cols="32" rows="5"></textarea> </div>
  </div>
</div>            
      ''';

      divEle.add(content);
      
      var infoWindow = new gm.InfoWindow(
          new gm.InfoWindowOptions()
          ..content = divEle[i]
          ..maxWidth = 275    
      );
      
      infoWind.add(infoWindow);
      
      //set markers
      var marker = new gm.Marker(new gm.MarkerOptions()
      ..position = latLongs[i] //ip address
      ..map = map
      ..draggable = false
      ..shape = makerShape
      ..animation = gm.Animation.DROP
      ..icon = markerIcon
      ..shadow = markerIconShadow
      );
      
      gooMarker.add(marker);
      
      //set mouseover trigger contents window pops up
      gooMarker[i].on.mouseover.add((e) {
        infoWind[i].open(map, gooMarker[i]);
      });
      
      //set mouseout trigger contents window closed
      //gooMarker[i].on.mouseout.add((e) {
        //infoWind[i].close();
      //});
      
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
void onDataLoaded(String response) {
  var news = Json.parse(response);
  print('client: received json:');
  print('responseText $response');
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
}
