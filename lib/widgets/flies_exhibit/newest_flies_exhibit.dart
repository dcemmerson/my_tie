import 'package:flutter/material.dart';
import 'package:my_tie/models/new_fly/fly.dart';
import 'package:my_tie/widgets/flies_exhibit/flies_exhibit_stream_builder.dart';

import 'fly_overview/fly_overview_exhibit.dart';

class NewestFliesExhibit extends StatefulWidget {
  @override
  _NewestFliesExhibitState createState() => _NewestFliesExhibitState();
}

class _NewestFliesExhibitState extends State<NewestFliesExhibit>
    with AutomaticKeepAliveClientMixin {
  bool keepAlive = true;

  @override
  bool get wantKeepAlive => keepAlive;

  Widget buildFlyExhibit(List<Fly> flies) {
    return ListView.builder(
      itemCount: flies.length,
      itemBuilder: (context, index) => FlyOverviewExhibit(flies[index]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FliesExhibitStreamBuilder(
      builder: buildFlyExhibit,
    );
  }
}
