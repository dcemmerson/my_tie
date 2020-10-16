import 'package:flutter/material.dart';
import 'package:my_tie/models/new_fly/fly_attribute.dart';
import 'package:my_tie/styles/styles.dart';

class FlyExhibitAttributes extends StatelessWidget {
  final List<FlyAttribute> attributes;

  FlyExhibitAttributes(this.attributes);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Wrap(
        alignment: WrapAlignment.spaceEvenly,
        children: attributes
            .map(
              (attr) => Container(
                padding:
                    EdgeInsets.fromLTRB(AppPadding.p2, 0, AppPadding.p2, 0),
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey[900],
                      blurRadius: 3,
                      offset: Offset(0, 3),
                    )
                  ],
                  color: attr.color,
                  borderRadius: BorderRadius.all(Radius.circular(3)),
                ),
                child: Text(
                  attr.value,
                  style: TextStyle(
                      fontSize: AppFonts.h6,
                      color: Theme.of(context).colorScheme.onPrimary),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
