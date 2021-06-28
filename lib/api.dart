import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

import 'oxygenPage.dart';
import 'protocol.dart';

class info extends StatefulWidget {
  @override
  infoState createState() => infoState();
}

var body, alarmBody, alarm;
var num, time, stage, type, coords, subtype, feuerwehren, location, status;
double _lat = 0, _lng = 0;
int alarmAmount = 0;

class infoState extends State<info> {
  Timer _timer;

  Future<void> _readAPI() async {
    final res = await get(Uri.parse('https://intranet.ooelfv.at/webext2/rss/json_2tage.txt'));
    //final res = await get(Uri.parse('http://192.168.0.8/laufend.txt'));
    //final res = await get(Uri.parse('http://86.56.241.47/laufend.txt'));
    body = json.decode(res.body);
    alarmBody = body['einsaetze'];
    alarmAmount = body['cnt_einsaetze'];
  }

  @override
  void initState() {
    _readAPI();
    _timer = new Timer.periodic(new Duration(seconds: 3), (timer) async {
      await getAPI();
    });
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void getAPI() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await _readAPI();
    _lat = 0.0;
    _lng = 0.0;
    String ff = preferences.getString("ff");
    for (int i = 0; i < alarmAmount; i++) {
      if (alarmBody[i.toString()].toString().contains(ff)) {
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
        time = alarm['startzeit'];
        time = time.toString().substring(0, time.toString().length - 5);
        time = time.toString().substring(0, 16) +
            "\n" +
            time.toString().substring(16);
        stage = alarm['alarmstufe'].toString();
        status = alarm['status'];
        type = alarm['einsatztyp']['text'];
        coords = "\n" +
            alarm['wgs84']['lat'].toString() +
            " " +
            alarm['wgs84']['lng'].toString();
        _lat = alarm['wgs84']['lat'];
        _lng = alarm['wgs84']['lng'];
        subtype = alarm['einsatzsubtyp']['text'];
        feuerwehren = "(" + alarm['cntfeuerwehren'].toString() + ")";
        for (int i = 0; i < alarm['cntfeuerwehren']; i++) {
          feuerwehren +=
              "\n" + alarm['feuerwehrenarray'][i.toString()]['fwname'];
        }
        location = alarm['adresse']['default'] +
            ", " +
            alarm['adresse']['earea'] +
            "\nZusatz: " +
            alarm['adresse']['ecompl'];
        if (status.toString().contains('abgeschlossen')) {
          createPDF(num + ".pdf");
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
    }
  }

  Future<void> createPDF(String name) async {
    String oxygen = persEntries
        .toString()
        .replaceAll(", ", "\n")
        .replaceAll("[", "")
        .replaceAll("]", "");
    String protocol = protocolEntries
        .toString()
        .replaceAll(", ", "\n")
        .replaceAll("[", "")
        .replaceAll("]", "");
    PdfDocument doc = PdfDocument();
    final page = doc.pages.add();
    final pageTwo = oxygen != "" ? doc.pages.add() : null;
    final pageThree = protocol != "" ? doc.pages.add() : null;
    PdfLayoutResult layoutResult = PdfTextElement(
            text: num +
                subtype +
                type +
                location +
                "\nAlarmstufe: " +
                stage +
                time +
                feuerwehren,
            font: PdfStandardFont(PdfFontFamily.helvetica, 12),
            brush: PdfSolidBrush(PdfColor(0, 0, 0)))
        .draw(
            page: page,
            bounds: Rect.fromLTWH(
                0, 0, page.getClientSize().width, page.getClientSize().height),
            format: PdfLayoutFormat(layoutType: PdfLayoutType.paginate));
    page.graphics.drawLine(
        PdfPen(PdfColor(255, 0, 0)),
        Offset(0, layoutResult.bounds.bottom + 10),
        Offset(page.getClientSize().width, layoutResult.bounds.bottom + 10));
    if (oxygen != "") {
      PdfLayoutResult layoutResultTwo = PdfTextElement(
              text: oxygen,
              font: PdfStandardFont(PdfFontFamily.helvetica, 12),
              brush: PdfSolidBrush(PdfColor(0, 0, 0)))
          .draw(
              page: pageTwo,
              bounds: Rect.fromLTWH(0, 0, page.getClientSize().width,
                  page.getClientSize().height),
              format: PdfLayoutFormat(layoutType: PdfLayoutType.paginate));
      pageTwo.graphics.drawLine(
          PdfPen(PdfColor(255, 0, 0)),
          Offset(0, layoutResultTwo.bounds.bottom + 10),
          Offset(pageTwo.getClientSize().width,
              layoutResultTwo.bounds.bottom + 10));
    }
    if (protocol != "") {
      PdfLayoutResult layoutResultThree = PdfTextElement(
              text: protocol,
              font: PdfStandardFont(PdfFontFamily.helvetica, 12),
              brush: PdfSolidBrush(PdfColor(0, 0, 0)))
          .draw(
              page: pageThree,
              bounds: Rect.fromLTWH(0, 0, page.getClientSize().width,
                  page.getClientSize().height),
              format: PdfLayoutFormat(layoutType: PdfLayoutType.paginate));
      pageThree.graphics.drawLine(
          PdfPen(PdfColor(255, 0, 0)),
          Offset(0, layoutResultThree.bounds.bottom + 10),
          Offset(pageThree.getClientSize().width,
              layoutResultThree.bounds.bottom + 10));
    }
    List<int> bytes = doc.save();
    doc.dispose();
    final path = (await getExternalStorageDirectory()).path;
    final file = File('$path/$name');
    await file.writeAsBytes(bytes, flush: true);
    //OpenFile.open('$path/$name');
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
        ? Center(
            child: Container(
              child: Text(
                "Zur Zeit liegt kein Alarm vor",
                style: TextStyle(color: Colors.black87, fontSize: 28),
                textAlign: TextAlign.center,
              ),
            ),
          )
        : Container(
            alignment: Alignment.centerLeft,
            child: ListView(
              children: [
                Text(
                  "${subtype != null ? subtype + "\n(Stufe: ${stage != null ? stage : ""})" : ""}\n",
                  style: TextStyle(color: Colors.black87, fontSize: 19),
                  textAlign: TextAlign.left,
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                Text(
                  "${location != null ? location : ""}\n",
                  style: TextStyle(color: Colors.black87, fontSize: 16),
                  textAlign: TextAlign.left,
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.015),
                Text(
                  "${time != null ? time : ""}\n",
                  style: TextStyle(color: Colors.black87, fontSize: 14),
                  textAlign: TextAlign.left,
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.015),
                Text(
                  "Feuerwehren: ${feuerwehren != null ? feuerwehren : ""}\n",
                  style: TextStyle(color: Colors.black87, fontSize: 14),
                  textAlign: TextAlign.left,
                ),
              ],
            ),
          );
  }
}
