import 'package:my_tie/pages/tab_based_pages/tab_page.dart';
import 'package:my_tie/services/network/fly_exhibit_services/by_materials_fly_exhibit_service.dart';
import 'package:my_tie/services/network/fly_form_template_service.dart';

import '../user_bloc.dart';
import 'fly_exhibit_bloc.dart';

class ByMaterialsFlyExhibitBloc extends FlyExhibitBloc {
//debug
  final String exhibitBlocType = "ByMaterialsFlyExhibitBloc";

  FlyExhibitType get flyExhibitType => FlyExhibitType.MaterialMatch;

  ByMaterialsFlyExhibitBloc({
    UserBloc userBloc,
    ByMaterialsFlyExhibitService byMaterialsFlyExhibitService,
    FlyFormTemplateService flyFormTemplateService,
  }) : super(
            userBloc: userBloc,
            flyExhibitService: byMaterialsFlyExhibitService,
            flyFormTemplateService: flyFormTemplateService);
}
