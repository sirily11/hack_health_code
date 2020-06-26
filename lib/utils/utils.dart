import 'package:health_qr_code_generator/model/HealthCode.dart';

/// Convert [int time] to [Datetime]
DateTime convert(int time) {
  if (time == null) {
    return null;
  }
  return DateTime.fromMillisecondsSinceEpoch(time);
}

/// Get [first] and [second] time diff
Duration getExipireDuration(DateTime first, DateTime second) {
  return first.difference(second);
}

String durationToString(Duration duration) {
  return duration.toString().split('.').first.padLeft(8, "0");
}

/// Get progress.
/// Max is one day.
/// Return the percentage of current duration in one day
double getDurationProgress(Duration duration) {
  return ((Duration.millisecondsPerDay - duration.inMilliseconds) /
          Duration.millisecondsPerDay)
      .abs();
}

/// Get DateTime one has expired according to DateTime two
bool hasExpired(DateTime one, DateTime two) {
  var diff = one.compareTo(two);
  return diff > 0;
}

void getContinueHealCodeList(List<HealthCode> healthCodeList) {
  healthCodeList[0].isContinued = true;

  for (int i = 1; i < healthCodeList.length; i++) {
    var yesterdayHealthCode = healthCodeList[i - 1];
    var todayHealthCode = healthCodeList[i];

    if (!hasExpired(convert(todayHealthCode.lastReportTime),
        convert(yesterdayHealthCode.outTime))) {
      todayHealthCode.isContinued = true;
    } else {
      todayHealthCode.isContinued = false;
    }
  }
}

List<HealthCode> getLastContinueDays(List<HealthCode> healthCodeList) {
  List<HealthCode> newList = [];
  for (int i = 0; i < healthCodeList.length; i++) {
    var healthCode = healthCodeList[i];
    if (!healthCode.isContinued) {
      newList.clear();
      continue;
    }
    if (newList.isEmpty && i > 0) {
      var yesterdayHealthCode = healthCodeList[i - 1];
      if (!hasExpired(convert(healthCode.lastReportTime),
          convert(yesterdayHealthCode.outTime))) {
        newList.add(yesterdayHealthCode);
      }
    }
    newList.add(healthCode);
  }

  return newList;
}


