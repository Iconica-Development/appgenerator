import 'package:flutter/material.dart';
 
 import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_geojson/flutter_map_geojson.dart';
import 'package:json_path/json_path.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

 class Item {
  String title;
  String subtitle;
  String longitude;
  String latitude;
  String image;
  String detailtext;
  String tag;
  String icon;
  Map<String, dynamic> additionalAttributes;

  Item(
      {this.title = "",
      this.subtitle = "",
      this.longitude = "",
      this.latitude = "",
      this.image = "",
      this.detailtext = "",
      this.tag = "",
      this.icon = "",
      this.additionalAttributes = const {}});

  Item.fromJson(Map<String, dynamic> json)
      : title = json['title'],
        subtitle = json['subtitle'],
        longitude = json['longitude'],
        latitude = json['latitude'],
        image = json['image'],
        detailtext = json['detailtext'],
        tag = json['tag'],
        icon = json['icon'],
        additionalAttributes = json;

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'subtitle': subtitle,
      'longitude': longitude,
      'latitude': latitude,
      'image': image,
      'detailtext': detailtext,
      'tag': tag,
      'icon': icon,
      ...additionalAttributes
    };
  }
}


class StringWrapper {
  late dynamic value;
  StringWrapper([dynamic value]) {
    this.value = value ?? "";
  }
}

class StateEntry {
  late int id;
  dynamic value;
  StateEntry({required this.id, this.value});
}
class StateMnmgt {
  List<StateEntry> state = []; 
  getState(id) {
    return state.where((s) => s.id == id).first.value;
  }
  setState(int id, value) {
    for (var item in state) {
        if (item.id == id) { item.value = value; return; }  
    }
    state.add(StateEntry(id:id, value:value));
  } 
}

StateMnmgt statemanagement = StateMnmgt(); 
 
 
class HydroBarChartData {
  final String xLabel;
  final double yValue;

  HydroBarChartData(this.xLabel, this.yValue);
}

class BarChartApiDatasource extends ChangeNotifier {
  String url = "";
  List<HydroBarChartData>  response = [];
  BarChartApiDatasource({this.url = ""}) ;
  Map<String, List<HydroBarChartData> Function(dynamic apiData)> dataAdapters = {};
  Map<String, dynamic> filter = {};
  Map<String, String Function()> endpointBuilders = {};
  

  set ur(v) {
      url = v;
      notifyListeners();
      
  }
  List<HydroBarChartData> load() {
    var urlName = '';
    
    for (var endpointBuilderKey in endpointBuilders.keys) {
      var key = endpointBuilderKey;
      if (url.contains(key)) {
        urlName = key;
      }
    }

    var urlWithFilter = endpointBuilders[urlName]!();

    print('Loading data from $urlWithFilter');

    http.read(Uri.parse(urlWithFilter)).then((httpResponse) {
        response = dataAdapters[urlName]!(json.decode(httpResponse));
        notifyListeners();
      });
    return response;
  }

  setValue(u)  { url = u; () async { response = json.decode(await http.read(Uri.parse(url))); notifyListeners(); }();}
  void setFilter(Map<String, dynamic> filter)  { 
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
  List<dynamic>  getValue()  { return response; }

  List<HydroBarChartData> localHostDataAdapter(dynamic apiData) {
    var data = apiData as List<dynamic>;
    var chartDataList = <HydroBarChartData>[];
    
    for (var chartDataEntry in data) {
      var entry = chartDataEntry as Map<String, dynamic>;
      var timestamp = entry['day'];
      var date = DateTime.parse(timestamp);
      var day = DateFormat('dd/MM').format(date);
      var rainfall = entry['rainfall'];
       chartDataList.add(HydroBarChartData(day, rainfall));
    }
    return chartDataList;
  }

  String localHostEndpointBuilder() {
    var filterString = '?';
    filterString += 'province=${filter['name']}&';
    // filterString += 'latitude=${filter['latitude']}&';
    // filterString += 'longitude=${filter['longitude']}&';
    return url + filterString;
  }
}
             


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
  // String mapping = "";
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
      )
      ).toList();
      }
  List<String> getErrors() => errors;

  _getJsonPathValue(String path, Map<String, dynamic> json) {
    var formattedPath = '\$.$path';
    print('PATH: $formattedPath');
    JsonPath jsonPath = JsonPath(formattedPath);
    var matches = jsonPath.read(json);
    print("i found the following amount of matches: ${matches.length}");
    if (matches.length > 0) {
      print("MATCH FOUND: ${matches.first.value}");
      return matches.first.value.toString();
    } else {
      return "";
    }
  }
}

             


class DataMapper {
  DataMapper({required this.attributeMappings});
  final List<AttributeMapping> attributeMappings;

  Map<String, String> get mappingsAsMap => Map.fromEntries(attributeMappings.map((e) => MapEntry(e.attributeName, e.jsonAttribute)));
}



