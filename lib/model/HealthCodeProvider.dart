import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_qr_reader/flutter_qr_reader.dart';
import 'package:image_picker/image_picker.dart';

import 'HealthCode.dart';

class HealthCodeProvider with ChangeNotifier {

  /// Scan qr code and return healthcode information
  Future<HealthCode> scan(
    BuildContext context, {
    ImageSource source = ImageSource.gallery,
  }) async {
    final picked = await ImagePicker().getImage(source: source);

    if (picked != null) {
      final File file = File(picked.path);
      final String data = await FlutterQrReader.imgScan(file);
      try {
        Map jsonData = JsonDecoder().convert(data);
        var healthCode = HealthCode.fromJson(jsonData);
        return healthCode;
      } catch (err) {
        showDialog(
          context: context,
          child: AlertDialog(
            title: Text("Read Error"),
            content: Text("Invaild Health Code"),
            actions: <Widget>[
              FlatButton(
                child: Text("OK"),
                onPressed: () => Navigator.pop(context),
              )
            ],
          ),
        );
        return null;
      }
    }
    return null;
  }
}
