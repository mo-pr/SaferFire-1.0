import 'package:flutter/material.dart';
import 'package:map_launcher/map_launcher.dart';

import 'api.dart';

class map extends StatefulWidget {
  @override
  _mapState createState() => _mapState();
}

class _mapState extends State<map> {
  double lat = 0, lng = 0;

  @override
  void initState() {
    setState(() {
      lat = infoState().getlat();
      lng = infoState().getlng();
    });
    super.initState();
  }

  void loadMap() async {
    bool isAvailable = false;
    isAvailable = (await MapLauncher.isMapAvailable(MapType.google))!;
    if (isAvailable) {
      await MapLauncher.showMarker(
        mapType: MapType.google,
        coords: Coords(lat, lng),
        title: "Alarm",
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (lat != null && lng != null && lat != 0 && lng != 0) {
      loadMap();
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(
            "Karte",
            style: TextStyle(fontSize: 20),
          ),
          backgroundColor: Color(0xffb32b19),
        ),
        body: Center(
          child: Text(
            "Es liegt ein Alarm vor",
            style: TextStyle(color: Colors.black87, fontSize: 28),
            textAlign: TextAlign.center,
          ),
        ),
      );
    } else {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(
            "Karte",
            style: TextStyle(fontSize: 20),
          ),
          backgroundColor: Color(0xffb32b19),
        ),
        body: Center(
          child: Text(
            "Zur Zeit liegt kein Alarm vor",
            style: TextStyle(color: Colors.black87, fontSize: 28),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }
  }
}
