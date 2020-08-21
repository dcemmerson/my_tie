import 'package:flutter/material.dart';
import 'package:my_tie/widgets/waste_list_view/waste_items_list.dart';

class WasteListPage extends StatelessWidget {
  static const route = '/wasteItems';
  static const title = 'Waste Items';

  @override
  Widget build(BuildContext context) {
    return WasteItems();
  }
}
