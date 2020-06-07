import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:health_qr_code_generator/model/HomeProvider.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

class HomePage extends StatelessWidget {
  DateTime convert(int time) {
    if (time == null) {
      return null;
    }
    return DateTime.fromMillisecondsSinceEpoch(time);
  }

  @override
  Widget build(BuildContext context) {
    HomeProvider homeProvider = Provider.of(context);

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
            child: Container(
              width: 200,
              height: 200,
              child: homeProvider.healthCode != null
                  ? QrImage(
                      foregroundColor: Colors.teal,
                      data: JsonEncoder().convert(
                        homeProvider.healthCode.toJson(),
                      ),
                    )
                  : Center(
                      child: Text(
                        "No data",
                      ),
                    ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.info),
            title: Text("ID"),
            subtitle: Text(
              "${homeProvider.healthCode?.codeId}",
            ),
          ),
          ListTile(
            onTap: () async {
              if (homeProvider.healthCode != null) {
                final DateTime picked = await DatePicker.showDateTimePicker(
                  context,
                  currentTime: convert(homeProvider.healthCode.lastReportTime),
                  minTime: DateTime.now(),
                );
                homeProvider.updateTime(picked);
              }
            },
            leading: Icon(Icons.date_range),
            title: Text("Last Report Time"),
            subtitle: Text(
              "${convert(homeProvider.healthCode?.lastReportTime)}",
            ),
          ),
          ListTile(
            leading: Icon(Icons.date_range),
            title: Text("Out Time"),
            subtitle: Text(
              "${convert(homeProvider.healthCode?.outTime)}",
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              RaisedButton(
                onPressed: () async {
                  await homeProvider.scan(context);
                },
                child: Text("Scan"),
              )
            ],
          )
        ],
      ),
    );
  }
}
