/// filename: subpage_container.dart
/// last modified: 08/30/2020
/// description: SubPageContainer extends the SubPageBase class and defines
///   the getter methods for page body and page title. SubPageContainer is used
///   in the route journy when a user is adding a new fly. SubPageContainer
///   allows user to take an inner journy in the new fly tab, still while being
///   able to swipe to the other pages available in the app and not lose their
///   progress.

import 'package:flutter/material.dart';

import 'package:my_tie/pages/base/page_base_stateless/subpage_base.dart';
import 'package:my_tie/pages/bottom_navigation_based_pages/new_fly_start_page.dart';
import 'package:my_tie/pages/route_based_pages/new_fly_pages/add_new_attribute_page.dart';
import 'package:my_tie/pages/route_based_pages/new_fly_pages/new_fly_instruction_page.dart';
import 'package:my_tie/pages/route_based_pages/new_fly_pages/add_new_property_page.dart';

import 'package:my_tie/pages/route_based_pages/new_fly_pages/new_fly_attributes_page.dart';
import 'package:my_tie/pages/route_based_pages/new_fly_pages/new_fly_materials_page.dart';
import 'package:my_tie/pages/route_based_pages/new_fly_pages/new_fly_preview_publish_page.dart';
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
      case SubPageType.NewFlyInstructionPage:
        page = NewFlyInstructionPage();
        break;
      case SubPageType.NewFlyPreviewPublishPage:
        page = NewFlyPreviewPublishPage();
        break;
      // DB new fly form template editing routes:
      case SubPageType.AddNewAttributePage:
        page = AddNewAttributePage();
        break;
      case SubPageType.AddNewPropertyPage:
        page = AddNewPropertyPage();
        break;
      // case SubPageType.InstructionStepDetailPage:
      //   page = InstructionStepDetailPage();
      //   break;

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
      case SubPageType.AddNewAttributePage:
        return AddNewAttributePage.title;
      case SubPageType.AddNewPropertyPage:
        return AddNewPropertyPage.title;
      case SubPageType.NewFlyInstructionPage:
        return NewFlyInstructionPage.title;
      case SubPageType.NewFlyPreviewPublishPage:
        return NewFlyPreviewPublishPage.title;
      // case SubPageType.InstructionStepDetailPage:
      //   return InstructionStepDetailPage.title;
      default:
        return NewFlyMaterialsPage.title;
    }
  }

  SubPageType get subPageType => this._subPageType;
}
