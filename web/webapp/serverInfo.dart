part of server;

var uriXML = 'news.xml';
var vTitle;
var vDescription;
var vPhoto;
var vTime;

//NO NEED HttpServer IF YOU ARE USING RIKULO STREAM SERVER, BECAUSE YOU DO NOT NEED TWO SERVERS
void serverInfo(HttpConnect connect){
  
  var _cxs = new List<HttpConnect>();
  var request = connect.request;
  var response = connect.response;
  
  if(request.uri.path == '/news' && request.method == 'POST')
  {    
    response.addString('Welcome from the server!');
    List<String> result = new List<String>();
    
    void convertASCII(int key)
    {
      //convert from ASCII decimal to char
      String temp = new String.fromCharCode(key);
      result.add(temp);
    }
    
    void printAll()
    {
      StringBuffer sb = new StringBuffer();
      result.forEach((String key)=>sb.add(key));
      String res = sb.toString();
      //{"title":"kjk","photo":false,"time":"2013-02-28T11:11","description":"jkjk","ip":"191.23.3.1"}
      print(res);
      
      //parse all the data
      Map parsedMap = Json.parse(res);
      print(parsedMap['title']==''?'none':parsedMap['title']);
      print(parsedMap['description']==''?'none':parsedMap['description']);
      print(parsedMap['photo']==false?'none':parsedMap['photo']);
      print(parsedMap['time']==''?'none':parsedMap['time']);
      print(parsedMap['ip']==''?'none':parsedMap['ip']);
    }
    
    //listen to the incoming JSON data
    request.listen((List<int> data){
    var tmp;
    onData: data.forEach((int key)=>convertASCII(key));
    onDone: printAll();
    });
    
    //raw.forEach((int key)=>response.addString(new String.fromCharCode(key)));
    response.addString(' Received Content Length of: ');
    response.addString(request.contentLength.toString());

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