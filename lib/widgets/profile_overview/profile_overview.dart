import 'package:flutter/material.dart';
import 'package:my_tie/widgets/profile_overview/profile_overview_stream_builder.dart';

class ProfileOverview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ProfileOverviewStreamBuilder(
      child: (data) => Text('built'),
    );
  }
}
