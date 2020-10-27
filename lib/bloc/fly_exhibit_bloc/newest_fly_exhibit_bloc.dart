import 'package:my_tie/pages/tab_based_pages/tab_page.dart';
import 'package:my_tie/services/network/fly_exhibit_services/newest_fly_exhibit_service.dart';
import 'package:my_tie/services/network/fly_form_template_service.dart';

import '../user_bloc.dart';
import 'fly_exhibit_bloc.dart';

class NewestFlyExhibitBloc extends FlyExhibitBloc {
  FlyExhibitType get flyExhibitType => FlyExhibitType.Newest;

  NewestFlyExhibitBloc({
    UserBloc userBloc,
    NewestFlyExhibitService newestFlyExhibitService,
    FlyFormTemplateService flyFormTemplateService,
  }) : super(
            userBloc: userBloc,
            flyExhibitService: newestFlyExhibitService,
            flyFormTemplateService: flyFormTemplateService);
}
