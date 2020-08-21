import 'package:flutter/material.dart';

import 'package:my_tie/models/wasted_item.dart';
import 'package:my_tie/routes/routes.dart';
import 'package:my_tie/styles/styles.dart';
import 'package:my_tie/utils/date.dart';

class CompactListTile extends StatelessWidget {
  final WastedItem wastedItem;

  CompactListTile({@required this.wastedItem});
  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        key: ValueKey(wastedItem.name + wastedItem.count.toString()),
        leading: const Icon(Icons.chevron_right),
        title: Row(children: [
          Text(
            Date.humanizeTimestamp(wastedItem.date),
            style: TextStyle(fontSize: AppFonts.h3),
          ),
          Text(' (' + Date.dayOfWeek(wastedItem.date) + ')'),
        ]),
        trailing: Text(wastedItem.count.toString()),
        onTap: () => Routes.wasteDetailPage(context, item: wastedItem),
      ),
    );
  }
}
