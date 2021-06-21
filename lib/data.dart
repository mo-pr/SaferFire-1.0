
import 'dart:ui';
import 'dart:io';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:safer_fire_test/protocol.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

import 'oxygenPage.dart';

String datum;
String uhrzeit;
String alarmiertDurch;
String ausgeruecktUm;
String feuerwehr;
String einsatzgrund;
String einsatzort;
String anforderungsDurch;
String benoetigt;
String wichtigeHinweise;
String telefon;
String funk;
String schadenslage;
String vorkommnisseTaetigkeiten;
String Mannschaftsstaerke;
String Fahrzeuge;

List<Einsatzbericht> berichte;
var body, alarmBody, alarm;
var num, time, stage, type, coords, subtype, feuerwehren, location, status;
double _lat = 0, _lng= 0;
int alarmAmount = 0;

class Data{

  Data(){
    berichte = <Einsatzbericht>[];
    CreatFakeData();
  }


  void CreatFakeData (){
    Einsatzbericht bericht01 = new Einsatzbericht("12.1","14:20","FF-Zwettl a/d Rodl","Brand","Zwettl a/d Rodl");
    Einsatzbericht bericht02= new Einsatzbericht("15.2","14:20","FF-Linz","Brand","Linz");
    Einsatzbericht bericht03 = new Einsatzbericht("24.4","14:20","FF-Traun","Brand","Traun");
    Einsatzbericht bericht04 = new Einsatzbericht("03.5","14:20","FF-Wels","Brand","Wels");
    Einsatzbericht bericht05 = new Einsatzbericht("29.5","14:20","FF-Graz","Brand","Graz");
    Einsatzbericht bericht06 = new Einsatzbericht("14.6","14:20","FF-Traberg","Brand","Traberg");

    berichte.add(bericht01);
    berichte.add(bericht02);
    berichte.add(bericht03);
    berichte.add(bericht04);
    berichte.add(bericht05);
    berichte.add(bericht06);
  }


  List GetData(){
    return berichte;
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
    OpenFile.open('$path/$name');
  }


  getProtocol(){
    Object entry = protocolEntries[0];
    String test = entry.toString();
    protocolEntries;
  }
}

class Einsatzbericht{
  String datum;
  String uhrzeit;
  String alarmiertDurch;
  String ausgeruecktUm;
  String feuerwehr;
  String einsatzgrund;
  String einsatzort;
  String anforderungsDurch;
  String benoetigt;
  String wichtigeHinweise;
  String telefon;
  String funk;
  String schadenslage;
  String vorkommnisseTaetigkeiten;
  String Mannschaftsstaerke;
  String Fahrzeuge;

  Einsatzbericht(this.datum, this.uhrzeit, this.feuerwehr, this.einsatzgrund, this.einsatzort);

  String GetPlace(){
    return einsatzort;
  }

  @override
  String toString() {
    return 'Einsatzbericht{einsatzort: $einsatzort}';
  }
}

