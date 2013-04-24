Change Log:
V3.0
------------------------------------------------------------------
What to Fix:
-----------------------------
IndexRangerError
Next, Pre buttons

Next:
-------------------------------
Mouseover news event: popup photos

What has changed?
-------------------------------
Add cookies, sessions
Support more than one user
Add current page number, total pages
fix some minor issues
Warning: not compatiable with version higher than r20602, such as M4 (v21823)
Steam upgraded to v0.7.0
Dart Editor 0.4.3_r20602
Dart SDK 0.4.3.5_r20602
Server: main.dart
Client: 10.1.1.11:5050
The localhost has changed to 10.1.1.11:5050 for testing in my case.
You must use r20602 version and Stream v0.6.2 to in order to run the codes correctly.

Versions:
-------------------------------
Last Version: V2.9
This Version: V3.0

Change Log:
V2.9
------------------------------------------------------------------
What to Fix:
-----------------------------
Pagenite
Session

Next:
-------------------------------
Restrict the data up to today
Create List
Redesign html
Save date to WebDB or IndexedDB
Load news from DB and send to client

What has changed?
-------------------------------
Add page next prev function
Add load list
fix some minor issues
Steam upgraded to v0.6.2
Dart Editor 0.4.5_r21094
Dat SDK 0.4.5.1_r21094
Server: main.dart
Client: 10.1.1.11:5050
The localhost has changed to 10.1.1.11:5050 for testing in my case.
You must use r20602 version and Stream v0.6.2 to in order to run the codes correctly.

Versions:
-------------------------------
Last Version: V2.8
This Version: V2.9

Change Log:
V2.8
------------------------------------------------------------------
What to Fix:
-----------------------------
N/A

Next:
-------------------------------
Restrict the data up to today
Create List
Redesign html
Save date to WebDB or IndexedDB
Load news from DB and send to client

What has changed?
-------------------------------
Allow to upload photos in loop
Click on icon to open InfoWindow, click on icon to close InfoWindow
Only one InfoWindow instance is allowed
Environment prerequisite:
Steam upgraded to v0.6.2
Dart Editor 0.4.3_r20602
Dat SDK 0.4.3.5_r26062
Server: main.dart
Client: 10.1.1.11:5050
The localhost has changed to 10.1.1.11:5050 for testing in my case.
You must use r20602 version and Stream v0.6.2 to in order to run the codes correctly.

Versions:
-------------------------------
Last Version: V2.7
This Version: V2.8

Change Log:
V2.7 (M1)
------------------------------------------------------------------
What to Fix:
-----------------------------
1.After uploaded photos, can't upload photos again
2.Need "keep uploading photos, remove the last one, add the new one" <===
3.JSON.json and x.news need to be presented

Next:
-------------------------------
Retrieve the JSON data from the server.
Upload photo to server.
Get IP address from user.
Save date to WebDB or IndexedDB
Load news from DB and send to client

What has changed?
-------------------------------
Only allow one instance of InfoWindow at any time
User must upload at least one photo along with the news
If there are less than four photos for one news, it loads the default photo
Users can upload news with photos, and submit to the server, the sever than load both the description and photos of the news
There are significant changes since last update.
Environment prerequisite:
Steam upgraded to v0.6.2
Dart Editor 0.4.3_r20602
Dat SDK 0.4.3.5_r26062
Server: main.dart
Client: 10.1.1.11:5050
The localhost has changed to 10.1.1.11:5050 for testing in my case.
You must use r20602 version and Stream v0.6.2 to in order to run the codes correctly.

Versions:
-------------------------------
Last Version: V2.6
This Version: V2.7

Change Log:
V2.6
------------------------------------------------------------------
What to Fix:
-----------------------------
1.upload photos to the server
2.refine the json format
3.validate the users input before submt

Next:
-------------------------------
Retrieve the JSON data from the server.
Upload photo to server.
Get IP address from user.
Save date to WebDB or IndexedDB
Load news from DB and send to client

What has changed?
-------------------------------
Customized InfoWindow, put css photo carosoul, comment, and more details.
When the users submit the data, the lat,lnt coordinates will be sent to the server as well
Changed to new marker icons
The server now can save the data using Sync read method.
The client can receive the json data from the server
Steam upgraded to v0.6.2
Dart Editor 0.4.3_r20602
Dat SDK 0.4.3.5_r26062
The localhost has changed to 10.1.1.11:5050 for testing in my case.
You must use r20602 version and Stream v0.6.2 to in order to run the codes correctly.

Versions:
-------------------------------
Last Version: V2.5
This Version: V2.6

Change Log:
V2.5
------------------------------------------------------------------
What to Fix:
-----------------------------
1.to polish the info window
2.upload photo to the server
3.refine the json format
4.validate the users input before submt

Next:
-------------------------------
Retrieve the JSON data from the server.
Upload photo to server.
Get IP address from user.
Save date to WebDB or IndexedDB
Load news from DB and send to client

What has changed?
-------------------------------
Customized InfoWindow, put css photo carosoul, comment, and more details.


Versions:
-------------------------------
Last Version: V2.4
This Version: V2.5

Change Log:
V2.4
------------------------------------------------------------------
What to Fix:
-----------------------------
1.to polish the info window
2.upload photo to the server
3.refine the json format
4.validate the users input before submt

Next:
-------------------------------
Retrieve the JSON data from the server.
Upload photo to server.
Get IP address from user.
Save date to WebDB or IndexedDB
Load news from DB and send to client

What has changed?
-------------------------------
When the users submit the data, the lat,lnt coordinates will be sent to the server as well
Changed to new marker icons

Versions:
-------------------------------
Last Version: V2.3
This Version: V2.4

Change Log:
V2.3
------------------------------------------------------------------
What to Fix:
-----------------------------
1.ask google map to get the current lat, long coordinates of user
2.upload photo to the server
3.refine the json format
4.validate the users input before submt

Next:
-------------------------------
Retrieve the JSON data from the server.
Upload photo to server.
Get IP address from user.
Save date to WebDB or IndexedDB
Load news from DB and send to client

What has changed?
-------------------------------
The server now can save the data using Sync read method.
The client can receive the json data from the server
Now the browser will load the data json feed from the server when its loading

Versions:
-------------------------------
Last Version: V2.2
This Version: V2.3

Change Log:
V2.2
------------------------------------------------------------------
What to Fix:
-----------------------------
somehow the server can print out the json data, but can't save it to a variable!

Next:
-------------------------------
Retrieve the JSON data from the server.
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
Last Version: V2.1
This Version: V2.2

Change Log:

V2.1
------------------------------------------------------------------
What to Fix:
-----------------------------
Now the server can get POST data sent from the browser side!!

Next:
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
Last Version: V2.0
This Version: V2.1

=====================================================
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

Notice:
-------------------------------
This app is incompatible with Stream v0.6.0
This app is run on Steam v0.5.5
Disable the apache server is you have
Remove Avast V8 Antivirus Software if you have connection problem
Contact:
-------------------------------
Author: Mao Weiqing
Email: admin@weiqingmao.com.au
Date: 15 March 2013