//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/dispute_clarification.dart';
import 'package:materyalph_api_client/src/model/dispute_proposal.dart';
import 'package:materyalph_api_client/src/model/dispute_order_ref.dart';
import 'package:materyalph_api_client/src/model/dispute_admin_context.dart';
import 'package:materyalph_api_client/src/model/dispute_appeal.dart';
import 'package:materyalph_api_client/src/model/dispute_vendor_permissions.dart';
import 'package:materyalph_api_client/src/model/dispute_deadline.dart';
import 'package:materyalph_api_client/src/model/dispute_decision.dart';
import 'package:materyalph_api_client/src/model/reimbursement_timeline_item.dart';
import 'package:built_collection/built_collection.dart';
import 'package:materyalph_api_client/src/model/dispute_affected_line.dart';
import 'package:materyalph_api_client/src/model/dispute_remedy.dart';
import 'package:materyalph_api_client/src/model/refund_timeline_item.dart';
import 'package:materyalph_api_client/src/model/dispute_handler.dart';
import 'package:materyalph_api_client/src/model/dispute_timeline_entry.dart';
import 'package:materyalph_api_client/src/model/dispute_original_payment_method.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'dispute_detail.g.dart';

/// One case: the chronological timeline, proposals, clarifications, immutable decisions, the one appeal, remedies and the linked Dispute-Conclusion Refunds. Fulfillment Staff receive a limited view.
///
/// Properties:
/// * [id]
/// * [reference]
/// * [orderId]
/// * [orderReference]
/// * [status]
/// * [caseKind]
/// * [issueType]
/// * [requestedRemedy]
/// * [requestedAmountCentavos]
/// * [filedByParty]
/// * [responsibleParty]
/// * [nextDeadline]
/// * [refundState]
/// * [remedyState]
/// * [appealAvailable]
/// * [vendorName]
/// * [buyerName]
/// * [assignedToAdmin]
/// * [decisions]
/// * [filedAt]
/// * [updatedAt]
/// * [description]
/// * [affectedLines]
/// * [originalPaymentMethod]
/// * [preferredContactChannel]
/// * [order]
/// * [deadlines]
/// * [serverTime]
/// * [timezone]
/// * [handler]
/// * [lockVersion]
/// * [timeline]
/// * [proposals]
/// * [clarifications]
/// * [appeal]
/// * [remedies]
/// * [refunds]
/// * [reimbursements]
/// * [availableActions]
/// * [limitedView]
/// * [permissions]
/// * [admin]
@BuiltValue()
abstract class DisputeDetail implements Built<DisputeDetail, DisputeDetailBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'reference')
  String get reference;

  @BuiltValueField(wireName: r'order_id')
  String get orderId;

  @BuiltValueField(wireName: r'order_reference')
  String get orderReference;

  @BuiltValueField(wireName: r'status')
  DisputeDetailStatusEnum get status;
  // enum statusEnum {  OPEN_AWAITING_RESPONSE,  MUTUAL_RESOLUTION,  ESCALATED_ADMIN_REVIEW,  AWAITING_CLARIFICATION,  DECIDED,  APPEAL_OPEN,  RESOLVED,  CLOSED_INCONCLUSIVE,  };

  @BuiltValueField(wireName: r'case_kind')
  DisputeDetailCaseKindEnum get caseKind;
  // enum caseKindEnum {  TRANSACTION,  POST_COMPLETION_RETURN,  };

  @BuiltValueField(wireName: r'issue_type')
  DisputeDetailIssueTypeEnum get issueType;
  // enum issueTypeEnum {  WRONG_ITEM,  DEFECTIVE,  INCOMPLETE_DELIVERY,  LATE_OR_MISSING,  MISLEADING_LISTING,  PAYMENT,  INVOICE,  OTHER_TRANSACTION,  PHYSICAL_PAYMENT_NOT_RECEIVED,  PICKUP_NO_SHOW,  ABUSIVE_COMMUNICATION,  FALSE_EVIDENCE,  INACCESSIBLE_DELIVERY_SITE,  };

  @BuiltValueField(wireName: r'requested_remedy')
  DisputeDetailRequestedRemedyEnum get requestedRemedy;
  // enum requestedRemedyEnum {  REPLACEMENT,  FULL_REFUND,  PARTIAL_REFUND,  RETURN_AND_REFUND,  INVOICE_CORRECTION,  PAYMENT_OF_BALANCE,  WARNING_ONLY,  OTHER,  };

  @BuiltValueField(wireName: r'requested_amount_centavos')
  int? get requestedAmountCentavos;

  @BuiltValueField(wireName: r'filed_by_party')
  DisputeDetailFiledByPartyEnum get filedByParty;
  // enum filedByPartyEnum {  BUYER,  VENDOR,  };

  @BuiltValueField(wireName: r'responsible_party')
  DisputeDetailResponsiblePartyEnum get responsibleParty;
  // enum responsiblePartyEnum {  BUYER,  VENDOR,  BOTH,  ADMIN,  REQUESTED_PARTY,  NONE,  };

  @BuiltValueField(wireName: r'next_deadline')
  DisputeDeadline? get nextDeadline;

  @BuiltValueField(wireName: r'refund_state')
  String get refundState;

  @BuiltValueField(wireName: r'remedy_state')
  DisputeDetailRemedyStateEnum get remedyState;
  // enum remedyStateEnum {  NONE,  PENDING,  COMPLETED,  FAILED,  };

  @BuiltValueField(wireName: r'appeal_available')
  bool get appealAvailable;

  @BuiltValueField(wireName: r'vendor_name')
  String get vendorName;

  @BuiltValueField(wireName: r'buyer_name')
  String? get buyerName;

  @BuiltValueField(wireName: r'assigned_to_admin')
  bool get assignedToAdmin;

  @BuiltValueField(wireName: r'decisions')
  BuiltList<DisputeDecision> get decisions;

  @BuiltValueField(wireName: r'filed_at')
  DateTime? get filedAt;

  @BuiltValueField(wireName: r'updated_at')
  DateTime? get updatedAt;

  @BuiltValueField(wireName: r'description')
  String? get description;

  @BuiltValueField(wireName: r'affected_lines')
  BuiltList<DisputeAffectedLine> get affectedLines;

  @BuiltValueField(wireName: r'original_payment_method')
  DisputeOriginalPaymentMethod? get originalPaymentMethod;

  @BuiltValueField(wireName: r'preferred_contact_channel')
  DisputeDetailPreferredContactChannelEnum? get preferredContactChannel;
  // enum preferredContactChannelEnum {  IN_APP,  EMAIL,  };

  @BuiltValueField(wireName: r'order')
  DisputeOrderRef get order;

  @BuiltValueField(wireName: r'deadlines')
  BuiltList<DisputeDeadline> get deadlines;

  @BuiltValueField(wireName: r'server_time')
  DateTime get serverTime;

  @BuiltValueField(wireName: r'timezone')
  String get timezone;

  @BuiltValueField(wireName: r'handler')
  DisputeHandler get handler;

  @BuiltValueField(wireName: r'lock_version')
  int get lockVersion;

  @BuiltValueField(wireName: r'timeline')
  BuiltList<DisputeTimelineEntry> get timeline;

  @BuiltValueField(wireName: r'proposals')
  BuiltList<DisputeProposal> get proposals;

  @BuiltValueField(wireName: r'clarifications')
  BuiltList<DisputeClarification> get clarifications;

  @BuiltValueField(wireName: r'appeal')
  DisputeAppeal? get appeal;

  @BuiltValueField(wireName: r'remedies')
  BuiltList<DisputeRemedy> get remedies;

  @BuiltValueField(wireName: r'refunds')
  BuiltList<RefundTimelineItem> get refunds;

  @BuiltValueField(wireName: r'reimbursements')
  BuiltList<ReimbursementTimelineItem>? get reimbursements;

  @BuiltValueField(wireName: r'available_actions')
  BuiltList<DisputeDetailAvailableActionsEnum> get availableActions;
  // enum availableActionsEnum {  RESPOND,  PROPOSE,  ANSWER_PROPOSAL,  ESCALATE,  ADD_EVIDENCE,  MESSAGE,  ANSWER_CLARIFICATION,  APPEAL,  RECORD_REPLACEMENT,  CONFIRM_REPLACEMENT,  ADD_FULFILLMENT_EVIDENCE,  ASSIGN_TO_ME,  REQUEST_CLARIFICATION,  DECIDE,  DECIDE_APPEAL,  };

  @BuiltValueField(wireName: r'limited_view')
  bool get limitedView;

  @BuiltValueField(wireName: r'permissions')
  DisputeVendorPermissions? get permissions;

  @BuiltValueField(wireName: r'admin')
  DisputeAdminContext? get admin;

  DisputeDetail._();

  factory DisputeDetail([void updates(DisputeDetailBuilder b)]) = _$DisputeDetail;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(DisputeDetailBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<DisputeDetail> get serializer => _$DisputeDetailSerializer();
}

