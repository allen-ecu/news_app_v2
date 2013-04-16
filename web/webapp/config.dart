//Configuration
part of server;

final HOST = "10.1.1.3"; // eg: localhost 
final PORT = 5050; 

//URI mapping
var _mapping = {
  "/": home,
  "/send": receiveJSON,
  "/receive": sendJSON,
  "/png": receivePNG,
  "/pngreceive": sendPNG,
  "/receiveinfo": sendInfo,
  "/sendinfo": receiveInfo
};

var _errormapping = {
   "404": "/webapp/404.html",
   "500": "/webapp/500.html"
};