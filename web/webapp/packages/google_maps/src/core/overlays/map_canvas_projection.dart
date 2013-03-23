// Copyright (c) 2012, Alexandre Ardhuin
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

part of google_maps;

class MapCanvasProjection extends MVCObject {
  static final INSTANCIATOR = (js.Proxy jsProxy) => new MapCanvasProjection.fromJsProxy(jsProxy);

  MapCanvasProjection.fromJsProxy(js.Proxy jsProxy) : super.fromJsProxy(jsProxy);

  LatLng fromContainerPixelToLatLng(Point pixel, [bool nowrap]) => $.fromContainerPixelToLatLng(pixel, nowrap).map(LatLng.INSTANCIATOR).value;
  LatLng fromDivPixelToLatLng(Point pixel, [bool nowrap]) => $.fromDivPixelToLatLng(pixel, nowrap).map(LatLng.INSTANCIATOR).value;
  Point fromLatLngToContainerPixel(LatLng latLng) => $.fromLatLngToContainerPixel(latLng).map(Point.INSTANCIATOR).value;
  Point fromLatLngToDivPixel(LatLng latLng) => $.fromLatLngToDivPixel(latLng).map(Point.INSTANCIATOR).value;
  num get worldWidth => $.getWorldWidth().value;
}