class _$DisputeDetailSerializer implements PrimitiveSerializer<DisputeDetail> {
  @override
  final Iterable<Type> types = const [DisputeDetail, _$DisputeDetail];

  @override
  final String wireName = r'DisputeDetail';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    DisputeDetail object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'reference';
    yield serializers.serialize(
      object.reference,
      specifiedType: const FullType(String),
    );
    yield r'order_id';
    yield serializers.serialize(
      object.orderId,
      specifiedType: const FullType(String),
    );
    yield r'order_reference';
    yield serializers.serialize(
      object.orderReference,
      specifiedType: const FullType(String),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(DisputeDetailStatusEnum),
    );
    yield r'case_kind';
    yield serializers.serialize(
      object.caseKind,
      specifiedType: const FullType(DisputeDetailCaseKindEnum),
    );
    yield r'issue_type';
    yield serializers.serialize(
      object.issueType,
      specifiedType: const FullType(DisputeDetailIssueTypeEnum),
    );
    yield r'requested_remedy';
    yield serializers.serialize(
      object.requestedRemedy,
      specifiedType: const FullType(DisputeDetailRequestedRemedyEnum),
    );
    if (object.requestedAmountCentavos != null) {
      yield r'requested_amount_centavos';
      yield serializers.serialize(
        object.requestedAmountCentavos,
        specifiedType: const FullType(int),
      );
    }
    yield r'filed_by_party';
    yield serializers.serialize(
      object.filedByParty,
      specifiedType: const FullType(DisputeDetailFiledByPartyEnum),
    );
    yield r'responsible_party';
    yield serializers.serialize(
      object.responsibleParty,
      specifiedType: const FullType(DisputeDetailResponsiblePartyEnum),
    );
    if (object.nextDeadline != null) {
      yield r'next_deadline';
      yield serializers.serialize(
        object.nextDeadline,
        specifiedType: const FullType.nullable(DisputeDeadline),
      );
    }
    yield r'refund_state';
    yield serializers.serialize(
      object.refundState,
      specifiedType: const FullType(String),
    );
    yield r'remedy_state';
    yield serializers.serialize(
      object.remedyState,
      specifiedType: const FullType(DisputeDetailRemedyStateEnum),
    );
    yield r'appeal_available';
    yield serializers.serialize(
      object.appealAvailable,
      specifiedType: const FullType(bool),
    );
    yield r'vendor_name';
    yield serializers.serialize(
      object.vendorName,
      specifiedType: const FullType(String),
    );
    if (object.buyerName != null) {
      yield r'buyer_name';
      yield serializers.serialize(
        object.buyerName,
        specifiedType: const FullType(String),
      );
    }
    yield r'assigned_to_admin';
    yield serializers.serialize(
      object.assignedToAdmin,
      specifiedType: const FullType(bool),
    );
    yield r'decisions';
    yield serializers.serialize(
      object.decisions,
      specifiedType: const FullType(BuiltList, [FullType(DisputeDecision)]),
    );
    if (object.filedAt != null) {
      yield r'filed_at';
      yield serializers.serialize(
        object.filedAt,
        specifiedType: const FullType(DateTime),
      );
    }
    if (object.updatedAt != null) {
      yield r'updated_at';
      yield serializers.serialize(
        object.updatedAt,
        specifiedType: const FullType(DateTime),
      );
    }
    if (object.description != null) {
      yield r'description';
      yield serializers.serialize(
        object.description,
        specifiedType: const FullType(String),
      );
    }
    yield r'affected_lines';
    yield serializers.serialize(
      object.affectedLines,
      specifiedType: const FullType(BuiltList, [FullType(DisputeAffectedLine)]),
    );
    if (object.originalPaymentMethod != null) {
      yield r'original_payment_method';
      yield serializers.serialize(
        object.originalPaymentMethod,
        specifiedType: const FullType.nullable(DisputeOriginalPaymentMethod),
      );
    }
    if (object.preferredContactChannel != null) {
      yield r'preferred_contact_channel';
      yield serializers.serialize(
        object.preferredContactChannel,
        specifiedType: const FullType(DisputeDetailPreferredContactChannelEnum),
      );
    }
    yield r'order';
    yield serializers.serialize(
      object.order,
      specifiedType: const FullType(DisputeOrderRef),
    );
    yield r'deadlines';
    yield serializers.serialize(
      object.deadlines,
      specifiedType: const FullType(BuiltList, [FullType(DisputeDeadline)]),
    );
    yield r'server_time';
    yield serializers.serialize(
      object.serverTime,
      specifiedType: const FullType(DateTime),
    );
    yield r'timezone';
    yield serializers.serialize(
      object.timezone,
      specifiedType: const FullType(String),
    );
    yield r'handler';
    yield serializers.serialize(
      object.handler,
      specifiedType: const FullType(DisputeHandler),
    );
    yield r'lock_version';
    yield serializers.serialize(
      object.lockVersion,
      specifiedType: const FullType(int),
    );
    yield r'timeline';
    yield serializers.serialize(
      object.timeline,
      specifiedType: const FullType(BuiltList, [FullType(DisputeTimelineEntry)]),
    );
    yield r'proposals';
    yield serializers.serialize(
      object.proposals,
      specifiedType: const FullType(BuiltList, [FullType(DisputeProposal)]),
    );
    yield r'clarifications';
    yield serializers.serialize(
      object.clarifications,
      specifiedType: const FullType(BuiltList, [FullType(DisputeClarification)]),
    );
    if (object.appeal != null) {
      yield r'appeal';
      yield serializers.serialize(
        object.appeal,
        specifiedType: const FullType.nullable(DisputeAppeal),
      );
    }
    yield r'remedies';
    yield serializers.serialize(
      object.remedies,
      specifiedType: const FullType(BuiltList, [FullType(DisputeRemedy)]),
    );
    yield r'refunds';
    yield serializers.serialize(
      object.refunds,
      specifiedType: const FullType(BuiltList, [FullType(RefundTimelineItem)]),
    );
    if (object.reimbursements != null) {
      yield r'reimbursements';
      yield serializers.serialize(
        object.reimbursements,
        specifiedType: const FullType(BuiltList, [FullType(ReimbursementTimelineItem)]),
      );
    }
    yield r'available_actions';
    yield serializers.serialize(
      object.availableActions,
      specifiedType: const FullType(BuiltList, [FullType(DisputeDetailAvailableActionsEnum)]),
    );
    yield r'limited_view';
    yield serializers.serialize(
      object.limitedView,
      specifiedType: const FullType(bool),
    );
    if (object.permissions != null) {
      yield r'permissions';
      yield serializers.serialize(
        object.permissions,
        specifiedType: const FullType.nullable(DisputeVendorPermissions),
      );
    }
    if (object.admin != null) {
      yield r'admin';
      yield serializers.serialize(
        object.admin,
        specifiedType: const FullType.nullable(DisputeAdminContext),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    DisputeDetail object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required DisputeDetailBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.id = valueDes;
          break;
        case r'reference':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.reference = valueDes;
          break;
        case r'order_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.orderId = valueDes;
          break;
        case r'order_reference':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.orderReference = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DisputeDetailStatusEnum),
          ) as DisputeDetailStatusEnum;
          result.status = valueDes;
          break;
        case r'case_kind':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DisputeDetailCaseKindEnum),
          ) as DisputeDetailCaseKindEnum;
          result.caseKind = valueDes;
          break;
        case r'issue_type':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DisputeDetailIssueTypeEnum),
          ) as DisputeDetailIssueTypeEnum;
          result.issueType = valueDes;
          break;
        case r'requested_remedy':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DisputeDetailRequestedRemedyEnum),
          ) as DisputeDetailRequestedRemedyEnum;
          result.requestedRemedy = valueDes;
          break;
        case r'requested_amount_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.requestedAmountCentavos = valueDes;
          break;
        case r'filed_by_party':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DisputeDetailFiledByPartyEnum),
          ) as DisputeDetailFiledByPartyEnum;
          result.filedByParty = valueDes;
          break;
        case r'responsible_party':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DisputeDetailResponsiblePartyEnum),
          ) as DisputeDetailResponsiblePartyEnum;
          result.responsibleParty = valueDes;
          break;
        case r'next_deadline':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DisputeDeadline),
          ) as DisputeDeadline?;
          if (valueDes == null) continue;
          result.nextDeadline.replace(valueDes);
          break;
        case r'refund_state':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.refundState = valueDes;
          break;
        case r'remedy_state':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DisputeDetailRemedyStateEnum),
          ) as DisputeDetailRemedyStateEnum;
          result.remedyState = valueDes;
          break;
        case r'appeal_available':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.appealAvailable = valueDes;
          break;
        case r'vendor_name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.vendorName = valueDes;
          break;
        case r'buyer_name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.buyerName = valueDes;
          break;
        case r'assigned_to_admin':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.assignedToAdmin = valueDes;
          break;
        case r'decisions':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(DisputeDecision)]),
          ) as BuiltList<DisputeDecision>;
          result.decisions.replace(valueDes);
          break;
        case r'filed_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.filedAt = valueDes;
          break;
        case r'updated_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.updatedAt = valueDes;
          break;
        case r'description':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.description = valueDes;
          break;
        case r'affected_lines':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(DisputeAffectedLine)]),
          ) as BuiltList<DisputeAffectedLine>;
          result.affectedLines.replace(valueDes);
          break;
        case r'original_payment_method':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DisputeOriginalPaymentMethod),
          ) as DisputeOriginalPaymentMethod?;
          if (valueDes == null) continue;
          result.originalPaymentMethod.replace(valueDes);
          break;
        case r'preferred_contact_channel':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DisputeDetailPreferredContactChannelEnum),
          ) as DisputeDetailPreferredContactChannelEnum?;
          if (valueDes == null) continue;
          result.preferredContactChannel = valueDes;
          break;
        case r'order':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DisputeOrderRef),
          ) as DisputeOrderRef;
          result.order.replace(valueDes);
          break;
        case r'deadlines':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(DisputeDeadline)]),
          ) as BuiltList<DisputeDeadline>;
          result.deadlines.replace(valueDes);
          break;
        case r'server_time':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.serverTime = valueDes;
          break;
        case r'timezone':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.timezone = valueDes;
          break;
        case r'handler':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DisputeHandler),
          ) as DisputeHandler;
          result.handler.replace(valueDes);
          break;
        case r'lock_version':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.lockVersion = valueDes;
          break;
        case r'timeline':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(DisputeTimelineEntry)]),
          ) as BuiltList<DisputeTimelineEntry>;
          result.timeline.replace(valueDes);
          break;
        case r'proposals':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(DisputeProposal)]),
          ) as BuiltList<DisputeProposal>;
          result.proposals.replace(valueDes);
          break;
        case r'clarifications':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(DisputeClarification)]),
          ) as BuiltList<DisputeClarification>;
          result.clarifications.replace(valueDes);
          break;
        case r'appeal':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DisputeAppeal),
          ) as DisputeAppeal?;
          if (valueDes == null) continue;
          result.appeal.replace(valueDes);
          break;
        case r'remedies':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(DisputeRemedy)]),
          ) as BuiltList<DisputeRemedy>;
          result.remedies.replace(valueDes);
          break;
        case r'refunds':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(RefundTimelineItem)]),
          ) as BuiltList<RefundTimelineItem>;
          result.refunds.replace(valueDes);
          break;
        case r'reimbursements':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BuiltList, [FullType(ReimbursementTimelineItem)]),
          ) as BuiltList<ReimbursementTimelineItem>?;
          if (valueDes == null) continue;
          result.reimbursements.replace(valueDes);
          break;
        case r'available_actions':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(DisputeDetailAvailableActionsEnum)]),
          ) as BuiltList<DisputeDetailAvailableActionsEnum>;
          result.availableActions.replace(valueDes);
          break;
        case r'limited_view':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.limitedView = valueDes;
          break;
        case r'permissions':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DisputeVendorPermissions),
          ) as DisputeVendorPermissions?;
          if (valueDes == null) continue;
          result.permissions.replace(valueDes);
          break;
        case r'admin':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DisputeAdminContext),
          ) as DisputeAdminContext?;
          if (valueDes == null) continue;
          result.admin.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  DisputeDetail deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = DisputeDetailBuilder();
    final serializedList = (serialized as Iterable<Object?>).toList();
    final unhandled = <Object?>[];
    _deserializeProperties(
      serializers,
      serialized,
      specifiedType: specifiedType,
      serializedList: serializedList,
      unhandled: unhandled,
      result: result,
    );
    return result.build();
  }
}


class DisputeDetailStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'OPEN_AWAITING_RESPONSE')
  static const DisputeDetailStatusEnum OPEN_AWAITING_RESPONSE = _$disputeDetailStatusEnum_OPEN_AWAITING_RESPONSE;
  @BuiltValueEnumConst(wireName: r'MUTUAL_RESOLUTION')
  static const DisputeDetailStatusEnum MUTUAL_RESOLUTION = _$disputeDetailStatusEnum_MUTUAL_RESOLUTION;
  @BuiltValueEnumConst(wireName: r'ESCALATED_ADMIN_REVIEW')
  static const DisputeDetailStatusEnum ESCALATED_ADMIN_REVIEW = _$disputeDetailStatusEnum_ESCALATED_ADMIN_REVIEW;
  @BuiltValueEnumConst(wireName: r'AWAITING_CLARIFICATION')
  static const DisputeDetailStatusEnum AWAITING_CLARIFICATION = _$disputeDetailStatusEnum_AWAITING_CLARIFICATION;
  @BuiltValueEnumConst(wireName: r'DECIDED')
  static const DisputeDetailStatusEnum DECIDED = _$disputeDetailStatusEnum_DECIDED;
  @BuiltValueEnumConst(wireName: r'APPEAL_OPEN')
  static const DisputeDetailStatusEnum APPEAL_OPEN = _$disputeDetailStatusEnum_APPEAL_OPEN;
  @BuiltValueEnumConst(wireName: r'RESOLVED')
  static const DisputeDetailStatusEnum RESOLVED = _$disputeDetailStatusEnum_RESOLVED;
  @BuiltValueEnumConst(wireName: r'CLOSED_INCONCLUSIVE')
  static const DisputeDetailStatusEnum CLOSED_INCONCLUSIVE = _$disputeDetailStatusEnum_CLOSED_INCONCLUSIVE;

  static Serializer<DisputeDetailStatusEnum> get serializer => _$disputeDetailStatusEnumSerializer;

  const DisputeDetailStatusEnum._(String name): super(name);

  static BuiltSet<DisputeDetailStatusEnum> get values => _$disputeDetailStatusEnumValues;
  static DisputeDetailStatusEnum valueOf(String name) => _$disputeDetailStatusEnumValueOf(name);
}

class DisputeDetailCaseKindEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'TRANSACTION')
  static const DisputeDetailCaseKindEnum TRANSACTION = _$disputeDetailCaseKindEnum_TRANSACTION;
  @BuiltValueEnumConst(wireName: r'POST_COMPLETION_RETURN')
  static const DisputeDetailCaseKindEnum POST_COMPLETION_RETURN = _$disputeDetailCaseKindEnum_POST_COMPLETION_RETURN;

  static Serializer<DisputeDetailCaseKindEnum> get serializer => _$disputeDetailCaseKindEnumSerializer;

  const DisputeDetailCaseKindEnum._(String name): super(name);

  static BuiltSet<DisputeDetailCaseKindEnum> get values => _$disputeDetailCaseKindEnumValues;
  static DisputeDetailCaseKindEnum valueOf(String name) => _$disputeDetailCaseKindEnumValueOf(name);
}

class DisputeDetailIssueTypeEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'WRONG_ITEM')
  static const DisputeDetailIssueTypeEnum WRONG_ITEM = _$disputeDetailIssueTypeEnum_WRONG_ITEM;
  @BuiltValueEnumConst(wireName: r'DEFECTIVE')
  static const DisputeDetailIssueTypeEnum DEFECTIVE = _$disputeDetailIssueTypeEnum_DEFECTIVE;
  @BuiltValueEnumConst(wireName: r'INCOMPLETE_DELIVERY')
  static const DisputeDetailIssueTypeEnum INCOMPLETE_DELIVERY = _$disputeDetailIssueTypeEnum_INCOMPLETE_DELIVERY;
  @BuiltValueEnumConst(wireName: r'LATE_OR_MISSING')
  static const DisputeDetailIssueTypeEnum LATE_OR_MISSING = _$disputeDetailIssueTypeEnum_LATE_OR_MISSING;
  @BuiltValueEnumConst(wireName: r'MISLEADING_LISTING')
  static const DisputeDetailIssueTypeEnum MISLEADING_LISTING = _$disputeDetailIssueTypeEnum_MISLEADING_LISTING;
  @BuiltValueEnumConst(wireName: r'PAYMENT')
  static const DisputeDetailIssueTypeEnum PAYMENT = _$disputeDetailIssueTypeEnum_PAYMENT;
  @BuiltValueEnumConst(wireName: r'INVOICE')
  static const DisputeDetailIssueTypeEnum INVOICE = _$disputeDetailIssueTypeEnum_INVOICE;
  @BuiltValueEnumConst(wireName: r'OTHER_TRANSACTION')
  static const DisputeDetailIssueTypeEnum OTHER_TRANSACTION = _$disputeDetailIssueTypeEnum_OTHER_TRANSACTION;
  @BuiltValueEnumConst(wireName: r'PHYSICAL_PAYMENT_NOT_RECEIVED')
  static const DisputeDetailIssueTypeEnum PHYSICAL_PAYMENT_NOT_RECEIVED = _$disputeDetailIssueTypeEnum_PHYSICAL_PAYMENT_NOT_RECEIVED;
  @BuiltValueEnumConst(wireName: r'PICKUP_NO_SHOW')
  static const DisputeDetailIssueTypeEnum PICKUP_NO_SHOW = _$disputeDetailIssueTypeEnum_PICKUP_NO_SHOW;
  @BuiltValueEnumConst(wireName: r'ABUSIVE_COMMUNICATION')
  static const DisputeDetailIssueTypeEnum ABUSIVE_COMMUNICATION = _$disputeDetailIssueTypeEnum_ABUSIVE_COMMUNICATION;
  @BuiltValueEnumConst(wireName: r'FALSE_EVIDENCE')
  static const DisputeDetailIssueTypeEnum FALSE_EVIDENCE = _$disputeDetailIssueTypeEnum_FALSE_EVIDENCE;
  @BuiltValueEnumConst(wireName: r'INACCESSIBLE_DELIVERY_SITE')
  static const DisputeDetailIssueTypeEnum INACCESSIBLE_DELIVERY_SITE = _$disputeDetailIssueTypeEnum_INACCESSIBLE_DELIVERY_SITE;

  static Serializer<DisputeDetailIssueTypeEnum> get serializer => _$disputeDetailIssueTypeEnumSerializer;

  const DisputeDetailIssueTypeEnum._(String name): super(name);

  static BuiltSet<DisputeDetailIssueTypeEnum> get values => _$disputeDetailIssueTypeEnumValues;
  static DisputeDetailIssueTypeEnum valueOf(String name) => _$disputeDetailIssueTypeEnumValueOf(name);
}

class DisputeDetailRequestedRemedyEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'REPLACEMENT')
  static const DisputeDetailRequestedRemedyEnum REPLACEMENT = _$disputeDetailRequestedRemedyEnum_REPLACEMENT;
  @BuiltValueEnumConst(wireName: r'FULL_REFUND')
  static const DisputeDetailRequestedRemedyEnum FULL_REFUND = _$disputeDetailRequestedRemedyEnum_FULL_REFUND;
  @BuiltValueEnumConst(wireName: r'PARTIAL_REFUND')
  static const DisputeDetailRequestedRemedyEnum PARTIAL_REFUND = _$disputeDetailRequestedRemedyEnum_PARTIAL_REFUND;
  @BuiltValueEnumConst(wireName: r'RETURN_AND_REFUND')
  static const DisputeDetailRequestedRemedyEnum RETURN_AND_REFUND = _$disputeDetailRequestedRemedyEnum_RETURN_AND_REFUND;
  @BuiltValueEnumConst(wireName: r'INVOICE_CORRECTION')
  static const DisputeDetailRequestedRemedyEnum INVOICE_CORRECTION = _$disputeDetailRequestedRemedyEnum_INVOICE_CORRECTION;
  @BuiltValueEnumConst(wireName: r'PAYMENT_OF_BALANCE')
  static const DisputeDetailRequestedRemedyEnum PAYMENT_OF_BALANCE = _$disputeDetailRequestedRemedyEnum_PAYMENT_OF_BALANCE;
  @BuiltValueEnumConst(wireName: r'WARNING_ONLY')
  static const DisputeDetailRequestedRemedyEnum WARNING_ONLY = _$disputeDetailRequestedRemedyEnum_WARNING_ONLY;
  @BuiltValueEnumConst(wireName: r'OTHER')
  static const DisputeDetailRequestedRemedyEnum OTHER = _$disputeDetailRequestedRemedyEnum_OTHER;

  static Serializer<DisputeDetailRequestedRemedyEnum> get serializer => _$disputeDetailRequestedRemedyEnumSerializer;

  const DisputeDetailRequestedRemedyEnum._(String name): super(name);

  static BuiltSet<DisputeDetailRequestedRemedyEnum> get values => _$disputeDetailRequestedRemedyEnumValues;
  static DisputeDetailRequestedRemedyEnum valueOf(String name) => _$disputeDetailRequestedRemedyEnumValueOf(name);
}

class DisputeDetailFiledByPartyEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'BUYER')
  static const DisputeDetailFiledByPartyEnum BUYER = _$disputeDetailFiledByPartyEnum_BUYER;
  @BuiltValueEnumConst(wireName: r'VENDOR')
  static const DisputeDetailFiledByPartyEnum VENDOR = _$disputeDetailFiledByPartyEnum_VENDOR;

  static Serializer<DisputeDetailFiledByPartyEnum> get serializer => _$disputeDetailFiledByPartyEnumSerializer;

  const DisputeDetailFiledByPartyEnum._(String name): super(name);

  static BuiltSet<DisputeDetailFiledByPartyEnum> get values => _$disputeDetailFiledByPartyEnumValues;
  static DisputeDetailFiledByPartyEnum valueOf(String name) => _$disputeDetailFiledByPartyEnumValueOf(name);
}

class DisputeDetailResponsiblePartyEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'BUYER')
  static const DisputeDetailResponsiblePartyEnum BUYER = _$disputeDetailResponsiblePartyEnum_BUYER;
  @BuiltValueEnumConst(wireName: r'VENDOR')
  static const DisputeDetailResponsiblePartyEnum VENDOR = _$disputeDetailResponsiblePartyEnum_VENDOR;
  @BuiltValueEnumConst(wireName: r'BOTH')
  static const DisputeDetailResponsiblePartyEnum BOTH = _$disputeDetailResponsiblePartyEnum_BOTH;
  @BuiltValueEnumConst(wireName: r'ADMIN')
  static const DisputeDetailResponsiblePartyEnum ADMIN = _$disputeDetailResponsiblePartyEnum_ADMIN;
  @BuiltValueEnumConst(wireName: r'REQUESTED_PARTY')
  static const DisputeDetailResponsiblePartyEnum REQUESTED_PARTY = _$disputeDetailResponsiblePartyEnum_REQUESTED_PARTY;
  @BuiltValueEnumConst(wireName: r'NONE')
  static const DisputeDetailResponsiblePartyEnum NONE = _$disputeDetailResponsiblePartyEnum_NONE;

  static Serializer<DisputeDetailResponsiblePartyEnum> get serializer => _$disputeDetailResponsiblePartyEnumSerializer;

  const DisputeDetailResponsiblePartyEnum._(String name): super(name);

  static BuiltSet<DisputeDetailResponsiblePartyEnum> get values => _$disputeDetailResponsiblePartyEnumValues;
  static DisputeDetailResponsiblePartyEnum valueOf(String name) => _$disputeDetailResponsiblePartyEnumValueOf(name);
}

class DisputeDetailRemedyStateEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'NONE')
  static const DisputeDetailRemedyStateEnum NONE = _$disputeDetailRemedyStateEnum_NONE;
  @BuiltValueEnumConst(wireName: r'PENDING')
  static const DisputeDetailRemedyStateEnum PENDING = _$disputeDetailRemedyStateEnum_PENDING;
  @BuiltValueEnumConst(wireName: r'COMPLETED')
  static const DisputeDetailRemedyStateEnum COMPLETED = _$disputeDetailRemedyStateEnum_COMPLETED;
  @BuiltValueEnumConst(wireName: r'FAILED')
  static const DisputeDetailRemedyStateEnum FAILED = _$disputeDetailRemedyStateEnum_FAILED;

  static Serializer<DisputeDetailRemedyStateEnum> get serializer => _$disputeDetailRemedyStateEnumSerializer;

  const DisputeDetailRemedyStateEnum._(String name): super(name);

  static BuiltSet<DisputeDetailRemedyStateEnum> get values => _$disputeDetailRemedyStateEnumValues;
  static DisputeDetailRemedyStateEnum valueOf(String name) => _$disputeDetailRemedyStateEnumValueOf(name);
}

class DisputeDetailPreferredContactChannelEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'IN_APP')
  static const DisputeDetailPreferredContactChannelEnum IN_APP = _$disputeDetailPreferredContactChannelEnum_IN_APP;
  @BuiltValueEnumConst(wireName: r'EMAIL')
  static const DisputeDetailPreferredContactChannelEnum EMAIL = _$disputeDetailPreferredContactChannelEnum_EMAIL;

  static Serializer<DisputeDetailPreferredContactChannelEnum> get serializer => _$disputeDetailPreferredContactChannelEnumSerializer;

  const DisputeDetailPreferredContactChannelEnum._(String name): super(name);

  static BuiltSet<DisputeDetailPreferredContactChannelEnum> get values => _$disputeDetailPreferredContactChannelEnumValues;
  static DisputeDetailPreferredContactChannelEnum valueOf(String name) => _$disputeDetailPreferredContactChannelEnumValueOf(name);
}

class DisputeDetailAvailableActionsEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'RESPOND')
  static const DisputeDetailAvailableActionsEnum RESPOND = _$disputeDetailAvailableActionsEnum_RESPOND;
  @BuiltValueEnumConst(wireName: r'PROPOSE')
  static const DisputeDetailAvailableActionsEnum PROPOSE = _$disputeDetailAvailableActionsEnum_PROPOSE;
  @BuiltValueEnumConst(wireName: r'ANSWER_PROPOSAL')
  static const DisputeDetailAvailableActionsEnum ANSWER_PROPOSAL = _$disputeDetailAvailableActionsEnum_ANSWER_PROPOSAL;
  @BuiltValueEnumConst(wireName: r'ESCALATE')
  static const DisputeDetailAvailableActionsEnum ESCALATE = _$disputeDetailAvailableActionsEnum_ESCALATE;
  @BuiltValueEnumConst(wireName: r'ADD_EVIDENCE')
  static const DisputeDetailAvailableActionsEnum ADD_EVIDENCE = _$disputeDetailAvailableActionsEnum_ADD_EVIDENCE;
  @BuiltValueEnumConst(wireName: r'MESSAGE')
  static const DisputeDetailAvailableActionsEnum MESSAGE = _$disputeDetailAvailableActionsEnum_MESSAGE;
  @BuiltValueEnumConst(wireName: r'ANSWER_CLARIFICATION')
  static const DisputeDetailAvailableActionsEnum ANSWER_CLARIFICATION = _$disputeDetailAvailableActionsEnum_ANSWER_CLARIFICATION;
  @BuiltValueEnumConst(wireName: r'APPEAL')
  static const DisputeDetailAvailableActionsEnum APPEAL = _$disputeDetailAvailableActionsEnum_APPEAL;
  @BuiltValueEnumConst(wireName: r'RECORD_REPLACEMENT')
  static const DisputeDetailAvailableActionsEnum RECORD_REPLACEMENT = _$disputeDetailAvailableActionsEnum_RECORD_REPLACEMENT;
  @BuiltValueEnumConst(wireName: r'CONFIRM_REPLACEMENT')
  static const DisputeDetailAvailableActionsEnum CONFIRM_REPLACEMENT = _$disputeDetailAvailableActionsEnum_CONFIRM_REPLACEMENT;
  @BuiltValueEnumConst(wireName: r'ADD_FULFILLMENT_EVIDENCE')
  static const DisputeDetailAvailableActionsEnum ADD_FULFILLMENT_EVIDENCE = _$disputeDetailAvailableActionsEnum_ADD_FULFILLMENT_EVIDENCE;
  @BuiltValueEnumConst(wireName: r'ASSIGN_TO_ME')
  static const DisputeDetailAvailableActionsEnum ASSIGN_TO_ME = _$disputeDetailAvailableActionsEnum_ASSIGN_TO_ME;
  @BuiltValueEnumConst(wireName: r'REQUEST_CLARIFICATION')
  static const DisputeDetailAvailableActionsEnum REQUEST_CLARIFICATION = _$disputeDetailAvailableActionsEnum_REQUEST_CLARIFICATION;
  @BuiltValueEnumConst(wireName: r'DECIDE')
  static const DisputeDetailAvailableActionsEnum DECIDE = _$disputeDetailAvailableActionsEnum_DECIDE;
  @BuiltValueEnumConst(wireName: r'DECIDE_APPEAL')
  static const DisputeDetailAvailableActionsEnum DECIDE_APPEAL = _$disputeDetailAvailableActionsEnum_DECIDE_APPEAL;

  static Serializer<DisputeDetailAvailableActionsEnum> get serializer => _$disputeDetailAvailableActionsEnumSerializer;

  const DisputeDetailAvailableActionsEnum._(String name): super(name);

  static BuiltSet<DisputeDetailAvailableActionsEnum> get values => _$disputeDetailAvailableActionsEnumValues;
  static DisputeDetailAvailableActionsEnum valueOf(String name) => _$disputeDetailAvailableActionsEnumValueOf(name);
}

