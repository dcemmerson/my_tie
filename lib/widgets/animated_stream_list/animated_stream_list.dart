/// This implementation of AnimatedStreamList is almost entirely identical
/// to that found at https://pub.dev/packages/animated_stream_list. The key
/// difference is that there appears to be a bug with the AnimatedStreamList
/// available from pub.dev, specifically, that package incorrectly attempts
/// to access the Equalizer static method, DiffUtil.eq, which was not
/// passed to myersDiff in the spawned isolate in the original package (as
/// of Nov 2020), thus finding null and defaulting to (a, b) => a == b.
/// This results in animating wrong list item on UI. I have opened an
/// issue and proposed solutions (and offered to open pull request) and
/// offered to submit pull request but as of No 2020, AnimatedListStream
/// from pub.dev is still broken, which is why we are implementing it here.
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'diff_applier.dart';
import 'list_controller.dart';
import 'myers_diff.dart';

class AnimatedStreamList<E> extends StatefulWidget {
  final Stream<List<E>> streamList;
  final List<E> initialList;
  final AnimatedStreamListItemBuilder<E> itemBuilder;
  final AnimatedStreamListItemBuilder<E> itemRemovedBuilder;
  final Axis scrollDirection;
  final bool reverse;
  final ScrollController scrollController;
  final bool primary;
  final ScrollPhysics scrollPhysics;
  final bool shrinkWrap;
  final EdgeInsetsGeometry padding;
  final Equalizer equals;
  final Duration duration;

  AnimatedStreamList(
      {@required this.streamList,
      this.initialList,
      @required this.itemBuilder,
      @required this.itemRemovedBuilder,
      this.scrollDirection: Axis.vertical,
      this.reverse: false,
      this.scrollController,
      this.primary,
      this.scrollPhysics,
      this.shrinkWrap: false,
      this.padding,
      this.equals,
      this.duration = const Duration(milliseconds: 300)});

  @override
  State<StatefulWidget> createState() => _AnimatedStreamListState<E>();
}

class _AnimatedStreamListState<E> extends State<AnimatedStreamList<E>>
    with WidgetsBindingObserver {
  final GlobalKey<AnimatedListState> _globalKey = GlobalKey();
  ListController<E> _listController;
  DiffApplier<E> _diffApplier;
  DiffUtil<E> _diffUtil;
  StreamSubscription _subscription;

  void startListening() {
    _subscription?.cancel();
    _subscription = widget.streamList.asyncExpand((list) {
      print(list);
      return _diffUtil
          .calculateDiff(_listController.items, list, equalizer: widget.equals)
          .then(_diffApplier.applyDiffs)
          .asStream();
    }).listen((list) {});
  }

  void stopListening() {
    _subscription?.cancel();
    _subscription = null;
  }

  @override
  void initState() {
    super.initState();
    _listController = ListController(
        key: _globalKey,
        items: widget.initialList ?? <E>[],
        itemRemovedBuilder: widget.itemRemovedBuilder,
        duration: widget.duration);

    _diffApplier = DiffApplier(_listController);
    _diffUtil = DiffUtil();

    startListening();
  }

  @override
  void dispose() {
    stopListening();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        startListening();
        break;
      case AppLifecycleState.paused:
        stopListening();
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedList(
      initialItemCount: _listController.items.length,
      key: _globalKey,
      scrollDirection: widget.scrollDirection,
      reverse: widget.reverse,
      primary: widget.primary,
      controller: widget.scrollController,
      physics: widget.scrollPhysics,
      padding: widget.padding,
      shrinkWrap: widget.shrinkWrap,
      itemBuilder:
          (BuildContext context, int index, Animation<double> animation) =>
              widget.itemBuilder(
        _listController[index],
        index,
        context,
        animation,
      ),
    );
  }
}
