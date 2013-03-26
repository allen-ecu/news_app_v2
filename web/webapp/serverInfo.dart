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

  List<String> result = new List<String>();
  
  if(request.uri.path == '/send' && request.method == 'POST')
  {    
    response.addString('Welcome from the server!');
    
    //convert from ASCII decimal to char
    convertASCII(int key)
    {
      String temp = new String.fromCharCode(key);
      result.add(temp);
    }
    
    printAll()
    {
      //convert json data to Stri
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
      print(parsedMap['time']==false?'none':parsedMap['time']);
      print(parsedMap['ip']==''?'none':parsedMap['ip']);
      
      //save Json string to file
      void finishWrite()
      {
        print('file write completed.');
      }
      //write json to file
      var jsonFile = new File('JSON.json');
      jsonFile.writeAsString(res, mode: FileMode.APPEND, encoding: Encoding.UTF_8)
      ..whenComplete(finishWrite);
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
    response.addString('<a href=\'\\\'>Oops!Let us go home!</a>');
    response.statusCode = HttpStatus.NOT_FOUND;
  }
    connect.close();
}

void clientInfo(HttpConnect connect) {
  
  var request = connect.request;
  var response = connect.response;
  
  if(request.uri.path == '/receive' && request.method == 'GET')
  {
    
  String output = 'none';
  
  File jsonDoc = new File('JSON.json');
  Future<String> onFinished = jsonDoc.readAsString(Encoding.UTF_8);
  onFinished.then((stringData) => output = stringData.toString());

  print(output);
  //response.headers.contentType = contentTypes['application/json'];
  connect.response
    //..headers.contentType = contentTypes["json"]
    ..addString(output);
  }
  else
  {
    response.addString('<a href=\'\\\'>Oops!Let us go home!</a>');
    response.statusCode = HttpStatus.NOT_FOUND;
  }
    connect.close();
}