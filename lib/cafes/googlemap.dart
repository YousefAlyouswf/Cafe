import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';

class GoogleMap extends StatefulWidget {
  @override
  _GoogleMapState createState() => _GoogleMapState();
}

class _GoogleMapState extends State<GoogleMap> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Maps Sample App'),
          backgroundColor: Colors.green[700],
        ),
        body: FlutterMap(
            options: new MapOptions(
              center: new LatLng(24.673, 46.803),
              minZoom: 10.0,
            ),
            layers: [
              TileLayerOptions(
                urlTemplate:
                    "https://api.mapbox.com/styles/v1/yousef1989/ck602xox23rok1inxh4rmg7r6/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoieW91c2VmMTk4OSIsImEiOiJjazYwMGZqcHAwMXUzM2xuNXc4Y3V3MmJ4In0.vemoxOpYUpYUJEE-XoKP3A",
                additionalOptions: {
                  'accessToken':
                      'pk.eyJ1IjoieW91c2VmMTk4OSIsImEiOiJjazYwMHZuYXIwMzRuM21sNjNwbzdwc2NlIn0.vemoxOpYUpYUJEE-XoKP3A',
                  'id': 'mapbox.mapbox-streets-v8',
                },
              ),
              new MarkerLayerOptions(markers: [
                new Marker(
                  width: 45,
                  height: 45,
                  point: LatLng(24.673, 46.803),
                  builder: (context)=>new Container(
                    child: IconButton(
                      icon: Icon(Icons.location_on),
                      color: Colors.red,
                      iconSize: 45,
                      onPressed: (){
                        print("Marker point");
                      },
                    ),
                  )
                )
              ])
            ]),
      ),
    );
  }
}
