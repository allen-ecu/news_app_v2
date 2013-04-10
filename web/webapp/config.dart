//Configuration
part of server;

final PORT = int.parse(Platform.environment['PORT']).toString();
final HOST= int.parse(Platform.environment['HOST']).toString();

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