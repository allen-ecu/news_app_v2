//Server
library server;

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

class NewsInfo {
  String title;
  String description;
  String photo;
  String time;
  String ip;
  NewsInfo(this.title, this.description, this.photo, this.time, this.ip);
}


void main() {
  new StreamServer(uriMapping: _mapping, errorMapping: _errormapping)
  ..port = 8080
  ..host = '127.0.0.1'
  ..start();
}
