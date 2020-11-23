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
abstract class DiffVisitor {
  void visitInsertDiff(InsertDiff diff);

  void visitDeleteDiff(DeleteDiff diff);

  void visitChangeDiff(ChangeDiff diff);
}

abstract class Diff implements Comparable<Diff> {
  final int index;
  final int size;

  const Diff(this.index, this.size);

  @override
  String toString() {
    return "${this.runtimeType.toString()} index: $index, size: $size";
  }

  @override
  int compareTo(Diff other) => index - other.index;

  void accept(DiffVisitor visitor);
}

class InsertDiff<E> extends Diff {
  final List<E> items;

  InsertDiff(int index, int size, this.items) : super(index, size);

  @override
  void accept(DiffVisitor visitor) => visitor.visitInsertDiff(this);
}

class DeleteDiff extends Diff {
  DeleteDiff(int index, int size) : super(index, size);

  @override
  void accept(DiffVisitor visitor) => visitor.visitDeleteDiff(this);
}

class ChangeDiff<E> extends Diff {
  final List<E> items;

  ChangeDiff(int index, int size, this.items) : super(index, size);

  @override
  void accept(DiffVisitor visitor) => visitor.visitChangeDiff(this);
}
