import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter_sparkline/flutter_sparkline.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:safer_fire_test/data.dart';

// Zeiten Daten
List<charts.Series<Task, String>> _timeSharing;

// UnfallType Daten
var accidentTypeDataFront;
List<charts.Series<Pollution, String>> _accidentLevel;
List<charts.Series<Task, String>> _accidentType;

// Betroffenen Daten
List<charts.Series<InjuredData, String>> _injuredData;

class Data{


  Data() {
    TimeSpentData();
    AccidentType();
    Involved();
  }

  void TimeSpentData(){
    _timeSharing = List<charts.Series<Task, String>>();

    var accidentTypes = [
      new Task('Anfahrt', 12, Colors.blue),
      new Task('Einsatz', 50, Colors.red),
      new Task('Aufräumen', 45, Colors.green),
      new Task('Schreibtisch', 32, Colors.grey),
    ];

    _timeSharing.add(
      charts.Series(
        domainFn: (Task task, _) => task.task,
        measureFn: (Task task, _) => task.taskvalue,
        colorFn: (Task task, _) =>
            charts.ColorUtil.fromDartColor(task.colorval),
        id: 'Air Pollution',
        data: accidentTypes,
        labelAccessorFn: (Task row, _) => '${row.taskvalue}',
      ),
    );
  }

  void AccidentType(){
    _accidentLevel = List<charts.Series<Pollution, String>>();
    _accidentType = List<charts.Series<Task, String>>();

    accidentTypeDataFront = [48.0, 30.0, 61.0, 129.0, 246.0, 67.0];
    var level1Data = [
      new Pollution(1980, 'Brand', 80),
      new Pollution(1980, 'Technisch', 21),
      new Pollution(1980, 'Schadstoff', 10),
    ];
    var level2Data = [
      new Pollution(1985, 'Brand', 200),
      new Pollution(1980, 'Technisch', 150),
      new Pollution(1985, 'Schadstoff', 80),
    ];
    var level3Data = [
      new Pollution(1985, 'Brand', 30),
      new Pollution(1980, 'Technisch', 300),
      new Pollution(1985, 'Schadstoff', 180),
    ];

    var accidentTypes = [
      new Task('Technischer Einsatz', 25, Colors.blue),
      new Task('Brandeinsatz', 25, Colors.red),
      new Task('Schadstoffeinsatz', 25, Colors.green),
      new Task('Anderes', 25, Colors.grey),
    ];

    _accidentLevel.add(
      charts.Series(
        domainFn: (Pollution pollution, _) => pollution.place,
        measureFn: (Pollution pollution, _) => pollution.quantity,
        id: '1',
        data: level1Data,
        fillPatternFn: (_, __) => charts.FillPatternType.solid,
        fillColorFn: (Pollution pollution, _) =>
            charts.ColorUtil.fromDartColor(Colors.yellow),
      ),
    );

    _accidentLevel.add(
      charts.Series(
        domainFn: (Pollution pollution, _) => pollution.place,
        measureFn: (Pollution pollution, _) => pollution.quantity,
        id: '2',
        data: level2Data,
        fillPatternFn: (_, __) => charts.FillPatternType.solid,
        fillColorFn: (Pollution pollution, _) =>
            charts.ColorUtil.fromDartColor(Colors.orange),
      ),
    );

    _accidentLevel.add(
      charts.Series(
        domainFn: (Pollution pollution, _) => pollution.place,
        measureFn: (Pollution pollution, _) => pollution.quantity,
        id: '3',
        data: level3Data,
        fillPatternFn: (_, __) => charts.FillPatternType.solid,
        fillColorFn: (Pollution pollution, _) =>
            charts.ColorUtil.fromDartColor(Colors.red),
      ),
    );

    _accidentType.add(
      charts.Series(
        domainFn: (Task task, _) => task.task,
        measureFn: (Task task, _) => task.taskvalue,
        colorFn: (Task task, _) =>
            charts.ColorUtil.fromDartColor(task.colorval),
        id: 'accidentType',
        data: accidentTypes,
        labelAccessorFn: (Task row, _) => '${row.taskvalue}',
      ),
    );
  }

