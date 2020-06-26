import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:health_qr_code_generator/model/DatabaseProvider.dart';
import 'package:health_qr_code_generator/model/HealthCode.dart';
import 'package:health_qr_code_generator/model/HealthCodeProvider.dart';
import 'package:health_qr_code_generator/pages/home/healthcode/HealthCodeDetailPage.dart';
import 'package:health_qr_code_generator/pages/home/healthcode/HealthCodeRow.dart';
import 'package:health_qr_code_generator/utils/utils.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:sembast/sembast.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Duration expireDuration;
  DateTime currentTime = DateTime.now();
  HealthCode latestHealthCode;

  @override
  void initState() {
    super.initState();
    Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        currentTime = DateTime.now();
      });

      if (latestHealthCode != null) {
        setState(() {
          expireDuration = getExipireDuration(
            convert(latestHealthCode.outTime),
            DateTime.now(),
          );
        });
      } else {
        expireDuration = null;
      }
    });
  }

  Future<void> scan(ImageSource source) async {
    HealthCodeProvider healthCodeProvider = Provider.of(context, listen: false);
    // var healthCode = await healthCodeProvider.scan(context, source: source);
    Navigator.pop(context);
    await showCupertinoModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context, scrollController) => HealthCodeDetailPage(
        healthCode: testHealthCode2,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    DatabaseProvider databaseProvider = Provider.of(context);

    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          buildIconButton(context),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (databaseProvider.db == null) {
            // await database init
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return SingleChildScrollView(
            child: Column(
              children: <Widget>[
                LinearProgressIndicator(
                  value: expireDuration != null
                      ? getDurationProgress(expireDuration)
                      : 0,
                ),
                Text(
                  "Expire in ${expireDuration != null ? durationToString(expireDuration) : "None"}",
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                StreamBuilder(
                  stream: databaseProvider.stream,
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Center(
                        child: Text("Error: ${snapshot.error}"),
                      );
                    }
                    if (!snapshot.hasData) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    List<RecordSnapshot<int, Map<String, dynamic>>> data =
                        snapshot.data;

                    List<HealthCode> healthCodeList = data
                        .map(
                          (e) => HealthCode.fromJson(e.value),
                        )
                        .toList();

                    if (healthCodeList.length > 0) {
                      latestHealthCode = healthCodeList.last;
                    } else {
                      latestHealthCode = null;
                    }

                    getContinueHealCodeList(healthCodeList);

                    return ListView.separated(
                        shrinkWrap: true,
                        separatorBuilder: (context, index) => Divider(),
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: healthCodeList.length,
                        itemBuilder: (context, index) {
                          var healthData = healthCodeList[index];
                          return HealthCodeRow(
                            hasExpired: hasExpired(
                              currentTime,
                              convert(healthCodeList[index].outTime),
                            ),
                            healthCode: healthData,
                            index: index,
                            databaseKey: data[index].key,
                          );
                        });
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget buildIconButton(BuildContext context) {
    return IconButton(
      onPressed: () async {
        showCupertinoModalPopup(
          context: context,
          builder: (c) => CupertinoActionSheet(
            actions: <Widget>[
              CupertinoActionSheetAction(
                onPressed: () async {
                  await scan(ImageSource.camera);
                },
                child: Text("Take From Camera"),
              ),
              CupertinoActionSheetAction(
                onPressed: () async {
                  await scan(ImageSource.gallery);
                },
                child: Text("From Library"),
              )
            ],
          ),
        );
      },
      icon: Icon(Icons.camera_alt),
    );
  }
}
