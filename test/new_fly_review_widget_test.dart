// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_tie/models/fly.dart';
import 'package:my_tie/models/new_fly_form_template.dart';
import 'package:my_tie/models/new_fly_form_transfer.dart';
import 'package:my_tie/styles/string_format.dart';
import 'package:my_tie/widgets/forms/new_fly_form/review/attribute_review.dart';
import 'package:my_tie/widgets/forms/new_fly_form/review/material_review.dart';
import 'mock_data.dart';
import 'test_value_keys.dart';

void main() {
  testWidgets(
      'Test AttributeReview widget. Pass in mock template doc and empty fly in progress',
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
      'Test AttributeReview widget. Pass in mock template doc and mock fly in progress doc',
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
      'Test Material Review widget. Pass in mock template doc and empty fly in progress doc',
      (WidgetTester tester) async {
    final newFlyFormTemplate =
        NewFlyFormTemplate.fromDoc(MockData.mockNewFlyFormDoc);
    final flyInProgress =
        Fly.formattedForReview(flyFormTemplate: newFlyFormTemplate);

    final nfft = NewFlyFormTransfer(
        flyInProgress: flyInProgress, newFlyFormTemplate: newFlyFormTemplate);

    // Build our app and trigger a frame.
    Widget widget = TestWidgetWrapper(
        child: MaterialReview(
      newFlyFormTransfer: nfft,
    ));
    await tester.pumpWidget(widget);
    await tester.tap(find.byKey(ValueKey(TestValueKeys.startMaterialsKey)));
    await tester.pumpAndSettle();

    // We should find the title of each material (eg 'Beads', 'Dubbings', etc)
    flyInProgress.materials.forEach((flyMaterials) {
      expect(find.text(flyMaterials.name.toTitleCase()), findsOneWidget);
    });
  });

  testWidgets(
      'Test Material Review widget. Pass in mock template doc and fly in progress doc',
      (WidgetTester tester) async {
    final newFlyFormTemplate =
        NewFlyFormTemplate.fromDoc(MockData.mockNewFlyFormDoc);
    final flyInProgress = Fly.formattedForReview(
        mats: MockData.flyInProgressDoc['materials'],
        flyFormTemplate: newFlyFormTemplate);

    final nfft = NewFlyFormTransfer(
        flyInProgress: flyInProgress, newFlyFormTemplate: newFlyFormTemplate);

    // Build our app and trigger a frame.
    Widget widget = TestWidgetWrapper(
        child: MaterialReview(
      newFlyFormTransfer: nfft,
    ));
    await tester.pumpWidget(widget);
    await tester.tap(find.byKey(ValueKey(TestValueKeys.startMaterialsKey)));
    await tester.pumpAndSettle();

    // We should find the title of each material (eg 'Beads', 'Dubbings', etc)
    flyInProgress.materials.forEach((flyMaterials) {
      expect(find.text(flyMaterials.name.toTitleCase()), findsOneWidget);
      flyMaterials.flyMaterials?.asMap()?.forEach((propertyIndex, flyMaterial) {
        // Use propertyIndex to locat this material subgroup ValueKey.
        flyMaterial.properties.forEach((propName, propValue) {
          expect(
              find.descendant(
                  of: find.byKey(
                      ValueKey(flyMaterial.name + propertyIndex.toString())),
                  matching: find.text(propValue)),
              findsOneWidget);
        });
      });
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
      home: Scaffold(body: SingleChildScrollView(child: child)),
    );
  }
}
