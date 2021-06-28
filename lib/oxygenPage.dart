import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Oxygen extends StatefulWidget {
  @override
  _OxygenState createState() => _OxygenState();
}

List<PDFEntry> persEntries = <PDFEntry>[];
List<Entry> entries = <Entry>[];

class _OxygenState extends State<Oxygen> {
  final _key = new GlobalKey<FormState>(), _keyT = new GlobalKey<FormState>();
  String p01, p02, p03, n01, n02, n03;
  Timer _timer;

  String formatTime(int milliseconds) {
    var secs = milliseconds ~/ 1000;
    var hours = (secs ~/ 3600).toString().padLeft(2, '0');
    var minutes = ((secs % 3600) ~/ 60).toString().padLeft(2, '0');
    var seconds = (secs % 60).toString().padLeft(2, '0');
    return "$hours:$minutes:$seconds";
  }

  @override
  void initState() {
    super.initState();
    _timer = new Timer.periodic(new Duration(milliseconds: 30), (timer) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void handleStartStop(int index) {
    if (entries[index]._timer.isRunning) {
      entries[index]._timer.stop();
      persEntries[index]._stoptime = DateTime.now();
    } else {
      entries[index]._timer.start();
      entries[index]._time =
          DateFormat('kk:mm:ss').format(DateTime.now()).toString();
      persEntries[index]._starttime = DateTime.now();
    }
    setState(() {});
  }

  void resetTime(int index){
    if (!entries[index]._timer.isRunning) {
      entries[index]._timer.reset();
    }
  }

  void _promptRemoveTodoItem(int index) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return new AlertDialog(
              title: new Text("Trupp " +
                  (index + 1).toString() +
                  ": Wählen Sie eine Aktion"),
              actions: <Widget>[
                new FlatButton(
                    child: new Text('Start'),
                    onPressed: () {
                      handleStartStop(index);
                      Navigator.of(context).pop();
                    }),
                new FlatButton(
                    child: new Text('Stop'),
                    onPressed: () {
                      handleStartStop(index);
                      Navigator.of(context).pop();
                    }),
                new FlatButton(
                    child: new Text('Reset'),
                    onPressed: () {
                      resetTime(index);
                      Navigator.of(context).pop();
                    })
              ]);
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: entries.isEmpty == true
            ? Container(
                child: Text(
                  "Keine Trupp vorhanden",
                  style: TextStyle(color: Colors.black87, fontSize: 28),
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.all(8),
                scrollDirection: Axis.vertical,
                itemCount: entries.length,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () => _promptRemoveTodoItem(index),
                    child: Container(
                        color: Colors.transparent,
                        child: Card(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                children: [
                                  Text(
                                    "Trupp: " +
                                        entries[index].entryNr.toString(),
                                    style: TextStyle(
                                        fontSize: 19.0, color: Colors.black87),
                                  ),
                                  SizedBox(
                                    height: 4,
                                  ),
                                  Divider(
                                    height: 20,
                                    thickness: 4,
                                    color: Colors.grey,
                                  ),
                                  Text(
                                    entries[index]._getNames(),
                                    style: TextStyle(
                                        fontSize: 19.0,
                                        color: Colors.lightGreen),
                                  ),
                                  SizedBox(
                                    height: 12,
                                  ),
                                  Text(
                                    formatTime(entries[index]
                                        ._timer
                                        .elapsedMilliseconds),
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  ),
                                ],
                              )),
                        )),
                  );
                }),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red,
        child: Icon(Icons.add),
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(Constants.padding),
                ),
                elevation: 0,
                backgroundColor: Colors.transparent,
                child: contentBox(context),
              );
            },
          );
        },
      ),
    );
  }

  contentBox(context) {
    return Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(
              left: Constants.padding,
              top: Constants.padding,
              right: Constants.padding,
              bottom: Constants.padding),
          margin: EdgeInsets.only(top: Constants.avatarRadius),
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Colors.white,
              borderRadius: BorderRadius.circular(Constants.padding),
              boxShadow: [
                BoxShadow(
                    color: Colors.black, offset: Offset(0, 10), blurRadius: 10),
              ]),
          child: Form(
            key: _keyT,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  "Neuer Trupp",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                ),
                TextFormField(
                  validator: (e) {
                    if (e.isEmpty) {
                      return "Person 01 darf nicht leer sein";
                    }
                  },
                  onSaved: (e) => n01 = e,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w300,
                  ),
                  decoration: InputDecoration(
                      prefixIcon: Padding(
                        padding: EdgeInsets.only(left: 20, right: 15),
                      ),
                      contentPadding: EdgeInsets.all(18),
                      labelText: "Person 01"),
                ),
                TextFormField(
                  validator: (e) {
                    if (e.isEmpty) {
                      return "Person 02 darf nicht leer sein";
                    }
                  },
                  onSaved: (e) => n02 = e,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w300,
                  ),
                  decoration: InputDecoration(
                      prefixIcon: Padding(
                        padding: EdgeInsets.only(left: 20, right: 15),
                      ),
                      contentPadding: EdgeInsets.all(18),
                      labelText: "Person 02"),
                ),
                TextFormField(
                  onSaved: (e) => n03 = e,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w300,
                  ),
                  decoration: InputDecoration(
                      prefixIcon: Padding(
                        padding: EdgeInsets.only(left: 20, right: 15),
                      ),
                      contentPadding: EdgeInsets.all(18),
                      labelText: "Person 03"),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: FlatButton(
                      onPressed: () {
                        final form = _keyT.currentState;
                        if (form.validate()) {
                          form.save();
                          Navigator.of(context).pop();
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return Dialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(Constants.padding),
                                ),
                                elevation: 0,
                                backgroundColor: Colors.transparent,
                                child: pressureBox(context),
                              );
                            },
                          );
                        }
                      },
                      child: Text(
                        "Speichern",
                        style: TextStyle(fontSize: 18),
                      )),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          left: Constants.padding,
          right: Constants.padding,
          child: CircleAvatar(
            backgroundColor: Colors.transparent,
            radius: Constants.avatarRadius,
            child: ClipRRect(
              borderRadius:
                  BorderRadius.all(Radius.circular(Constants.avatarRadius)),
              //child: Image.asset("assets/images/logo_small_icon_only_inverted.png")
            ),
          ),
        ),
      ],
    );
  }

  pressureBox(context) {
    return Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(
              left: Constants.padding,
              top: Constants.padding,
              right: Constants.padding,
              bottom: Constants.padding),
          margin: EdgeInsets.only(top: Constants.avatarRadius),
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Colors.white,
              borderRadius: BorderRadius.circular(Constants.padding),
              boxShadow: [
                BoxShadow(
                    color: Colors.black, offset: Offset(0, 10), blurRadius: 10),
              ]),
          child: Form(
            key: _key,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  "Sauerstoff",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                ),
                TextFormField(
                  validator: (e) {
                    if (e.isEmpty) {
                      return "Druck von Person 01 darf nicht leer sein";
                    }
                  },
                  onSaved: (e) => p01 = e,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w300,
                  ),
                  decoration: InputDecoration(
                      prefixIcon: Padding(
                        padding: EdgeInsets.only(left: 20, right: 15),
                      ),
                      contentPadding: EdgeInsets.all(18),
                      labelText: "Druck 01"),
                ),
                TextFormField(
                  validator: (e) {
                    if (e.isEmpty) {
                      return "Druck von Person 02 darf nicht leer sein";
                    }
                  },
                  onSaved: (e) => p02 = e,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w300,
                  ),
                  decoration: InputDecoration(
                      prefixIcon: Padding(
                        padding: EdgeInsets.only(left: 20, right: 15),
                      ),
                      contentPadding: EdgeInsets.all(18),
                      labelText: "Druck 02"),
                ),
                (n03 != "")
                    ? TextFormField(
                        validator: (e) {
                          if (e.isEmpty) {
                            return "Druck von Person 03 darf nicht leer sein";
                          }
                        },
                        onSaved: (e) => p03 = e,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w300,
                        ),
                        decoration: InputDecoration(
                            prefixIcon: Padding(
                              padding: EdgeInsets.only(left: 20, right: 15),
                            ),
                            contentPadding: EdgeInsets.all(18),
                            labelText: "Druck 03"),
                      )
                    : Container(),
                SizedBox(
                  height: 4,
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: FlatButton(
                      onPressed: () {
                        final form = _key.currentState;
                        if (form.validate()) {
                          form.save();
                          if (n01 != "") {
                            setState(() {
                              DateTime now = new DateTime.now();
                              entries.add(new Entry(
                                  n01,
                                  n02,
                                  n03,
                                  entries.length + 1));
                              persEntries.add(new PDFEntry(
                                  n01,
                                  n02,
                                  n03,
                                  entries.length));

                              entries[entries.length - 1]._pressure01 = p01;
                              persEntries[entries.length - 1]._pressure01 = p01;
                              persEntries[entries.length - 1]._people = 1;
                              entries[entries.length - 1]._pressure02 = p02;
                              persEntries[entries.length - 1]._pressure02 = p02;
                              persEntries[entries.length - 1]._people = 2;
                              if (n03 != "") {
                                entries[entries.length - 1]._pressure03 = p03;
                              }
                              if (n03 != "") {
                                persEntries[entries.length - 1]._pressure03 =
                                    p03;
                                persEntries[entries.length - 1]._people = 3;
                              }
                              entries[entries.length - 1]._timer = Stopwatch();
                            });
                            Navigator.of(context).pop();
                          }
                        }
                      },
                      child: Text(
                        "Speichern",
                        style: TextStyle(fontSize: 18),
                      )),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          left: Constants.padding,
          right: Constants.padding,
          child: CircleAvatar(
            backgroundColor: Colors.transparent,
            radius: Constants.avatarRadius,
            child: ClipRRect(
              borderRadius:
                  BorderRadius.all(Radius.circular(Constants.avatarRadius)),
              //child: Image.asset("assets/images/logo_small_icon_only_inverted.png")
            ),
          ),
        ),
      ],
    );
  }
}

