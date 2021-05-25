import 'package:flutter/material.dart';
import 'package:map_launcher/map_launcher.dart';

import 'api.dart';
import 'sharedloginregister.dart';

class map extends StatefulWidget {
  const map({Key key}) : super(key: key);

  @override
  _mapState createState() => _mapState();
}

class _mapState extends State<map> {
  double lat, lng;
  @override
  void initState() {
    setState(() {
      lat = infoState().getlat();
      lng = infoState().getlng();
    });
    super.initState();
  }

  void loadMap()async{
    if (await MapLauncher.isMapAvailable(MapType.google)) {
      await MapLauncher.showMarker(
        mapType: MapType.google,
        coords: Coords(lat, lng),
        title: "Alarm",
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if(lat != null && lng != null && lat != 0 && lng != 0){
      loadMap();
      return Container(
        child: Text(
          "Es liegt ein Alarm vor",
          style: TextStyle(color: Colors.white, fontSize: 28),
          textAlign: TextAlign.center,
        ),
      );
    }
    else{
      return Container(
        child: Text(
          "Zur Zeit liegt kein Alarm vor",
          style: TextStyle(color: Colors.white, fontSize: 28),
          textAlign: TextAlign.center,
        ),
      );
    }
  }
}
