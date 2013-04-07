//Mao Weiqing, Master of Computer Scicence, Edith Cowan University, 2012, Western Australia
//Email: dustonlyperth@gmail.com

part of server;
var uriXML = 'news.xml';
var vTitle;
var vDescription;
var vPhoto;
var vTime;
String id = 'none';

//NO NEED HttpServer IF YOU ARE USING RIKULO STREAM SERVER, BECAUSE YOU DO NOT NEED TWO SERVERS
//Receive JSON data from the browser, and save it to local JSON.json file
void serverInfo(HttpConnect connect){
  var _cxs = new List<HttpConnect>();
  var request = connect.request;
  var response = connect.response;
  String ip = request.connectionInfo.remoteHost;
  if(request.uri.path == '/send' && request.method == 'POST')
  {    
    response.write('Welcome from the server!');
    String res;
    var stream = request.transform(new StringDecoder());
    saveJSN()
    {
      //{"title":"skdfjk","lat":-31.970612,"time":"2013-04-17T11:11","description":"ksdjfkds","ip":"10.1.1.5","photo":"1","long":115.78638550000005}
      //format the json data
      String sub = res.trim().substring(4, res.length);
      Pattern patt = new RegExp(r'"ip":"none"');
      String rlp = '\"ip\":\"$ip\"';
      String re = sub.replaceFirst(patt, rlp);
      String str = re.substring(0, re.length-1);
      //generate id
      Map parsedMap = Json.parse(re);
      String time = parsedMap['time'];
      String oid = '$ip$time';
      Pattern pat = new RegExp(r':');
      id = oid.replaceFirst(pat, '.');

      String append = ',\"id\":\"$id\"}';
      String result = '$str$append';
      print('Json Info: $result');
      
      //save Json string to file
      void finishWrite()
      {
        print('Json file writing finished.');
      }
      //write json to file
      var jsonFile = new File('JSON.json');
      if(jsonFile.existsSync())
      {
        jsonFile.writeAsString(',$result', mode: FileMode.APPEND, encoding: Encoding.UTF_8)
        ..whenComplete(finishWrite);
      }
      else
      {
        jsonFile.writeAsString('$result', mode: FileMode.WRITE, encoding: Encoding.UTF_8)
        ..whenComplete(finishWrite);
      }
    }
    
    stream.listen((String value){
      //save data to string progressively
      res = '$res$value';
      },
      onDone:() => saveJSN(),
      onError:(error) => print(error)
    );
    //raw.forEach((int key)=>response.addString(new String.fromCharCode(key)));
    response.write(' Received Content Length of: ');
    response.write(request.contentLength.toString());
    connect.close();
  }
  else
  {
    response.write('<a href=\'\\\'>Oops!Let us go home!</a>');
    response.statusCode = HttpStatus.NOT_FOUND;
    connect.close();
  }
}

void receivePNG(HttpConnect connect){
  var _cxs = new List<HttpConnect>();
  var request = connect.request;
  var response = connect.response;
  if(request.uri.path == '/png' && request.method == 'POST')
  { 
    String png='';
    response.write('The server starts handling png request!');
    //read incoming List<int> data from request and use StringDecoder to transform it to string
    var stream = request.transform(new StringDecoder());

    savePNG()
    {
      String sub = png.trim().substring(4, png.length);
      
      //pirnt information of uplodaed photo
      print('Photos Info: $sub');

      //save png data to PNG.json file
      File jsonFile = new File('$id.news');
      try
      {
          //write a new file
          Future<File> f = jsonFile.writeAsString(sub, mode:FileMode.WRITE, encoding:Encoding.UTF_8);
          f.then((File) => print('Image file writing finished!'));
      }
      catch(e)
      {
        print(e);
      }
      response.write(' Received PNG Length of: ');
      response.write(request.contentLength.toString());
      connect.close();
    }
    stream.listen((String value){
      //save data to string progressively
      png = '$png$value';
      },
      onDone:() => savePNG(),
      onError:(error) => print(error)
    );
  }
  else
  {
    response.write('<a href=\'\\\'>Oops!Let us go home!</a>');
    response.statusCode = HttpStatus.NOT_FOUND;
    connect.close();
  }
}

//Load local JSON.json data and send it to the browser
void clientInfo(HttpConnect connect) {
  var request = connect.request;
  var response = connect.response;
  if(request.uri.path == '/receive' && request.method == 'GET')
  {
  File jsonDoc = new File('JSON.json');
  //use Sync method
  String data = jsonDoc.readAsStringSync();
  //Future<String> onFinished = jsonDoc.readAsString(Encoding.UTF_8);
  //onFinished.then((stringData) => output = stringData);
  //to use Async method can't give the value to output
  connect.response
    ..headers.contentType = contentTypes["application/json"]
    ..write('[$data]');
  }
  else
  {
    response.write('<a href=\'\\\'>Oops!Let us go home!</a>');
    response.statusCode = HttpStatus.NOT_FOUND;
  }
    connect.close();
}

//Load local PNG.json data and send it to the browser
void sendPNG(HttpConnect connect) {
  var request = connect.request;
  var response = connect.response;
  if(request.uri.path == '/pngReceive' && request.method == 'GET')
  {
    String data, dataFinal;
  try
  {
    File jsonDoc = new File('JSON.json');
    data= jsonDoc.readAsStringSync();
    
    //rearrage news string
    List<int> startCol = new List<int>();
    startCol.add(0);
    List<int> endCol = new List<int>();
    int indexI = 0, indexJ = 0;
    while(indexI !=-1)
    {
    int tmp =data.indexOf('{', indexI+1);
    if(tmp != -1)
    {
    startCol.add(tmp);
    }
    indexI = tmp;
    }
    while(indexJ !=-1)
    {
    int tmp =data.indexOf('}', indexJ+1);
    if(tmp != -1)
    {
    endCol.add(tmp);
    }
    indexJ = tmp;
    }

    //get news list
    List<String> newsList = new List<String>();
    for(int i=0;i<startCol.length;i++)
    {
      String slice = data.slice(startCol[i], endCol[i]+1);
      newsList.add(slice);
    }
    //get id list
    List<String> idList = new List<String>();
    mapNews(String news)
    {
      Map idMap = Json.parse(news);
      idList.add(idMap['id']);
    }
    newsList.forEach((String news)=>mapNews(news));
    
    //idList.forEach((String value)=>print(value));
    //read each PNG file
    List<String> pngList = new List<String>();
    for(int j=0;j<idList.length;j++)
    {
    String fileName = idList[j];
    File jsonDoc = new File('$fileName.news');
    String temp= jsonDoc.readAsStringSync();
    pngList.add('{$temp}');
    }
    String da = pngList.toString();
    dataFinal = da.slice(1, da.length-1);
  }
  catch(e)
  {
   print('Parse PNG Data Error: $e');
  }
  //Future<String> onFinished = jsonDoc.readAsString(Encoding.UTF_8);
  //onFinished.then((stringData) => output = stringData);
  //to use Async method can't give the value to output
  connect.response
    ..headers.contentType = contentTypes["text/plain"]
    ..write('$dataFinal');
  }
  else
  {
    response.write('<a href=\'\\\'>Oops!Let us go home!</a>');
    response.statusCode = HttpStatus.NOT_FOUND;
  }
    connect.close();
}