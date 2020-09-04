import 'package:flutter/material.dart';
import 'package:my_tie/bloc/state/my_tie_state.dart';
import 'package:my_tie/models/arguments/instruction_page_attribute.dart';
import 'package:my_tie/models/fly_instruction.dart';

typedef BuildPage = Widget Function(FlyInstruction);

class FlyInProgressInstructionStepStreamBuilder extends StatelessWidget {
  final BuildPage child;
  final InstructionPageAttribute instructionPageAttribute;
  FlyInProgressInstructionStepStreamBuilder(
      {@required this.instructionPageAttribute, @required this.child});

  Widget _buildLoading() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: MyTieStateContainer.of(context)
            .blocProvider
            .newFlyBloc
            .getFlyInProgressInstructionStep(instructionPageAttribute),
        builder: (context, AsyncSnapshot<FlyInstruction> snapshot) {
          print(snapshot.connectionState);
          if (snapshot.hasError) {
            print(snapshot.error);
            return Text('error occurred');
          }
          switch (snapshot.connectionState) {
            case (ConnectionState.done):
            case (ConnectionState.active):
              return child(snapshot.data);
            case (ConnectionState.none):
            case (ConnectionState.waiting):
            default:
              return _buildLoading();
          }
        });
  }
}
