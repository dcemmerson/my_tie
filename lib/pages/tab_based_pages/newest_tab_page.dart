import 'package:flutter/cupertino.dart';
import 'package:my_tie/pages/tab_based_pages/tab_page.dart';
import 'package:my_tie/widgets/flies_exhibit/flies_exhibit_entry.dart';

class NewestTabPage extends TabPage {
  static const _name = 'Newest';
  // static final _widget =
  // FliesExhibitEntry(flyExhibitType: FlyExhibitType.Newest);

  String get name => _name;
  Widget widget(ScrollController parentScrollConroller) => FliesExhibitEntry(
      scrollController: scrollController,
      // parentScrollController: parentScrollConroller,
      flyExhibitType: FlyExhibitType.Newest);
}
