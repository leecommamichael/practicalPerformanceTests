import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';

void main() => runApp(MyApp());

const double dLat = 0.000017;
const double dLon = 0.00008;

double raise(double base, double difference) {
  int signModifier = base < 0 ? -1 : 1;
  return signModifier * (base.abs() + difference.abs());
}

List<LatLng> makeBreedingPlotCoords( LatLng bottomRight) {
  return [
    bottomRight,
    LatLng(bottomRight.latitude, raise(bottomRight.longitude, dLon)),
    LatLng(raise(bottomRight.latitude, dLat), raise(bottomRight.longitude, dLon)),
    LatLng(raise(bottomRight.latitude, dLat), bottomRight.longitude),
  ];
}

List<Polygon> makeField(LatLng bottomRight, int numRows, int numCols, double padSize) {
  List<Polygon> plots = [];

  for (int i=1; i<=numCols; i++) {
          final spaceDueToRowPadding = (i - 1) * padSize;
          final spaceDueToRowOffset = i * dLon;
          for (int ii=1; ii<=numRows; ii++) {
                  final spaceDueToColumnPadding = (ii - 1) * padSize;
                  final spaceDueToColumnOffset = ii * dLat;
                  LatLng thisBottomRight = LatLng(
                          raise(raise(bottomRight.latitude, spaceDueToColumnOffset), spaceDueToColumnPadding),
                          raise(raise(bottomRight.longitude, spaceDueToRowOffset), spaceDueToRowPadding)
                  );
                  plots.add(Polygon(points: makeBreedingPlotCoords(thisBottomRight)));
          }
  }

  return plots;
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Center(child: 
        Container(color: Color.fromRGBO(255, 25, 55, 1),
        child: FlutterMap(
      options: MapOptions(
        center: LatLng(38.789, -90.308),
        zoom: 5,
        minZoom: 1.0,
        maxZoom: 100.0,
      ),
      layers: [
        TileLayerOptions(
          urlTemplate: "https://api.tiles.mapbox.com/v4/{id}/{z}/{x}/{y}@2x.png?access_token={accessToken}",
          additionalOptions: {
            'accessToken': 'pk.eyJ1IjoibGVlY29tbWFtaWNoYWVsIiwiYSI6ImNrMGx2NWl4NTBvMm0zYnVwY3kwdzJqaXUifQ.YwgWp2ybvWqmxbU3YA5smA',
            'id': 'mapbox.streets',
          },
        ),
        MarkerLayerOptions(
          markers: [
            Marker(
              width: 5.0,
              height: 5.0,
              point: LatLng(38.790, -90.308),
              builder: (ctx) =>
              Container(
                child: FlutterLogo(),
              ),
            ),
          ],
        ),
        PolygonLayerOptions(polygons: [
                Polygon(
                  points: makeBreedingPlotCoords(LatLng(38.789, -90.308))
                )                
              ] + makeField(LatLng(38.789, -90.308), 100, 500, 0.0000075),
            )
          ]
        )
    )
  ),
);
}
}