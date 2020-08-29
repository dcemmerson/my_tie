import 'package:flutter/material.dart';

import 'package:my_tie/pages/base/page_base_stateless/subpage_base.dart';
import 'package:my_tie/pages/bottom_navigation_based_pages/new_fly_start_page.dart';

import 'package:my_tie/pages/route_based_pages/new_fly_pages/new_fly_attributes_page.dart';
import 'package:my_tie/pages/route_based_pages/new_fly_pages/new_fly_materials_page.dart';
import 'package:my_tie/pages/route_based_pages/new_fly_pages/new_fly_publish_page.dart';

class SubPageContainer extends SubPageBase {
  final SubPageType _subPageType;

  SubPageContainer({Key key, @required subPageType})
      : this._subPageType = subPageType,
        super(key: key);

  @override
  Widget get body {
    var page;
    switch (subPageType) {
      case SubPageType.NewFlyStartPage:
        page = NewFlyStartPage();
        break;
      case SubPageType.NewFlyAttributesPage:
        page = NewFlyAttributesPage();
        break;
      case SubPageType.NewFlyMaterialsPage:
        page = NewFlyMaterialsPage();
        break;
      case SubPageType.NewFlyPublishPage:
        page = NewFlyPublishPage();
        break;
      default:
        page = NewFlyStartPage();
    }
    return Padding(
      padding: EdgeInsets.zero,
      child: page,
    );
  }

  @override
  String get subPageTitle {
    switch (subPageType) {
      case SubPageType.NewFlyStartPage:
        return NewFlyStartPage.route;
      case SubPageType.NewFlyAttributesPage:
        return NewFlyAttributesPage.title;
      case SubPageType.NewFlyMaterialsPage:
        return NewFlyMaterialsPage.title;
      case SubPageType.NewFlyPublishPage:
        return NewFlyPublishPage.title;
      default:
        return NewFlyMaterialsPage.title;
    }
  }

  SubPageType get subPageType => this._subPageType;
}
