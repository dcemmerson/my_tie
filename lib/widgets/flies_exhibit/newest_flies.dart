import 'package:flutter/material.dart';
import 'package:my_tie/models/new_fly/fly.dart';
import 'package:my_tie/widgets/flies_exhibit/flies_exhibit_stream_builder.dart';

class NewestFlies extends StatelessWidget {
  Widget buildFlyExhibit(List<Fly> flies) {
    print(flies);
    return Center(
      child: Text('hello world'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FliesExhibitStreamBuilder(
      builder: buildFlyExhibit,
    );
  }
}
