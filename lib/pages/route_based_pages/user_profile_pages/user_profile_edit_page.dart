import 'package:flutter/material.dart';
import 'package:my_tie/widgets/profile/profile_edit/user_profile_edit.dart';

class UserProfileEditPage extends StatelessWidget {
  static const route = '/userprofiledit';
  static const title = 'Edit Materials On Hand';

  @override
  Widget build(BuildContext context) {
    return UserProfileEdit();
  }
}
