//#pragma: imports
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_hooks/flutter_hooks.dart';


//#pragma: config
{ 
  defaultAction: "setFilter" 
}




//#pragma: declaration
class MapClickEvent {
  final String? name;
  final LatLng? coordinate;
  final Marker? marker;
  final Polyline? polyline;
  final Polygon? polygon;

  MapClickEvent({
    this.coordinate,
    this.marker,
    this.polyline,
    this.polygon,
    this.name,
    });

  MapClickEvent copyWith({
    LatLng? coordinate,
    Marker? marker,
    Polyline? polyline,
    Polygon? polygon,
    String? name,
  }) {
    return MapClickEvent(
      coordinate: coordinate ?? this.coordinate,
      marker: marker ?? this.marker,
      polyline: polyline ?? this.polyline,
      polygon: polygon ?? this.polygon,
      name: name ?? this.name,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'latitude': coordinate?.latitude,
      'longitude': coordinate?.longitude,
    };
  }
}
class HydroMap extends StatefulWidget {
  const HydroMap({super.key});

  @override
  State<HydroMap> createState() => _HydroMapState();

}

class _HydroMapState extends State<HydroMap> {
  final LayerHitNotifier hitNotifier = ValueNotifier(null);
  final LayerHitNotifier eventNotifier = ValueNotifier(null);

  @override
  void initState() {
    super.initState();
    eventNotifier.addListener(() {
      if (eventNotifier.value != null) {
        print(eventNotifier.value);
        var hitResult = eventNotifier.value as LayerHitResult<Object>;
        if (hitResult.hitValues.isEmpty) {
          return;
        }
        MapClickEvent mapClickEvent = hitResult.hitValues.first as MapClickEvent;
        mapClickEvent = mapClickEvent.copyWith(coordinate: hitResult.coordinate);
        print("Coordinate: ${mapClickEvent.coordinate}");
        print("Event: ${mapClickEvent}");
        var event = mapClickEvent.toJson();
        ##TRIGGERS##
  }
});

  }

  @override
  void dispose() {
    eventNotifier.removeListener(() {});
    super.dispose();
  }  

  @override
  Widget build(BuildContext context) {
    var layers = ##SOURCE## as MapLayers;
    var polygons = layers.polygons;

    void addTapEvents() {
      var markerLayers = layers.markerLayer!;
      var markers = <Marker>[];
      for (var marker in markerLayers) {
        markers.add(Marker(
          point: marker.layerObject.point,
          child: GestureDetector(
            onTap: () {},
          ),
        ));
      }

      var polygonsWithHitValue = <Polygon>[];
      for (var entry in layers.polygonLayer) {
        var polygon = entry.layerObject;
        var poly = Polygon(
          points: polygon.points,
          holePointsList: polygon.holePointsList,
          color: polygon.color,
          borderStrokeWidth: polygon.borderStrokeWidth,
          borderColor: polygon.borderColor,
          disableHolesBorder: polygon.disableHolesBorder,
          pattern: polygon.pattern,
          strokeCap: polygon.strokeCap,
          strokeJoin: polygon.strokeJoin,
          label: polygon.label,
          labelStyle: polygon.labelStyle,
          labelPlacement: polygon.labelPlacement,
          rotateLabel: polygon.rotateLabel,
          hitValue: MapClickEvent(name: entry.name, polygon: polygon),
        );
        polygonsWithHitValue.add(poly);
      }
      polygons = polygonsWithHitValue;
    }

    addTapEvents();

    return FlutterMap(
      options: MapOptions(
        initialCenter: LatLng(52.37, 4.90),
        onTap: (_, __) {
          eventNotifier.value = hitNotifier.value;
        },
      ),
      children: [
        TileLayer(
          urlTemplate: "[[tileUrl]]",
        ),
        ...[MarkerLayer(markers: [])],
        ...[PolygonLayer(hitNotifier: hitNotifier, polygons: polygons)],
        ...[const PolylineLayer(polylines: <Polyline<Object>>[])],
      ],
    );
  }
}

//#pragma: execution
SizedBox(width: 500, height: 500, child: HydroMap()),



