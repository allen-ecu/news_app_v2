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

class RectangleOptions extends jsw.IsJsProxy {
  set bounds(LatLngBounds bounds) => $.bounds = bounds;
  set clickable(bool clickable) => $.clickable = clickable;
  set draggable(bool draggable) => $.draggable = draggable;
  set editable(bool editable) => $.editable = editable;
  set fillColor(String fillColor) => $.fillColor = fillColor;
  set fillOpacity(num fillOpacity) => $.fillOpacity = fillOpacity;
  set map(GMap map) => $.map = map;
  set strokeColor(String strokeColor) => $.strokeColor = strokeColor;
  set strokeOpacity(num strokeOpacity) => $.strokeOpacity = strokeOpacity;
  set strokePosition(StrokePosition strokePosition) => $.strokePosition = strokePosition;
  set strokeWeight(num strokeWeight) => $.strokeWeight = strokeWeight;
  set visible(bool visible) => $.visible = visible;
  set zIndex(num zIndex) => $.zIndex = zIndex;
}