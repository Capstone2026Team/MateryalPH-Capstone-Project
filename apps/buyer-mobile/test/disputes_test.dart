import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:materyalph/design_system/components/dispute_components.dart';
import 'package:materyalph/design_system/theme.dart';
import 'package:materyalph/features/disputes/dispute_models.dart';
import 'package:materyalph/features/disputes/dispute_screens.dart';
import 'package:materyalph/features/map_discovery/discovery_models.dart';
import 'package:materyalph/features/orders/order_details_screen.dart';
import 'package:materyalph/features/orders/order_models.dart';

import 'disputes_fakes.dart';
import 'orders_fakes.dart';

Widget _app(Widget home) => MaterialApp(theme: BuyerTheme.light, home: home);

Future<void> _tall(WidgetTester tester) async {
  await tester.binding.setSurfaceSize(const Size(390, 2400));
  addTearDown(() => tester.binding.setSurfaceSize(null));
}

final _fixedNow = DateTime.utc(2026, 10, 5, 3);
DateTime _now() => _fixedNow;

void main() {
  testWidgets(
    'filing shows the masked original method read-only, has no refund destination and sends one key',
    (tester) async {
      await _tall(tester);
      final repository = FakeDisputesRepository()
        ..eligible = eligibility()
        ..detail = disputeDetail();
      await tester.pumpWidget(
        _app(
          FileDisputeScreen(
            orderId: 'order-1',
            repository: repository,
            picker: () async => EvidenceFile(
              bytes: Uint8List.fromList([1, 2, 3]),
              filename: 'cracked.jpg',
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Filing does not refund automatically'), findsOneWidget);
      expect(find.text('GCash •••• 1234'), findsOneWidget);
      expect(
        find.textContaining('cannot choose another destination'),
        findsOneWidget,
      );
      // Nothing on the form accepts a refund destination: no account, wallet or bank field.
      expect(
        find.textContaining(
          RegExp('account number|bank|wallet number', caseSensitive: false),
        ),
        findsNothing,
      );

      await tester.tap(find.text('File dispute'));
      await tester.pump();
      expect(find.text('Choose what went wrong.'), findsOneWidget);
      expect(repository.filings, isEmpty);

      await tester.tap(find.text('What went wrong?'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Defective or damaged').last);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Requested remedy'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Partial refund').last);
      await tester.pumpAndSettle();
      await tester.tap(find.text('File dispute'));
      await tester.pump();
      expect(
        find.text('Enter the partial refund amount you are asking for.'),
        findsOneWidget,
      );

      await tester.enterText(
        find.widgetWithText(TextField, 'Partial amount you are asking for (₱)'),
        '90.00',
      );
      await tester.tap(find.byType(CheckboxListTile));
      await tester.enterText(
        find.widgetWithText(TextField, 'Describe the problem'),
        'Five blocks arrived cracked at the corners.',
      );
      await tester.tap(find.text('Attach evidence (optional)'));
      await tester.pumpAndSettle();
      expect(find.text('cracked.jpg'), findsOneWidget);
      await tester.tap(find.text('File dispute'));
      await tester.pumpAndSettle();

      expect(repository.filings, [
        {
          'issueType': 'DEFECTIVE',
          'requestedRemedy': 'PARTIAL_REFUND',
          'amount': 9000,
          'lines': ['line-1'],
          'file': 'cracked.jpg',
        },
      ]);
      expect(repository.keys, hasLength(1));
    },
  );

  testWidgets('an offline filing retry reuses the same idempotency key', (
    tester,
  ) async {
    await _tall(tester);
    final repository = FakeDisputesRepository()
      ..eligible = eligibility()
      ..detail = disputeDetail()
      ..failOnce = (call) => call == 'file'
          ? const DiscoveryFailure(
              DiscoveryFailureKind.offline,
              'You appear to be offline.',
            )
          : null;
    await tester.pumpWidget(
      _app(FileDisputeScreen(orderId: 'order-1', repository: repository)),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('What went wrong?'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Wrong item').last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Requested remedy'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Replacement').last);
    await tester.pumpAndSettle();
    await tester.enterText(
      find.widgetWithText(TextField, 'Describe the problem'),
      'The store sent 6-inch blocks instead of 4-inch.',
    );
    await tester.tap(find.byType(CheckboxListTile));
    await tester.tap(find.text('File dispute'));
    await tester.pumpAndSettle();
    expect(find.text('You appear to be offline.'), findsOneWidget);
    await tester.tap(find.text('File dispute'));
    await tester.pumpAndSettle();
    expect(repository.keys, hasLength(2));
    expect(repository.keys.toSet(), hasLength(1));
  });

  testWidgets('return and refund requires an affected item before sending', (
    tester,
  ) async {
    await _tall(tester);
    final repository = FakeDisputesRepository()
      ..eligible = eligibility()
      ..detail = disputeDetail();
    await tester.pumpWidget(
      _app(FileDisputeScreen(orderId: 'order-1', repository: repository)),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('What went wrong?'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Defective or damaged').last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Requested remedy'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Return and refund').last);
    await tester.pumpAndSettle();
    await tester.enterText(
      find.widgetWithText(TextField, 'Describe the problem'),
      'The steel bars arrived damaged and need returning.',
    );
    await tester.tap(find.text('File dispute'));
    await tester.pumpAndSettle();
    expect(find.text('Select at least one affected item.'), findsOneWidget);
    expect(repository.filings, isEmpty);
    await tester.tap(find.byType(CheckboxListTile));
    await tester.pump();
    expect(find.text('Select at least one affected item.'), findsNothing);
    await tester.tap(find.text('File dispute'));
    await tester.pumpAndSettle();
    expect(repository.filings.single['requestedRemedy'], 'RETURN_AND_REFUND');
    expect(repository.filings.single['lines'], ['line-1']);
  });

  testWidgets(
    'API validation highlights fields and keeps the entered complaint',
    (tester) async {
      await _tall(tester);
      final repository = FakeDisputesRepository()
        ..eligible = eligibility()
        ..failOnce = (call) => call == 'file'
            ? const DiscoveryFailure(
                DiscoveryFailureKind.validation,
                'Review the highlighted fields and try again.',
                details: {
                  'description': ['Explain which items were damaged.'],
                  'affected_line_ids.0': ['This order line is unavailable.'],
                  'files.0': ['The evidence file is too large.'],
                  'order_id': ['This order is unavailable.'],
                },
              )
            : null;
      await tester.pumpWidget(
        _app(FileDisputeScreen(orderId: 'order-1', repository: repository)),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('What went wrong?'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Wrong item').last);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Requested remedy'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Replacement').last);
      await tester.pumpAndSettle();
      await tester.tap(find.byType(CheckboxListTile));
      const complaint = 'The steel bars arrived damaged and need returning.';
      await tester.enterText(
        find.widgetWithText(TextField, 'Describe the problem'),
        complaint,
      );
      await tester.tap(find.text('File dispute'));
      await tester.pumpAndSettle();
      final description = tester.widget<TextField>(
        find.widgetWithText(TextField, 'Describe the problem'),
      );
      expect(
        description.decoration!.errorText,
        'Explain which items were damaged.',
      );
      expect(description.controller!.text, complaint);
      expect(find.text('This order line is unavailable.'), findsOneWidget);
      expect(find.text('The evidence file is too large.'), findsOneWidget);
      expect(find.textContaining('This order is unavailable.'), findsOneWidget);
      expect(
        tester.widget<CheckboxListTile>(find.byType(CheckboxListTile)).value,
        isTrue,
      );
    },
  );

  testWidgets('ineligible orders explain why and show no form', (tester) async {
    final repository = FakeDisputesRepository()
      ..eligible = eligibility(available: false);
    await tester.pumpWidget(
      _app(FileDisputeScreen(orderId: 'order-1', repository: repository)),
    );
    await tester.pumpAndSettle();
    expect(find.text('This order already has an active case.'), findsOneWidget);
    expect(find.text('File dispute'), findsNothing);
  });

  testWidgets(
    'the case shows Manila deadlines, one timeline and evidence opened through the signed API',
    (tester) async {
      await _tall(tester);
      const url =
          'https://api.test/api/v1/buyers/disputes/case-1/files/file-1/content?expires=1791172800&signature=abc';
      final repository = FakeDisputesRepository()
        ..detail = disputeDetail(
          evidence: [
            DisputeEvidenceView(
              fileId: 'file-1',
              label: 'ORIGINAL',
              name: 'cracked.jpg',
              contentType: 'image/jpeg',
              byteSize: 3,
              url: url,
              expiresAt: DateTime.utc(2026, 10, 5, 3, 5),
            ),
          ],
        );
      repository.files[url] = Uint8List.fromList([1, 2, 3]);
      final opened = <String>[];
      await tester.pumpWidget(
        _app(
          DisputeDetailScreen(
            caseId: 'case-1',
            repository: repository,
            now: _now,
            openFile: (context, bytes, name, type) async =>
                opened.add('$name:${bytes.length}'),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Response due in'), findsOneWidget);
      expect(find.text('Waiting for the store.'), findsOneWidget);
      expect(find.text('Case filed'), findsOneWidget);
      expect(find.textContaining('You · Oct 5, 2026'), findsOneWidget);
      await tester.tap(find.text('cracked.jpg'));
      await tester.pumpAndSettle();
      expect(repository.calls, contains('evidenceFile'));
      expect(opened, ['cracked.jpg:3']);
    },
  );

  for (final filedByParty in ['BUYER', 'VENDOR']) {
    testWidgets(
      'original complaint attributes the saved problem to $filedByParty',
      (tester) async {
        await _tall(tester);
        final vendorFiled = filedByParty == 'VENDOR';
        const description =
            'The agreed materials were not received.\nPlease review the attached details.';
        final repository = FakeDisputesRepository()
          ..detail = disputeDetail(
            filedByParty: filedByParty,
            issueType: vendorFiled ? 'PICKUP_NO_SHOW' : 'DEFECTIVE',
            requestedRemedy: vendorFiled ? 'WARNING_ONLY' : 'PARTIAL_REFUND',
            requestedAmountCentavos: vendorFiled ? null : 150050,
            description: description,
          );
        await tester.pumpWidget(
          _app(
            DisputeDetailScreen(
              caseId: 'case-1',
              repository: repository,
              now: _now,
            ),
          ),
        );
        await tester.pumpAndSettle();
        final complaint = find.byType(DisputeComplaintDetails);
        expect(find.text('Original complaint'), findsOneWidget);
        expect(find.text('Your complaint'), findsNothing);
        for (final text in [
          "${vendorFiled ? 'Vendor' : 'Buyer'}'s description of the problem",
          description,
          vendorFiled ? 'Pickup no-show' : 'Defective or damaged',
          vendorFiled ? 'Warning only' : 'Partial refund · ₱1,500.50',
        ]) {
          expect(
            find.descendant(of: complaint, matching: find.text(text)),
            findsOneWidget,
          );
        }
      },
    );
  }

  testWidgets('an absent original description has an explicit empty state', (
    tester,
  ) async {
    await _tall(tester);
    final repository = FakeDisputesRepository()
      ..detail = disputeDetail(description: null);
    await tester.pumpWidget(
      _app(
        DisputeDetailScreen(
          caseId: 'case-1',
          repository: repository,
          now: _now,
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('No problem description was recorded.'), findsOneWidget);
  });

  testWidgets('an expired evidence link reloads the case instead of fetching', (
    tester,
  ) async {
    await _tall(tester);
    final repository = FakeDisputesRepository()
      ..detail = disputeDetail(
        evidence: [
          DisputeEvidenceView(
            fileId: 'file-1',
            label: 'ORIGINAL',
            name: 'cracked.jpg',
            contentType: 'image/jpeg',
            byteSize: 3,
            url: 'https://api.test/x?expires=1&signature=old',
            expiresAt: DateTime.utc(2026, 10, 5, 2, 59),
          ),
        ],
      );
    await tester.pumpWidget(
      _app(
        DisputeDetailScreen(
          caseId: 'case-1',
          repository: repository,
          now: _now,
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('cracked.jpg'));
    await tester.pumpAndSettle();
    expect(
      repository.calls.where((call) => call == 'dispute:case-1'),
      hasLength(2),
    );
    expect(repository.calls, isNot(contains('evidenceFile')));
    expect(
      find.text('File links refreshed. Open the file again.'),
      findsOneWidget,
    );
  });

  testWidgets(
    'only server-allowed actions render; accepting a proposal confirms first',
    (tester) async {
      await _tall(tester);
      final repository = FakeDisputesRepository()
        ..detail = disputeDetail(
          status: 'MUTUAL_RESOLUTION',
          actions: const {'ANSWER_PROPOSAL'},
          proposals: const [
            DisputeProposalView(
              id: 'p1',
              proposedByParty: 'VENDOR',
              remedy: 'PARTIAL_REFUND',
              amountCentavos: 9000,
              terms: 'Refund the five cracked blocks.',
              state: 'PROPOSED',
              canAnswer: true,
            ),
          ],
        );
      await tester.pumpWidget(
        _app(
          DisputeDetailScreen(
            caseId: 'case-1',
            repository: repository,
            now: _now,
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Appeal this decision'), findsNothing);
      expect(find.text('Need MateryalPH to decide?'), findsNothing);
      expect(find.text('Add to the case'), findsNothing);

      await tester.tap(find.text('Accept'));
      await tester.pumpAndSettle();
      expect(find.text('Accept this proposal?'), findsOneWidget);
      expect(find.textContaining('original payment method'), findsWidgets);
      await tester.tap(find.widgetWithText(FilledButton, 'Accept').last);
      await tester.pumpAndSettle();
      expect(repository.calls, contains('answerProposal:p1:ACCEPT'));
    },
  );

  testWidgets(
    'a decided case tracks its remedy and refund to the original method',
    (tester) async {
      await _tall(tester);
      final repository = FakeDisputesRepository()
        ..detail = disputeDetail(
          status: 'DECIDED',
          actions: const {'APPEAL'},
          deadlines: [
            DisputeDeadlineView(
              kind: 'APPEAL',
              at: DateTime.utc(2026, 10, 12, 9),
              responsibleParty: 'EITHER',
              label: 'Oct 12, 2026, 5:00 PM',
            ),
          ],
          decisions: [
            DisputeDecisionView(
              id: 'd1',
              version: 1,
              kind: 'ADMIN_DECISION',
              outcome: 'PARTIAL_REFUND',
              awardedCentavos: 9000,
              reason: 'Photos show five cracked blocks on delivery.',
              enforceable: false,
              current: true,
              decidedAt: DateTime.utc(2026, 10, 5, 2),
              appealDueAt: DateTime.utc(2026, 10, 12, 9),
            ),
          ],
          remedies: const [
            DisputeRemedyView(
              id: 'r1',
              kind: 'ONLINE_REFUND',
              state: 'PENDING',
              amountCentavos: 9000,
              canConfirm: false,
            ),
          ],
          refunds: RefundTimelineView(
            refunds: [
              RefundItemView(
                id: 'rf1',
                trigger: 'DISPUTE_CONCLUSION',
                state: 'REFUND_PENDING',
                displayState: 'PENDING',
                amountCentavos: 9000,
                principalCentavos: 9000,
                processingFeeCentavos: 0,
                originalMethod: 'GCash •••• 1234',
                message:
                    'Refund to your original payment method is in progress.',
                requestedAt: DateTime.utc(2026, 10, 5, 2),
              ),
            ],
            reimbursements: const [],
            noLongerDueCentavos: 0,
          ),
        );
      await tester.pumpWidget(
        _app(
          DisputeDetailScreen(
            caseId: 'case-1',
            repository: repository,
            now: _now,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Remedy in progress'), findsOneWidget);
      expect(find.text('Dispute-Conclusion Refunds'), findsOneWidget);
      expect(
        find.textContaining('Becomes final if neither party appeals'),
        findsOneWidget,
      );
      expect(
        find.text('Either party may appeal once until this time.'),
        findsOneWidget,
      );

      await tester.tap(find.text('Start an appeal'));
      await tester.pumpAndSettle();
      await tester.enterText(
        find.widgetWithText(TextField, 'Why the decision should change'),
        'The store photos show the wrong pallet entirely.',
      );
      await tester.tap(find.text('File appeal'));
      await tester.pumpAndSettle();
      expect(find.text('Attach the new evidence.'), findsOneWidget);
      expect(
        repository.calls.where((call) => call.startsWith('appeal')),
        isEmpty,
      );
    },
  );

  testWidgets('a conflict after a deadline reloads the case from the server', (
    tester,
  ) async {
    await _tall(tester);
    final repository = FakeDisputesRepository()
      ..detail = disputeDetail(actions: const {'MESSAGE'})
      ..failOnce = (call) => call == 'message'
          ? const DiscoveryFailure(
              DiscoveryFailureKind.conflict,
              'This case changed. Review the latest state.',
            )
          : null;
    await tester.pumpWidget(
      _app(
        DisputeDetailScreen(
          caseId: 'case-1',
          repository: repository,
          now: _now,
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.enterText(
      find.widgetWithText(TextField, 'Message'),
      'Any update?',
    );
    await tester.tap(find.text('Send message'));
    await tester.pumpAndSettle();
    expect(
      find.text('This case changed. Review the latest state.'),
      findsOneWidget,
    );
    expect(
      repository.calls.where((call) => call == 'dispute:case-1'),
      hasLength(2),
    );
  });

  testWidgets(
    'order details links the case and offers filing only when the server allows it',
    (tester) async {
      await _tall(tester);
      final repository = FakeOrdersRepository(
        detail: orderDetail(
          state: 'DISPUTED',
          actions: const {'VIEW_DISPUTE', 'REQUEST_INVOICE'},
          dispute: const OrderDisputeRefView(
            caseId: 'case-1',
            reference: 'CASE-261004-ABC123',
            status: 'OPEN_AWAITING_RESPONSE',
            filedByParty: 'BUYER',
          ),
          invoice: const OrderInvoiceRefView(
            status: 'NOT_YET_UPLOADED',
            records: 0,
            openRequests: 0,
          ),
        ),
      );
      repository.disputes.detail = disputeDetail();
      await tester.pumpWidget(
        _app(
          OrderDetailsScreen(
            orderId: 'order-1',
            repository: repository,
            now: _now,
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('CASE-261004-ABC123'), findsOneWidget);
      expect(find.byType(DisputeStatusChip), findsOneWidget);
      expect(find.text('File a dispute'), findsNothing);
      expect(find.text('No copy uploaded yet'), findsOneWidget);
      await tester.tap(find.text('View case'));
      await tester.pumpAndSettle();
      expect(find.byType(DisputeDetailScreen), findsOneWidget);
    },
  );

  testWidgets('invoices show the store copy and send one keyed request', (
    tester,
  ) async {
    await _tall(tester);
    final repository = FakeDisputesRepository()..invoiceData = invoicesView();
    await tester.pumpWidget(
      _app(
        OrderInvoicesScreen(
          orderId: 'order-1',
          repository: repository,
          now: _now,
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('No invoice copy uploaded yet.'), findsOneWidget);
    expect(find.text('Billing details'), findsNothing);
    expect(find.text('MateryalPH documents'), findsNothing);
    expect(find.text('Request a correction'), findsNothing);

    await tester.tap(find.text('Request a copy'));
    await tester.pumpAndSettle();
    expect(
      find.textContaining('never extends its legal issuance deadline'),
      findsOneWidget,
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Full name'),
      'Juan Buyer',
    );
    await tester.enterText(
      find.widgetWithText(
        TextFormField,
        'Street name, building, house no. / billing address',
      ),
      '123 Sample Street, Manila',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Details for the Vendor'),
      'Please send the sales invoice.',
    );
    await tester.tap(find.byType(CheckboxListTile));
    await tester.tap(find.text('Submit Request'));
    await tester.pumpAndSettle();
    expect(repository.calls, contains('requestInvoice:COPY'));
    expect(repository.keys, hasLength(1));
    expect(find.text('Request sent to the store.'), findsOneWidget);
  });

  testWidgets('a mismatched invoice copy never changes what the Buyer pays', (
    tester,
  ) async {
    await _tall(tester);
    final repository = FakeDisputesRepository()
      ..invoiceData = invoicesView(
        records: const [
          InvoiceRecordItem(
            id: 'inv-1',
            invoiceType: 'VENDOR_GOODS_INVOICE',
            issuer: 'Alpha Construction Supply Corp.',
            invoiceNumber: 'SI-000123',
            issuedOn: '2026-10-05',
            amountCentavos: 19000,
            originLabel: 'DEMO sample uploaded in TEST mode',
            complianceNote: 'Issued by the store, not by MateryalPH.',
            reconciliationState: 'INVOICE_RECONCILIATION_REQUIRED',
            reconciliationDifferenceCentavos: 1000,
            buyerTotalUnchanged: true,
          ),
        ],
      );
    await tester.pumpWidget(
      _app(
        OrderInvoicesScreen(
          orderId: 'order-1',
          repository: repository,
          now: _now,
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(
      find.textContaining('What you pay does not change.'),
      findsOneWidget,
    );
    expect(find.text('DEMO sample uploaded in TEST mode'), findsOneWidget);
    expect(find.text('Request a correction'), findsOneWidget);
  });

  testWidgets('a forbidden case shows the permission state with retry', (
    tester,
  ) async {
    final repository = FakeDisputesRepository()
      ..failure = const DiscoveryFailure(
        DiscoveryFailureKind.forbidden,
        'You cannot view this case.',
      );
    await tester.pumpWidget(
      _app(
        DisputeDetailScreen(
          caseId: 'case-x',
          repository: repository,
          now: _now,
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('This case could not load'), findsOneWidget);
    expect(find.text('You cannot view this case.'), findsOneWidget);
    expect(find.text('Retry'), findsOneWidget);
  });
}
