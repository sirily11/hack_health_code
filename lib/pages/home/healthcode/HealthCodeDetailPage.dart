import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:health_qr_code_generator/model/DatabaseProvider.dart';
import 'package:health_qr_code_generator/model/HealthCode.dart';
import 'package:health_qr_code_generator/utils/utils.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

class HealthCodeDetailPage extends StatelessWidget {
  final HealthCode healthCode;

  /// Show add button
  final bool showAdd;

  HealthCodeDetailPage({@required this.healthCode, this.showAdd = true});

  @override
  Widget build(BuildContext context) {
    DatabaseProvider databaseProvider = Provider.of(context);
    return Scaffold(
      body: Column(
        children: <Widget>[
          SizedBox(
            height: 20,
          ),
          Center(
            child: QrImage(
              data: JsonEncoder().convert(
                healthCode.toJson(),
              ),
              foregroundColor: Colors.green,
              size: 180,
            ),
          ),
          ListTile(
            title: Text("ID"),
            subtitle: Text(healthCode.codeId),
          ),
          Divider(),
          ListTile(
            title: Text("Reported time"),
            subtitle: Text(
              convert(healthCode.lastReportTime).toString(),
            ),
          ),
          Divider(),
          ListTile(
            title: Text("Expire time"),
            subtitle: Text(
              convert(healthCode.outTime).toString(),
            ),
          ),
          Spacer(),
          if (showAdd)
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: RaisedButton(
                      onPressed: () async {
                        try {
                          await databaseProvider.add(healthCode);
                          Navigator.pop(context);
                        } catch (err) {
                          showDialog(
                            context: context,
                            builder: (c) => AlertDialog(
                              title: Text("Cannot Add Info"),
                              actions: <Widget>[
                                FlatButton(
                                  child: Text("Close"),
                                  onPressed: () => Navigator.pop(context),
                                )
                              ],
                            ),
                          );
                        }
                      },
                      child: Text("Add"),
                    ),
                  )
                ],
              ),
            )
        ],
      ),
    );
  }
}
