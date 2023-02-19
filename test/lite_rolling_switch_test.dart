import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lite_rolling_switch/lite_rolling_switch.dart';

void main() {
  testWidgets(
      'Button switch have the expected text and an icon on initial state',
      (tester) async {
    // Create the widget by telling the tester to build it.
    await tester.pumpWidget(MaterialApp(
        home: Center(
      child: LiteRollingSwitch(
          value: false,
          textOff: 'Off',
          iconOff: Icons.remove,
          onTap: () {},
          onDoubleTap: () {},
          onSwipe: () {},
          onChanged: (value) {}),
    )));

    // Create the Finders.
    final textFinder = find.text('Off');
    final iconFinder = find.byIcon(Icons.remove);

    // Use the `findsOneWidget` matcher provided by flutter_test to
    // verify that there is exactly one widget in the widget tree.
    expect(textFinder, findsOneWidget);
    expect(iconFinder, findsOneWidget);
  });

  testWidgets(
      'Button switch change to the expected text and an icon when tapped',
      (tester) async {
    // Constants
    const defaultDuration = Duration(milliseconds: 600);
    const initialStateIcon = Icons.add;
    const initialStateText = 'On';
    const finalStateIcon = Icons.remove;
    const finalStateText = 'Off';

    // Create the widget by telling the tester to build it.
    await tester.pumpWidget(
      MaterialApp(
          home: LiteRollingSwitch(
              value: true,
              textOn: initialStateText,
              iconOn: initialStateIcon,
              textOff: finalStateText,
              iconOff: finalStateIcon,
              animationDuration: defaultDuration,
              onTap: () {},
              onDoubleTap: () {},
              onSwipe: () {},
              onChanged: (value) {})),
    );

    // Initial state Finders.
    final initialStateTextFinder = find.text(initialStateText);
    final initialStateIconFinder = find.byIcon(initialStateIcon);

    // Use the `findsOneWidget` matcher provided by flutter_test to
    // verify that there is exactly one widget in the widget tree.
    expect(initialStateTextFinder, findsOneWidget);
    expect(initialStateIconFinder, findsOneWidget);

    // Tap the icon and trigger a frame (animation tick).
    await tester.tap(initialStateIconFinder);
    await tester.pump(defaultDuration);

    // Final state Finders.
    final finalStateTextFinder = find.text(finalStateText);
    final finalStateIconFinder = find.byIcon(finalStateIcon);

    // Verify that our text and icon has changed as expected.
    expect(finalStateTextFinder, findsOneWidget);
    expect(finalStateIconFinder, findsOneWidget);
  });
}
