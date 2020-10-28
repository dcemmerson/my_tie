import 'package:flutter/material.dart';
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
// with SingleTickerProviderStateMixin
{
  final PageStorageBucket _bucket = PageStorageBucket();

  ThemeManager _themeManager;
  ScrollController _scrollController;
  // TabController _tabController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    // if (widget.tabPages != null) {
    //   _tabController = TabController(
    //       length: widget.tabPages.length, initialIndex: 0, vsync: this);
    // }
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
    _scrollController.dispose();
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
    return DefaultTabController(
      length: widget.tabPages.length,
      // initialIndex: 0,
      child: NestedScrollView(
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
                children: widget.tabPages
                    .map((tabPage) => SafeArea(
                        top: false, bottom: false, child: tabPage.widget))
                    .toList()),
        // ),
      ),
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
