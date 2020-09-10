import 'package:flutter/material.dart';
import 'package:my_tie/styles/styles.dart';

typedef OnPressedCallback = void Function();

class ReviewEditButton extends StatelessWidget {
  final OnPressedCallback onPressedCallback;
  final String semanticLabel;

  ReviewEditButton({@required this.onPressedCallback, this.semanticLabel});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressedCallback,
      iconSize: AppFonts.h5,
      padding: EdgeInsets.fromLTRB(AppPadding.p2, 0, AppPadding.p2, 0),
      constraints:
          BoxConstraints(maxHeight: AppFonts.h4, maxWidth: AppFonts.h4),
      icon: Icon(
        Icons.edit,
        semanticLabel: semanticLabel,
      ),
    );
  }
}
