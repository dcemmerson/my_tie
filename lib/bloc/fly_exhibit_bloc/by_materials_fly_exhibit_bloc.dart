import 'package:my_tie/pages/tab_based_pages/tab_page.dart';
import 'package:my_tie/services/network/fly_exhibit_services/by_materials_fly_exhibit_service.dart';
import 'package:my_tie/services/network/fly_form_template_service.dart';

import '../user_bloc.dart';
import 'fly_exhibit_bloc.dart';

class ByMaterialsFlyExhibitBloc extends FlyExhibitBloc {
//debug
  final String exhibitBlocType = 'ByMaterialsFlyExhibitBloc';

  FlyExhibitType get flyExhibitType => FlyExhibitType.MaterialMatch;

  ByMaterialsFlyExhibitBloc({
    UserBloc userBloc,
    ByMaterialsFlyExhibitService byMaterialsFlyExhibitService,
    FlyFormTemplateService flyFormTemplateService,
  }) : super(
            userBloc: userBloc,
            flyExhibitService: byMaterialsFlyExhibitService,
            flyFormTemplateService: flyFormTemplateService);

  /// name: initFliesFetch
  /// description: We must override this method from FlyExhibitBloc because
  ///   favorited flies are stored in a top level collection (for simple
  ///   querying functionallity). When we query Firestore for a user's
  ///   favorites (from the favorites collection), we only obtain fly stubs
  ///   and not the entire fly doc - thus we must query the fly collection with
  ///   the doc id obtained from each fly stub.
  // @override
  // void initFliesFetch() async {}

  /// name: fliesFetch
  /// description: We must override this method from FlyExhibitBloc for same
  ///   reason described in initFliesFetch.
  // @override
  // void fliesFetch() async {}
}
