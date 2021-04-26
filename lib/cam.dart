import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class camera extends StatefulWidget {
  @override
  _cameraState createState() => _cameraState();
}

List<File> images = <File>[];

class _cameraState extends State<camera> {
  File _image;
  final imagePicker = ImagePicker();

  Future getImage() async {
    final image = await imagePicker.getImage(source: ImageSource.camera);
    setState(() {
      _image = File(image.path);
      images.add(File(image.path));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: images.isEmpty == true
            ? Container(
                child: Text(
                  "Keine Fotos vorhanden",
                  style: TextStyle(color: Colors.white, fontSize: 28),
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.all(8),
                scrollDirection: Axis.vertical,
                itemCount: images.length,
                //gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount:2),
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
                          child: Image.file(images[index])),
                      color: Colors.transparent,
                    ),
                  );
                }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: getImage,
        backgroundColor: Colors.red,
        child: Icon(Icons.camera),
      ),
    );
  }
}
