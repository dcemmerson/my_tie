import 'package:flutter/material.dart';
import 'package:my_tie/widgets/waste_item_detail.dart';

class WasteDetailPage extends StatelessWidget {
  static const route = '/wastedetail';
  static const title = 'Waste Details';

  @override
  Widget build(BuildContext context) {
    return WasteItemDetail();
  }
}
