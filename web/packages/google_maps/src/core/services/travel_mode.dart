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

class TravelMode extends jsw.IsEnum<String> {
  static final BICYCLING = new TravelMode._(maps.TravelMode.BICYCLING);
  static final DRIVING = new TravelMode._(maps.TravelMode.DRIVING);
  static final TRANSIT = new TravelMode._(maps.TravelMode.TRANSIT);
  static final WALKING = new TravelMode._(maps.TravelMode.WALKING);

  static final _INSTANCES = [BICYCLING, DRIVING, TRANSIT, WALKING];

  static TravelMode find(Object o) => findIn(_INSTANCES, o);

  TravelMode._(String value) : super(value);

  bool operator ==(Object other) => value == (other is TravelMode ? (other as TravelMode).value : other);
}