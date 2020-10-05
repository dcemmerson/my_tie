import 'package:my_tie/pages/tab_based_pages/random_tab_page.dart';

import 'favorites_tab_page.dart';
import 'material_match_tab_page.dart';

class Tabs {
  static final pages = [
    MaterialMatchTabPage(),
    // NewestTabPage(),
    RandomTabPage(),
    FavoritesTabPage(),
  ];
}
