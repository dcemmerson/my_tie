import 'package:flutter/material.dart';
import 'package:my_tie/pages/authentication_page.dart';
import 'package:my_tie/pages/base/page_base_stateless/page_base.dart';
import 'package:my_tie/pages/route_based_pages/user_profile_pages/profile_page.dart';
import 'package:my_tie/pages/route_based_pages/user_profile_pages/user_profile_edit_page.dart';

class PageContainer extends PageBase {
  final PageType _pageType;

  PageContainer({Key key, @required pageType})
      : this._pageType = pageType,
        super(key: key);

  @override
  Widget get body {
    var page;
    switch (pageType) {
      case PageType.AuthenticationPage:
        page = AuthenticationPage();
        break;
      case PageType.AccountPage:
        page = AccountPage();
        break;
      case PageType.UserProfileEditPage:
        page = UserProfileEditPage();
        break;
      default:
        page = AccountPage();
    }
    return Padding(
      padding: EdgeInsets.zero,
      child: page,
    );
  }

  @override
  String get pageTitle {
    switch (pageType) {
      case PageType.AuthenticationPage:
        return AuthenticationPage.title;
      case PageType.AccountPage:
        return AccountPage.title;
      case PageType.UserProfileEditPage:
        return UserProfileEditPage.title;
      default:
        return AccountPage.title;
    }
  }

  PageType get pageType => this._pageType;
}
