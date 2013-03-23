part of server;

var uriXML = 'news.xml';
var vTitle;
var vDescription;
var vPhoto;
var vTime;

/*
void serverInfo(HttpConnect connect){
  
  var _cxs = new List<HttpConnect>(), request = connect.request, response = connect.response;

  if (!connect.isIncluded)
    response.headers.contentType = new ContentType.fromString("""text/html; charset=utf-8""");

  if (request.uri.path == '/news')
  {
    
    response.addString('Hello World!');
    response.addString(connect.errorDetail.error.toString());
  }
  else
  {
    response.addString('Resources Not found');
    response.statusCode = HttpStatus.NOT_FOUND;
  }
    connect.close();
}
*/

//NO NEED HttpServer IF YOU ARE USING RIKULO STREAM SERVER, BECAUSE YOU DO NOT NEED TWO SERVERS
void serverInfo(HttpConnect connect){
  
  var _cxs = new List<HttpConnect>();
  var _v_;
  
  var request = connect.request;
  var response = connect.response;
  
  if(request.uri.path == '/news' && request.method == 'POST')
  {
   
    response.addString('welcome from the server!');
    response.addString('Content Length: ');
    response.addString(request.contentLength.toString());
    response.addString('.....');
    
  }
  else
  {
    response.addString('Not found');
    response.statusCode = HttpStatus.NOT_FOUND;
  }
    connect.close();
}

/*
void serverInfo(HttpConnect connect, NewsInfo news) {
  // Read an XML file.
  //handleXML(uriXML);
  //print("vDescription");
  //final info = {"title": vTitle, "description": vDescription, "photo": vPhoto, "time": vTime};
  final info = {"title": news.title, "description": news.description, "photo": news.photo, "time": news.time};
  connect.response
    ..headers.contentType = contentTypes["json"]
    ..addString(Json.stringify(info));
  connect.close();
}

void handleXML(var xmlDoc) {
  
  try {
    vTitle = xmlDoc.query('title').text;
    vDescription = xmlDoc.query('description').text;
    vPhoto = xmlDoc.query('photo').text;
    vTime = xmlDoc.query('time').text;
    
  } catch(e) {
    print('$uriXML doesn\'t have correct XML formatting.');
  }
}
*/