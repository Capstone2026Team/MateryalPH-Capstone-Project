import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:materyalph/design_system/components/fulfillment_components.dart';
import 'package:materyalph/design_system/theme.dart';
import 'package:materyalph/features/orders/order_details_screen.dart';
import 'package:materyalph/features/orders/order_models.dart';
import 'package:materyalph/features/orders/orders_repository.dart';
import 'package:materyalph_api_client/materyalph_api_client.dart' as api;

import 'orders_fakes.dart';

/// Phase 12 Buyer fulfillment, receipt, cancellation and refund views. Synthetic data only.
Widget _app(Widget home) => MaterialApp(theme: BuyerTheme.light, home: home);

final _now = DateTime.utc(2026, 10, 6, 2);
const _photoPath =
    '/buyers/orders/order-1/files/01a0fb55-e5f2-7081-a9ee-314ee8596f70';

FulfillmentStepView _step(
  String key,
  String label,
  String status, {
  FulfillmentProofView? proof,
  bool proofRequired = false,
}) => FulfillmentStepView(
  key: key,
  label: label,
  status: status,
  proofRequired: proofRequired,
  at: status == 'COMPLETE' ? DateTime.utc(2026, 10, 6, 1) : null,
  actorRole: status == 'COMPLETE' ? 'FULFILLMENT' : null,
  proof: proof,
);

const _deliveryProof = FulfillmentProofView(
  milestone: 'DELIVERED',
  handoverConfirmed: true,
  receiverName: 'Site Foreman',
  receiverKind: 'AUTHORIZED_RECEIVER',
  photoPath: _photoPath,
);

FulfillmentView _delivered({
  bool paused = false,
  FulfillmentIssueView? issue,
  bool readOnly = false,
}) => FulfillmentView(
  method: 'DELIVERY',
  state: 'DELIVERED',
  late: false,
  expectedDate: '2026-10-06',
  trackingNotice:
      'Progress comes from milestones the Vendor records. There is no live GPS tracking.',
  nextAction: 'CONFIRM_RECEIPT',
  assigneeName: 'Rider One',
  proof: _deliveryProof,
  steps: [
    _step('CONFIRMED', 'Confirmed', 'COMPLETE'),
    _step('PROCESSING', 'Preparing', 'COMPLETE'),
    _step('OUT_FOR_DELIVERY', 'Out for delivery', 'COMPLETE'),
    _step(
      'DELIVERED',
      'Delivered',
      'COMPLETE',
      proof: _deliveryProof,
      proofRequired: true,
    ),
    _step('COMPLETED', 'Receipt confirmed', 'CURRENT'),
  ],
  receipt: FulfillmentReceiptView(
    paused: paused,
    windowHours: 48,
    dueAt: paused ? null : _now.add(const Duration(hours: 47)),
    remainingSeconds: paused ? 3600 * 30 : null,
  ),
  issue: issue,
  thread: FulfillmentThreadView(
    available: true,
    readOnly: readOnly,
    conversationId: 'conversation-1',
  ),
);

const _unavailable = CancellationView(
  mode: 'UNAVAILABLE',
  available: false,
  explanation:
      'Cancellation is not available once the order is out for delivery. Use Report a Problem or Fulfillment Messages instead.',
  requiresReason: false,
  reasonCodes: [],
  nrpcRetainableCentavos: 0,
  canWithdrawRequest: false,
  remedies: [
    CancellationRemedyView(
      code: 'REPORT_PROBLEM',
      available: true,
      note: 'Tell the Vendor what went wrong at handover.',
    ),
    CancellationRemedyView(
      code: 'DISPUTE',
      available: true,
      note: 'Available after a problem report is not resolved.',
    ),
  ],
);