  void Involved(){
    _injuredData = List<charts.Series<InjuredData, String>>();

    var injuredData = [
      new InjuredData(2021, '14-Tagen', 0),
      new InjuredData(2021, '10-Tagen', 6),
      new InjuredData(2021, '8-Tagen', 2),
      new InjuredData(2021, '5-Tagen', 1),
      new InjuredData(2021, '2-Tagen', 4),
    ];

    _injuredData.add(
      charts.Series(
        domainFn: (InjuredData injuredData, _) => injuredData.place,
        measureFn: (InjuredData injuredData, _) => injuredData.quantity,
        id: 'injured',
        data: injuredData,
        fillPatternFn: (_, __) => charts.FillPatternType.solid,
        fillColorFn: (InjuredData injuredData, _) =>
            charts.ColorUtil.fromDartColor(Colors.blue),
      ),
    );
  }
}



class ChartsPage extends StatefulWidget {
  @override
  ChartsPageState createState() => ChartsPageState();
//_HomePageState createState() => _HomePageState();
}

class ChartsPageState extends State<ChartsPage> {

  Data data01 = new Data();

  //Einsatzbericht test01 = berichte.first;

  ChartsPageState(){
    Data _data = new Data();
  }

  var data = [48.0, 30.0, 61.0, 129.0, 246.0, 67.0];
  var data1 = [0.0,-2.0,3.5,-2.0,0.5,0.7,0.8,1.0,2.0,3.0,3.2];

