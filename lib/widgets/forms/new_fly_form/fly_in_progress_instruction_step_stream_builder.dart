import 'package:flutter/material.dart';
import 'package:my_tie/bloc/state/my_tie_state.dart';
import 'package:my_tie/models/arguments/instruction_page_attribute.dart';
import 'package:my_tie/models/bloc_transfer_related/fly_instruction_transfer.dart';

typedef BuildPage = Widget Function(FlyInstructionTransfer);

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
        builder: (context, AsyncSnapshot<FlyInstructionTransfer> snapshot) {
          //FlyInstructionTransfer adapt
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
