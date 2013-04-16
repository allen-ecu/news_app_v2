//Mao Weiqing, Master of Computer Scicence, Edith Cowan University, 2012, Western Australia
//Email: dustonlyperth@gmail.com

part of server;
//String uriXML = 'news.xml';
String vTitle;
String vDescription;
String vPhoto;
String vTime;
String id = 'none';
num itemsperfetch = 4;//min: 1
num currentpage;
num totalpage;
num pageNum = 1;
num userCount = 0;
List<num> pageIndex = new List<num>();

//NO NEED HttpServer IF YOU ARE USING RIKULO STREAM SERVER, BECAUSE YOU DO NOT NEED TWO SERVERS
//Receive JSON data from the browser, and save it to local JSON.json file
void receiveJSON(HttpConnect connect){
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
void sendJSON(HttpConnect connect) {
  
  print('News Item Preferred to Fetch: $itemsperfetch');
  
  var request = connect.request;
  var response = connect.response;
  if(request.uri.path == '/receive' && request.method == 'GET')
  { 
    File jsonDoc = new File('JSON.json');
    //use Sync method
    String data = jsonDoc.readAsStringSync();
  
    //reconstruct news string to news list
    List<String> newsList = buildNewsList(data);
    
    num totalnewslen = newsList.length;
    print('Total News Items: $totalnewslen');
    
    //generate page index
    pageIndex = generatePageIndex(itemsperfetch, totalnewslen, pageNum);
    
    if(pageIndex != null)
    {
    //output page index
    print('Page Index: ');
    print(pageIndex.toString());
    
    //only fetch the 'itemstofetch' number of news of currentpage
    String dataStr = buildStrToSend(newsList, pageIndex);
    
    connect.response
    ..headers.contentType = contentTypes["application/json"]
    ..write('[$dataStr]');
    }
    else
    {
      response.write('PageIndex is null!');
      response.statusCode = HttpStatus.NOT_FOUND;
    }
  }
  else
  {
    response.write('<a href=\'\\\'>Oops!Let us go home!</a>');
    response.statusCode = HttpStatus.NOT_FOUND;
  }
  connect.close();
}

String buildStrToSend(List<String> newsList, List<num> pageIndex) {
  //output data format {...},{...},{...}
  String dataStr='';
  
  for(int i = 0; i< pageIndex.length; i++)
  {
    String tmp=newsList[pageIndex[i]];
    if(dataStr == '')
    {
      dataStr ='$tmp';
    }
    else
    {
      dataStr ='$dataStr,$tmp';
    }
  }
  return dataStr;
}

List<String> buildNewsList(String data) {
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
  
  //fill news items to a list
  List<String> newsList = new List<String>();
  for(int i=0;i<startCol.length;i++)
  {
    String slice = data.slice(startCol[i], endCol[i]+1);
    newsList.add(slice);
  }
  return newsList;
}

List<num> generatePageIndex(num itemsperfetch, num totalnewslen, num pageNum) {
  
  if(itemsperfetch == 0)
  {
    print('The server needs to fetch at least one news item!');
    return null;
  }
  else if(totalnewslen == 0)
  {
    print('The server did not find any news items!');
    return null;
  }
  else
  {
        // decide currentpage and totalpage
        num itemstofetch,currentpages, totalpages;
        if(itemsperfetch<totalnewslen)
        {
          //8<5
          itemstofetch = itemsperfetch;
          num tmp = totalnewslen/itemsperfetch;
          totalpages = tmp.ceil();
        
          if(pageNum> 0 && pageNum <= totalpages)
          {
            currentpages = pageNum;
          }
          else
          {
            currentpages = 1;
          }
        }
        else
        {
          //5
          itemstofetch = totalnewslen;
            currentpages = 1;
            totalpages = 1;
        }
      
        //debug
        print('News Item to Fetch: $itemstofetch');
        print('currentpage: $currentpages');
        print('totalpages: $totalpages');
        
        currentpage = currentpages;
        totalpage = totalpages;
        
        List<num> pageIndex = new List<num>();
        if(currentpages != totalpages)
        {
          for(int i = itemstofetch*(currentpages -1); i<itemstofetch*currentpages; i++)
          {
            pageIndex.add(i);
          }
        }
        else
        {
          num add =totalnewslen - itemstofetch*(totalpages-1) - 1;
          for(int i = itemstofetch*(currentpages -1); i<itemstofetch*(currentpages -1)+add+1; i++)
          {
            pageIndex.add(i);
          }
        }
        return pageIndex;
  }
}

void receiveInfo(HttpConnect connect){
  var _cxs = new List<HttpConnect>();
  var request = connect.request;
  var response = connect.response;
  String ip = request.connectionInfo.remoteHost;
  if(request.uri.path == '/sendinfo' && request.method == 'POST')
  { 
    String res;
    var stream = request.transform(new StringDecoder());
    saveINFO()
    {
       pageNum = int.parse(res);
       print('Asking for Page: $pageNum');
    }
    
    stream.listen((String value){
      //save data to string progressively
      res = value;
      },
      onDone:() => saveINFO(),
      onError:(error) => print(error)
    );
    connect.close();
  }
  else
  {
    response.write('Receive Page Info Error!');
    response.statusCode = HttpStatus.NOT_FOUND;
    connect.close();
  }
}

void sendInfo(HttpConnect connect) {
  var request = connect.request;
  var response = connect.response;
  if(request.uri.path == '/receiveinfo' && request.method == 'GET')
  {
    Map obj = new Map();
    obj['currentpage'] = pageNum;
    obj['totalpage'] = totalpage;
    String data = Json.stringify(obj);
    connect.response
    ..headers.contentType = contentTypes["text/plain"]
    ..write('$data');
  }
  else
  {
    response.write('Something is wrong!');
    response.statusCode = HttpStatus.NOT_FOUND;
  }
    connect.close();
}

//Load local PNG.json data and send it to the browser
void sendPNG(HttpConnect connect) {
  var request = connect.request;
  var response = connect.response;
  if(request.uri.path == '/pngreceive' && request.method == 'GET')
  {
    String data, dataFinal;
    File jsonDoc = new File('JSON.json');
    data= jsonDoc.readAsStringSync();
    
    //rearrage news string
    List<String> newsList = buildNewsList(data);
    //fetch page indexed items
    num newslen = newsList.length;
    num itemstofetch = itemsperfetch<newslen? itemsperfetch:newslen;
    List<String> pageItems = new List<String>();
    
    if(pageIndex != null)
    {
      dataFinal = buildPNGStrtoSend(pageItems, newsList);  
      connect.response
      ..headers.contentType = contentTypes["text/plain"]
      ..write('$dataFinal');
    }
    else
    {
      response.write('PageIndex is null!');
      response.statusCode = HttpStatus.NOT_FOUND;
    }
  }
  else
  {
    response.write('<a href=\'\\\'>Oops!Let us go home!</a>');
    response.statusCode = HttpStatus.NOT_FOUND;
  }
    connect.close();
}

String buildPNGStrtoSend(List<String> itemsfetched, List<String> newsList) {
  //fetch png of indexed page
  for(int j = 0; j< pageIndex.length; j++)
  {
    itemsfetched.add(newsList[pageIndex[j]]);
  }
  
  //get id list
  List<String> idList = new List<String>();
  mapNews(String news)
  {
    Map idMap = Json.parse(news);
    idList.add(idMap['id']);
  }
  itemsfetched.forEach((String news)=>mapNews(news));
  
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
  String dataFinal = da.slice(1, da.length-1);
  return dataFinal;
}