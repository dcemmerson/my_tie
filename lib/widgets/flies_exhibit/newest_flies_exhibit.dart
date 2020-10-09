import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:my_tie/bloc/fly_exhibit_bloc.dart';
import 'package:my_tie/bloc/state/my_tie_state.dart';
import 'package:my_tie/models/new_fly/fly.dart';
import 'package:my_tie/widgets/flies_exhibit/flies_exhibit_stream_builder.dart';
import 'package:my_tie/widgets/misc/creation_aware_list_item.dart';

import 'fly_overview/fly_overview_exhibit.dart';

class NewestFliesExhibit extends StatefulWidget {
  @override
  _NewestFliesExhibitState createState() => _NewestFliesExhibitState();
}

class _NewestFliesExhibitState extends State<NewestFliesExhibit>
    with AutomaticKeepAliveClientMixin {
  FlyExhibitBloc _flyExhibitBloc;
  bool _keepAlive = true;
  int _flyCount = 0;
  int _itemsCreated = 0;

  @override
  bool get wantKeepAlive => _keepAlive;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _flyExhibitBloc =
        MyTieStateContainer.of(context).blocProvider.flyExhibitBloc;
  }

  void _handleItemCreated() async {
    _itemsCreated++;
    if (_itemsCreated == _flyCount) {
      _flyExhibitBloc.requestFetchFliesSink.add(FetchNewestFliesEvent());
      print('SCHEDULE');
      await Future.delayed(Duration(seconds: 3));
      SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
        print('CALLBACK');

        setState(() {});
      });
    }
  }

  Widget buildFlyExhibit(List<Fly> flies) {
    _flyCount = flies.length;
    return ListView.builder(
      itemCount: flies.length,
      itemBuilder: (context, index) => CreationAwareWidget(
        child: FlyOverviewExhibit(flies[index]),
        itemCreated: _handleItemCreated,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FliesExhibitStreamBuilder(
      builder: buildFlyExhibit,
    );
  }
}