class Entry {
  Stopwatch _timer;
  int _entryNr;
  String _person01;
  String _person02;
  String _person03;
  String _time;

  String _pressure01;
  String _pressure02;
  String _pressure03;

  Entry(_person01, _person02, _person03, _number) {
    this._person01 = _person01;
    this._person02 = _person02;
    this._person03 = _person03;
    this._entryNr = _number;
  }

  String _getNames() {
    String names = _person01 + " - " + _pressure01 + " bar\n";
    if (!(_person02 == null || _person02 == "")) {
      names += _person02 + " - " + _pressure02 + " bar\n";
    }
    if (!(_person03 == null || _person03 == "")) {
      names += _person03 + " - " + _pressure03 + " bar\n";
    }

    return names;
  }

  String _getTime() {
    return _time;
  }

  int get entryNr => _entryNr;

  @override
  String toString() {
    return '$_time\n$_person01';
  }
}

class PDFEntry {
  int _people;
  int _entryNr;
  String _person01;
  String _person02;
  String _person03;
  DateTime _starttime;
  DateTime _stoptime;
  String _pressure01;
  String _pressure02;
  String _pressure03;

  PDFEntry(_person01, _person02, _person03, _number) {
    this._person01 = _person01;
    this._person02 = _person02;
    this._person03 = _person03;
    this._entryNr = _number;
    this._starttime = DateTime.now();
    this._stoptime = DateTime.now();
  }

