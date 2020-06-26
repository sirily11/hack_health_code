import 'package:flutter_test/flutter_test.dart';
import 'package:health_qr_code_generator/model/HealthCode.dart';
import 'package:health_qr_code_generator/utils/utils.dart';

void main() {
  group("get Continue healthcode", () {
    DateTime today = DateTime.now();
    test("Test 1", () {
      // Only one record
      List<HealthCode> codeList = [
        HealthCode(
          id: "1",
          lastReportTime: today.millisecondsSinceEpoch,
          outTime: today.add(Duration(days: 1)).millisecondsSinceEpoch,
          zoning: 'dev',
        )
      ];

      getContinueHealCodeList(codeList);
      expect(true, codeList[0].isContinued);
    });

    test("Test 2", () {
      // Only two records and continuously
      List<HealthCode> codeList = [
        HealthCode(
          id: "1",
          lastReportTime: today.millisecondsSinceEpoch,
          outTime: today.add(Duration(days: 1)).millisecondsSinceEpoch,
          zoning: 'dev',
        ),
        HealthCode(
          id: "2",
          lastReportTime: today.add(Duration(hours: 3)).millisecondsSinceEpoch,
          outTime: today.add(Duration(days: 1)).millisecondsSinceEpoch,
          zoning: 'dev',
        )
      ];

      getContinueHealCodeList(codeList);
      expect(codeList[0].isContinued, true);
      expect(codeList[1].isContinued, true);
    });

    test("Test 3", () {
      // Only two records and not continuously
      List<HealthCode> codeList = [
        HealthCode(
          id: "1",
          lastReportTime: today.millisecondsSinceEpoch,
          outTime: today.add(Duration(days: 1)).millisecondsSinceEpoch,
          zoning: 'dev',
        ),
        HealthCode(
          id: "2",
          lastReportTime: today.add(Duration(days: 2)).millisecondsSinceEpoch,
          outTime: today.add(Duration(days: 3)).millisecondsSinceEpoch,
          zoning: 'dev',
        )
      ];

      getContinueHealCodeList(codeList);
      expect(codeList[0].isContinued, true);
      expect(codeList[1].isContinued, false);
    });

    test("Test 4", () {
      // Three records and continuously
      List<HealthCode> codeList = [
        HealthCode(
          id: "1",
          lastReportTime: today.millisecondsSinceEpoch,
          outTime: today.add(Duration(days: 1)).millisecondsSinceEpoch,
          zoning: 'dev',
        ),
        HealthCode(
          id: "2",
          lastReportTime: today.add(Duration(days: 1)).millisecondsSinceEpoch,
          outTime: today.add(Duration(days: 2)).millisecondsSinceEpoch,
          zoning: 'dev',
        ),
        HealthCode(
          id: "2",
          lastReportTime: today.add(Duration(days: 2)).millisecondsSinceEpoch,
          outTime: today.add(Duration(days: 3)).millisecondsSinceEpoch,
          zoning: 'dev',
        )
      ];

      getContinueHealCodeList(codeList);
      expect(codeList[0].isContinued, true);
      expect(codeList[1].isContinued, true);
      expect(codeList[2].isContinued, true);
    });

    test("Test 6", () {
      // Three records and not continuously
      List<HealthCode> codeList = [
        HealthCode(
          id: "1",
          lastReportTime: today.millisecondsSinceEpoch,
          outTime: today.add(Duration(days: 1)).millisecondsSinceEpoch,
          zoning: 'dev',
        ),
        HealthCode(
          id: "2",
          lastReportTime: today.add(Duration(days: 2)).millisecondsSinceEpoch,
          outTime: today.add(Duration(days: 3)).millisecondsSinceEpoch,
          zoning: 'dev',
        ),
        HealthCode(
          id: "2",
          lastReportTime: today.add(Duration(days: 3)).millisecondsSinceEpoch,
          outTime: today.add(Duration(days: 4)).millisecondsSinceEpoch,
          zoning: 'dev',
        )
      ];

      getContinueHealCodeList(codeList);
      expect(codeList[0].isContinued, true);
      expect(codeList[1].isContinued, false);
      expect(codeList[2].isContinued, true);
    });

    test("Test 5", () {
      // Three records and not continuously
      List<HealthCode> codeList = [
        HealthCode(
          id: "1",
          lastReportTime: today.millisecondsSinceEpoch,
          outTime: today.add(Duration(days: 1)).millisecondsSinceEpoch,
          zoning: 'dev',
        ),
        HealthCode(
          id: "2",
          lastReportTime: today.add(Duration(days: 2)).millisecondsSinceEpoch,
          outTime: today.add(Duration(days: 3)).millisecondsSinceEpoch,
          zoning: 'dev',
        ),
        HealthCode(
          id: "3",
          lastReportTime: today.add(Duration(days: 3)).millisecondsSinceEpoch,
          outTime: today.add(Duration(days: 4)).millisecondsSinceEpoch,
          zoning: 'dev',
        ),
        HealthCode(
          id: "4",
          lastReportTime: today.add(Duration(days: 4)).millisecondsSinceEpoch,
          outTime: today.add(Duration(days: 5)).millisecondsSinceEpoch,
          zoning: 'dev',
        ),
        HealthCode(
          id: "5",
          lastReportTime: today.add(Duration(days: 5)).millisecondsSinceEpoch,
          outTime: today.add(Duration(days: 6)).millisecondsSinceEpoch,
          zoning: 'dev',
        ),
      ];

      getContinueHealCodeList(codeList);
      expect(codeList[0].isContinued, true, reason: "1");
      expect(codeList[1].isContinued, false, reason: "2");
      expect(codeList[2].isContinued, true, reason: "3");
      expect(codeList[3].isContinued, true, reason: "4");
      expect(codeList[4].isContinued, true, reason: "5");
    });
  });

  group("Get last continue days", () {
    DateTime today = DateTime.now();
    test("Test 1", () {
      List<HealthCode> codeList = [
        HealthCode(
          id: "1",
          lastReportTime: today.millisecondsSinceEpoch,
          outTime: today.add(Duration(days: 1)).millisecondsSinceEpoch,
          zoning: 'dev',
          isContinued: true,
        )
      ];
      var days = getLastContinueDays(codeList);
      expect(days.length, 1);
    });

    test("Test 2", () {
      List<HealthCode> codeList = [
        HealthCode(
          id: "1",
          zoning: 'dev',
          isContinued: true,
        ),
        HealthCode(
          id: "2",
          zoning: 'dev',
          isContinued: true,
        )
      ];
      var days = getLastContinueDays(codeList);
      expect(days.length, 2);
    });

    test("Test 3", () {
      List<HealthCode> codeList = [
        HealthCode(
          id: "1",
          zoning: 'dev',
          isContinued: true,
        ),
        HealthCode(
          id: "2",
          zoning: 'dev',
          isContinued: false,
        ),
        HealthCode(
          id: "3",
          zoning: 'dev',
          isContinued: true,
        ),
        HealthCode(
          id: "4",
          zoning: 'dev',
          isContinued: true,
        ),
        HealthCode(
          id: "5",
          zoning: 'dev',
          isContinued: true,
        ),
      ];
      var days = getLastContinueDays(codeList);
      expect(days.length, 3);
    });
  });
}