  Material myTextItems(String title, String subtitle){
    return Material(
      color: Colors.white,
      elevation: 14.0,
      borderRadius: BorderRadius.circular(24.0),
      shadowColor: Color(0x802196F3),
      child: Center(
        child:Padding(
          padding: EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment:MainAxisAlignment.center,
            children: <Widget>[
              Column(
                mainAxisAlignment:MainAxisAlignment.center,
                children: <Widget>[

                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child:Text(title,style:TextStyle(
                      fontSize: 20.0,
                      color: Colors.blueAccent,
                    ),),
                  ),

                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child:Text(subtitle,style:TextStyle(
                      fontSize: 30.0,
                    ),),
                  ),

                ],
              ),
            ],
          ),
        ),
      ),
    );
  }


  Material myCircularItems(String title, String subtitle){
    return Material(
      color: Colors.white,
      elevation: 14.0,
      borderRadius: BorderRadius.circular(24.0),
      shadowColor: Color(0x802196F3),
      child: Center(
        child:Padding(
          padding: EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment:MainAxisAlignment.center,
            children: <Widget>[
              Column(
                mainAxisAlignment:MainAxisAlignment.center,
                children: <Widget>[

                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child:Text(title,style:TextStyle(
                      fontSize: 20.0,
                      color: Colors.blueAccent,
                    ),),
                  ),

                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child:Text(subtitle,style:TextStyle(
                      fontSize: 30.0,
                    ),),
                  ),

                ],
              ),
            ],
          ),
        ),
      ),
    );
  }


  Material mychart1Items(String title, String priceVal,String subtitle) {
    return Material(
      color: Colors.white,
      elevation: 14.0,
      borderRadius: BorderRadius.circular(24.0),
      shadowColor: Color(0x802196F3),
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(2.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[

                  Padding(
                    padding: EdgeInsets.all(1.0),
                    child: Text(title, style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.blueAccent,
                    ),),
                  ),

                  Padding(
                    padding: EdgeInsets.all(1.0),
                    child: Text(priceVal, style: TextStyle(
                      fontSize: 30.0,
                    ),),
                  ),
                  Padding(
                    padding: EdgeInsets.all(1.0),
                    child: Text(subtitle, style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.blueGrey,
                    ),),
                  ),

                  Padding(
                    padding: EdgeInsets.all(0.1),
                    child: new Sparkline(
                      data: data,
                      lineColor: Color(0xffff6101),
                      pointsMode: PointsMode.all,
                      pointSize: 8.0,
                    ),
                  ),

                ],
              ),
            ],
          ),
        ),
      ),
    );
  }


  Material mychart2Items(String title, String priceVal,String subtitle) {
    return Material(
      color: Colors.white,
      elevation: 14.0,
      borderRadius: BorderRadius.circular(24.0),
      shadowColor: Color(0x802196F3),
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[

                  Padding(
                    padding: EdgeInsets.all(1.0),
                    child: Text(title, style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.blueAccent,
                    ),),
                  ),

                  Padding(
                    padding: EdgeInsets.all(1.0),
                    child: Text(priceVal, style: TextStyle(
                      fontSize: 30.0,
                    ),),
                  ),
                  Padding(
                    padding: EdgeInsets.all(1.0),
                    child: Text(subtitle, style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.blueGrey,
                    ),),
                  ),

                  Padding(
                    padding: EdgeInsets.all(0.5),
                    child: new Sparkline(
                      data: data1,
                      fillMode: FillMode.below,
                      fillGradient: new LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.blue, Colors.white],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }




  Material deploymentsItem(String date, String time, String place){
    return Material(
      color: Colors.white,
      elevation: 14.0,
      borderRadius: BorderRadius.circular(8.0),
      shadowColor: Color(0x802196F3),
      child: Center(
        child:Padding(
          padding: EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment:MainAxisAlignment.center,
            children: <Widget>[
              Column(
                mainAxisAlignment:MainAxisAlignment.center,
                children: <Widget>[

                  Padding(
                    padding: EdgeInsets.all(6.0),
                    child:Text(date,style:TextStyle(
                      fontSize: 20.0,
                      color: Colors.red,
                    ),),
                  ),

                  Padding(
                    padding: EdgeInsets.all(6.0),
                    child:Text(time,style:TextStyle(
                      fontSize: 30.0,
                    ),),
                  ),

                  Padding(
                    padding: EdgeInsets.all(1.0),
                    child:Text(place,style:TextStyle(
                      fontSize: 18.0,
                      color:Colors.grey,
                    ),),
                  ),

                ],
              ),
            ],
          ),
        ),
      ),
    );
  }




  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: TabBar(
            indicatorColor: Colors.red,
            tabs: [
              Padding(
                  padding: EdgeInsets.all(12),
                  child: Text('Einsätze',
                      style: TextStyle(fontSize: 18, color: Colors.black))),
              Padding(
                  padding: EdgeInsets.all(12),
                  child: Text('Daten',
                      style: TextStyle(fontSize: 18, color: Colors.black))),
            ],
          ),
          body: TabBarView(
            children: [
              Padding(
                padding: EdgeInsets.all(6.0),
                child: StaggeredGridView.count(
                  crossAxisCount: 4,
                  crossAxisSpacing: 0.2,
                  mainAxisSpacing: 0.2,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => DeploymentsPage("011","Linz","FF-Gründberg","Autounfall","12:45")),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        child: deploymentsItem("gestern","20 min", "Linz"),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => DeploymentsPage("012","Zwettl an der Rodl","FF-Zwettl, FF-Badleonfleden","Brand","16:15")),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        child: deploymentsItem("vor 2 Tagen","48 min", "Zwettl"),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => DeploymentsPage("013","Wels","FF-Traun","Sturz","8:20")),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        child: deploymentsItem("vor 3 Tagen","45 min", "Wels"),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(6),
                      child: deploymentsItem("vor 5 Tagen","112 min", "Linz"),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(6),
                      child: deploymentsItem("vor 8 Tagen", "34 min", "Traberg"),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(6),
                      child: deploymentsItem("vor 12 Tagen", "219 min", "Graz"),
                    ),

                  ],
                  staggeredTiles: [
                    StaggeredTile.extent(4, 140.0),
                    StaggeredTile.extent(2, 140.0),
                    StaggeredTile.extent(2, 140.0),
                    StaggeredTile.extent(2, 140.0),
                    StaggeredTile.extent(2, 140.0),
                    StaggeredTile.extent(2, 140.0),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: StaggeredGridView.count(
                  crossAxisCount: 4,
                  crossAxisSpacing: 12.0,
                  mainAxisSpacing: 12.0,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => StartPage()),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        child: mychart1Items("Dauer","50","~Einsatzdauer"),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => AccidentType()),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        child: myCircularItems("Einsatz","  25%\nBrand"),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Injured()),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        child: myTextItems("Verletzte","~3"),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right:8.0),
                      child: myTextItems("Beteiligte","25M"),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: mychart2Items("Einsatzorte"," ","Oberösterreich"),
                    ),

                  ],
                  staggeredTiles: [
                    StaggeredTile.extent(4, 250.0),
                    StaggeredTile.extent(2, 250.0),
                    StaggeredTile.extent(2, 120.0),
                    StaggeredTile.extent(2, 120.0),
                    StaggeredTile.extent(4, 250.0),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DeploymentsPage extends StatelessWidget {

  String _location = null;
  String _feuerwehren = null;
  String _subtype = null;
  String _coords = null;
  String _type = null;
  String _stage = null;
  String _time = null;
  String _id = null;

  DeploymentsPage(String id, String location, String feuerwehren, String type, String time){
    _location = location;
    _feuerwehren = feuerwehren;
    _type = type;
    _time = time;
    _id = id;
  }

  Container deploymentData(String title, String data){
    return Container(
      margin: const EdgeInsets.all(5),
      padding: EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(6),
            topRight: Radius.circular(6),
            bottomLeft: Radius.circular(6),
            bottomRight: Radius.circular(6)
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Text(title + ': ' + data, textAlign: TextAlign.left, style: TextStyle(fontSize: 20),),
          ),
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text("Einsatz: " + _id),
      ),
      body: Container(
        color: Colors.white,
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Container(
                  child: Text('Einsatz', textAlign: TextAlign.center, style: TextStyle(fontSize: 36,),),
                ),
                Container(
                  child: Text('Bilder:', style: TextStyle(fontSize: 20),),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ImageGallary()),
                    );
                  },
                  child: Image.asset('assets/images/fire.png',width: 400,height: 200,fit: BoxFit.cover),
                ),
                SizedBox(  height: 10,),
                Text('ID: ' + _id, style: TextStyle(fontSize: 30),),
                Divider(
                  height: 20,
                  thickness: 4,
                  color: Colors.grey,
                ),
                deploymentData('Ort', _location),
                deploymentData('Feuerwehren', _feuerwehren),
                deploymentData('Einsatzart', _type),
                deploymentData('Zeit', _time),
                deploymentData('Dauer', '1h 42min'),
                SizedBox(  height: 20,),
                OutlinedButton(
                  onPressed: () {
                    print('Protokoll wurde erstellt');
                    },
                  child: const Text('Protokoll erstellen', style: TextStyle(fontSize: 18,color: Colors.red,),),
                ),
                SizedBox(  height: 40,),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ImageGallary extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Gallary"),
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Container(
                  child: Image.asset('assets/images/fire.png',width: 400,height: 200,fit: BoxFit.cover),
                ),
                SizedBox(  height: 15,),
                Container(
                  child: Image.asset('assets/images/fire02.png',width: 400,height: 200,fit: BoxFit.cover),
                ),
                SizedBox(  height: 15,),
                Container(
                  child: Image.asset('assets/images/fire03.png',width: 400,height: 200,fit: BoxFit.cover),
                ),
                SizedBox(  height: 15,),
                Container(
                  child: Image.asset('assets/images/fire04.jpg',width: 400,height: 200,fit: BoxFit.cover),
                ),
                SizedBox(  height: 15,),
                Container(
                  child: Image.asset('assets/images/fire05.jpg',width: 400,height: 200,fit: BoxFit.cover),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class StartPage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
//ChartsPageState createState() => ChartsPageState();
}


