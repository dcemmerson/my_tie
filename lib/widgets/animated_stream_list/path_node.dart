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
abstract class PathNode {
  final int originIndex;
  final int revisedIndex;
  final PathNode previousNode;

  PathNode(this.originIndex, this.revisedIndex, this.previousNode);

  bool isSnake();

  bool isBootStrap() => originIndex < 0 || revisedIndex < 0;

  PathNode previousSnake() {
    if (isBootStrap()) return null;
    if (!isSnake() && previousNode != null) return previousNode.previousSnake();
    return this;
  }

  @override
  String toString() {
    final buffer = StringBuffer();
    buffer.write("[");
    PathNode node = this;
    while (node != null) {
      buffer.write("(");
      buffer.write("${node.originIndex.toString()}");
      buffer.write(",");
      buffer.write("${node.revisedIndex.toString()}");
      buffer.write(")");
      node = node.previousNode;
    }
    buffer.write("]");
    return buffer.toString();
  }
}

class Snake extends PathNode {
  Snake(int originIndex, int revisedIndex, PathNode previousNode)
      : super(originIndex, revisedIndex, previousNode);

  @override
  bool isSnake() => true;
}

class DiffNode extends PathNode {
  DiffNode(int originIndex, int revisedIndex, PathNode previousNode)
      : super(originIndex, revisedIndex,
            previousNode == null ? null : previousNode.previousSnake());

  @override
  bool isSnake() => false;
}
