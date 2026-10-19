import 'package:built_value/json_object.dart';
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

api.ChatQuotationChange change(String path, Object? before, Object? after) =>
    api.ChatQuotationChange(
      (b) => b
        ..path = path
        ..label = 'raw server label for $path'
        ..before = before == null ? null : JsonObject(before)
        ..after = after == null ? null : JsonObject(after),
    );

void main() {
  test(
    'generated quotation codec retains change requests and their exact deadline',
    () {
      final version = quotation().rebuild(
        (b) => b
          ..requestedChanges = 'Please reduce quantity.'
          ..changeRequestedAt = '2026-10-18T03:00:00Z'
          ..vendorResponseDueAt = '2026-10-19T03:00:00Z',
      );
      final wire = api.standardSerializers.serializeWith(
        api.ChatQuotationVersion.serializer,
        version,
      );
      final decoded = api.standardSerializers.deserializeWith(
        api.ChatQuotationVersion.serializer,
        wire,
      );
      expect(decoded, version);
      expect(quotation().requestedChanges, isNull);
    },
  );
  test('only decision-relevant changes survive the raw field diff', () {
    final content = quotation().content;
    final notes = importantQuotationChanges(content, [
      change('lines.0.line_id', 'old', 'new'),
      change('lines.0.variant_id', 'a', 'b'),
      change('lines.0.source_price_version_id', 'a', 'b'),
      change('lines.0.source_tax_version_id', 'a', 'b'),
      change('lines.0.load.weight_kg', '1', '2'),
      change('lines.0.quantity', '2.0000', '4.0000'),
      change('lines.0.unit_price_centavos', 1500, 1700),
      change('commercial.materials_vat_centavos', 100, 729),
      change('processing_fee_status', null, 'PENDING_PAYMENT_CHANNEL'),
      change('destination.address', 'x', 'y'),
      change('fulfillment_method', 'DELIVERY', 'PICKUP'),
      change('fulfillment_date', null, '2099-10-01'),
      change('payment_method', null, 'ONLINE'),
    ]);
    expect(notes.map((n) => '${n.title}|${n.before}|${n.after}'), [
      'Portland Cement · Quantity|2 bag|4 bag',
      'Portland Cement · Unit price|₱15.00|₱17.00',
      'Fulfillment|Site Delivery|Self-Pickup',
      'Fulfillment date|null|2099-10-01',
      'Payment method|null|Online payment',
    ]);
  });
  test('added and removed products are named with their quantity', () {
    final notes = importantQuotationChanges(quotation().content, [
      change('lines.1', null, {
        'description': 'River sand',
        'quantity': '3.5000',
        'unit_code': 'cu.m',
        'variant_id': 'v',
      }),
      change('lines.2', {'description': 'Gravel', 'quantity': '1.0000'}, null),
    ]);
    expect(notes.map((n) => '${n.title}|${n.after}'), [
      'Added · River sand|3.5 cu.m',
      'Removed · Gravel|1',
    ]);
  });
  testWidgets('the thread carries one button, not the full quotation', (
    tester,
  ) async {
    var opened = 0;
    await tester.pumpWidget(
      MaterialApp(
        theme: BuyerTheme.light,
        home: Scaffold(
          body: QuotationThreadButton(
            version: quotation(),
            onOpen: () => opened++,
          ),
        ),
      ),
    );
    expect(find.text('Requested quotation v2'), findsOneWidget);
    expect(find.text('Awaiting your response · ₱68.00'), findsOneWidget);
    expect(find.text('Portland Cement'), findsNothing);
    expect(find.text('Review & accept'), findsNothing);
    await tester.tap(find.text('Requested quotation v2'));
    expect(opened, 1);
    await tester.pumpWidget(const SizedBox());
  });
  testWidgets('What changed lists only important notes and folds long lists', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(390, 1500));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      MaterialApp(
        theme: BuyerTheme.light,
        home: Scaffold(
          body: SingleChildScrollView(
            child: QuotationChangeList(
              emptyLabel: 'Nothing changed',
              notes: [
                for (var i = 1; i <= 7; i++)
                  QuotationChangeNote(
                    'Change $i',
                    before: '$i',
                    after: '${i + 1}',
                  ),
              ],
            ),
          ),
        ),
      ),
    );
    expect(find.text('What changed · 7'), findsOneWidget);
    expect(find.text('Change 5'), findsOneWidget);
    expect(find.text('Change 6'), findsNothing);
    await tester.tap(find.text('Show all 7 changes'));
    await tester.pump();
    expect(find.text('Change 7'), findsOneWidget);
    await tester.pumpWidget(const SizedBox());
  });
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
    expect(find.text('4 bag × ₱17.00'), findsOneWidget);
    expect(find.text('What changed'), findsOneWidget);
    expect(find.textContaining('fields'), findsNothing);
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
