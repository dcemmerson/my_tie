import 'package:flutter/material.dart';
import 'package:my_tie/models/arguments/routes_based/fly_instruction_modal_transfer.dart';
import 'package:my_tie/models/bloc_transfer_related/user_profile_fly_material_add_or_delete.dart';
import 'package:my_tie/models/fly_exhibits/fly_exhibit.dart';
import 'package:my_tie/models/new_fly/fly_instruction.dart';
import 'package:my_tie/routes/modal_routes.dart';
import 'package:my_tie/styles/string_format.dart';
import 'package:my_tie/styles/styles.dart';
import 'package:my_tie/widgets/title/title_group.dart';

class FlyExhibitDetailInstructions extends StatelessWidget {
  final FlyExhibit flyExhibit;

  const FlyExhibitDetailInstructions({Key key, this.flyExhibit})
      : super(key: key);
  List<Widget> _buildInstructions(BuildContext context) {
    return flyExhibit.fly.instructions.map((instr) {
      return Container(
        child: Column(children: [
          Card(
            color: Theme.of(context).colorScheme.surface,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  leading: Text(instr.step.toString(),
                      style: TextStyle(fontSize: AppFonts.h1)),
                  title: Text(instr.title),
                  subtitle: Text(instr.description),
                ),
                Wrap(
                  children: instr.imageUris
                      .map((uri) => _buildImage(instr, uri, context))
                      .toList(),
                ),
              ],
            ),
          ),
        ]),
      );
    }).toList();
  }

  Widget _buildImage(
      FlyInstruction instruction, String uri, BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => GestureDetector(
        onTap: () => instructionDetailDialog(instruction, uri, context),
        child: Padding(
          padding: EdgeInsets.all(AppPadding.p2),
          child: Image.network(
            uri,
            width: constraints.maxWidth / 2 - 2 * AppPadding.p2,
            height: constraints.maxWidth / 2 - 2 * AppPadding.p2,
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
        ),
      ),
    );
  }

  Future instructionDetailDialog(
      FlyInstruction instruction, String uri, BuildContext context) async {
    await ModalRoutes.instructionStepModalPage(
        context,
        FlyInstructionModalTransfer(
            initImageUri: uri, flyInstruction: instruction));
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      TitleGroup(title: 'Instructions'),
      ..._buildInstructions(context),
    ]);
  }
}
