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

  final _newestFliesStreamController = StreamController<List<FlyExhibit>>();
  Stream<List<FlyExhibit>> newestFliesStream;

  FlyExhibitBloc({
    // this.authBloc,
    this.userBloc,
    this.flyExhibitService,
    this.flyFormTemplateService,
  }) {
    // _newestFliesStreamController =
    // BehaviorSubject<List<Fly>>(seedValue: newestFlies);
    requestFetchFliesSink = _requestFetchFlies.sink;
    newestFliesStream = _newestFliesStreamController.stream;

    _newestFliesStreamController.onListen = _initNewestFliesFetch;

    _requestFetchFlies.stream.listen((ffe) {
      if (ffe is FetchNewestFliesEvent) {
        _newestFlies.add(FlyExhibitLoadingIndicator());
        _newestFliesStreamController.add(_newestFlies);
        _newestFliesFetch();
      } else {
        print('event not found');
      }
    });

    // Get userProfile, and listen for changes to userProfile. Update all FlyExhibit
    // if upon changes to userProfile.
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
  }
}

class FetchFliesEvent {}

class FetchNewestFliesEvent extends FetchFliesEvent {}

class FlyExhibitLoadingIndicator extends FlyExhibit {}

class FlyExhibitEndCapIndicator extends FlyExhibit {}
