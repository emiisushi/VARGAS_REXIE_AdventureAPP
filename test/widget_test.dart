import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:canvas_of_the_heart/main.dart';

void main() {
  testWidgets('App renders the first scene', (WidgetTester tester) async {
    await tester.pumpWidget(const CanvasOfTheHeartApp());
    expect(find.text('Continue...'), findsOneWidget);
  });
}
