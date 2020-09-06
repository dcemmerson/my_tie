import 'package:my_tie/utils/miscellaneous_constants.dart';
import 'package:my_tie/utils/range.dart';

/// filename: format.dart
/// description: Class with all static methods used for formatting strings
///   when displaying on screen. For example, make a string singular, make a
///   string in sentence case, etc.

extension StringExtension on String {
  static const ellipsis = '...';

  String toSingular() {
    RegExp regEx = RegExp('s\$');
    if (regEx.hasMatch(this)) {
      return substring(0, this.length - 1);
    } else {
      return this;
    }
  }

  String toSentenceCase() {
    RegExp regEx = RegExp('^[a-z]');
    return replaceAllMapped(regEx, (match) {
      return this[match.start].toUpperCase();
    });
  }

  String toTitleCase() {
    // This regex is inspired by https://www.30secondsofcode.org/dart/s/to-title-case
    RegExp regExp = RegExp(
        r'[A-Z]{2,}(?=[A-Z][a-z]+[0-9]*|\b)|[A-Z]?[a-z]+[0-9]*|[A-Z]|[0-9]+');

    return replaceAllMapped(regExp, (match) {
      return '${this[match.start].toUpperCase()}${this.substring(match.start + 1, match.end)}';
    });
  }

  String toPreview() {
    if (this.length <
        MiscellaneousConstants.maxPreviewLength + ellipsis.length) {
      return this;
    } else {
      return this.substring(0, MiscellaneousConstants.maxPreviewLength) +
          ellipsis;
    }
  }
}
