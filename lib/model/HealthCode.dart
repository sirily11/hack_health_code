// To parse this JSON data, do
//
//     final healthCode = healthCodeFromJson(jsonString);

import 'dart:convert';

HealthCode healthCodeFromJson(String str) => HealthCode.fromJson(json.decode(str));

String healthCodeToJson(HealthCode data) => json.encode(data.toJson());

class HealthCode {
    HealthCode({
        this.codeId,
        this.lastReportTime,
        this.outTime,
        this.zoning,
    });

    String codeId;
    int lastReportTime;
    int outTime;
    String zoning;

    factory HealthCode.fromJson(Map<String, dynamic> json) => HealthCode(
        codeId: json["codeId"],
        lastReportTime: json["lastReportTime"],
        outTime: json["outTime"],
        zoning: json["zoning"],
    );

    Map<String, dynamic> toJson() => {
        "codeId": codeId,
        "lastReportTime": lastReportTime,
        "outTime": outTime,
        "zoning": zoning,
    };
}
