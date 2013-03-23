//Configuration
part of server;

final HOST = "127.0.0.1"; // eg: localhost 
final PORT = 8080; 

//URI mapping
var _mapping = {
  "/": home,
  "/news": serverInfo,
};

var _errormapping = {
   "404": "/webapp/404.html",
   "500": "/webapp/500.html"
};