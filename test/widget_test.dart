import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:notes_app/coffee_prefs.dart';

void main() {
  testWidgets('strength counter increments and wraps at 5',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: CoffeePrefs())),
    );

    // Both counters start at 1 bean / 1 sugar cube.
    expect(find.byType(Image), findsNWidgets(2));

    // The FilledButton drives strength; the TextButton drives sugars.
    await tester.tap(find.byType(FilledButton));
    await tester.pump();
    expect(find.byType(Image), findsNWidgets(3));

    // 3 more taps take strength to 5, then a 4th wraps it back to 1.
    for (var i = 0; i < 3; i++) {
      await tester.tap(find.byType(FilledButton));
      await tester.pump();
    }
    expect(find.byType(Image), findsNWidgets(6));

    await tester.tap(find.byType(FilledButton));
    await tester.pump();
    expect(find.byType(Image), findsNWidgets(2));
  });

  testWidgets('sugars wrap to zero and show the empty label',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: CoffeePrefs())),
    );

    expect(find.text('No Sugars..'), findsNothing);

    // Sugars start at 1, so 5 taps run 2..5 and then wrap to 0.
    for (var i = 0; i < 5; i++) {
      await tester.tap(find.byType(TextButton));
      await tester.pump();
    }

    expect(find.text('No Sugars..'), findsOneWidget);
  });
}
