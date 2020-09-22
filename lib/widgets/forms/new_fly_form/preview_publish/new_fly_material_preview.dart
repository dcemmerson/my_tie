import 'package:flutter/material.dart';
import 'package:my_tie/models/new_fly/fly_materials.dart';
import 'package:my_tie/styles/string_format.dart';
import 'package:my_tie/styles/styles.dart';

class NewFlyMaterialPreview extends StatelessWidget {
  final List<FlyMaterial> materialList;

  NewFlyMaterialPreview({this.materialList});

  Widget _buildMaterialsHeader(BuildContext context) {
    return Container(
        // alignment: Alignment.centerLeft,
        padding: EdgeInsets.fromLTRB(
            AppPadding.p2, AppPadding.p6, AppPadding.p2, AppPadding.p2),
        child: Opacity(
            opacity: 0.9,
            child: Text('Materials',
                style: TextStyle(
                  fontSize: AppFonts.h3,
                  color: Theme.of(context).colorScheme.secondaryVariant,
                  decoration: TextDecoration.underline,
                ))));
  }

  List<Widget> _buildMaterialsPreview(BuildContext context) {
    return materialList.map((mat) {
      return Card(
        color: Theme.of(context).colorScheme.surface,
        child: Column(
          children: [
            ListTile(
              leading: Icon(mat.icon, color: mat.color),
              title: Text(mat.name.toSingular().toTitleCase()),
              subtitle: Text(mat.value),
            )
          ],
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      _buildMaterialsHeader(context),
      ..._buildMaterialsPreview(context)
    ]);
  }
}
