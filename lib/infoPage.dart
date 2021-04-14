import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class info extends StatefulWidget {
  @override
  InfoPage createState() => InfoPage();
}

class InfoPage extends State<info> {
  var body, alarmBody, alarm;
  var num, time, stage, type, coords, subtype, feuerwehren, location, status;
  static double _lat, _lng;
  int alarmAmount;

  void _readAPI() async {
    //final res = await get(Uri.parse('https://intranet.ooelfv.at/webext2/rss/json_2tage.txt'));
    //final res = await get(Uri.parse('http://192.168.0.8/laufend.txt'));
    final res = await get(Uri.parse('http://86.56.241.47/laufend.txt'));
    body = json.decode(res.body);
    alarmBody = body['einsaetze'];
    alarmAmount = body['cnt_einsaetze'];
  }

  void getAPI() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await _readAPI();
    _lat = 0.0;
    _lng = 0.0;
    for (int i = 0; i < alarmAmount; i++) {
      if (alarmBody[i.toString()].toString().contains(
          preferences.getString("ff"))) {
        setState(() {
          _lat = 0.0;
          _lng = 0.0;
          location = null;
          feuerwehren = null;
          subtype = null;
          coords = null;
          type = null;
          stage = null;
          time = null;
          num = null;
          status = null;
          alarm = alarmBody[i.toString()]['einsatz'];
          num = alarm['num1'];
          time = "\n" + alarm['startzeit'];
          stage = alarm['alarmstufe'].toString();
          status = alarm['status'];
          type = "\n" + alarm['einsatztyp']['text'];
          coords = "\n" +
              alarm['wgs84']['lat'].toString() +
              " " +
              alarm['wgs84']['lng'].toString();
          _lat = alarm['wgs84']['lat'];
          _lng = alarm['wgs84']['lng'];
          subtype = "\n" + alarm['einsatzsubtyp']['text'];
          feuerwehren = "(" + alarm['cntfeuerwehren'].toString() + ")";
          for (int i = 0; i < alarm['cntfeuerwehren']; i++) {
            feuerwehren += "\n" +
                alarm['feuerwehrenarray'][i.toString()]['fwname'];
          }
          location = "\nAdresse: " +
              alarm['adresse']['default'] +
              "\nOrt: " +
              alarm['adresse']['earea'] +
              " / " +
              alarm['adresse']['emun'] +
              "\nStraße: " +
              alarm['adresse']['efeanme'] +
              "\nHausnr.: " +
              alarm['adresse']['estnum'].toString() +
              "\nZusatz: " +
              alarm['adresse']['ecompl'];
          if (status.toString().contains('abgeschlossen')) {
            _lat = 0.0;
            _lng = 0.0;
            location = null;
            feuerwehren = null;
            subtype = null;
            coords = null;
            type = null;
            stage = null;
            time = null;
            num = null;
            status = null;
          }
        }
        );
      }
    }
  }

  set lat(double value) {
    _lat = value;
  }

  set lng(value) {
    _lng = value;
  }

  double getlat() {
    return _lat;
  }

  double getlng() {
    return _lng;
  }


  @override
  Widget build(BuildContext context) {
    getAPI();
    return Scaffold(// you can use Container, it wont be a whole page
      //backgroundColor: Color(0xFFB40284A),

      backgroundColor: Colors.grey[900], // background

      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Info',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.all(32),
        children: [
          num == null ? comingAlert() : comingAlert()
        ],
      )
    );
  }

  Widget test() {
    return Stack(
      children: <Widget>[
        // Stroked text as border.
        Text(
          'Greetings, planet!',
          style: TextStyle(fontSize: 40,
              fontWeight: FontWeight.bold
          ),
        ),
        // Solid text as fill.
        Text(
          'Greetings, planet!',
          style: TextStyle(
            fontSize: 40,
            color: Colors.grey[300],
          ),
        ),
      ],
    );
  }

  Widget noAlert() => RichText(
    text: TextSpan(
      children: [
        TextSpan(
          text: 'Es liegt kein Einsatz vor ',
          style: TextStyle(
            color: Colors.black,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    ),
  );

  Widget comingAlert() => RichText(
    text: TextSpan(
      children: [
        TextSpan(
          text: 'Einsatztyp:\n',
          style: TextStyle(
            fontSize: 20,
            decoration: TextDecoration.underline,
            //decorationStyle: TextDecorationStyle.dashed,
            fontWeight: FontWeight.bold,
          ),
        ),
        TextSpan(
          text: 'none\n\n',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
          ),
        ),
        TextSpan(
          text: 'Einsatzart:\n',
          style: TextStyle(
            fontSize: 20,
            decoration: TextDecoration.underline,
            fontWeight: FontWeight.bold,
          ),
        ),
        TextSpan(
          text: 'none\n\n',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
          ),
        ),
        TextSpan(
          text: 'Einsatzort:\n',
          style: TextStyle(
            fontSize: 20,
            decoration: TextDecoration.underline,
            fontWeight: FontWeight.bold,
          ),
        ),
        TextSpan(
          text: 'none\n\n',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
          ),
        ),
        TextSpan(
          text: 'Alarmstufe:\n',
          style: TextStyle(
            fontSize: 20,
            decoration: TextDecoration.underline,
            fontWeight: FontWeight.bold,
          ),
        ),
        TextSpan(
          text: 'none\n\n',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
          ),
        ),
        TextSpan(
          text: 'Alarmzeit:\n',
          style: TextStyle(
            fontSize: 20,
            decoration: TextDecoration.underline,
            fontWeight: FontWeight.bold,
          ),
        ),
        TextSpan(
          text: 'none\n\n',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
          ),
        ),
        TextSpan(
          text: 'Feuerwehren:\n',
          style: TextStyle(
            fontSize: 20,
            decoration: TextDecoration.underline,
            fontWeight: FontWeight.bold,
          ),
        ),
        TextSpan(
          text: 'none\n\n',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
          ),
        ),
      ],
    ),
  );
}