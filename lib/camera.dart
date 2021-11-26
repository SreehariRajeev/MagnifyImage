import 'dart:io';

import 'package:camerazoomapp/services/camera_services.dart';
import 'package:camerazoomapp/services/magnifier.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CameraApp extends StatefulWidget {
  @override
  _CameraAppState createState() => _CameraAppState();
}

class _CameraAppState extends State<CameraApp> {
  var _photo;
  Offset? position;
  bool magnifierVisible = false;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            XFile photo = await CameraServices.cameraPickImage();
            setState(() {
              _photo = File(photo.path);
            });
          },
          child: const Icon(Icons.camera),
        ),
        body: _photo == null
            ? Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                color: Colors.white,
                alignment: Alignment.center,
                child: const Text('Take a photo'),
              )
            : GestureDetector(
                onLongPressUp: () {
                  _endDragging();
                },
                onLongPressStart: (val) {
                  _startDragging(val.localPosition);
                },
                onLongPressMoveUpdate: (val) {
                  _startDragging(val.localPosition);
                },
                child: Magnifier(
                  position: position,
                  visible: magnifierVisible,
                  size: const Size(200, 200),
                  child: Image(
                    image: FileImage(_photo),
                  ),
                ),
              ),
      ),
    );
  }

  void _startDragging(Offset newPosition) {
    setState(() {
      magnifierVisible = true;
      position = newPosition;
    });
  }

  void _endDragging() {
    setState(() {
      magnifierVisible = false;
    });
  }
}
