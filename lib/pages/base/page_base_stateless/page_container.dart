import 'package:flutter/material.dart';
import 'package:my_tie/pages/authentication_page.dart';
import 'package:my_tie/pages/base/page_base_stateless/page_base.dart';

import 'package:my_tie/pages/route_based_pages/account_page.dart';
import 'package:my_tie/pages/route_based_pages/waste_detail_page.dart';
import 'package:my_tie/pages/route_based_pages/waste_list_page.dart';
import 'package:my_tie/pages/route_based_pages/waste_post_page.dart';

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
      case PageType.WastePage:
        page = WasteListPage();
        break;
      case PageType.WasteDetailPage:
        page = WasteDetailPage();
        break;
      case PageType.WastePostPage:
        page = WastePostPage();
        break;
      case PageType.AccountPage:
        page = AccountPage();
        break;
      default:
        page = WasteListPage();
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
      case PageType.WastePage:
        return WasteListPage.title;
      case PageType.WasteDetailPage:
        return WasteDetailPage.title;
      case PageType.AccountPage:
        return AccountPage.title;
      case PageType.WastePostPage:
      default:
        return WastePostPage.title;
    }
  }

  PageType get pageType => this._pageType;
}
