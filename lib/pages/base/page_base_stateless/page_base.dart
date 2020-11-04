import 'package:flutter/material.dart';
import 'package:linked_scroll_controller/linked_scroll_controller.dart';
import 'package:my_tie/bloc/state/my_tie_state.dart';
import 'package:my_tie/pages/tab_based_pages/tab_page.dart';
import 'package:my_tie/styles/theme_manager.dart';
import 'package:my_tie/widgets/drawer/settings_drawer.dart';
import 'package:my_tie/widgets/drawer/settings_drawer_icon.dart';

enum PageType {
  HomePage,
  // Fly exhibit pages.
  FlyExhibitDetailPage,
  AuthenticationPage,
  AccountPage,
  // user profile related
  ProfilePage,
  UserProfileEditMaterialPage,
  // new fly related
  NewFlyStartPage,
  NewFlyAttributesPage,
  NewFlyMaterialsPage,
  NewFlyInstructionPage,
  NewFlyPublishPage,
  NewFlyPreviewPublishPage,
  AddNewAttributePage,
  AddNewPropertyPage,
}

abstract class PageBase extends StatefulWidget {
  final List<TabPage> tabPages;

  PageBase({Key key, this.tabPages}) : super(key: key);

  PageType get pageType;

  String get pageTitle;

  Widget get body;

  @override
  _PageBaseState createState() => _PageBaseState();
}

class _PageBaseState extends State<PageBase>
    with SingleTickerProviderStateMixin {
  // final PageStorageBucket _bucket = PageStorageBucket();
  final List<ScrollController> tabScrollControllers = [];

  ThemeManager _themeManager;
  // LinkedScrollControllerGroup linkedScrollControllerGroup;
  ScrollController _appBarScrollController;
  TabController _tabController;

  int currTabIndex = -1;
  double childScrollPositionPrev = 0;
  // ScrollController _byMaterialsScrollController;
  // TabController _tabController;

  @override
  void initState() {
    super.initState();
    if (widget.tabPages != null) {
      _appBarScrollController = ScrollController();
      // _appBarScrollController.addListener(_handleChildScroll);
      // linkedScrollControllerGroup = LinkedScrollControllerGroup();
      _tabController =
          TabController(vsync: this, length: widget.tabPages.length);
      // linkedScrollControllerGroup
      //     .addAndGet(tabScrollControllers[_tabController.index]);
      _tabController.addListener(_handleTabControllerSwap);
      // _handleTabControllerSwap();
      // tabScrollControllers[0].addListener(_handleChildScroll);

    }
    // _byMaterialsScrollController = ScrollController();
    // if (widget.tabPages != null) {
    //   _tabController = TabController(
    //       length: widget.tabPages.length, initialIndex: 0, vsync: this);
    // }
  }

  //  name: _handleChildScroll
  //  description: When a child scroll controller is scrolled, the scroll is
  //    propagated up to call this method to handle the scroll and decide how
  //    the NestedScrollController should scroll to show or hide the appbar.
  void _handleChildScroll() {
    print("child scrolled");
    print('from $childScrollPositionPrev');
    var prevOffset = childScrollPositionPrev;
    childScrollPositionPrev = tabScrollControllers[currTabIndex].offset;
    print('to $childScrollPositionPrev');
    _appBarScrollController.animateTo(childScrollPositionPrev,
        duration: Duration(milliseconds: 200), curve: Curves.easeOut);
  }

  void _handleTabControllerSwap() {
    print("\n\nSwap\n\n");
    print(_tabController.index);
    // if (currTabIndex != -1) {
    tabScrollControllers[currTabIndex].removeListener(_handleChildScroll);
    // }

    currTabIndex = _tabController.index;
    tabScrollControllers[currTabIndex].addListener(_handleChildScroll);

    childScrollPositionPrev = tabScrollControllers[currTabIndex].offset;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _themeManager =
        ThemeManager(darkMode: MyTieStateContainer.of(context).isDarkMode);
  }

  @override
  void dispose() {
    // if (_tabController != null) {
    //   _tabController.dispose();
    // }
    print('dispose');
    if (_appBarScrollController != null) _appBarScrollController.dispose();
    super.dispose();
  }

  Widget _appBar(BuildContext context) {
    return NestedScrollView(
      // controller: ScrollController(),
      headerSliverBuilder: (context, innerBoxIsScrolled) => [
        SliverAppBar(
          snap: true,
          floating: true,
          centerTitle: true,
          elevation: 0.0,
          // floating: true,
          title: Text(widget.pageTitle),
          textTheme: Theme.of(context).primaryTextTheme,
          actions: [
            SettingsDrawerIcon(),
          ],
        ),
      ],
      body: widget.body,
    );
  }

  Widget _tabbedAppBar(BuildContext context) {
    return

        // DefaultTabController(
        //   length: widget.tabPages.length,
        //   // initialIndex: 0,
        //   child:
        NestedScrollView(
      controller: _appBarScrollController,
      headerSliverBuilder: (context, innerBoxIsScrolled) => [
        SliverAppBar(
          snap: true,
          floating: true,
          centerTitle: true,
          elevation: 0.0,
          // floating: true,
          title: Text(widget.pageTitle),
          textTheme: Theme.of(context).primaryTextTheme,
          actions: [
            SettingsDrawerIcon(),
          ],
          pinned: true,
          bottom: TabBar(
              controller: _tabController,
              tabs: widget.tabPages
                  .map((tabPage) => Tab(text: tabPage.name))
                  .toList()),
        ),
      ],
      body:
          // PageStorage(
          //   bucket: _bucket,
          //   child:
          TabBarView(
              controller: _tabController,
              children: widget.tabPages.map((tabPage) {
                tabScrollControllers.add(tabPage.scrollController);
                if (currTabIndex == -1) {
                  tabScrollControllers[0].addListener(_handleChildScroll);
                  currTabIndex = 0;
                }
                return SafeArea(
                    top: false,
                    bottom: false,
                    child: tabPage.widget(_appBarScrollController));
              }).toList()),
      // ),
      // ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var body;
    if (widget.tabPages != null) {
      body = _tabbedAppBar(context);
    } else {
      body = _appBar(context);
    }
    return Theme(
      data: _themeManager.themeData,
      child: Scaffold(
        appBar: AppBar(toolbarHeight: 0),
        endDrawer: SettingsDrawer(),
        body: body,
      ),
    );
  }
}