class _HomePageState extends State<StartPage> {
  List<charts.Series<Sales, int>> _seriesLineData;

  _generateData() {

    var linesalesdata = [
      new Sales(0, 48),
      new Sales(1, 30),
      new Sales(2, 61),
      new Sales(3, 129),
      new Sales(4, 246),
      new Sales(5, 67),
    ];

    _seriesLineData.add(
      charts.Series(
        colorFn: (__, _) => charts.ColorUtil.fromDartColor(Colors.blue),
        id: 'Air Pollution',
        data: linesalesdata,
        domainFn: (Sales sales, _) => sales.yearval,
        measureFn: (Sales sales, _) => sales.salesval,
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _seriesLineData = List<charts.Series<Sales, int>>();
    _generateData();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.red,
            //backgroundColor: Color(0xff308e1c),
            bottom: TabBar(
              indicatorColor: Colors.grey,
              tabs: [
                Tab(icon: Icon(FontAwesomeIcons.chartPie)),
                Tab(icon: Icon(FontAwesomeIcons.chartLine)),
              ],
            ),
            title: Text('Dauer'),
            leading: GestureDetector(
              onTap: () { Navigator.pop(context); },
              child: Icon(
                Icons.arrow_back_rounded,  // add custom icons also
              ),
            ),
          ),
          body: TabBarView(
            children: [
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Container(
                  child: Center(
                    child: Column(
                      children: <Widget>[
                        Text(
                          'Zeitaufteilung',style: TextStyle(fontSize: 24.0,fontWeight: FontWeight.bold),),
                        SizedBox(height: 10.0,),
                        Expanded(
                          child: charts.PieChart(
                              _timeSharing,
                              animate: false,
                              //animationDuration: Duration(seconds: 1),
                              behaviors: [
                                new charts.DatumLegend(
                                  outsideJustification: charts.OutsideJustification.endDrawArea,
                                  horizontalFirst: false,
                                  desiredMaxRows: 2,
                                  cellPadding: new EdgeInsets.only(right: 4.0, bottom: 4.0),
                                  entryTextStyle: charts.TextStyleSpec(
                                      color: charts.MaterialPalette.black,
                                      fontSize: 18),
                                )
                              ],
                              defaultRenderer: new charts.ArcRendererConfig(
                                  arcWidth: 80,
                                  startAngle: 4 / 5 * pi,
                                  arcLength: 7 / 5 * pi,
                                  arcRendererDecorators: [
                                    new charts.ArcLabelDecorator(
                                        labelPosition: charts.ArcLabelPosition.inside)
                                  ]
                              )
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Container(
                  child: Center(
                    child: Column(
                      children: <Widget>[
                        Text(
                          'Gesamteinsatzdauer der letzten Monate',style: TextStyle(fontSize: 20.0,fontWeight: FontWeight.bold),),
                        Expanded(
                          child: charts.LineChart(
                              _seriesLineData,
                              defaultRenderer: new charts.LineRendererConfig(
                                  includeArea: false, stacked: true, includePoints: true),
                              animate: false,
                              //animationDuration: Duration(seconds: 1),
                              behaviors: [
                                new charts.ChartTitle('Monat',
                                    behaviorPosition: charts.BehaviorPosition.bottom,
                                    titleOutsideJustification:charts.OutsideJustification.middleDrawArea),
                                new charts.ChartTitle('Dauer in min',
                                    behaviorPosition: charts.BehaviorPosition.start,
                                    titleOutsideJustification: charts.OutsideJustification.middleDrawArea)
                              ]
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Pollution {
  String place;
  int year;
  int quantity;

  Pollution(this.year, this.place, this.quantity);
}

class Task {
  String task;
  double taskvalue;
  Color colorval;

  Task(this.task, this.taskvalue, this.colorval);
}

class Sales {
  int yearval;
  int salesval;

  Sales(this.yearval, this.salesval);
}







class AccidentType extends StatefulWidget {
  @override
  AccidentTypeState createState() => AccidentTypeState();
//ChartsPageState createState() => ChartsPageState();
}


class AccidentTypeState extends State<AccidentType> {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.red,
            //backgroundColor: Color(0xff308e1c),
            bottom: TabBar(
              indicatorColor: Colors.grey,
              tabs: [
                Tab(icon: Icon(FontAwesomeIcons.chartPie)),
                Tab(icon: Icon(FontAwesomeIcons.solidChartBar),),
              ],
            ),
            title: Text('Einsatzdaten'),
            leading: GestureDetector(
              onTap: () { Navigator.pop(context); },
              child: Icon(
                Icons.arrow_back_rounded,  // add custom icons also
              ),
            ),
          ),
          body: TabBarView(
            children: [
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Container(
                  child: Center(
                    child: Column(
                      children: <Widget>[
                        Text(
                          'Unfallarten',style: TextStyle(fontSize: 24.0,fontWeight: FontWeight.bold),),
                        SizedBox(height: 10.0,),
                        Expanded(
                          child: charts.PieChart(
                              _accidentType,
                              animate: false,
                              //animationDuration: Duration(seconds: 1),
                              behaviors: [
                                new charts.DatumLegend(
                                  outsideJustification: charts.OutsideJustification.endDrawArea,
                                  horizontalFirst: false,
                                  desiredMaxRows: 2,
                                  cellPadding: new EdgeInsets.only(right: 4.0, bottom: 4.0),
                                  entryTextStyle: charts.TextStyleSpec(
                                      color: charts.MaterialPalette.purple.shadeDefault,
                                      fontSize: 18),
                                )
                              ],
                              defaultRenderer: new charts.ArcRendererConfig(
                                  arcWidth: 100,
                                  arcRendererDecorators: [
                                    new charts.ArcLabelDecorator(
                                        labelPosition: charts.ArcLabelPosition.inside)
                                  ])),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Container(
                  child: Center(
                    child: Column(
                      children: <Widget>[
                        Text(
                          'Alarmstuffe 1-2-3',style: TextStyle(fontSize: 24.0,fontWeight: FontWeight.bold),),
                        Expanded(
                          child: charts.BarChart(
                            _accidentLevel,
                            animate: false,
                            barGroupingType: charts.BarGroupingType.grouped,
                            //behaviors: [new charts.SeriesLegend()],
                            //animationDuration: Duration(seconds: 1),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}







class Injured extends StatefulWidget {
  @override
  InjuredState createState() => InjuredState();
//ChartsPageState createState() => ChartsPageState();
}


class InjuredState extends State<Injured> {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 1,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.red,
            //backgroundColor: Color(0xff308e1c),
            bottom: TabBar(
              indicatorColor: Colors.grey,
              tabs: [
                Tab(icon: Icon(FontAwesomeIcons.solidChartBar),),
              ],
            ),
            title: Text('Einsatzdaten'),
            leading: GestureDetector(
              onTap: () { Navigator.pop(context); },
              child: Icon(
                Icons.arrow_back_rounded,  // add custom icons also
              ),
            ),
          ),
          body: TabBarView(
            children: [
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Container(
                  child: Center(
                    child: Column(
                      children: <Widget>[
                        Text(
                          'Verletzte',style: TextStyle(fontSize: 24.0,fontWeight: FontWeight.bold),),
                        Expanded(
                          child: charts.BarChart(
                            _injuredData,
                            animate: true,
                            //behaviors: [new charts.SeriesLegend()],
                            animationDuration: Duration(seconds: 1),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class InjuredData {
  String place;
  int year;
  int quantity;

  InjuredData(this.year, this.place, this.quantity);
}