  @override
  String toString() {
    switch (_people) {
      case 1:
        return "Truppnr.: " +
            _entryNr.toString() +
            " von: " +
            _starttime.toIso8601String() +
            " bis: " +
            _stoptime.toIso8601String() +
            "\n(" +
            _person01 +
            " " +
            _pressure01 +
            "bar)";
        break;
      case 2:
        return "Truppnr.: " +
            _entryNr.toString() +
            " von: " +
            _starttime.toIso8601String() +
            " bis: " +
            _stoptime.toIso8601String() +
            "\n(" +
            _person01 +
            " " +
            _pressure01 +
            "bar) " "(" +
            _person02 +
            " " +
            _pressure02 +
            "bar)";
        break;
      case 3:
        return "Truppnr.: " +
            _entryNr.toString() +
            " von: " +
            _starttime.toIso8601String() +
            " bis: " +
            _stoptime.toIso8601String() +
            "\n(" +
            _person01 +
            " " +
            _pressure01 +
            "bar) " "(" +
            _person02 +
            " " +
            _pressure02 +
            "bar) " "(" +
            _person03 +
            " " +
            _pressure03 +
            "bar)";
        break;
    }
    return "";
  }
}

class Constants {
  Constants._();

  static const double padding = 20;
  static const double avatarRadius = 45;
}
