import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_tie/models/db_names.dart';
import 'package:my_tie/models/fly_exhibits/fly_exhibit.dart';
import 'package:my_tie/models/new_fly/fly.dart';
import 'package:my_tie/models/new_fly/new_fly_form_template.dart';
import 'package:my_tie/models/user_profile/user_materials_transfer.dart';
import 'package:my_tie/models/user_profile/user_profile.dart';
import 'package:my_tie/services/network/fly_exhibit_service.dart';
import 'package:my_tie/services/network/fly_form_template_service.dart';

import 'user_bloc.dart';

class FlyExhibitBloc {
  // final AuthBloc authBloc;
  final UserBloc userBloc;
  final FlyExhibitService flyExhibitService;
  final FlyFormTemplateService flyFormTemplateService;

  // Don't mark _newestFlies as final. During most the majority of the bloc,
  //  we will not reassign _newestFlies and instead just add FlyExhibits to it,
  //  but in instance of user updating profile, we will map _newestFlies to the
  //  updated version of _newest flies, thus needing to reassign.
  List<FlyExhibit> _newestFlies = [];
  DocumentSnapshot _prevNewestFlyDoc;
  UserProfile _userProfile;

  final _requestFetchFlies = StreamController<FetchFliesEvent>();
  StreamSink<FetchFliesEvent> requestFetchFliesSink;

  final _newestFliesStreamController =
      StreamController<List<FlyExhibit>>.broadcast();
  Stream<List<FlyExhibit>> newestFliesStream;

  StreamController<FlyExhibit> _newestFlyDetailStreamController;
  //  =    StreamController<FlyExhibit>();

  FlyExhibitBloc({
    this.userBloc,
    this.flyExhibitService,
    this.flyFormTemplateService,
  }) {
    requestFetchFliesSink = _requestFetchFlies.sink;
    newestFliesStream = _newestFliesStreamController.stream;

    _newestFliesStreamController.onListen = _initNewestFliesFetch;

    // Listen for fetch flies events being addd tos ink from UI (eg, when user
    //  scrolls to bottom of screen and infinite scroll needs to load more
    //  flies). First added the FlyExhibitLoadingIndicator, to tell UI to show
    //  spinner, then call _newestFliesFetch which will make request to db,
    //  update _newestFlies, then add _newest flies to newestFliesStreamController.
    _requestFetchFlies.stream.listen((ffe) {
      if (ffe is FetchNewestFliesEvent) {
        _newestFlies.add(FlyExhibitLoadingIndicator());
        _newestFliesStreamController.add(_newestFlies);
        _newestFliesFetch();
      } else {
        print('event not found - unimplemented $ffe');
      }
    });

    // Get userProfile, and listen for changes to userProfile. Update all FlyExhibit
    // if upon changes to userProfile (materials on hand for each fly may change
    //  when user profile is updated).
    userBloc.userMaterialsProfile.listen((UserMaterialsTransfer umt) {
      _userProfile = umt.userProfile;

      _newestFlies = _newestFlies.map((FlyExhibit flyExhibit) {
        if (flyExhibit is FlyExhibitEndCapIndicator)
          return FlyExhibitEndCapIndicator();
        return FlyExhibit.fromUserProfileAndFly(
            fly: flyExhibit.fly, userProfile: _userProfile);
      }).toList();

      _newestFliesStreamController.add(_newestFlies);
    });
  }

  Stream<FlyExhibit> getFlyExhibit(String docId) {
    FlyExhibit extractFlyExhibit(List<FlyExhibit> flyExhibits) {
      return flyExhibits.firstWhere(
          (flyExhibit) => flyExhibit.fly.docId == docId,
          orElse: () => null);
    }

    if (_newestFlyDetailStreamController != null)
      _newestFlyDetailStreamController.close();

    _newestFlyDetailStreamController = StreamController<FlyExhibit>();

    // Setup _newestFlyDetailStream controller to emit whenever _newestFliesStreamController
    // emits. For example, if user clicks 'Material on hand', user profile updates,
    //  which causes _newestFliesStreamConroller to update, which then causes
    //  _newestFlyDetailStreamController to update, as defined here.
    _newestFliesStreamController.stream.listen((flyExhibits) {
      _newestFlyDetailStreamController.add(extractFlyExhibit(flyExhibits));
    });

    _newestFlyDetailStreamController.add(extractFlyExhibit(_newestFlies));
    return _newestFlyDetailStreamController.stream;
  }

