import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:my_tie/bloc/fly_exhibit_bloc/fly_exhibit_bloc.dart';
import 'package:my_tie/bloc/state/my_tie_state.dart';
import 'package:my_tie/models/fly_exhibits/fly_exhibit.dart';
import 'package:my_tie/pages/tab_based_pages/tab_page.dart';
import 'package:my_tie/widgets/misc/creation_aware_widget.dart';
import 'package:animated_stream_list/animated_stream_list.dart';

import 'all_flies_loaded.dart';
import 'flies_exhibit_overview_stream_builder.dart';
import 'fly_exhibit_overview/fly_overview_exhibit.dart';

class FliesExhibitEntry extends StatefulWidget {
  final FlyExhibitType flyExhibitType;
  final ScrollController scrollController;

  FliesExhibitEntry({
    this.flyExhibitType,
    this.scrollController,
    // this.parentScrollController,
  });

  @override
  _FliesExhibitEntryState createState() => _FliesExhibitEntryState();
}

class _FliesExhibitEntryState extends State<FliesExhibitEntry>
    with AutomaticKeepAliveClientMixin {
  FlyExhibitBloc _flyExhibitBloc;
  bool _keepAlive = true;
  int _flyCount = 0;
  int _highestIndexCreated = -1;

  @override
  bool get wantKeepAlive => _keepAlive;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // We switch on the flyExhibitPage type passed in when forming the route,
    // which correspond to the three tabs on the UI: By Materials, Newest, or
    // Favorites. Different cases just pass in a different stream to the
    // StreamBuilder component and resuse the rest of the components and logic/
    // routing.
    switch (widget.flyExhibitType) {
      case FlyExhibitType.Newest:
        _flyExhibitBloc =
            MyTieStateContainer.of(context).blocProvider.newestFlyExhibitBloc;
        break;
      case FlyExhibitType.Favorites:
        _flyExhibitBloc = MyTieStateContainer.of(context)
            .blocProvider
            .favoritedFlyExhibitBloc;
        break;
      case FlyExhibitType.MaterialMatch:
      default:
        _flyExhibitBloc = MyTieStateContainer.of(context)
            .blocProvider
            .byMaterialsFlyExhibitBloc;
    }
  }

  void _handleItemCreated(int index) {
    if (index > _highestIndexCreated) {
      _highestIndexCreated = index;

      if (_highestIndexCreated >= _flyCount - 1) {
        _flyExhibitBloc.requestFetchFliesSink.add(FetchNewestFliesEvent());

        // Ensure we don't call setState while frame in progress.
        SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
          setState(() {});
        });
      }
    }
  }

  Widget buildFlyExhibit(List<FlyExhibit> flyExhibits) {
    // _flyCount is used closure (_handleItemCreated) passed to CreationAwareWidget
    // to know when to add request to fly request sink.
    _flyCount = flyExhibits.length;
    return CustomScrollView(controller: widget.scrollController,
        // key: PageStorageKey(widget.flyExhibitType.toString()),
        slivers: <Widget>[
          SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              if (flyExhibits[index] is FlyExhibitLoadingIndicator)
                return Container(child: CircularProgressIndicator());
              else if (flyExhibits[index] is FlyExhibitEndCapIndicator)
                return AllFliesLoaded();
              else
                return CreationAwareWidget(
                  index: index,
                  child: FlyOverviewExhibit(flyExhibits[index]),
                  itemCreated: _handleItemCreated,
                );
            }, addAutomaticKeepAlives: false, childCount: flyExhibits.length),
          ),
        ]);
  }

  Widget _buildTile(
      FlyExhibit flyExhibit, int index, Animation<double> animation) {
    // TextStyle textStyle = TextStyle();
    if (flyExhibit is FlyExhibitLoadingIndicator)
      return Container(child: CircularProgressIndicator());
    else if (flyExhibit is FlyExhibitEndCapIndicator)
      return AllFliesLoaded();
    else
      return SizeTransition(
        axis: Axis.vertical,
        sizeFactor: animation,
        child: CreationAwareWidget(
          index: index,
          child: FlyOverviewExhibit(flyExhibit),
          itemCreated: _handleItemCreated,
        ),
      );
  }

  Widget _buildRemovedTile(
      FlyExhibit flyExhibit, int index, Animation<double> animation) {
    // print('\n\n\n');
    // print(index);

    // TextStyle textStyle = TextStyle();
    if (flyExhibit is FlyExhibitLoadingIndicator)
      return Container(child: CircularProgressIndicator());
    else if (flyExhibit is FlyExhibitEndCapIndicator)
      return AllFliesLoaded();
    else
      return SizeTransition(
        axis: Axis.vertical,
        sizeFactor: animation,
        child: CreationAwareWidget(
          index: index,
          child: FlyOverviewExhibit(flyExhibit),
          itemCreated: _handleItemCreated,
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    print('build fly exhibit entry');
    if (widget.flyExhibitType == FlyExhibitType.Favorites) {
      return AnimatedStreamList<FlyExhibit>(
          initialList: [],
          duration: Duration(seconds: 5),
          equals: (a, b) {
            print('hello world');
            return FlyExhibit.equals(a as FlyExhibit, b as FlyExhibit);
          },
          itemBuilder: (flyExhibit, index, context, animation) =>
              _buildTile(flyExhibit, index, animation),
          itemRemovedBuilder: (flyExhibit, index, context, animation) =>
              _buildRemovedTile(flyExhibit, index, animation),
          streamList: _flyExhibitBloc.fliesStream);
    } else {
      return FliesExhibitOverviewStreamBuilder(
          builder: buildFlyExhibit, stream: _flyExhibitBloc.fliesStream);
    }
  }
}
