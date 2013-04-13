//Mao Weiqing, Master of Computer Scicence, Edith Cowan University, 2012, Western Australia
//Email: dustonlyperth@gmail.com

//Server
library server;

import 'dart:math' as Math;
import 'dart:io';
import 'dart:async';
import 'dart:json' as Json;
import "package:stream/stream.dart";
import 'package:xml/xml.dart' as xml;
import 'package:unittest/unittest.dart';
import 'package:rikulo_commons/mirrors.dart';

part "config.dart";
part "home.rsp.dart";
part "serverInfo.dart";

var curTime =new DateTime.now().toLocal().toString();
String maxTime, minTime;

class NewsInfo {
  String title;
  String description;
  String photo;
  String time;
  String ip;
  NewsInfo(this.title, this.description, this.photo, this.time, this.ip);
}


void main() {
  
  String t1 = curTime.slice(0,10);
  String t2 = curTime.slice(11,16);
  String t3 = 'T$t2';
  maxTime = '$t1$t3';
  
  new StreamServer(uriMapping: _mapping, errorMapping: _errormapping)
  ..port = 5050
  ..host = '10.1.1.3'
  ..start();
}
