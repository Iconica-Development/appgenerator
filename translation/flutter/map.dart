//#pragma: imports
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_hooks/flutter_hooks.dart';


//#pragma: config
{ 
  defaultAction: "setFilter",
  defaultGetter: "getList"
}




//#pragma: declaration
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
    var markers = ##SOURCE## as List<Item>;
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
          urlTemplate: "[[tileUrl]]",
        ),
        MarkerLayer(markers: markersWithHitValue),
        ...[const PolylineLayer(polylines: <Polyline<Object>>[])],
      ],
    );
  }
}

//#pragma: execution
SizedBox(width: 500, height: 500, child: HydroMap()),



