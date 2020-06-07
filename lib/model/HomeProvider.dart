import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_qr_reader/flutter_qr_reader.dart';
import 'package:health_qr_code_generator/model/HealthCode.dart';
import 'package:image_picker/image_picker.dart';

class HomeProvider with ChangeNotifier {
  HealthCode healthCode;
  HealthCode newHealthCode;

  Future<void> scan(BuildContext context) async {
    final picked = await ImagePicker().getImage(source: ImageSource.gallery);
    if (picked != null) {
      final File file = File(picked.path);
      final String data = await FlutterQrReader.imgScan(file);
      try {
        Map jsonData = JsonDecoder().convert(data);
        this.healthCode = HealthCode.fromJson(jsonData);
        notifyListeners();
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
      }
    }
  }

  void updateTime(DateTime dateTime) {
    this.healthCode.lastReportTime = dateTime.millisecondsSinceEpoch;
    var newDay = dateTime.add(Duration(days: 1));
    this.healthCode.outTime = newDay.millisecondsSinceEpoch;
    notifyListeners();
  }
}
