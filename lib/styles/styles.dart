import 'package:flutter/material.dart';

class AppColors {
  static const background = const Color(0xF0F0F0F0);
  static final success = Colors.green[400];
  static final error = Colors.red[400];
}

class AppFonts {
  static const h1 = 36.0;
  static const h2 = 30.0;
  static const h3 = 25.0;
  static const h4 = 21.0;
  static const h5 = 18.0;
  static const h6 = 16.0;
  static const h7 = 14.0;
  static const h8 = 12.0;
  static const h9 = 10.0;
  static const h10 = 8.0;
}

class AppPadding {
  static const p0 = 0.0;
  static const p1 = 1.0;
  static const p2 = 3.0;
  static const p3 = 5.0;
  static const p4 = 7.5;
  static const p5 = 10.0;
  static const p6 = 15.0;
  static const p7 = 20.0;
  static const p8 = 25.0;
  static const p9 = 30.0;
  static const p10 = 35.0;
  static const p11 = 40.0;
  static const p12 = 45.0;
}

class AppTextStyles {
  static const dropdown = const TextStyle(fontSize: 16);
  static const dropdownLg = const TextStyle(fontSize: 20);
  static const dropdownLabel = const TextStyle(fontSize: 20);

  static const header =
      const TextStyle(fontSize: AppFonts.h4, fontWeight: FontWeight.w600);
  static const subHeader =
      const TextStyle(fontSize: AppFonts.h6, fontWeight: FontWeight.w500);
}

class AppIcons {
  static final success = Colors.green[700];
  static final warning = Colors.yellow[700];
  static final danger = Colors.red[700];

  static Icon errorSmall(context) => Icon(Icons.error,
      size: small, color: Theme.of(context).colorScheme.error);
  static Icon errorExtraSmall(context) => Icon(Icons.error,
      size: extraSmall, color: Theme.of(context).colorScheme.error);

  static const small = 16.0;
  static const extraSmall = 14.0;

  static Color getColorByDifficulty(String difficulty) {
    switch (difficulty) {
      case 'easy':
        return success;
      case 'medium':
        return warning;
      case 'hard':
        return danger;
      default:
        return success;
    }
  }
}
