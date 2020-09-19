import 'package:flutter/material.dart';
import 'package:my_tie/models/arguments/fly_instruction_modal_transfer.dart';
import 'package:my_tie/pages/base/navigators_nested/dialog_page_route.dart';

import 'package:my_tie/pages/route_based_pages/hero_dialog_partial_page.dart';

class ModalRoutes {
  static final routes = {
    // '/dialog': (context) => DialogNavigatorEntry(),
    HeroDialogPartialPage.route: (FlyInstructionModalTransfer fimt) =>
        DialogPageRoute(
          builder: (context) => HeroDialogPartialPage(fimt: fimt),
        ),
  };

  static Future instructionStepModalPage(
          BuildContext context, FlyInstructionModalTransfer fitm) =>
      Navigator.push(context, routes[HeroDialogPartialPage.route](fitm));
}

class FlyInstructionTransferModal {}
