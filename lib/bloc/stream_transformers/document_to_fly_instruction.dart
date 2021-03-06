import 'dart:async';

import 'package:my_tie/models/bloc_transfer_related/fly_instruction_transfer.dart';
import 'package:my_tie/models/db_names.dart';
import 'package:my_tie/models/new_fly/fly.dart';
import 'package:my_tie/models/new_fly/fly_instruction.dart';

class DocumentToFlyInstruction<S, T> extends StreamTransformerBase<S, T> {
  final StreamTransformer<S, T> transformer;

  DocumentToFlyInstruction(int stepNumber)
      : transformer = createTransformer(stepNumber);

  @override
  Stream<T> bind(Stream<S> stream) => transformer.bind(stream);

  static StreamTransformer<S, T> createTransformer<S, T>(int stepNumber) =>
      StreamTransformer((Stream inputStream, bool cancelOnError) {
        StreamController controller;
        StreamSubscription subscription;
        controller = StreamController<T>(
          onListen: () {
            subscription = inputStream.listen((snapshot) {
              Fly fly;
              FlyInstruction flyInstruction;

              try {
                final Map doc = snapshot.docs[0].data();
                fly = Fly(
                  docId: snapshot.docs[0].id,
                  flyName: doc[DbNames.flyName],
                  attrs: doc[DbNames.attributes],
                  mats: doc[DbNames.materials],
                  instr: doc[DbNames.instructions],
                );
                if (doc[DbNames.instructions] != null &&
                    doc[DbNames.instructions][stepNumber.toString()] != null) {
                  flyInstruction = FlyInstruction.fromDoc(
                      doc[DbNames.instructions][stepNumber.toString()]);
                } else {
                  flyInstruction = FlyInstruction();
                }
              } catch (err) {
                print(err);
                flyInstruction = FlyInstruction();
                fly = Fly();
              }
              controller.add(FlyInstructionTransfer(
                  fly: fly, flyInstruction: flyInstruction));
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
