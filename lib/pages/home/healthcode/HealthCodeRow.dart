import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:health_qr_code_generator/model/DatabaseProvider.dart';
import 'package:health_qr_code_generator/model/HealthCode.dart';
import 'package:health_qr_code_generator/utils/utils.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';

import 'HealthCodeDetailPage.dart';

class HealthCodeRow extends StatelessWidget {
  final HealthCode healthCode;
  final int index;
  final int databaseKey;
  final bool hasExpired;

  HealthCodeRow({
    @required this.healthCode,
    @required this.databaseKey,
    @required this.index,
    @required this.hasExpired,
  });

  @override
  Widget build(BuildContext context) {
    DatabaseProvider databaseProvider = Provider.of(context);

    return Slidable(
      actionPane: SlidableDrawerActionPane(),
      secondaryActions: <Widget>[
        IconSlideAction(
          caption: "Delete",
          color: Colors.red,
          icon: Icons.delete,
          onTap: () async {
            try {
              await databaseProvider.delete(databaseKey);
            } catch (err) {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text("Delete Error"),
                  content: Text("Error: ${err.toString()}"),
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
        )
      ],
      child: Container(
        color: healthCode.isContinued ? Colors.green.withOpacity(0.2) : null,
        child: ListTile(
          onTap: () async {
            await showCupertinoModalBottomSheet(
              context: context,
              backgroundColor: Colors.transparent,
              builder: (context, scrollController) => HealthCodeDetailPage(
                healthCode: healthCode,
                showAdd: false,
              ),
            );
          },
          leading: Text("$index"),
          title: Text("Expire Time"),
          subtitle: Text(
            "${convert(healthCode.lastReportTime)}",
          ),
          trailing: hasExpired ? buildExpireIcon() : buildNotExpireIcon(),
        ),
      ),
    );
  }

  Icon buildExpireIcon() {
    return Icon(
      MdiIcons.closeCircle,
      color: Colors.red,
    );
  }

  Icon buildNotExpireIcon() {
    return Icon(
      MdiIcons.checkboxMarkedCircle,
      color: Colors.green,
    );
  }
}
