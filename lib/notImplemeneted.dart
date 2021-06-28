import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class noImpl extends StatefulWidget {
  @override
  _noImplState createState() => _noImplState();
}

class _noImplState extends State<noImpl> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Container(
          child: Text(
            "Not Implemented yet",
            style: TextStyle(color: Colors.black87, fontSize: 28),
          ),
        ),
      ),
    );
  }
}
