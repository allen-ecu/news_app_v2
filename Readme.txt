What to Fix:
-----------------------------
Now the server can get POST data sent from the browser side!!

Notice:
-------------------------------
This app is incompatible with Stream v0.6.0
This app is run on Steam v0.5.5

Following Steps:
-------------------------------
Save data to file
Upload photo to server.
Get IP address from user.
Save date to WebDB or IndexedDB
Load news from DB and send to client

What has changed?
-------------------------------
No need HttpServer, because we are using a server named Steam 0.6.0
The client : send json and set header content-type:application/json
The server: response addstream : Hello

Versions:
-------------------------------
Last Version: V2
This Version: V2.1

Introduction:
-------------------------------
This app allow user to enter a news in the browser.
The browser sends the news to the server.
The server saves the news to database.
The server looks up the database and load news in the browser on Google map.
The browser lists the latest news within the user's area according to his IP address.
Server: web/webapp/main.dart
Client: 127.0.0.1:8080
Both the client and server are written in Dart Language M3.

Contact:
-------------------------------
Author: Mao Weiqing
Email: admin@weiqingmao.com.au
Date: 24 March 2013
