import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_tie/models/db_names.dart';
import 'package:my_tie/models/fly_instruction.dart';

class DocumentToFlyInstruction<S, T> extends StreamTransformerBase<S, T> {
  final StreamTransformer<S, T> transformer;

  DocumentToFlyInstruction(int stepNumber)
      : transformer = createTransformer(stepNumber);

  @override
  Stream<T> bind(Stream<S> stream) => transformer.bind(stream);

  static StreamTransformer<S, T> createTransformer<S, T>(int stepNumber) =>
      new StreamTransformer((Stream inputStream, bool cancelOnError) {
        StreamController controller;
        StreamSubscription subscription;
        controller = new StreamController<T>(
          onListen: () {
            subscription = inputStream.listen((snapshot) {
              FlyInstruction flyInstruction;

              try {
                final Map doc = snapshot.data();
                flyInstruction = FlyInstruction.fromDoc(
                    doc[DbNames.instructions][stepNumber.toString()]);
              } catch (err) {
                print(err);
                flyInstruction = FlyInstruction();
              }
              controller.add(flyInstruction);
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