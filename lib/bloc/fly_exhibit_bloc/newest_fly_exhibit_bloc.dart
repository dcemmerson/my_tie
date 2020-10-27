import 'package:my_tie/services/network/fly_exhibit_services/newest_fly_exhibit_service.dart';
import 'package:my_tie/services/network/fly_form_template_service.dart';

import '../user_bloc.dart';
import 'fly_exhibit_bloc.dart';

class NewestFlyExhibitBloc extends FlyExhibitBloc {
  NewestFlyExhibitBloc({
    UserBloc userBloc,
    NewestFlyExhibitService newestFlyExhibitService,
    FlyFormTemplateService flyFormTemplateService,
  }) : super(
            userBloc: userBloc,
            flyExhibitService: newestFlyExhibitService,
            flyFormTemplateService: flyFormTemplateService);
}
