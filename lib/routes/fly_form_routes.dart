import 'package:flutter/material.dart';
import 'package:my_tie/bloc/state/fly_form_state.dart';
import 'package:my_tie/models/form_page_number.dart';
import 'package:my_tie/models/new_fly_form_template.dart';

import 'package:my_tie/pages/base/page_base_stateless/subpage_base.dart';
import 'package:my_tie/pages/base/page_base_stateless/subpage_container.dart';

import 'package:my_tie/pages/route_based_pages/new_fly_pages/new_fly_attributes_page.dart';
import 'package:my_tie/pages/route_based_pages/new_fly_pages/new_fly_materials_page.dart';
import 'package:my_tie/pages/route_based_pages/new_fly_pages/new_fly_publish_page.dart';
import 'package:my_tie/routes/route_guard.dart';

class FlyFormRoutes {
  static final routes = {
    NewFlyAttributesPage.route: (context) => RouteGuard(
        child: SubPageContainer(subPageType: SubPageType.NewFlyAttributesPage)),
    NewFlyMaterialsPage.route: (context) => RouteGuard(
        child: SubPageContainer(subPageType: SubPageType.NewFlyMaterialsPage)),
    NewFlyPublishPage.route: (context) => RouteGuard(
        child: SubPageContainer(subPageType: SubPageType.NewFlyPublishPage)),
  };

  static Future newFlyAttributesPage(BuildContext context) =>
      Navigator.pushNamed(context, NewFlyAttributesPage.route);

  static Future newFlyMaterialsPage(BuildContext context,
      {FormPageNumber pageNumber}) {
    return Navigator.pushNamed(context, NewFlyMaterialsPage.route,
        arguments: pageNumber);
  }

  static Future newFlyPublishPage(BuildContext context) =>
      Navigator.pushNamed(context, NewFlyPublishPage.route);

  static void goToNextPage({
    @required BuildContext context,
    @required NewFlyFormTemplate newFlyFormTemplate,
    @required FormPageNumber formPageNumber,
  }) {
    if (formPageNumber.pageNumber <
        newFlyFormTemplate.flyFormMaterials.length - 1) {
      FlyFormRoutes.newFlyMaterialsPage(
        context,
        pageNumber: FormPageNumber(
          pageNumber: formPageNumber.pageNumber + 1,
          pageCount: newFlyFormTemplate.flyFormMaterials.length,
        ),
      );
    } else {
      // End of form reached.
      // We need to first set the 'show skippable button' feature to true in the
      //  containing inherited widget so if user needs to go back to edit a page,
      //  they can easily come back to the publish page.
      FlyFormStateContainer.of(context).isSkippableToEnd = true;
      FlyFormRoutes.newFlyPublishPage(context);
    }
  }

  static void skipToEnd({
    @required BuildContext context,
    @required NewFlyFormTemplate newFlyFormTemplate,
    @required FormPageNumber formPageNumber,
  }) {
    int pagesToSkip = (newFlyFormTemplate.flyFormMaterials.length) -
        formPageNumber.pageNumber;

    // Now push all form related pages onto stack, followed by pushing the
    //  form review/publish page on.
    for (int i = 0; i < pagesToSkip; i++) {
      goToNextPage(
        context: context,
        newFlyFormTemplate: newFlyFormTemplate,
        formPageNumber: FormPageNumber(
          pageNumber: formPageNumber.pageNumber + i,
          pageCount: newFlyFormTemplate.flyFormMaterials.length,
        ),
      );
    }
  }
}
