import 'package:flutter/material.dart';
import 'package:health_qr_code_generator/model/HealthCode.dart';
import 'package:health_qr_code_generator/utils/utils.dart';

/// A widget that display expire duration and list of health code
class NotificationWidget extends StatelessWidget {
  final Duration expireDuration;
  final List<HealthCode> continueList;

  NotificationWidget({
    @required this.continueList,
    @required this.expireDuration,
  });

  int getDuration(DateTime one, DateTime two) {
    if (one != null && two != null) {
      var diff = one.difference(two);
      return diff.inDays;
    } else {
      return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Stack(
        children: <Widget>[
          SizedBox(
            height: 70,
            child: LinearProgressIndicator(
              value: expireDuration != null
                  ? getDurationProgress(expireDuration)
                  : 0,
            ),
          ),
          ListTile(
            title: Text(
                "Expire in ${expireDuration != null ? durationToString(expireDuration) : null}"),
            subtitle: Text(
              "已经连续打卡: ${continueList.length > 1 ? getDuration(
                  convert(continueList?.first?.lastReportTime),
                  convert(continueList?.last?.lastReportTime),
                ) : 0} 天",
            ),
          )
        ],
      ),
    );
  }
}
