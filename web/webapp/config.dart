//Configuration
part of server;

final HOST = "0.0.0.0"; // eg: localhost 
final PORT = 8080; 

//URI mapping
var _mapping = {
  "/": home,
  "/send": serverInfo,
  "/receive": clientInfo,
  "/png": receivePNG,
  "/pngReceive": sendPNG,
};

var _errormapping = {
   "404": "/webapp/404.html",
   "500": "/webapp/500.html"
};