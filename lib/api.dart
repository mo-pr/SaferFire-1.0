import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:http/http.dart';

class info extends StatefulWidget {

  info(String ff) {
    feuerwehr = ff;
  }

  @override
  infoState createState() => infoState();
}

String feuerwehr;

class infoState extends State<info> {
  String ffString;
  AudioCache cache = AudioCache();
  var body, alarmBody, alarm;
  var num, time, stage, type, coords, subtype, feuerwehren, location, status;
  static double _lat, _lng;
  int alarmAmount;
  bool isQuit = false;

  void _readAPI() async {
    final res = await get(
        Uri.parse('https://intranet.ooelfv.at/webext2/rss/json_2tage.txt'));
    setState(() {
      ffString = feuerwehr;
    });
    body = json.decode(res.body);
    alarmBody = body['einsaetze'];
    alarmAmount = body['cnt_einsaetze'];
  }

  void getAPI() async {
    await _readAPI();
    _lat = 0.0;
    _lng = 0.0;
    for (int i = 0; i < alarmAmount; i++) {
      if (alarmBody[i.toString()].toString().contains(ffString)) {
        if (isQuit == false) {
          //cache.play('gong_bf.mp3');
        }
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
          isQuit = true;
          alarm = alarmBody[i.toString()]['einsatz'];
          num = alarm['num1'];
          time = "\n" + alarm['startzeit'];
          stage = alarm['alarmstufe'].toString();
          status = alarm['status'];
          type = "\n"+ alarm['einsatztyp']['text'];
          coords = "\n" +
              alarm['wgs84']['lat'].toString() +
              " " +
              alarm['wgs84']['lng'].toString();
          _lat = alarm['wgs84']['lat'];
          _lng = alarm['wgs84']['lng'];
          subtype = "\n" +alarm['einsatzsubtyp']['text'];
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
          if(status.toString().contains('abgeschlossen')){
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
    return num == null
        ? Container(
            padding: EdgeInsets.only(top: (MediaQuery.of(context).size.height/3)),
            alignment: FractionalOffset.center,
            child: Text(
              "Zur Zeit liegt kein Alarm vor",
              style: TextStyle(color: Colors.white, fontSize: 26),
              textAlign: TextAlign.center,
            ),
          )
        : Container(
            width: double.infinity,
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.fromLTRB(25, 10, 25, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Einsatztyp:${subtype != null ? subtype : ""}\n",
                  style: TextStyle(color: Colors.white70, fontSize: 19),
                  textAlign: TextAlign.left,
                ),
                Text(
                  "Einsatzart:${type != null ? type : ""}\n",
                  style: TextStyle(color: Colors.white70, fontSize: 19),
                  textAlign: TextAlign.left,
                ),
                Text(
                  "Einsatzort: ${location != null ? location : ""}\n",
                  style: TextStyle(color: Colors.white70, fontSize: 18),
                  textAlign: TextAlign.left,
                ),
                Text(
                  "Alarmstufe: ${stage != null ? stage : ""}\n",
                  style: TextStyle(color: Colors.white70, fontSize: 18),
                  textAlign: TextAlign.left,
                ),
                Text(
                  "Alarmzeit:${time != null ? time : ""}\n",
                  style: TextStyle(color: Colors.white70, fontSize: 17),
                  textAlign: TextAlign.left,
                ),
                Text(
                  "Feuerwehren: ${feuerwehren != null ? feuerwehren : ""}\n",
                  style: TextStyle(color: Colors.white70, fontSize: 19),
                  textAlign: TextAlign.left,
                ),
              ],
            ),
          );
  }
}