import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:materyalph/design_system/components/peso_amount_field.dart';
import 'package:materyalph/features/projects/projects_repository.dart';

void main() {
  const formatter = PesoAmountFormatter();
  String type(String text) => formatter
      .formatEditUpdate(TextEditingValue.empty, TextEditingValue(text: text))
      .text;

  test('groups the whole part and limits decimals and digits', () {
    expect(type('1234567'), '1,234,567');
    expect(type('1234.567'), '1,234.56');
    expect(type('1,2a3.4.5'), '123.45');
    expect(type('0012'), '12');
    expect(type('59668558587'), '596,685,585');
    expect(type(''), '');
  });

  test('scale label and field text', () {
    expect(pesoScaleLabel(999), isNull);
    expect(pesoScaleLabel(150000), '150 thousand');
    expect(pesoScaleLabel(12345678), '12.35 million');
    expect(pesoFieldText(123450), '1,234.50');
    expect(parseProjectMoney('1,234,567.8'), 123456780);
    expect(parseProjectMoney('12,34'), isNull);
  });

  testWidgets('shows the scale readout while typing', (tester) async {
    final controller = TextEditingController();
    addTearDown(controller.dispose);
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: PesoAmountField(controller: controller, label: 'Budget'),
        ),
      ),
    );
    await tester.enterText(find.byType(TextField), '2500000');
    await tester.pump();
    expect(controller.text, '2,500,000');
    expect(find.text('≈ 2.5 million pesos'), findsOneWidget);
  });
}
