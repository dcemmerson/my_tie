import 'dart:async';
import 'package:my_tie/models/user_profile/user_profile.dart';

class DocumentToUserProfile<S, T> extends StreamTransformerBase<S, T> {
  final StreamTransformer<S, T> transformer;

  DocumentToUserProfile() : transformer = createTransformer();

  @override
  Stream<T> bind(Stream<S> stream) => transformer.bind(stream);

  static StreamTransformer<S, T> createTransformer<S, T>() =>
      StreamTransformer((Stream inputStream, bool cancelOnError) {
        StreamController controller;
        StreamSubscription subscription;
        controller = StreamController<T>(
          onListen: () {
            subscription = inputStream.listen((snapshot) {
              final userProfile =
                  UserProfile.fromDoc(snapshot.documents[0].data());

              controller.add(userProfile);
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
