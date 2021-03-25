import 'package:flutter/material.dart';

class InfoPage extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return Scaffold(// you can use Container, it wont be a whole page
      backgroundColor: Color(0xFFB40284A),
      body: Center(
        child: Container(
          color: Colors.red,
          child: Text('Infor-Page'),
        ),
      ),

    );
  }
}
