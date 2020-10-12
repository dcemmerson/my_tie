import 'package:flutter/material.dart';
import 'package:my_tie/widgets/flies_exhibit/fly_exhibit_detail/fly_exhibit_detail.dart';

class FlyExhibitDetailPage extends StatelessWidget {
  static const title = 'Fly Detail';
  static const route = '/fly_exhibit_detail';

  @override
  Widget build(BuildContext context) {
    return Container(child: FlyExhibitDetail());
  }
}
