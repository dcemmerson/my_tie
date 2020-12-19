import 'package:flutter/material.dart';
import 'package:my_tie/pages/authentication_page.dart';
import 'package:my_tie/pages/base/page_base_stateless/page_base.dart';
import 'package:my_tie/pages/bottom_navigation_based_pages/home_page.dart';
import 'package:my_tie/pages/bottom_navigation_based_pages/new_fly_start_page.dart';
import 'package:my_tie/pages/bottom_navigation_based_pages/profile_page.dart';
import 'package:my_tie/pages/route_based_pages/fly_exhibit_pages/fly_exhibit_detail_page.dart';
import 'package:my_tie/pages/route_based_pages/fly_search_pages/fly_search_page.dart';
import 'package:my_tie/pages/route_based_pages/new_fly_pages/add_new_attribute_page.dart';
import 'package:my_tie/pages/route_based_pages/new_fly_pages/add_new_property_page.dart';
import 'package:my_tie/pages/route_based_pages/new_fly_pages/new_fly_attributes_page.dart';
import 'package:my_tie/pages/route_based_pages/new_fly_pages/new_fly_instruction_page.dart';
import 'package:my_tie/pages/route_based_pages/new_fly_pages/new_fly_materials_page.dart';
import 'package:my_tie/pages/route_based_pages/new_fly_pages/new_fly_preview_publish_page.dart';
import 'package:my_tie/pages/route_based_pages/new_fly_pages/new_fly_publish_page.dart';
import 'package:my_tie/pages/route_based_pages/user_profile_pages/user_profile_edit_material_page.dart';
import 'package:my_tie/pages/tab_based_pages/tab_page.dart';
import 'package:my_tie/widgets/search_bar/fly_search.dart';

class PageContainer extends PageBase {
  final PageType _pageType;

  PageContainer({Key key, @required pageType, List<TabPage> tabPages})
      : this._pageType = pageType,
        super(key: key, tabPages: tabPages);

  @override
  Widget get body {
    var page;
    switch (pageType) {
      case PageType.AuthenticationPage:
        page = AuthenticationPage();
        break;
      // Start/Home page related.
      case PageType.HomePage:
        page = HomePage();
        break;
      case PageType.FlySearchPage:
        page = FlySearchPage();
        break;
      // Fly exhibit related.
      case PageType.FlyExhibitDetailPage:
        return FlyExhibitDetailPage();
      // User profile related.
      case PageType.ProfilePage:
        page = ProfilePage();
        break;
      case PageType.UserProfileEditMaterialPage:
        page = UserProfileEditMaterialPage();
        break;
      // New fly related.
      case PageType.NewFlyStartPage:
        page = NewFlyStartPage();
        break;
      case PageType.NewFlyAttributesPage:
        page = NewFlyAttributesPage();
        break;
      case PageType.NewFlyMaterialsPage:
        page = NewFlyMaterialsPage();
        break;
      case PageType.NewFlyPublishPage:
        page = NewFlyPublishPage();
        break;
      case PageType.NewFlyInstructionPage:
        page = NewFlyInstructionPage();
        break;
      case PageType.NewFlyPreviewPublishPage:
        page = NewFlyPreviewPublishPage();
        break;
      // DB new fly form template editing routes:
      case PageType.AddNewAttributePage:
        page = AddNewAttributePage();
        break;
      case PageType.AddNewPropertyPage:
        page = AddNewPropertyPage();
        break;
      default:
        page = ProfilePage();
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
      // case PageType.AccountPage:
      //   return AccountPage.title;
      // Start/Home page related.
      case PageType.HomePage:
        return HomePage.route;
      case PageType.FlySearchPage:
        return FlySearchPage.route;
      // Fly exhibit related.
      case PageType.FlyExhibitDetailPage:
        return FlyExhibitDetailPage.route;
      // Profile related.
      case PageType.ProfilePage:
        return ProfilePage.route;
      case PageType.UserProfileEditMaterialPage:
        return UserProfileEditMaterialPage.title;
      // New fly related.
      case PageType.NewFlyStartPage:
        return NewFlyStartPage.route;
      case PageType.NewFlyAttributesPage:
        return NewFlyAttributesPage.title;
      case PageType.NewFlyMaterialsPage:
        return NewFlyMaterialsPage.title;
      case PageType.NewFlyPublishPage:
        return NewFlyPublishPage.title;
      case PageType.AddNewAttributePage:
        return AddNewAttributePage.title;
      case PageType.AddNewPropertyPage:
        return AddNewPropertyPage.title;
      case PageType.NewFlyInstructionPage:
        return NewFlyInstructionPage.title;
      case PageType.NewFlyPreviewPublishPage:
        return NewFlyPreviewPublishPage.title;
      default:
        return ProfilePage.route;
    }
  }

  PageType get pageType => this._pageType;
}
