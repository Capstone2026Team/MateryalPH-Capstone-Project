import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:materyalph/design_system/theme.dart';
import 'package:materyalph/widgets/password_requirements.dart';

void main() {
  test('requirements mirror the 12 character mixed-case number rule', () {
    bool met(String value, int index) => passwordRequirements(value)[index].met;

    expect(passwordRequirements('').every((item) => !item.met), isTrue);
    expect(met('abcdefghijkl', 0), isTrue);
    expect(met('abcdefghijk', 0), isFalse);
    expect(met('abcA', 1), isTrue);
    expect(met('abc', 1), isFalse);
    expect(met('ABCa', 2), isTrue);
    expect(met('ABC', 2), isFalse);
    expect(met('abc1', 3), isTrue);
    expect(met('abc', 3), isFalse);
    expect(passwordMeetsRequirements('Abcdefghijk1'), isTrue);
    expect(passwordMeetsRequirements('abcdefghijk1'), isFalse);
  });

  testWidgets('checklist updates as the Buyer types and is announced', (
    tester,
  ) async {
    final controller = TextEditingController();
    addTearDown(controller.dispose);
    await tester.pumpWidget(
      MaterialApp(
        theme: BuyerTheme.light,
        home: Scaffold(body: PasswordRequirements(controller: controller)),
      ),
    );
    expect(
      find.bySemanticsLabel(
        'Must contain at least 1 uppercase letter, not met',
      ),
      findsOneWidget,
    );
    controller.text = 'Abcdefghijk1';
    await tester.pump();
    expect(
      find.bySemanticsLabel('Must contain at least 1 uppercase letter, met'),
      findsOneWidget,
    );
    expect(find.bySemanticsLabel(RegExp(r', not met$')), findsNothing);
  });
}
