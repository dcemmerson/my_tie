import 'dart:async';

import 'package:my_tie/models/db_names.dart';
import 'package:my_tie/models/fly.dart';

class DocumentToFly<S, T> extends StreamTransformerBase<S, T> {
  final StreamTransformer<S, T> transformer;

  DocumentToFly() : transformer = createTransformer();

  @override
  Stream<T> bind(Stream<S> stream) => transformer.bind(stream);

  static StreamTransformer<S, T> createTransformer<S, T>() =>
      new StreamTransformer((Stream inputStream, bool cancelOnError) {
        StreamController controller;
        StreamSubscription subscription;
        controller = new StreamController<T>(
          onListen: () {
            subscription = inputStream.listen((snapshot) {
              List fly = snapshot.documents.map((document) {
                try {
                  return Fly(
                      attrs: snapshot.data()[0][DbNames.attributes],
                      mats: snapshot.data()[0][DbNames.materials]);
                } catch (err) {
                  print(err);
                  return Fly();
                }
              }).toList();

              controller.add(fly);
            },
                onDone: controller.close,
                onError: controller.addError,
                cancelOnError: cancelOnError);
          },
          onPause: ([Future<dynamic> resumeSignal]) =>
              subscription.pause(resumeSignal),
          onResume: () => subscription.resume(),
          onCancel: () => subscription.cancel(),
        );
        return controller.stream.listen(null);
      });
}
