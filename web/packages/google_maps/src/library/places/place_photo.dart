// Copyright (c) 2013, Alexandre Ardhuin
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

part of google_maps_places;

class PlacePhoto extends jsw.IsJsProxy {
  static final INSTANCIATOR = (js.Proxy jsProxy) => new PlacePhoto.fromJsProxy(jsProxy);

  PlacePhoto() : super();
  PlacePhoto.fromJsProxy(js.Proxy jsProxy) : super.fromJsProxy(jsProxy);

  num get height => $.height.value;
  List<String> get htmlAttributions => $.html_attributions.map((js.Proxy jsProxy) => new jsw.JsList<String>.fromJsProxy(jsProxy, null)).value;
  num get width => $.width.value;
  set height(num height) => $.height = height;
  set htmlAttributions(List<String> htmlAttributions) => $.html_attributions = htmlAttributions;
  set width(num width) => $.width = width;
}