  /// name: _initNewestFliesFetch
  /// description: Used only for first call to Firestore to retrieve first 20
  ///   newest fly docs. This call initializes the prevNewestFlyDoc var, which
  ///   can then be used for subsequent calls to Firestore for additional fly
  ///   docs for newest fly exhibit, in an infinite scroll/fetch manner.
  void _initNewestFliesFetch() async {
    final Future<QuerySnapshot> flyTemplateDocF =
        flyFormTemplateService.newFlyForm;
    final Future<QuerySnapshot> queryF =
        flyExhibitService.initGetCompletedFliesByDate();

    // No need to use Future.wait, as query depeneds on flyFormTemplate.
    final flyFormTemplateDoc =
        NewFlyFormTemplate.fromDoc((await flyTemplateDocF).docs[0].data());
    final flyQueries = await queryF;

    _setPrevNewestDoc(flyQueries);
    _formatAndSendNewestFliesToUI(flyQueries, flyFormTemplateDoc);
  }

  void _newestFliesFetch() async {
    final Future<QuerySnapshot> flyTemplateDocF =
        flyFormTemplateService.newFlyForm;
    final Future<QuerySnapshot> queryF =
        flyExhibitService.getCompletedFliesByDateAfterDoc(_prevNewestFlyDoc);

    // No need to use Future.wait, as query depeneds on flyFormTemplate.
    final flyFormTemplateDoc =
        NewFlyFormTemplate.fromDoc((await flyTemplateDocF).docs[0].data());
    final flyQueries = await queryF;

    _setPrevNewestDoc(flyQueries);
    _formatAndSendNewestFliesToUI(flyQueries, flyFormTemplateDoc);
  }

  void _formatAndSendNewestFliesToUI(
      QuerySnapshot flyQueries, NewFlyFormTemplate flyFormTemplateDoc) async {
    // final UserMaterialsTransfer userMaterials =
    //     await userBloc.userMaterialsProfile.first;

    // userService.getUserProfile(authService.currentUser.uid);

    final List<FlyExhibit> flies = flyQueries.docs.map((doc) {
      final flyDoc = doc.data();
      return FlyExhibit.fromUserProfileAndFly(
        userProfile: _userProfile,
        fly: Fly.formattedForExhibit(
          docId: doc.id,
          flyName: flyDoc[DbNames.flyName],
          flyDescription: flyDoc[DbNames.flyDescription],
          attrs: flyDoc[DbNames.attributes],
          mats: flyDoc[DbNames.materials],
          instr: flyDoc[DbNames.instructions],
          imageUris: flyDoc[DbNames.topLevelImageUris],
          flyFormTemplate: flyFormTemplateDoc,
        ),
      );
    }).toList();

    _newestFlies.addAll(flies);
    _newestFlies.removeWhere((fly) => fly is FlyExhibitLoadingIndicator);
    if (flies.isEmpty) _newestFlies.add(FlyExhibitEndCapIndicator());
    _newestFliesStreamController.add(_newestFlies);
  }

  void _setPrevNewestDoc(QuerySnapshot flyQueries) {
    if (flyQueries.docs.length > 0)
      _prevNewestFlyDoc = flyQueries.docs[flyQueries.docs.length - 1];
  }

  void close() {
    _requestFetchFlies.close();
    requestFetchFliesSink.close();
    _newestFliesStreamController.close();

    // _newestFlyDetailStreamController could be null if user never clicked
    // on a fly exhibit to see details/instructions.
    if (_newestFlyDetailStreamController != null)
      _newestFlyDetailStreamController.close();
  }
}

class FetchFliesEvent {}

class FetchNewestFliesEvent extends FetchFliesEvent {}

class FlyExhibitLoadingIndicator extends FlyExhibit {}

class FlyExhibitEndCapIndicator extends FlyExhibit {}
