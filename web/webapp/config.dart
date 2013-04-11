//Configuration
part of server;

final PORT = '80';
final HOST= 'http://newsapp2.herokuapp.com';

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