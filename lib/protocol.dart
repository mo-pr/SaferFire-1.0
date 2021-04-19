import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Protocol extends StatefulWidget {
  @override
  _ProtocolState createState() => _ProtocolState();
}

List<Entry> entries = <Entry>[];

class _ProtocolState extends State<Protocol> {
  TextEditingController _controller = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: ListView.builder(
            padding: const EdgeInsets.all(8),
            scrollDirection: Axis.vertical,
            itemCount: entries.length,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                color: Colors.transparent,
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  elevation: 0,
                  child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 7),
                      child: Text(
                        entries[index].toString(),
                        style: TextStyle(color: Colors.white),
                      )),
                  color: Colors.transparent,
                ),
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
              top: Constants.avatarRadius
                  + Constants.padding,
              right: Constants.padding,
              bottom: Constants.padding
          ),
          margin: EdgeInsets.only(top: Constants.avatarRadius),
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Colors.white,
              borderRadius: BorderRadius.circular(Constants.padding),
              boxShadow: [
                BoxShadow(color: Colors.black, offset: Offset(0, 10),
                    blurRadius: 10
                ),
              ]
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text("Neuer Eintrag",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),),
              SizedBox(height: 15,),
              TextField(
                decoration: InputDecoration(hintText: "Text"),
                controller: _controller,
              ),
              SizedBox(height: 22,),
              Align(
                alignment: Alignment.bottomRight,
                child: FlatButton(
                    onPressed: () {
                      if(_controller.text != ""){
                        setState(() {
                          DateTime now = new DateTime.now();
                          entries.add(new Entry(DateFormat('yyyy-MM-dd – kk:mm').format(now).toString(), _controller.text));
                          _controller.clear();
                        });
                      }
                      Navigator.of(context).pop();
                    },
                    child: Text("Speichern", style: TextStyle(fontSize: 18),)),
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
                borderRadius: BorderRadius.all(
                    Radius.circular(Constants.avatarRadius)),
                child: Image.asset("assets/images/logo_small_icon_only_inverted.png")
            ),
          ),
        ),
      ],
    );
  }
}
class Entry {
  String _text, _time;

  Entry(this._time, this._text);

  @override
  String toString() {
    return '$_time: $_text';
  }
}


class Constants {
  Constants._();
  static const double padding =20;
  static const double avatarRadius =45;
}