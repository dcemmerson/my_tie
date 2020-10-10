import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:my_tie/bloc/fly_exhibit_bloc.dart';
import 'package:my_tie/bloc/state/my_tie_state.dart';
import 'package:my_tie/models/new_fly/fly.dart';
import 'package:my_tie/widgets/flies_exhibit/flies_exhibit_stream_builder.dart';
import 'package:my_tie/widgets/misc/creation_aware_widget.dart';

import 'all_flies_loaded.dart';
import 'fly_exhibit_overview/fly_overview_exhibit.dart';

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
  int _highestIndexCreated = -1;

  @override
  bool get wantKeepAlive => _keepAlive;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _flyExhibitBloc =
        MyTieStateContainer.of(context).blocProvider.flyExhibitBloc;
  }

  void _handleItemCreated(int index) {
    if (index > _highestIndexCreated) {
      _highestIndexCreated = index;
    }
    if (_highestIndexCreated >= _flyCount - 1) {
      _flyExhibitBloc.requestFetchFliesSink.add(FetchNewestFliesEvent());

      // Ensure we don't call setState while frame in progress.
      SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
        setState(() {});
      });
    }
  }

  Widget buildFlyExhibit(List<Fly> flies) {
    _flyCount = flies.length;
    return ListView.builder(
        addAutomaticKeepAlives: false,
        itemCount: flies.length,
        itemBuilder: (context, index) {
          if (flies[index] is FlyLoadingIndicator)
            return Container(child: CircularProgressIndicator());
          else if (flies[index] is FlyEndCapIndicator)
            return AllFliesLoaded();
          else
            return CreationAwareWidget(
              index: index,
              child: FlyOverviewExhibit(flies[index]),
              itemCreated: _handleItemCreated,
            );
        });
  }

  @override
  Widget build(BuildContext context) {
    return FliesExhibitStreamBuilder(
      builder: buildFlyExhibit,
    );
  }
}
