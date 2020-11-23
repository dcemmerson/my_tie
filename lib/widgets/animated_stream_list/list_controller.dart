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
import 'package:flutter/material.dart';

typedef Widget AnimatedStreamListItemBuilder<T>(
  T item,
  int index,
  BuildContext context,
  Animation<double> animation,
);

class ListController<E> {
  final GlobalKey<AnimatedListState> key;
  final List<E> items;
  final Duration duration;
  final AnimatedStreamListItemBuilder<E> itemRemovedBuilder;

  ListController({
    @required this.key,
    @required this.items,
    @required this.itemRemovedBuilder,
    @required this.duration,
  })  : assert(key != null),
        assert(itemRemovedBuilder != null),
        assert(items != null);

  AnimatedListState get _list => key.currentState;

  void insert(int index, E item) {
    items.insert(index, item);

    _list.insertItem(index, duration: duration);
  }

  void removeItemAt(int index) {
    E item = items.removeAt(index);
    _list.removeItem(
      index,
      (BuildContext context, Animation<double> animation) =>
          itemRemovedBuilder(item, index, context, animation),
      duration: duration,
    );
  }

  void listChanged(int startIndex, List<E> itemsChanged) {
    int i = 0;
    for (E item in itemsChanged) {
      items[startIndex + i] = item;
      i++;
    }

    // ignore: invalid_use_of_protected_member
    _list.setState(() {});
  }

  int get length => items.length;

  E operator [](int index) => items[index];

  int indexOf(E item) => items.indexOf(item);
}
