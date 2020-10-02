/// filename: instruction_step_modal.dart
/// description: Entry widget for route when user is looking at preview of new
///   fly and taps on an image. This route allows user to look at just a single
///   instruction, with the photo they tapped on blown up, and swipe to see the
///   other photos.

import 'package:flutter/material.dart';
import 'package:my_tie/models/arguments/routes_based/fly_instruction_modal_transfer.dart';
import 'package:my_tie/styles/styles.dart';

class InstructionStepModal extends StatelessWidget {
  final FlyInstructionModalTransfer fimt;

  InstructionStepModal({this.fimt});

  double _min(double a, double b) {
    if (a < b)
      return a;
    else
      return b;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AlertDialog(
        title: ListTile(
          leading: Text(fimt.flyInstruction.step.toString(),
              style: TextStyle(
                  fontSize: AppFonts.h1, fontStyle: FontStyle.normal)),
          title: Text(fimt.flyInstruction.title),
          subtitle: Text(fimt.flyInstruction.description),
        ),
        content: Container(
          child: Hero(
            tag: fimt.initImageUri,
            // child: Container(
            // height: _min(MediaQuery.of(context).size.height * 0.75, 800),
            // width: _min(MediaQuery.of(context).size.width * 0.9, 600),
            child: Image.network(
              fimt.initImageUri,
              // width: constraints.maxWidth / 2,
              // height: constraints.maxWidth / 2,
              fit: BoxFit.fill,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress != null) {
                  return Center(
                    child: LinearProgressIndicator(
                      value: loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes,
                    ),
                  );
                }
                return child;
              },
            ),
            // ),
          ),
        ),
      ),
    );
  }
}
