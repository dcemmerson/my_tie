import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:my_tie/bloc/fly_exhibit_bloc/fly_exhibit_bloc.dart';
import 'package:my_tie/bloc/state/my_tie_state.dart';
import 'package:my_tie/models/fly_exhibits/fly_exhibit.dart';
import 'package:my_tie/pages/tab_based_pages/tab_page.dart';
import 'package:my_tie/widgets/flies_exhibit/fly_exhibit_overview/fly_overview_exhibit_collapsible.dart';
import 'package:my_tie/widgets/misc/creation_aware_widget.dart';

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
  final GlobalKey<SliverAnimatedListState> _listKey =
      GlobalKey<SliverAnimatedListState>();

  List<FlyExhibit> flyExhibits;

  FlyExhibitBloc _flyExhibitBloc;
  bool _keepAlive = true;
  int _flyCount = 0;
  int _highestIndexCreated = -1;

  AnimatedList _animatedList;

  @override
  bool get wantKeepAlive => _keepAlive;
  SliverAnimatedListState get _animatedListState => _listKey.currentState;

  @override
  void initState() {
    super.initState();
    _animatedList = AnimatedList(
      key: _listKey,
      itemBuilder: buildFlyExhibit,
    );
  }

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
    _flyExhibitBloc.fliesStream.listen((exhibits) {
      _flyCount = exhibits.length;
      flyExhibits = exhibits;
      insertMissingExhibits();
      // setState(() => flyExhibits = exhibits);
    });
  }

  void insertMissingExhibits() {
    flyExhibits.asMap().forEach((index, exhibit) {
      if (!exhibit.hasBeenInserted) {
        exhibit.hasBeenInserted = true;
        _animatedListState?.insertItem(index);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
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

  // Widget buildFlyExhibit(List<FlyExhibit> flyExhibits) {
  //   // _flyCount is used closure (_handleItemCreated) passed to CreationAwareWidget
  //   // to know when to add request to fly request sink.
  //   _flyCount = flyExhibits.length;
  //   return CustomScrollView(controller: widget.scrollController,
  //       // key: PageStorageKey(widget.flyExhibitType.toString()),
  //       slivers: <Widget>[
  //         SliverList(
  //           delegate: SliverChildBuilderDelegate((context, index) {
  //             if (flyExhibits[index] is FlyExhibitLoadingIndicator)
  //               return Container(child: CircularProgressIndicator());
  //             else if (flyExhibits[index] is FlyExhibitEndCapIndicator)
  //               return AllFliesLoaded();
  //             else
  //               return CreationAwareWidget(
  //                 index: index,
  //                 child: FlyOverviewExhibitCollapsible(flyExhibits[index]),
  //                 itemCreated: _handleItemCreated,
  //               );
  //           }, addAutomaticKeepAlives: false, childCount: flyExhibits.length),
  //         ),
  //       ]);
  // }

  Widget buildFlyExhibit(
      BuildContext context, int index, Animation<double> animation) {
    // if (index > _flyCount) _flyCount = index;

    if (flyExhibits[index] is FlyExhibitLoadingIndicator)
      return Container(child: CircularProgressIndicator());
    else if (flyExhibits[index] is FlyExhibitEndCapIndicator)
      return AllFliesLoaded();
    else
      return CreationAwareWidget(
        index: index,
        child: FlyOverviewExhibitCollapsible(flyExhibits[index]),
        itemCreated: _handleItemCreated,
      );
  }

  @override
  Widget build(BuildContext context) {
    return _animatedList;
    // return FliesExhibitOverviewStreamBuilder(
    //     builder: buildFlyExhibit, stream: _flyExhibitBloc.fliesStream);
  }
}
