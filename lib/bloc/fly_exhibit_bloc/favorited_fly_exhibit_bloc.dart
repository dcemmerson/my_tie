import 'package:my_tie/pages/tab_based_pages/tab_page.dart';
import 'package:my_tie/services/network/fly_exhibit_services/favorited_fly_exhibit_service.dart';
import 'package:my_tie/services/network/fly_form_template_service.dart';

import '../user_bloc.dart';
import 'fly_exhibit_bloc.dart';

class FavoritedFlyExhibitBloc extends FlyExhibitBloc {
  final String exhibitBlocType = "FavoritedFlyExhibitBloc";

  FlyExhibitType get flyExhibitType => FlyExhibitType.Favorites;

  FavoritedFlyExhibitBloc({
    UserBloc userBloc,
    FlyFormTemplateService flyFormTemplateService,
    FavoritedFlyExhibitService favoritedFlyExhibitService,
  }) : super(
            userBloc: userBloc,
            flyExhibitService: favoritedFlyExhibitService,
            flyFormTemplateService: flyFormTemplateService);
}
