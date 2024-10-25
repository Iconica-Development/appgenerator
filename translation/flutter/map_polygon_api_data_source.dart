//#pragma: imports
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_geojson/flutter_map_geojson.dart';

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

class MapApiDataSource extends ChangeNotifier {
  String url = "";
  MapLayers  response = MapLayers();
  MapApiDataSource({this.url = ""}) ;
  Map<String, MapLayers Function(dynamic apiData)> dataAdapters = {};
  MapClickEvent? _currentEvent;


  set ur(v) {
      url = v;
      notifyListeners();
      
  }
  MapLayers load() {
    http.read(Uri.parse(url)).then((httpResponse) {
        for (var dataAdapterEntry in dataAdapters.entries) {
          var key = dataAdapterEntry.key;
          var value = dataAdapterEntry.value;
          if (url.contains(key)) {
            response = value(json.decode(httpResponse));
          }
        }
        notifyListeners();
      });
    return response;
  }

  setValue(u)  { url = u; load();}
  MapLayers getValue() { return response; }

  MapLayers localHostDataAdapter(dynamic apiData) {
    var myGeoJson = GeoJsonParser();
    myGeoJson!.parseGeoJson(apiData);
    var polygonsLayer = <MapLayer<Polygon<Object>>>[];

    for (int i = 0; i < myGeoJson.polygons.length; i++) {
      var name = apiData['features'][i]['properties']['name'];
      polygonsLayer.add(MapLayer<Polygon<Object>>(name: name, layerObject: myGeoJson.polygons[i]));
    }
    
    return MapLayers(
      markerLayer: [],
      polygonLayer: polygonsLayer,
      polylineLayer: [],
    );
  }
}
             
//#pragma: global
MapApiDataSource datasource[[id]] = MapApiDataSource(url:'[[url]]');

//#pragma: setup
datasource[[id]].addListener((){
  setState(() {});
});
datasource[[id]].dataAdapters['localhost'] = datasource[[id]].localHostDataAdapter;
datasource[[id]].load();