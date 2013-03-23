//Auto-generated by RSP Compiler
//Source: web\webapp\home.rsp.html
part of server;

/** Template, home, for rendering the view. */
void home(HttpConnect connect) { //4
  var _cxs = new List<HttpConnect>(), request = connect.request, response = connect.response, _v_;

  if (!connect.isIncluded)
    response.headers.contentType = new ContentType.fromString("""text/html; charset=utf-8""");

  response.addString("""

<!DOCTYPE html>
<html>
  <head>
    <title>Map App</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=no">
    <meta charset="utf-8">
    <link href="theme.css" rel="stylesheet">
  </head>
  <body>
  
  <div>
    
  <div class="header">
  <h1>"News Board App" Demonstration (Dart, Rikulo Steam, XML, MySQL, JS)</h1>
  </div>
  
  <div class="sidebar">
  <h2>News Updater</h2>
  
  <table>
    <tr><td><label>Title</label></td><td><input class="text" id="title" name="title" placeholder= "Enter your news title here" autofocus="true"/></td></tr>
    <tr><td><label>Description</label></td><td><textarea class="text" id="description" name="description" placeholder= "Enter your news description here" cols="38" rows="5"></textarea></td></tr>
    <tr><td><label>Photo</label></td><td><input type="file" id="photo" name="photo" accept="image/*"/></td></tr>
    <tr><td><label>Date</label></td><td><input type="datetime-local" id="time" name="time"/></td></tr>
    <tr><td><button id="submit">Submit</button></td></tr>
  </table>
  
  </div>
  
  <div class="news">
  <h2>Lastest News</h2>
  </div>
  
  <div class="body">
  <h2>News Distribution</h2>
  <p id="mapinfo">Share news with everyone in everywhere.</p>
  <div id="mapholder"></div> 
  </div>
    
  <div class="footer">
  Mao Weiqing, Perth, Western Australia, 2013. Email: admin@weiqingmao.com.au  FOR DEMOSTRATION ONLY.
  </div>
  
  </div>
  
    <script src="http://maps.googleapis.com/maps/api/js?sensor=false"></script>
    <script type="application/dart" src="../client.dart"></script>
    <script src="../packages/browser/dart.js"></script>
    <!--jscript version for non-dart browser-->
    <!--<script src="../client.dart.js""></script>-->
  </body>
</html>
"""); //#4

  connect.close();
}