class AttributeMapping {
  AttributeMapping({
    required this.attributeName,
    required this.jsonAttribute,
  });
  final String attributeName;
  final String jsonAttribute;
}



class HydroMap extends StatefulWidget {
  const HydroMap({super.key});

  @override
  State<HydroMap> createState() => _HydroMapState();

}

class _HydroMapState extends State<HydroMap> {

  @override
  void initState() {
    super.initState();

  }

  @override
  void dispose() {
    super.dispose();
  }  

  @override
  Widget build(BuildContext context) {
    var markers = datasource2.getList()
 as List<Item>;
    var markersWithHitValue = <Marker>[];

    void addTapEvents() {
      for (var marker in markers) {
        markersWithHitValue.add(Marker(
          point:  LatLng(double.parse(marker.latitude), double.parse(marker.longitude)),
          child: GestureDetector(
            onTap: () {
              var event = marker;
              print('clicked on marker: ${event.title}');
            },
            child: Icon(Icons.location_on),
          ),
        ));
      }
    }

    addTapEvents();

    return FlutterMap(
      options: MapOptions(
        initialCenter: LatLng(52.37, 4.90),
      ),
      children: [
        TileLayer(
          urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
        ),
        MarkerLayer(markers: markersWithHitValue),
        ...[const PolylineLayer(polylines: <Polyline<Object>>[])],
      ],
    );
  }
}



class HydroRangeSlider extends StatefulWidget {
  const HydroRangeSlider({super.key});

  @override
  State<HydroRangeSlider> createState() => _HydroRangeSliderState();
}

class _HydroRangeSliderState extends State<HydroRangeSlider> {
  RangeValues values = const RangeValues(0, 200);

  @override
  Widget build(BuildContext context) {
    return 
    SliderTheme(
      data: SliderTheme.of(context).copyWith(
        showValueIndicator: ShowValueIndicator.always,
      ),
      child:
    RangeSlider(
      values: values,
      min: 0,
      max: 200,
      labels: RangeLabels(
        values.start.round().toString(),
        values.end.round().toString(),
      ),
      onChanged: (RangeValues newValues) {
        setState(() {
          values = newValues;
        });
        var event = {
          'fromDate': values.start.round().toString(),
          'toDate': values.end.round().toString(),
        };
        datasource2.updateFilter(event);

      },
    ),);
  }
}



class HydroBarChart extends StatelessWidget {
  const HydroBarChart({super.key});

  @override
  Widget build(BuildContext context) {
    var dataList = datasource1.getValue()
;
    return SizedBox(
      width: 500,
      height: 500,
      child: BarChart(BarChartData(
      barGroups: 
      dataList.asMap().entries.map((e) => BarChartGroupData(
        x: e.key,
        barRods: [BarChartRodData(toY: e.value.yValue)],
      )).toList(),
      titlesData: FlTitlesData(
            show: true,
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 22,
                getTitlesWidget: (value, meta) {
                  var label = dataList[value.toInt()].xLabel;
                  return Text(
                    label,
                    style: const TextStyle(
                      fontSize: 15,
                    ),
                  );
                },
              ),
            ),
            rightTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: false,
              ),
            ),
            topTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: false,
              ),
            ),
          )
    )));
  }
}





 
 
BarChartApiDatasource datasource1 = BarChartApiDatasource(url:'http://localhost:1337/rain');






MapMarkerApiDataSource datasource2 = MapMarkerApiDataSource(url:'http://localhost:1337/weather-stations', mappings: DataMapper(
  attributeMappings: [
    
AttributeMapping(
  attributeName: 'title',
  jsonAttribute: 'title', 
),



AttributeMapping(
  attributeName: 'longitude',
  jsonAttribute: 'longitude', 
),



AttributeMapping(
  attributeName: 'latitude',
  jsonAttribute: 'latitude', 
),



AttributeMapping(
  attributeName: 'subtitle',
  jsonAttribute: 'weatherData[0].actualRainfallMM', 
),



  ],
).mappingsAsMap);



void main() { 
    runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter App Generator Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Map'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
   @override
  void initState() {
    
datasource1.addListener((){
  setState(() {});
});
datasource1.dataAdapters['localhost'] = datasource1.localHostDataAdapter;
datasource1.endpointBuilders['localhost'] = datasource1.localHostEndpointBuilder;
datasource1.load();

datasource2.addListener((){
  setState(() {});
});
datasource2.load(); 

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            


SizedBox(width: 500, height: 500, child: HydroMap()),





SizedBox(width: 500, height: 50, child: HydroRangeSlider()),

HydroBarChart(),

GestureDetector(onTap:(){ dynamic event; }, child:Text("${StringWrapper().value != '' ? StringWrapper().value : 'Rainfall'}", style: Theme.of(context).textTheme.headlineMedium)),
 
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}