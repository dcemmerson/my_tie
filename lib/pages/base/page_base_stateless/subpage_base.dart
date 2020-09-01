import 'package:flutter/material.dart';
import 'package:my_tie/bloc/state/fly_form_state.dart';
import 'package:my_tie/bloc/state/my_tie_state.dart';
import 'package:my_tie/models/form_page_number.dart';
import 'package:my_tie/styles/styles.dart';
import 'package:my_tie/styles/theme_manager.dart';

enum SubPageType {
  NewFlyStartPage,
  NewFlyAttributesPage,
  NewFlyMaterialsPage,
  NewFlyPublishPage,
  AddNewAttributePage,
  AddNewPropertyPage,
}

abstract class SubPageBase extends StatelessWidget {
  static const _appBarSize = AppFonts.h4;

  ThemeManager themeManager;

  SubPageType get subPageType;

  String get subPageTitle;
  Widget get body;

  SubPageBase({Key key}) : super(key: key);

  IconButton _subNavPopButton(BuildContext context) {
    if (ModalRoute.of(context)?.canPop == true) {
      return IconButton(
        padding: EdgeInsets.all(AppPadding.p0),
        icon: Icon(Icons.arrow_back),
        iconSize: _appBarSize,
        onPressed: () => Navigator.of(context).pop(),
      );
    } else {
      return null;
    }
  }

  String getFormProgress(BuildContext context) {
    // Check that the arg passed if of type FormPageNumber. Usually will be,
    //  but if user is adding a new attribute or material to db, then we won't
    //  have passed a FormPageNumber arg in.
    var arg = ModalRoute.of(context).settings.arguments;
    FormPageNumber fpn = (arg is FormPageNumber) ? arg : null;
    int currPage = (fpn?.pageNumber ?? 0) + 1;
    int pageCount = fpn?.pageCount ?? 0;

    if (pageCount > 0) {
      return currPage.toString() + ' / ' + pageCount.toString();
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    themeManager =
        ThemeManager(darkMode: MyTieStateContainer.of(context).isDarkMode);
    if (subPageType == SubPageType.NewFlyStartPage) {
      // Then don't show the appbar.
      return FlyFormStateContainer(
        child: Theme(
          data: themeManager.themeData,
          child: Scaffold(
            body: body,
          ),
        ),
      );
    } else {
      return Theme(
        data: themeManager.themeData,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).accentColor,
            centerTitle: true,
            elevation: 0.0,
            leading: _subNavPopButton(context),
            actions: [
              Padding(
                  padding:
                      EdgeInsets.fromLTRB(0, AppPadding.p1, AppPadding.p1, 0),
                  child: Text(getFormProgress(context))),
            ],

            // iconTheme: themeManager.themeData.appSubBarTheme.actionsIconTheme,
            primary: false,
            title: Text(subPageTitle, style: AppTextStyles.subHeader),
            textTheme: Theme.of(context).primaryTextTheme,
            toolbarHeight: _appBarSize,
          ),
          body: body,
        ),
      );
    }
  }
}
