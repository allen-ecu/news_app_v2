part of server;

var uriXML = 'news.xml';
var vTitle;
var vDescription;
var vPhoto;
var vTime;


//NO NEED HttpServer IF YOU ARE USING RIKULO STREAM SERVER, BECAUSE YOU DO NOT NEED TWO SERVERS
//Receive JSON data from the browser, and save it to local JSON.json file
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
      //{"title":"kjk","photo":false,"time":"2013-02-28T11:11","description":"jkjk","ip":"191.23.3.1","lat":"none","long":"none"}
      print(res);
      
      //parse all the data
      Map parsedMap = Json.parse(res);
      print(parsedMap['title']==''?'none':parsedMap['title']);
      print(parsedMap['description']==''?'none':parsedMap['description']);
      print(parsedMap['photo']==false?'none':parsedMap['photo']);
      print(parsedMap['time']==false?'none':parsedMap['time']);
      print(parsedMap['ip']==''?'none':parsedMap['ip']);
      print(parsedMap['lat']==''?'0':parsedMap['lat']);
      print(parsedMap['long']==''?'0':parsedMap['long']);
      
      //save Json string to file
      void finishWrite()
      {
        print('file write completed.');
      }
      //write json to file
      var jsonFile = new File('JSON.json');
      if(jsonFile.existsSync())
      {
        jsonFile.writeAsString(',$res', mode: FileMode.APPEND, encoding: Encoding.UTF_8)
        ..whenComplete(finishWrite);
      }
      else
      {
        jsonFile.writeAsString('$res', mode: FileMode.WRITE, encoding: Encoding.UTF_8)
        ..whenComplete(finishWrite);
      }
      
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

//Load local JSON.json data and send it to the browser
void clientInfo(HttpConnect connect) {
  
  var request = connect.request;
  var response = connect.response;
  
  if(request.uri.path == '/receive' && request.method == 'GET')
  {
    
  File jsonDoc = new File('JSON.json');
  //use Sync method
  String data = jsonDoc.readAsStringSync(Encoding.UTF_8);

  //Future<String> onFinished = jsonDoc.readAsString(Encoding.UTF_8);
  //onFinished.then((stringData) => output = stringData);
  //to use Async method can't give the value to output

  connect.response
    ..headers.contentType = contentTypes["application/json"]
    ..addString('[$data]');
  }
  else
  {
    response.addString('<a href=\'\\\'>Oops!Let us go home!</a>');
    response.statusCode = HttpStatus.NOT_FOUND;
  }
    connect.close();
}