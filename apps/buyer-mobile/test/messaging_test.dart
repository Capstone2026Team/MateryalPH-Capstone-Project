import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:materyalph/design_system/components/messaging_components.dart';
import 'package:materyalph/design_system/theme.dart';
import 'package:materyalph_api_client/materyalph_api_client.dart' as api;

api.ChatQuotationVersion quotation({bool latest = true}) =>
    api.ChatQuotationVersion(
      (b) => b
        ..id = 'version-2'
        ..version = 2
        ..latest = latest
        ..state = latest ? 'PUBLISHED' : 'SUPERSEDED'
        ..publishedAt = '2026-09-30T00:00:00Z'
        ..expiresAt = '2099-09-30T00:00:00Z'
        ..contentHash = 'hash'
        ..viewed = true
        ..actions.addAll(['view', 'accept', 'reject', 'counter'])
        ..content.update(
          (c) => c
            ..fulfillmentMethod = 'PICKUP'
            ..paymentMethod = 'ONLINE'
            ..fulfillmentDate = '2099-10-01'
            ..priceSource =
                api.ChatQuotationContentPriceSourceEnum.PRIVATE_TRANSACTION
            ..processingFeeStatus = 'PENDING_PAYMENT_CHANNEL'
            ..lines.add(
              api.ChatQuotationLine(
                (l) => l
                  ..variantId = 'variant'
                  ..quantity = '4'
                  ..unitPriceCentavos = 1700
                  ..description = 'Portland Cement'
                  ..unitCode = 'bag'
                  ..taxCategory = 'VAT_12'
                  ..sourcePriceVersionId = 'price'
                  ..sourceTaxVersionId = 'tax',
              ),
            )
            ..commercial.update(
              (m) => m
                ..materialsPayableCentavos = 6800
                ..materialsVatCentavos = 729
                ..vendorDiscountCentavos = 0
                ..deliveryCentavos = 0
                ..nrpcCentavos = 0
                ..commercialTotalCentavos = 6800,
            ),
        ),
    );

void main() {
  test('a conversation before its first draft decodes without a quotation', () {
    final page = api.standardSerializers.deserializeWith(
      api.ChatQuotationPage.serializer,
      {'quotation': null, 'versions': <Object>[], 'has_more': false},
    );
    expect(page!.quotation, isNull);
    expect(page.versions, isEmpty);
  });
  testWidgets('latest quotation has valid actions and exact Manila deadline', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(390, 1500));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    String? action;
    await tester.pumpWidget(
      MaterialApp(
        theme: BuyerTheme.light,
        home: Scaffold(
          body: SingleChildScrollView(
            child: QuotationVersionCard(
              version: quotation(),
              onAction: (value) => action = value,
            ),
          ),
        ),
      ),
    );
    expect(find.text('Latest version'), findsOneWidget);
    expect(find.textContaining('Manila'), findsOneWidget);
    await tester.tap(find.text('Review & accept'));
    expect(action, 'accept');
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox());
  });
  testWidgets(
    'superseded quotation retains terms and has no stale acceptance',
    (tester) async {
      await tester.binding.setSurfaceSize(const Size(320, 1500));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      await tester.pumpWidget(
        MaterialApp(
          theme: BuyerTheme.light,
          home: Scaffold(
            body: SingleChildScrollView(
              child: QuotationVersionCard(
                version: quotation(latest: false),
                onAction: (_) {},
              ),
            ),
          ),
        ),
      );
      expect(find.text('Portland Cement'), findsOneWidget);
      expect(find.text('Review & accept'), findsNothing);
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox());
    },
  );
}
