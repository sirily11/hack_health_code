// To parse this JSON data, do
//
//     final healthCode = healthCodeFromJson(jsonString);

import 'dart:convert';

import 'package:uuid/uuid.dart';

HealthCode healthCodeFromJson(String str) =>
    HealthCode.fromJson(json.decode(str));

String healthCodeToJson(HealthCode data) => json.encode(data.toJson());

class HealthCode {
  HealthCode({
    this.codeId,
    this.lastReportTime,
    this.outTime,
    this.zoning,
    this.id,
    this.isContinued = false,
  });

  String id;
  String codeId;
  int lastReportTime;
  int outTime;
  String zoning;
  bool isContinued;

  factory HealthCode.fromJson(Map<String, dynamic> json) => HealthCode(
        id: Uuid().v4(),
        codeId: json["codeId"],
        lastReportTime: json["lastReportTime"],
        outTime: json["outTime"],
        zoning: json["zoning"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "codeId": codeId,
        "lastReportTime": lastReportTime,
        "outTime": outTime,
        "zoning": zoning,
      };
}

var testHealthCode = HealthCode(
  codeId: "1",
  lastReportTime: DateTime.now().millisecondsSinceEpoch,
  outTime: DateTime.now().add(Duration(days: 1)).millisecondsSinceEpoch,
  zoning: "dev",
  id: "2",
);

var testHealthCode2 = HealthCode(
  codeId: "1",
  lastReportTime: 1,
  outTime: 10000,
  zoning: "dev",
  id: "2",
);