const _cancelNow = CancellationView(
  mode: 'CANCEL_NOW',
  available: true,
  explanation:
      'You can cancel before the Vendor starts preparing. Paid amounts are refunded to your original payment method.',
  requiresReason: true,
  reasonCodes: ['CHANGE_OF_REQUIREMENT', 'BUDGET_CHANGE', 'OTHER'],
  nrpcRetainableCentavos: 0,
  canWithdrawRequest: false,
  remedies: [],
);

const _fullRefundPlan = CancellationPlanView(
  onlineRefundTotalCentavos: 1026441,
  cashReimbursementCentavos: 0,
  releasedUnpaidCentavos: 0,
  nrpcRetainedCentavos: 0,
  paidTotalCentavos: 1026441,
  payments: [
    CancellationPlanPaymentView(
      purpose: 'FULL_ORDER_PAYMENT',
      refundCentavos: 1026441,
      processingFeeCentavos: 26441,
      channelName: 'GCash',
    ),
  ],
);

RefundItemView _refund(String displayState) => RefundItemView(
  id: 'refund-$displayState',
  trigger: 'CANCELLATION',
  state: displayState == 'PROCESSED' ? 'REFUNDED' : 'REFUND_PENDING',
  displayState: displayState,
  amountCentavos: 1026441,
  processingFeeCentavos: 26441,
  originalMethod: 'GCash',
  message: displayState == 'PROCESSED'
      ? 'The provider confirmed the refund.'
      : 'Sent to the payment provider. It is not received yet.',
  requestedAt: DateTime.utc(2026, 10, 6, 1),
  completedAt: displayState == 'PROCESSED'
      ? DateTime.utc(2026, 10, 6, 3)
      : null,
);

