import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:my_tie/models/fly_instruction.dart';
import 'package:my_tie/routes/modal_routes.dart';
import 'package:my_tie/styles/styles.dart';
import 'package:my_tie/widgets/forms/new_fly_form/preview_publish/instruction_preview/instruction_preview_carousel.dart';

class NewFlyInstructionsPreview extends StatelessWidget {
  static const _imagePadding = 10.0;
  static const _imagesPerRun = 2;

  final List<FlyInstruction> instructions;

  NewFlyInstructionsPreview({this.instructions});

  Widget _buildInstructionsHeader(BuildContext context) {
    return Container(
        padding: EdgeInsets.fromLTRB(
            AppPadding.p2, AppPadding.p6, AppPadding.p2, AppPadding.p2),
        child: Opacity(
            opacity: 0.9,
            child: Text('Instructions',
                style: TextStyle(
                  fontSize: AppFonts.h3,
                  color: Theme.of(context).colorScheme.secondaryVariant,
                  decoration: TextDecoration.underline,
                ))));
  }

  List<Widget> _buildInstructions(BuildContext context) {
    return instructions.map((instr) {
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
                        .toList()),
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
      builder: (context, constraints) => Hero(
        tag: uri,
        child: GestureDetector(
          onTap: () => instructionDetailDialog(instruction, uri, context),
          child: Image.network(
            uri,
            width: constraints.maxWidth / 2,
            height: constraints.maxWidth / 2,
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
    await ModalRoutes.instructionStepModalPage(context);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildInstructionsHeader(context),
        ..._buildInstructions(context)
      ],
    );
  }
}
