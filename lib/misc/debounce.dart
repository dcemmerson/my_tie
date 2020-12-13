/// filename: debounce.dart
/// description: Class which contains typical deounce behavior, for
///   example to prevent excessive API calls being made when user
///   is typing input into a input field that fires events on change.
import 'dart:async';

class Debounce {
  final Duration delay;
  final Function callback;
  Timer _timer;

  Debounce(this.delay, this.callback);

  Function call() {
    return (args) {
      _timer?.cancel();
      _timer = Timer(delay, () => callback(args));
    };
  }

  void close() {
    _timer.cancel();
  }
}
