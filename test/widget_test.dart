// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_tie/models/new_fly/fly.dart';
import 'package:my_tie/models/new_fly/new_fly_form_template.dart';
import 'package:my_tie/models/new_fly/new_fly_form_transfer.dart';
import 'package:my_tie/widgets/forms/new_fly_form/review/attribute_review.dart';

import 'mock_data.dart';

void main() {
  testWidgets(
      'Test AttributeReview widget. Pass in mock fly in progress doc and empty fly in progress',
      (WidgetTester tester) async {
    final newFlyFormTemplate =
        NewFlyFormTemplate.fromDoc(MockData.mockNewFlyFormDoc);
    final flyInProgress = Fly.formattedForReview(
      flyFormTemplate: newFlyFormTemplate,
    );
    // flyName: MockData.flyInProgressDoc['fly_name'],
    // attrs: MockData.flyInProgressDoc['attributes']);

    final nfft = NewFlyFormTransfer(
        flyInProgress: flyInProgress, newFlyFormTemplate: newFlyFormTemplate);
    // Build our app and trigger a frame.
    Widget widget = TestWidgetWrapper(
        child: AttributeReview(
      field: null,
      newFlyFormTransfer: nfft,
    ));
    await tester.pumpWidget(widget);
    expect(find.text('No name'), findsOneWidget);
    expect(find.text('[None]'), findsNWidgets(4));

    // Check that each attribute key still appears in widget.
    flyInProgress.attributes.forEach((attr) {
      expect(find.text(attr.name), findsOneWidget);
    });
  });

  testWidgets(
      'Test AttributeReview widget. Pass in mock fly in progress doc and mock fly in progress doc',
      (WidgetTester tester) async {
    final newFlyFormTemplate =
        NewFlyFormTemplate.fromDoc(MockData.mockNewFlyFormDoc);
    final flyInProgress = Fly.formattedForReview(
      flyFormTemplate: newFlyFormTemplate,
      flyName: MockData.flyInProgressDoc['fly_name'],
      attrs: MockData.flyInProgressDoc['attributes'],
    );

    final nfft = NewFlyFormTransfer(
        flyInProgress: flyInProgress, newFlyFormTemplate: newFlyFormTemplate);
    // Build our app and trigger a frame.
    Widget widget = TestWidgetWrapper(
        child: AttributeReview(
      newFlyFormTransfer: nfft,
    ));
    await tester.pumpWidget(widget);

    // Check that each attribute key and value text appear in widget.
    flyInProgress.attributes.forEach((attr) {
      expect(find.text(attr.name), findsOneWidget);
      expect(find.text(attr.value), findsOneWidget);
    });
  });

  testWidgets(
      'Test MaterialReview widget. Pass in mock fly in progress doc and mock fly in progress doc',
      (WidgetTester tester) async {
    final newFlyFormTemplate =
        NewFlyFormTemplate.fromDoc(MockData.mockNewFlyFormDoc);
    final flyInProgress = Fly(
        flyName: MockData.flyInProgressDoc['fly_name'],
        attrs: MockData.flyInProgressDoc['attributes']);

    final nfft = NewFlyFormTransfer(
        flyInProgress: flyInProgress, newFlyFormTemplate: newFlyFormTemplate);
    // Build our app and trigger a frame.
    Widget widget = TestWidgetWrapper(
        child: AttributeReview(
      newFlyFormTransfer: nfft,
    ));
    await tester.pumpWidget(widget);

    // Check that each attribute key and value text appear in widget.
    flyInProgress.attributes.forEach((attr) {
      expect(find.text(attr.name), findsOneWidget);
      expect(find.text(attr.value), findsOneWidget);
    });
  });
}

/// name: TestWidgetWrapper
/// description: Use to wrap test widgets when test widget does not include a
///   scaffold, to avoid directionallity exception.
class TestWidgetWrapper extends StatelessWidget {
  final Widget child;

  const TestWidgetWrapper({Key key, @required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(body: child),
    );
  }
}
