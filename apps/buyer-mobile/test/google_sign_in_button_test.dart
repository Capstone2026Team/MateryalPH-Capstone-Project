import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:materyalph/design_system/theme.dart';
import 'package:materyalph/widgets/google_sign_in_button.dart';

void main() {
  Widget host(VoidCallback? onPressed) => MaterialApp(
    theme: BuyerTheme.light,
    home: Scaffold(
      body: GoogleSignInButton(
        label: 'Continue with Google',
        onPressed: onPressed,
      ),
    ),
  );

  testWidgets(
    'shows the Google mark before the label and meets the target size',
    (tester) async {
      var taps = 0;
      await tester.pumpWidget(host(() => taps++));

      final mark = tester.getRect(find.byType(GoogleMark));
      final label = tester.getRect(find.text('Continue with Google'));
      expect(mark.size, const Size.square(18));
      expect(mark.right, lessThan(label.left));
      expect(
        tester.getSize(find.byType(OutlinedButton)).height,
        greaterThanOrEqualTo(44),
      );

      await tester.tap(find.byType(GoogleSignInButton));
      expect(taps, 1);
    },
  );

  testWidgets('is disabled while a Google request is opening', (tester) async {
    await tester.pumpWidget(host(null));

    expect(
      tester.widget<OutlinedButton>(find.byType(OutlinedButton)).enabled,
      isFalse,
    );
  });
}