void main() {
  testWidgets(
    'a delivered order shows proof on its step, a receipt countdown and confirms after asking',
    (tester) async {
      await tester.binding.setSurfaceSize(const Size(390, 2400));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      final repository = FakeOrdersRepository(
        detail: orderDetail(
          state: 'DELIVERED',
          payment: 'PAID',
          fulfillment: 'DELIVERY',
          actions: const {'CONFIRM_RECEIPT', 'REPORT_PROBLEM'},
          fulfillmentView: _delivered(),
          cancellation: _unavailable,
        ),
      );
      repository.files['01a0fb55-e5f2-7081-a9ee-314ee8596f70'] = Uint8List(0);
      String? opened;
      await tester.pumpWidget(
        _app(
          OrderDetailsScreen(
            orderId: 'order-1',
            repository: repository,
            now: () => _now,
            openConversation: (context, id) async => opened = id,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Delivery progress'), findsOneWidget);
      expect(find.text('Proof of delivery'), findsOneWidget);
      expect(
        find.text('Received by Site Foreman (authorized receiver)'),
        findsOneWidget,
      );
      // The private photo is read only through the order-scoped API path.
      expect(
        repository.calls,
        contains('orderFile:01a0fb55-e5f2-7081-a9ee-314ee8596f70'),
      );
      expect(
        find.text('Confirm receipt or report a problem within'),
        findsOneWidget,
      );
      expect(find.textContaining('no live GPS'), findsWidgets);
      // Cancellation is explained in text, with the remedies that stay open.
      await tester.scrollUntilVisible(
        find.text('Still available to you'),
        300,
        scrollable: find.byType(Scrollable).first,
      );
      expect(
        find.textContaining('not available once the order is out'),
        findsOneWidget,
      );
      expect(find.text('Still available to you'), findsOneWidget);
      expect(find.text('Cancel order'), findsNothing);

      await tester.scrollUntilVisible(
        find.text('Fulfillment Messages'),
        -300,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.tap(find.text('Fulfillment Messages'));
      await tester.pumpAndSettle();
      expect(opened, 'conversation-1');

      repository.onDecision = (_) => orderDetail(
        state: 'COMPLETED',
        payment: 'PAID',
        fulfillment: 'DELIVERY',
        fulfillmentView: _delivered(readOnly: true),
      );
      await tester.tap(find.text('Confirm receipt'));
      await tester.pumpAndSettle();
      expect(find.text('Confirm you received this order?'), findsOneWidget);
      await tester.tap(
        find.widgetWithText(FilledButton, 'Confirm receipt').last,
      );
      await tester.pumpAndSettle();
      expect(repository.calls, contains('confirmReceipt'));
      expect(repository.keys, hasLength(1));
      expect(
        find.text('Receipt confirmed. Your order is completed.'),
        findsOneWidget,
      );
      expect(
        find.text('View Fulfillment Messages (read-only)'),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'a problem report needs a category and description and sends one photo',
    (tester) async {
      await tester.binding.setSurfaceSize(const Size(390, 2400));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      final repository = FakeOrdersRepository(
        detail: orderDetail(
          state: 'DELIVERED',
          payment: 'PAID',
          fulfillment: 'DELIVERY',
          actions: const {'CONFIRM_RECEIPT', 'REPORT_PROBLEM'},
          fulfillmentView: _delivered(),
        ),
      );
      repository.onDecision = (_) => orderDetail(
        state: 'DELIVERED',
        payment: 'PAID',
        fulfillment: 'DELIVERY',
        actions: const {'CONFIRM_RECEIPT', 'RESOLVE_PROBLEM'},
        fulfillmentView: _delivered(
          paused: true,
          issue: const FulfillmentIssueView(
            id: 'issue-1',
            category: 'DAMAGED',
            description: 'Three blocks arrived cracked.',
            state: 'OPEN',
          ),
        ),
      );
      await tester.pumpWidget(
        _app(
          OrderDetailsScreen(
            orderId: 'order-1',
            repository: repository,
            now: () => _now,
            problemPhotoPicker: () async => ProblemPhoto(
              bytes: Uint8List.fromList([1, 2, 3]),
              filename: 'cracked.jpg',
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Report a problem'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Send report'));
      await tester.pump();
      expect(find.text('Choose what went wrong.'), findsOneWidget);
      await tester.tap(find.text('Damaged item'));
      await tester.enterText(
        find.widgetWithText(TextField, 'What happened?'),
        'Three blocks arrived cracked.',
      );
      await tester.tap(find.text('Add a photo (optional)'));
      await tester.pumpAndSettle();
      expect(find.textContaining('cracked.jpg'), findsOneWidget);
      await tester.tap(find.text('Send report'));
      await tester.pumpAndSettle();

      expect(repository.calls, contains('reportProblem:DAMAGED:cracked.jpg'));
      expect(find.text('Automatic confirmation is paused'), findsOneWidget);
      expect(find.text('Problem reported · Damaged item'), findsOneWidget);
      expect(find.text('Mark as resolved'), findsOneWidget);
    },
  );

  testWidgets(
    'a paid cancellation shows the server refund plan, requires a reason and reports initiation only',
    (tester) async {
      await tester.binding.setSurfaceSize(const Size(390, 2400));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      final repository =
          FakeOrdersRepository(
              detail: orderDetail(
                state: 'CONFIRMED',
                payment: 'PAID',
                actions: const {'CANCEL'},
                cancellation: _cancelNow,
                lockVersion: 7,
              ),
            )
            ..preview = const CancellationPreviewView(
              availability: _cancelNow,
              fullRefund: _fullRefundPlan,
              nrpcRetainableCentavos: 0,
              notice: 'Refunds go to the original payment method only.',
            );
      repository.onDecision = (_) => orderDetail(
        state: 'CANCELLED',
        payment: 'PAID',
        refundTimeline: RefundTimelineView(
          refunds: [_refund('INITIATED')],
          reimbursements: const [],
          noLongerDueCentavos: 0,
        ),
      );
      await tester.pumpWidget(
        _app(
          OrderDetailsScreen(
            orderId: 'order-1',
            repository: repository,
            now: () => _now,
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.widgetWithText(OutlinedButton, 'Cancel order'));
      await tester.pumpAndSettle();
      expect(find.text('Cancel this order?'), findsOneWidget);
      expect(
        find.textContaining('Refund to your original GCash'),
        findsOneWidget,
      );
      expect(find.text('₱10,264.41'), findsOneWidget);
      await tester.tap(find.widgetWithText(FilledButton, 'Cancel order'));
      await tester.pump();
      expect(find.text('Choose a cancellation reason.'), findsOneWidget);
      await tester.tap(find.text('Other'));
      await tester.pump();
      await tester.tap(find.widgetWithText(FilledButton, 'Cancel order'));
      await tester.pump();
      expect(
        find.text('Explain the reason in at least 5 characters.'),
        findsOneWidget,
      );
      await tester.enterText(
        find.widgetWithText(TextField, 'Explain your reason (required)'),
        'Site work postponed',
      );
      await tester.tap(find.widgetWithText(FilledButton, 'Cancel order'));
      await tester.pumpAndSettle();

      expect(repository.calls, contains('cancel:7:OTHER:Site work postponed'));
      expect(
        find.textContaining(
          'refund was initiated to your original payment method — it is not received yet',
        ),
        findsOneWidget,
      );
      expect(find.text('Refund initiated — not yet received'), findsOneWidget);
      expect(find.text('Refund processed'), findsNothing);
    },
  );

  testWidgets(
    'refund initiation and success look different and a recorded cash reimbursement can be confirmed',
    (tester) async {
      await tester.binding.setSurfaceSize(const Size(390, 1600));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      ReimbursementItemView? acknowledged;
      await tester.pumpWidget(
        _app(
          Scaffold(
            body: SingleChildScrollView(
              child: RefundTimelineCard(
                timeline: RefundTimelineView(
                  refunds: [_refund('INITIATED'), _refund('PROCESSED')],
                  reimbursements: const [
                    ReimbursementItemView(
                      id: 'r1',
                      state: 'VENDOR_REIMBURSEMENT_PENDING',
                      amountCentavos: 400000,
                      method: 'CASH',
                      message: 'The Vendor recorded a cash reimbursement.',
                      confirmedByReview: false,
                      hasEvidence: true,
                    ),
                  ],
                  noLongerDueCentavos: 25000,
                  decision: const CancellationDecisionSummary(
                    cause: 'VENDOR',
                    decidedBy: 'VENDOR',
                    nrpcRetainedCentavos: 0,
                    refundTotalCentavos: 1026441,
                    cashReimbursementCentavos: 400000,
                  ),
                ),
                onAcknowledge: (item) => acknowledged = item,
              ),
            ),
          ),
        ),
      );

      expect(find.text('Cancelled by the Vendor'), findsOneWidget);
      expect(find.text('Refund initiated — not yet received'), findsOneWidget);
      expect(find.text('Refund processed'), findsOneWidget);
      final initiated = tester.widget<Text>(
        find.text('Refund initiated — not yet received'),
      );
      final processed = tester.widget<Text>(find.text('Refund processed'));
      expect(initiated.style?.color, isNot(processed.style?.color));
      expect(find.text('No longer due'), findsOneWidget);
      await tester.tap(find.text('I received it'));
      expect(acknowledged?.id, 'r1');
    },
  );

  test(
    'the API order detail maps fulfillment, cancellation and refund timeline',
    () async {
      final data =
          jsonDecode(
                File(
                  'test/fixtures/order_detail_without_payment_attempt.json',
                ).readAsStringSync(),
              )
              as Map<String, dynamic>;
      data['lock_version'] = 9;
      data['available_actions'] = ['CONFIRM_RECEIPT', 'REPORT_PROBLEM'];
      data['fulfillment'] = {
        'method': 'PICKUP',
        'state': 'PICKED_UP',
        'expected_date': '2026-10-06',
        'late': false,
        'steps': [
          {
            'key': 'PICKED_UP',
            'label': 'Picked up',
            'status': 'COMPLETE',
            'at': '2026-10-06T01:00:00Z',
            'actor_role': 'STORE_STAFF',
            'proof_required': true,
            'proof': {
              'milestone': 'PICKED_UP',
              'recorded_at': '2026-10-06T01:00:00Z',
              'receiver_name': 'Buyer Name',
              'receiver_kind': 'BUYER',
              'handover_confirmed': true,
              'photo_path': null,
              'signature_path': null,
            },
            'proof_requirements': ['RECEIVER_NAME', 'HANDOVER_CONFIRMATION'],
          },
        ],
        'proof': null,
        'tracking_notice': 'No live GPS tracking.',
        'trips': <Object?>[],
        'accepted_arrangement': null,
        'receipt': {
          'due_at': '2026-10-08T01:00:00Z',
          'paused': false,
          'remaining_seconds': null,
          'confirmed_at': null,
          'confirmation_source': null,
          'window_hours': 48,
        },
        'issue': null,
        'assignment': null,
        'vehicle_issues': <Object?>[],
        'thread': {
          'available': true,
          'conversation_id': 'conversation-1',
          'read_only': false,
          'read_only_reason': null,
          'notice': null,
        },
        'next_action': 'CONFIRM_RECEIPT',
      };
      data['cancellation'] = {
        'mode': 'UNAVAILABLE',
        'available': false,
        'explanation': 'Cancellation is closed after pickup.',
        'requires_reason': false,
        'reason_codes': <Object?>[],
        'nrpc_retainable_centavos': 0,
        'can_withdraw_request': false,
        'response_due_at': null,
        'remedies': [
          {'code': 'REPORT_PROBLEM', 'available': true, 'note': 'Report it.'},
        ],
        'open_request': null,
      };
      data['refund_timeline'] = {
        'refunds': [
          {
            'id': 'refund-1',
            'trigger': 'CANCELLATION',
            'state': 'REFUND_PENDING',
            'display_state': 'INITIATED',
            'amount_centavos': 5000,
            'principal_centavos': 4900,
            'processing_fee_centavos': 100,
            'payment_purpose': 'FULL_ORDER_PAYMENT',
            'original_method': 'GCash',
            'attempt_number': 1,
            'requested_at': '2026-10-06T01:00:00Z',
            'completed_at': null,
            'failure_code': null,
            'evidence_origin': 'SIMULATED',
            'can_retry': false,
            'arrival_note': null,
            'message': 'Sent to the provider.',
          },
        ],
        'reimbursements': <Object?>[],
        'no_longer_due_centavos': 0,
        'decision': null,
      };
      final dio = Dio(BaseOptions(baseUrl: 'https://api.example.test'));
      final repository = ApiOrdersRepository(
        client: api.MateryalphApiClient(
          dio: dio,
          interceptors: [
            InterceptorsWrapper(
              onRequest: (options, handler) => handler.resolve(
                Response<Object?>(
                  requestOptions: options,
                  statusCode: 200,
                  data: {
                    'data': data,
                    'meta': <String, Object?>{},
                    'errors': <Object?>[],
                  },
                ),
              ),
            ),
          ],
        ),
        onSessionExpired: () async {},
      );

      final order = await repository.order('order-1');
      expect(order.lockVersion, 9);
      expect(order.actions, containsAll(['CONFIRM_RECEIPT', 'REPORT_PROBLEM']));
      expect(order.fulfillment!.method, 'PICKUP');
      expect(order.fulfillment!.steps.single.proof!.receiverKind, 'BUYER');
      expect(order.fulfillment!.receipt.windowHours, 48);
      expect(order.fulfillment!.thread.conversationId, 'conversation-1');
      expect(order.cancellation!.mode, 'UNAVAILABLE');
      expect(order.cancellation!.remedies.single.code, 'REPORT_PROBLEM');
      expect(order.refundTimeline!.refunds.single.displayState, 'INITIATED');
    },
  );
}
