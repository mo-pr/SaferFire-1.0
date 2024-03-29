import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';

class adr extends StatefulWidget {
  @override
  _adrState createState() => _adrState();
}

class _adrState extends State<adr> {
  TextEditingController teSeach = TextEditingController();
  List<ADRobj> adrs = [];
  List<ADRobj> items = [];

  @override
  void initState() {
    super.initState();
    adrs.clear();
    items.clear();
    getData();
  }

  Future getData() async {
    /*final conn = await MySqlConnection.connect(new ConnectionSettings(
      host: '192.168.0.8',
      port: 3306,
      user: 'MP_DEV',
      password: 'MP_DEV',
      db: 'saferfire',
    ));*/
    final conn = await MySqlConnection.connect(new ConnectionSettings(
      host: '86.56.241.47',
      port: 3306,
      user: 'MP_DEV',
      password: 'MP_DEV',
      db: 'saferfire',
    ));
    var result = await conn.query('select * from unnumbers');
    for (var row in result) {
      adrs.add(new ADRobj(
          row[0].toString(),
          row[1].toString() != null ? row[1].toString() : "",
          row[2].toString() != null ? row[2].toString() : "",
          row[3].toString() != null ? row[3].toString() : ""));
      items.add(new ADRobj(
          row[0].toString(),
          row[1].toString() != null ? row[1].toString() : "",
          row[2].toString() != null ? row[2].toString() : "",
          row[3].toString() != null ? row[3].toString() : ""));
    }
    setState(() {});
    await conn.close();
  }

  void _showDetail(int index) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return new AlertDialog(
              title: new Text("UN-Nummer: " +
                  adrs.asMap()[index].unnr.padLeft(4, '0') +
                  "\n\n" +
                  adrs.asMap()[index].bez),
              actions: <Widget>[
                new FlatButton(
                    child: new Text('Abbrechen'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    })
              ]);
        });
  }

  void filterSeach(String query) async {
    List<ADRobj> searchList = adrs;
    List<ADRobj> dummySearch = [];
    if (query == "" || query == null || query == " ") {
      setState(() {
        items.clear();
        items = adrs;
      });
    } else {
      for (ADRobj item in searchList) {
        if (item.unnr.toLowerCase().contains(query.toLowerCase())) {
          dummySearch.add(item);
        }
      }
      setState(() {
        items.clear();
        items.addAll(dummySearch);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: TextField(
              keyboardType: TextInputType.number,
              style: TextStyle(color: Colors.black87),
              onChanged: (value) {
                setState(() {
                  filterSeach(value);
                });
              },
              cursorColor: Color(0xffb32b19),
              controller: teSeach,
              decoration: InputDecoration(
                enabledBorder: new OutlineInputBorder(
                  borderRadius: new BorderRadius.circular(25.0),
                  borderSide: BorderSide(color: Color(0xffb32b19)),
                ),
                focusedBorder: new OutlineInputBorder(
                  borderRadius: new BorderRadius.circular(25.0),
                  borderSide: BorderSide(color: Color(0xffb32b19)),
                ),
                hintText: 'Search...',
                hintStyle: TextStyle(color: Colors.black87),
                labelText: 'Search',
                labelStyle: TextStyle(color: Colors.black87),
                prefixIcon: Icon(
                  Icons.search,
                  color: Color(0xffb32b19),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
                padding: const EdgeInsets.all(8),
                scrollDirection: Axis.vertical,
                itemCount: items.length,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                      onTap: () => _showDetail(index),
                      child: Container(
                          color: Colors.transparent,
                          child: Card(
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: Colors.transparent,
                                radius: Constants.padding,
                                child: ClipRRect(
                                    child: Image.asset(
                                        "assets/images/2000px-ADR33_UN1203.svg.png")),
                              ),
                              title: Text(
                                items[index].unnr.padLeft(4, '0'),
                                style: TextStyle(
                                    fontSize: 19.0, color: Colors.black87),
                              ),
                            ),
                          )));
                }),
          ),
        ],
      ),
    );
  }
}

class ADRobj {
  String unnr;
  String gefnr;
  String klasse;
  String bez;

  ADRobj(this.unnr, this.gefnr, this.klasse, this.bez);
}

class Constants {
  Constants._();

  static const double padding = 20;
  static const double avatarRadius = 45;
}
