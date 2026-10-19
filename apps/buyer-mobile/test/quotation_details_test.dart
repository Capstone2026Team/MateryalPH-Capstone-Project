import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:materyalph/design_system/components/messaging_components.dart';
import 'package:materyalph/design_system/components/quotation_details.dart';
import 'package:materyalph/design_system/components/specification_chips.dart';
import 'package:materyalph/design_system/theme.dart';
import 'package:materyalph_api_client/materyalph_api_client.dart' as api;

import 'messaging_test.dart' show quotation;

Future<void> showDetails(
  WidgetTester tester,
  Widget child, {
  double scale = 1,
}) async {
  await tester.binding.setSurfaceSize(const Size(320, 1000));
  addTearDown(() => tester.binding.setSurfaceSize(null));
  await tester.pumpWidget(
    MaterialApp(
      theme: BuyerTheme.light,
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(
          context,
        ).copyWith(textScaler: TextScaler.linear(scale)),
        child: child!,
      ),
      home: Scaffold(body: SingleChildScrollView(child: child)),
    ),
  );
}

void main() {
  testWidgets(
    'accepted quotation shows the Buyer payment choice and direct physical fee treatment',
    (tester) async {
      final version = quotation().rebuild(
        (b) => b
          ..state = 'ACCEPTED'
          ..selectedPaymentMethod = 'IN_STORE'
          ..actions.clear(),
      );
      await showDetails(tester, QuotationVersionCard(version: version));
      expect(find.text('In-Store Payment'), findsOneWidget);
      expect(find.text('Not applicable'), findsOneWidget);
      expect(find.text('Buyer selects before accepting'), findsNothing);
      expect(tester.takeException(), isNull);
    },
  );
  testWidgets(
    'quoted technical details display from the decoded published line',
    (tester) async {
      final line = api.standardSerializers.deserializeWith(
        api.ChatQuotationLine.serializer,
        {
          'variant_id': 'item',
          'quantity': '4.0000',
          'unit_price_centavos': 1700,
          'description': 'Portland Cement',
          'unit_code': 'bag',
          'tax_category': 'VAT_12',
          'source_price_version_id': 'price',
          'source_tax_version_id': 'tax',
          'brand': 'Quoted brand',
          'variant_label': '40 kg bag',
          'specifications': {
            'compressive_strength_mpa': '28',
            'cement_type': 'Type 1',
          },
        },
      )!;
      final version = quotation().rebuild(
        (b) => b
          ..state = 'VIEWED'
          ..content.lines.replace([line]),
      );
      await showDetails(
        tester,
        QuotationVersionCard(version: version, onAction: (_) {}),
      );
      final specs = tester.widget<SpecificationChips>(
        find.byType(SpecificationChips),
      );
      expect(specs.details.map(specificationText), [
        'Brand Quoted brand',
        'Variant 40 kg bag',
        'Compressive Strength (MPa) 28',
        'Cement Type Type 1',
      ]);
      expect(find.text('4 bag × ₱17.00'), findsOneWidget);
      expect(find.text('Viewed by Buyer'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('historical details stay readable and omit zero discount noise', (
    tester,
  ) async {
    await showDetails(
      tester,
      QuotationVersionCard(version: quotation(), onAction: (_) {}),
    );
    expect(
      find.text('Technical details not recorded for this quotation.'),
      findsOneWidget,
    );
    expect(find.textContaining('Vendor discount ('), findsNothing);
    expect(find.text('Materials subtotal'), findsNothing);
    expect(find.text('Included VAT (in materials)'), findsOneWidget);
    expect(find.text('₱7.29'), findsOneWidget);
    expect(find.text('₱68.00'), findsNWidgets(2));
    expect(find.text('Pending'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'saved net total includes VAT and NRPC and remains readable at large text',
    (tester) async {
      final content = quotation().content.rebuild(
        (c) => c
          ..fulfillmentMethod = 'DELIVERY'
          ..commercial.update(
            (m) => m
              ..materialsGrossCentavos = 100000
              ..vendorDiscountCentavos = 10000
              ..materialsPayableCentavos = 90000
              ..materialsVatCentavos = 9643
              ..deliveryCentavos = 20000
              ..nrpcCentavos = 5000
              ..commercialTotalCentavos = 110000,
          )
          ..discount.update(
            (d) => d
              ..scope = api.ChatQuotationDiscountAssessmentScopeEnum.MATERIALS
              ..percent = '10.00'
              ..basisCentavos = 100000
              ..deductionCentavos = 10000,
          ),
      );
      await showDetails(
        tester,
        QuotationPaymentBreakdown(content: content),
        scale: 2,
      );
      expect(find.text('Materials subtotal'), findsOneWidget);
      expect(find.text('₱1,000.00'), findsOneWidget);
      expect(find.text('Vendor discount (materials · 10.00%)'), findsOneWidget);
      expect(find.text('− ₱100.00'), findsOneWidget);
      expect(find.text('₱900.00'), findsOneWidget);
      expect(find.text('₱96.43'), findsOneWidget);
      expect(find.text('Total before processing fee'), findsOneWidget);
      expect(find.text('₱1,100.00'), findsOneWidget);
      expect(find.text('NRPC included in total'), findsOneWidget);
      expect(find.text('₱50.00'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'delivery discount displays gross, deduction and saved net delivery separately',
    (tester) async {
      final content = quotation().content.rebuild(
        (c) => c
          ..fulfillmentMethod = 'DELIVERY'
          ..commercial.update(
            (m) => m
              ..deliveryCentavos = 18000
              ..commercialTotalCentavos = 24800,
          )
          ..discount.update(
            (d) => d
              ..scope = api.ChatQuotationDiscountAssessmentScopeEnum.DELIVERY
              ..percent = '10.00'
              ..basisCentavos = 20000
              ..deductionCentavos = 2000,
          ),
      );
      await showDetails(tester, QuotationPaymentBreakdown(content: content));
      expect(find.text('Delivery subtotal'), findsOneWidget);
      expect(find.text('₱200.00'), findsOneWidget);
      expect(find.text('Vendor discount (delivery · 10.00%)'), findsOneWidget);
      expect(find.text('− ₱20.00'), findsOneWidget);
      expect(find.text('Delivery after discounts'), findsOneWidget);
      expect(find.text('₱180.00'), findsOneWidget);
      expect(find.text('₱248.00'), findsOneWidget);
      expect(find.textContaining('Vendor discount (materials'), findsNothing);
      expect(tester.takeException(), isNull);
    },
  );
}
