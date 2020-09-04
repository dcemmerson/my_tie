/// filename: fly_form_routes.dart
/// description: FlyFormRoutes is a static class which contains routes specific
///   to the user filling out the new fly form, as well as editting the fly form
///   template in the db. FlyFormRoutes must be imported in Routes.dart to
///   register routes when app launches. All routes in this file require user
///   to be logged in to access, which is implemented using RouteGuard class.

import 'package:flutter/material.dart';
import 'package:my_tie/models/arguments/add_attribute_argument.dart';
import 'package:my_tie/models/arguments/add_property_argument.dart';
import 'package:my_tie/models/arguments/instruction_page_attribute.dart';
import 'package:my_tie/models/form_page_number.dart';

import 'package:my_tie/pages/base/page_base_stateless/subpage_base.dart';
import 'package:my_tie/pages/base/page_base_stateless/subpage_container.dart';
import 'package:my_tie/pages/route_based_pages/new_fly_pages/add_new_attribute_page.dart';
import 'package:my_tie/pages/route_based_pages/new_fly_pages/add_new_property_page.dart';

import 'package:my_tie/pages/route_based_pages/new_fly_pages/new_fly_attributes_page.dart';
import 'package:my_tie/pages/route_based_pages/new_fly_pages/new_fly_instruction_page.dart';
import 'package:my_tie/pages/route_based_pages/new_fly_pages/new_fly_materials_page.dart';
import 'package:my_tie/pages/route_based_pages/new_fly_pages/new_fly_publish_page.dart';
import 'package:my_tie/routes/route_guard.dart';

class FlyFormRoutes {
  static final routes = {
    NewFlyAttributesPage.route: (context) => RouteGuard(
        child: SubPageContainer(subPageType: SubPageType.NewFlyAttributesPage)),
    NewFlyMaterialsPage.route: (context) => RouteGuard(
        child: SubPageContainer(subPageType: SubPageType.NewFlyMaterialsPage)),
    NewFlyInstructionPage.route: (context) => RouteGuard(
        child:
            SubPageContainer(subPageType: SubPageType.NewFlyInstructionPage)),
    NewFlyPublishPage.route: (context) => RouteGuard(
        child: SubPageContainer(subPageType: SubPageType.NewFlyPublishPage)),

    // DB new fly form editting routes.
    AddNewAttributePage.route: (context) => RouteGuard(
        child: SubPageContainer(subPageType: SubPageType.AddNewAttributePage)),
    AddNewPropertyPage.route: (context) => RouteGuard(
        child: SubPageContainer(subPageType: SubPageType.AddNewPropertyPage)),
  };

  static Future newFlyAttributesPage(BuildContext context) =>
      Navigator.pushNamed(context, NewFlyAttributesPage.route);

  static Future newFlyMaterialsPage(BuildContext context,
          {FormPageNumber pageNumber}) =>
      Navigator.pushNamed(context, NewFlyMaterialsPage.route,
          arguments: pageNumber);

  static Future addNewAttributePage(BuildContext context,
          {AddAttributeArgument addAttributeArgument}) =>
      Navigator.pushNamed(context, AddNewAttributePage.route,
          arguments: addAttributeArgument);

  static Future addPropertyToFormTemplate(BuildContext context,
          {AddPropertyArgument addPropertyArgument}) =>
      Navigator.pushNamed(context, AddNewPropertyPage.route,
          arguments: addPropertyArgument);

  static Future newFlyPublishPage(BuildContext context) =>
      Navigator.pushNamed(context, NewFlyPublishPage.route);

  static Future newFlyInstructionPage(BuildContext context,
          InstructionPageAttribute instructionPageAttribute) =>
      Navigator.pushNamed(context, NewFlyInstructionPage.route,
          arguments: instructionPageAttribute);
}
