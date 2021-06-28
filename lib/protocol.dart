import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Protocol extends StatefulWidget {
  @override
  _ProtocolState createState() => _ProtocolState();
}

List<Entry> protocolEntries = <Entry>[];

class _ProtocolState extends State<Protocol> {
  TextEditingController _controller = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: protocolEntries.isEmpty == true
            ? Container(
          child: Text(
            "Keine Einträge vorhanden",
            style: TextStyle(color: Colors.black87, fontSize: 28),
          ),
        )
            : ListView.builder(
            padding: const EdgeInsets.all(8),
            scrollDirection: Axis.vertical,
            itemCount: protocolEntries.length,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                margin: EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10)),
                    boxShadow: [
                      BoxShadow(
                        color:
                        Colors.grey.withOpacity(0.3),
                        spreadRadius: 2,
                        blurRadius: 2,
                        offset: Offset(0,
                            3),
                      ),
                    ],
                  ),
                  child: Card(
                    color: Colors.transparent,
                    shadowColor: Colors.transparent,
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.transparent,
                        radius: Constants.padding,
                        child: ClipRRect(
                            borderRadius: BorderRadius.all(
                                Radius.circular(Constants.avatarRadius)),
                            child: Image.asset(
                                "assets/images/logo_small_icon_only.png")),
                      ),
                      title: Text(
                        protocolEntries[index].getString(),
                        style:
                        TextStyle(fontSize: 15.0, color: Colors.black87),
                      ),
                    ),
                  ));
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
              top: Constants.avatarRadius + Constants.padding,
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
                "Neuer Eintrag",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: 15,
              ),
              TextField(
                decoration: InputDecoration(hintText: "Text"),
                controller: _controller,
              ),
              SizedBox(
                height: 22,
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: FlatButton(
                    onPressed: () {
                      if (_controller.text != "") {
                        setState(() {
                          protocolEntries.add(new Entry(
                              DateTime.now(),
                              _controller.text,protocolEntries.length+1));
                          _controller.clear();
                        });
                      }
                      Navigator.of(context).pop();
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
                child: Image.asset(
                    "assets/images/logo_small_icon_only_inverted.png")),
          ),
        ),
      ],
    );
  }
}

class Entry {
  String _text;
  DateTime _time;
  int _entrynr;
  Entry(this._time, this._text, this._entrynr);

  String getString() {
    return DateFormat('dd.MM.yyyy – kk:mm:ss')
        .format(_time)
        .toString()+"\n\n$_text";
  }

  @override
  String toString() {
    return "Eintragnr.: "+_entrynr.toString()+" Zeit: "+_time.toIso8601String()+"\nText: "+_text;
  }
}

class Constants {
  Constants._();

  static const double padding = 20;
  static const double avatarRadius = 45;
}