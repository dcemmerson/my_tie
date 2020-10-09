import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_tie/models/db_names.dart';
import 'package:my_tie/models/new_fly/fly.dart';
import 'package:my_tie/models/new_fly/new_fly_form_template.dart';
import 'package:my_tie/services/network/fly_exhibit_service.dart';
import 'package:my_tie/services/network/fly_form_template_service.dart';
import 'package:rxdart/subjects.dart';

class FlyExhibitBloc {
  final FlyExhibitService flyExhibitService;
  final FlyFormTemplateService flyFormTemplateService;

  final List<Fly> newestFlies = [];
  DocumentSnapshot prevNewestFlyDoc;

  final _requestFetchFlies = StreamController<FetchFliesEvent>();
  StreamSink<FetchFliesEvent> requestFetchFliesSink;

  final _newestFliesStreamController = StreamController<List<Fly>>();
  Stream<List<Fly>> newestFliesStream;

  FlyExhibitBloc({this.flyExhibitService, this.flyFormTemplateService}) {
    // _newestFliesStreamController =
    // BehaviorSubject<List<Fly>>(seedValue: newestFlies);
    requestFetchFliesSink = _requestFetchFlies.sink;
    newestFliesStream = _newestFliesStreamController.stream;

    _newestFliesStreamController.onListen = _initNewestFliesFetch;

    _requestFetchFlies.stream.listen((ffe) {
      if (ffe is FetchNewestFliesEvent) {
        _newestFliesFetch();
      } else {
        print('event not found');
      }
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
    _sendNewestFliesToUI(flyQueries, flyFormTemplateDoc);
  }

  void _newestFliesFetch() async {
    final Future<QuerySnapshot> flyTemplateDocF =
        flyFormTemplateService.newFlyForm;
    final Future<QuerySnapshot> queryF =
        flyExhibitService.getCompletedFliesByDateAfterDoc(prevNewestFlyDoc);

    // No need to use Future.wait, as query depeneds on flyFormTemplate.
    final flyFormTemplateDoc =
        NewFlyFormTemplate.fromDoc((await flyTemplateDocF).docs[0].data());
    final flyQueries = await queryF;

    _setPrevNewestDoc(flyQueries);
    _sendNewestFliesToUI(flyQueries, flyFormTemplateDoc);
  }

  void _sendNewestFliesToUI(
      QuerySnapshot flyQueries, NewFlyFormTemplate flyFormTemplateDoc) {
    final List<Fly> flies = flyQueries.docs.map((doc) {
      final flyDoc = doc.data();
      return Fly.formattedForExhibit(
        docId: doc.id,
        flyName: flyDoc[DbNames.flyName],
        flyDescription: flyDoc[DbNames.flyDescription],
        attrs: flyDoc[DbNames.attributes],
        mats: flyDoc[DbNames.materials],
        instr: flyDoc[DbNames.instructions],
        imageUris: flyDoc[DbNames.topLevelImageUris],
        flyFormTemplate: flyFormTemplateDoc,
      );
    }).toList();

    newestFlies.addAll(flies);
    _newestFliesStreamController.add(newestFlies);
  }

  void _setPrevNewestDoc(QuerySnapshot flyQueries) {
    prevNewestFlyDoc = flyQueries.docs[flyQueries.docs.length - 1];
  }

  void close() {
    _requestFetchFlies.close();
    requestFetchFliesSink.close();
    _newestFliesStreamController.close();
  }
}

class FetchFliesEvent {}

class FetchNewestFliesEvent extends FetchFliesEvent {}
