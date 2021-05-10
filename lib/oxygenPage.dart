import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:async';

class Oxygen extends StatefulWidget {
  @override
  _OxygenState createState() => _OxygenState();
}

List<Entry> entries = <Entry>[];

class _OxygenState extends State<Oxygen> {
  Timer _timer;
  TextEditingController _controller01 = new TextEditingController();
  TextEditingController _controller02 = new TextEditingController();
  TextEditingController _controller03 = new TextEditingController();
  TextEditingController _pressure01 = new TextEditingController();
  TextEditingController _pressure02 = new TextEditingController();
  TextEditingController _pressure03 = new TextEditingController();

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
      debugPrint("WAS RUNNING");
      entries[index]._timer.stop();
      entries.removeAt(index);
    } else {
      entries[index]._timer.start();
    }
    setState(() {});
  }

  void _promptRemoveTodoItem(int index) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return new AlertDialog(
              title: new Text("Trupp " + (index + 1).toString() + " zurück?"),
              actions: <Widget>[
                new FlatButton(
                    child: new Text('NEIN'),
                    onPressed: () => Navigator.of(context).pop()),
                new FlatButton(
                    child: new Text('JA'),
                    onPressed: () {
                      handleStartStop(index);
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
                  style: TextStyle(color: Colors.white, fontSize: 28),
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
                          color: Colors.white10,
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
                                        fontSize: 19.0, color: Colors.white),
                                  ),
                                  SizedBox(
                                    height: 4,
                                  ),
                                  Text(
                                    "Time: " + entries[index]._getTime(),
                                    style: TextStyle(
                                        fontSize: 16.0,
                                        color: Colors.red,
                                        fontWeight: FontWeight.bold),
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
          _controller01.clear();
          _controller02.clear();
          _controller03.clear();
          _pressure01.clear();
          _pressure02.clear();
          _pressure03.clear();
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
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                "Neuer Trupp",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: 8,
              ),
              TextField(
                decoration: InputDecoration(hintText: "Person 1"),
                controller: _controller01,
              ),
              SizedBox(
                height: 4,
              ),
              TextField(
                decoration: InputDecoration(hintText: "Person 2"),
                controller: _controller02,
              ),
              SizedBox(
                height: 4,
              ),
              TextField(
                decoration: InputDecoration(hintText: "Person 3"),
                controller: _controller03,
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: FlatButton(
                    onPressed: () {
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
                    },
                    child: Text(
                      "Speichern",
                      style: TextStyle(fontSize: 18),
                    )),
              ),
            ],
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
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                "Sauerstoff",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: 8,
              ),
              TextField(
                decoration: InputDecoration(hintText: "Druck Person 1 "),
                controller: _pressure01,
              ),
              SizedBox(
                height: 4,
              ),
              (_controller02.text != "")
                  ? TextField(
                      decoration: InputDecoration(hintText: "Druck Person 2"),
                      controller: _pressure02,
                    )
                  : Container(),
              SizedBox(
                height: 4,
              ),
              (_controller03.text != "")
                  ? TextField(
                      decoration: InputDecoration(hintText: "Druck Person 3"),
                      controller: _pressure03,
                    )
                  : Container(),
              SizedBox(
                height: 4,
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: FlatButton(
                    onPressed: () {
                      if (_controller01.text != "") {
                        setState(() {
                          DateTime now = new DateTime.now();
                          entries.add(new Entry(
                              DateFormat('kk:mm:ss').format(now).toString(),
                              _controller01.text,
                              _controller02.text,
                              _controller03.text,
                              entries.length + 1));

                          entries[entries.length - 1]._pressure01 =
                              _pressure01.text;

                          if (_controller02.text != "") {
                            entries[entries.length - 1]._pressure02 =
                                _pressure02.text;
                          }
                          if (_controller03.text != "") {
                            entries[entries.length - 1]._pressure03 =
                                _pressure03.text;
                          }
                          _controller01.clear();
                          _controller02.clear();
                          _controller03.clear();
                          _pressure01.clear();
                          _pressure02.clear();
                          _pressure03.clear();
                          entries[entries.length - 1]._timer = Stopwatch();
                          handleStartStop(entries.length - 1);
                        });
                        Navigator.of(context).pop();
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

  Entry(_time, _person01, _person02, _person03, _number) {
    this._time = _time;
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

class Constants {
  Constants._();

  static const double padding = 20;
  static const double avatarRadius = 45;
}
