import 'package:flutter/material.dart';
import 'package:my_tie/widgets/forms/new_fly_form/review/new_fly_form_publish.dart';

class NewFlyPublishPage extends StatefulWidget {
  static const title = 'Publish Fly';
  static const route = '/new_fly/publish';

  @override
  _NewFlyPublishPageState createState() => _NewFlyPublishPageState();
}

class _NewFlyPublishPageState extends State<NewFlyPublishPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return NewFlyFormPublish();
  }
}
