import 'package:flutter/material.dart';
import 'package:my_tie/models/new_fly/fly_attribute.dart';
import 'package:my_tie/styles/styles.dart';

class FlyExhibitAttributes extends StatelessWidget {
  final List<FlyAttribute> attributes;

  FlyExhibitAttributes(this.attributes);

  @override
  Widget build(BuildContext context) {
    return
        // Flexible(
        //   child:
        Container(
      child: Wrap(
        alignment: WrapAlignment.spaceEvenly,
        children: attributes
            // .where((attr) => attr.name != 'difficulty')
            .map(
              (attr) =>
                  // ClipRRect(
                  // borderRadius: BorderRadius.all(Radius.circular(5)),
                  // child:
                  Container(
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
                  // border: Border.all(color: Color('0xffffff'))
                ),
                // color: attr.color,
                child: Text(
                  attr.value,
                  style: TextStyle(
                      fontSize: AppFonts.h6,
                      color: Theme.of(context).colorScheme.onPrimary),
                ),
              ),
              // ),
            )
            .toList(),
      ),

      // ),
    );
  }
}
