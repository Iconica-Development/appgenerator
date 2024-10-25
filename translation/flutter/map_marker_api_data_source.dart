import 'root.dart';
//#pragma: imports
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_geojson/flutter_map_geojson.dart';
import 'package:json_path/json_path.dart';
import 'dart:convert';


//#pragma: config
{ 
  defaultGetter: "getList"
}

//#pragma: declaration
class MapLayer<T> {
  final String name;
  final T layerObject;

  const MapLayer({this.name = '', required this.layerObject});

  MapLayer<T> copyWith({
    String? name,
    T? layerObject,
  }) {
    return MapLayer<T>(
      name: name ?? this.name,
      layerObject: layerObject ?? this.layerObject,
    );
  }
}
class MapLayers {
  final List<MapLayer<Polygon<Object>>> polygonLayer;
  final List<MapLayer<Polyline<Object>>> polylineLayer;
  final List<MapLayer<Marker>> markerLayer;
  // final List<Polygon<Object>> polygonLayers;
  // final List<Polyline<Object>> polylineLayers;
  // final List<Marker> markerLayers;

  MapLayers({
        this.markerLayer = const [], 
        this.polygonLayer = const [], 
        this.polylineLayer = const [],
        });

  List<Polygon<Object>> get polygons => polygonLayer.map((e) => e.layerObject).toList();
  List<Polyline<Object>> get polylines => polylineLayer.map((e) => e.layerObject).toList();
  List<Marker> get markers => markerLayer.map((e) => e.layerObject).toList();

  MapLayers copyWith({
    List<MapLayer<Polygon<Object>>>? polygonLayer,
    List<MapLayer<Polyline<Object>>>? polylineLayer,
    List<MapLayer<Marker>>? markerLayer,
  }) {
    return MapLayers(
      polygonLayer: polygonLayer ?? this.polygonLayer,
      polylineLayer: polylineLayer ?? this.polylineLayer,
      markerLayer: markerLayer ?? this.markerLayer,
    );
  }
}

class MapMarkerApiDataSource extends ChangeNotifier {
  String url = "";
  MapMarkerApiDataSource({required this.mappings, this.url = ""});
  // String mapping = "[[mapping]]";
  List<dynamic>  response = [];
  List<String> errors = [];
  Map<String, dynamic> filter = {};
  Map<String, String> mappings;


  set ur(v) {
      url = v;
      notifyListeners();
      
  }

  Future<List<dynamic>> load() async {
    () async { 
      try {
        var urlWithFilter = url;
        // add all filters to the url
        if (filter.length > 0) {
          urlWithFilter += "?";
          filter.forEach((key, value) {
            urlWithFilter += "$key=$value&";
          });
        }
        response = json.decode(await http.read(Uri.parse(urlWithFilter))); notifyListeners();
      } catch(e) {
        print("ERROR: $e");
        errors.add("Timeout, API source is not available");
        notifyListeners();
     }
      }();
    return response;
  }

  Future<void> updateFilter(Map<String, dynamic> filter) async {
    var filterItems = <String, dynamic>{};
    this.filter.forEach((key, value) {
      filterItems[key] = value;
    });
    filter.forEach((key, value) {
      filterItems[key] = value;
    });
    this.filter = filterItems;
    load();
  }

  setValue(u)  { url = u; () async { response = json.decode(await http.read(Uri.parse(url))); notifyListeners(); }();}
  List<Item>  getList()  { 
    print(response);
    print(mappings);
     return response.map((e) =>
      Item(
        title: mappings['title'] != null ? _getJsonPathValue(mappings['title']!, e) : "",
        subtitle: mappings['subtitle'] != null ? _getJsonPathValue(mappings['subtitle']!, e) : "",
        detailtext: mappings['detailtext'] != null ? _getJsonPathValue(mappings['detailtext']!, e) : "",
        tag: mappings['tag'] != null ? _getJsonPathValue(mappings['tag']!, e) : "",
        icon: mappings['icon'] != null ? _getJsonPathValue(mappings['icon']!, e) : "",
        longitude: mappings['longitude'] != null ? _getJsonPathValue(mappings['longitude']!, e).toString() : "",
        latitude: mappings['latitude'] != null ? _getJsonPathValue(mappings['latitude']!, e).toString() : "",
        image: mappings['image'] != null ? _getJsonPathValue(mappings['image']!, e) : "",
        additionalAttributes: 
      )
      ).toList();
      }
  List<String> getErrors() => errors;

  _getJsonPathValue(String path, Map<String, dynamic> json) {
    var formattedPath = '\$.$path';
    print('PATH: $formattedPath');
    JsonPath jsonPath = JsonPath(formattedPath);
    var matches = jsonPath.read(json);
    if (matches.length > 0) {
      return matches.first.value.toString();
    } else {
      return "";
    }
  }
}

             
//#pragma: global
MapMarkerApiDataSource datasource[[id]] = MapMarkerApiDataSource(url:'[[url]]', mappings:[[data_mapper]].mappingsAsMap);

//#pragma: setup
datasource[[id]].addListener((){
  setState(() {});
});
datasource[[id]].load(); 