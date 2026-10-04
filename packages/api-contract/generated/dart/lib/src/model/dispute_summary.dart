//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/dispute_deadline.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'dispute_summary.g.dart';

/// DisputeSummary
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
@BuiltValue()
abstract class DisputeSummary implements Built<DisputeSummary, DisputeSummaryBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'reference')
  String get reference;

  @BuiltValueField(wireName: r'order_id')
  String get orderId;

  @BuiltValueField(wireName: r'order_reference')
  String get orderReference;

  @BuiltValueField(wireName: r'status')
  DisputeSummaryStatusEnum get status;
  // enum statusEnum {  OPEN_AWAITING_RESPONSE,  MUTUAL_RESOLUTION,  ESCALATED_ADMIN_REVIEW,  AWAITING_CLARIFICATION,  DECIDED,  APPEAL_OPEN,  RESOLVED,  CLOSED_INCONCLUSIVE,  };

  @BuiltValueField(wireName: r'case_kind')
  DisputeSummaryCaseKindEnum get caseKind;
  // enum caseKindEnum {  TRANSACTION,  POST_COMPLETION_RETURN,  };

  @BuiltValueField(wireName: r'issue_type')
  DisputeSummaryIssueTypeEnum get issueType;
  // enum issueTypeEnum {  WRONG_ITEM,  DEFECTIVE,  INCOMPLETE_DELIVERY,  LATE_OR_MISSING,  MISLEADING_LISTING,  PAYMENT,  INVOICE,  OTHER_TRANSACTION,  PHYSICAL_PAYMENT_NOT_RECEIVED,  PICKUP_NO_SHOW,  ABUSIVE_COMMUNICATION,  FALSE_EVIDENCE,  INACCESSIBLE_DELIVERY_SITE,  };

  @BuiltValueField(wireName: r'requested_remedy')
  DisputeSummaryRequestedRemedyEnum get requestedRemedy;
  // enum requestedRemedyEnum {  REPLACEMENT,  FULL_REFUND,  PARTIAL_REFUND,  RETURN_AND_REFUND,  INVOICE_CORRECTION,  PAYMENT_OF_BALANCE,  WARNING_ONLY,  OTHER,  };

  @BuiltValueField(wireName: r'requested_amount_centavos')
  int? get requestedAmountCentavos;

  @BuiltValueField(wireName: r'filed_by_party')
  DisputeSummaryFiledByPartyEnum get filedByParty;
  // enum filedByPartyEnum {  BUYER,  VENDOR,  };

  @BuiltValueField(wireName: r'responsible_party')
  DisputeSummaryResponsiblePartyEnum get responsibleParty;
  // enum responsiblePartyEnum {  BUYER,  VENDOR,  BOTH,  ADMIN,  REQUESTED_PARTY,  NONE,  };

  @BuiltValueField(wireName: r'next_deadline')
  DisputeDeadline? get nextDeadline;

  @BuiltValueField(wireName: r'refund_state')
  String get refundState;

  @BuiltValueField(wireName: r'remedy_state')
  DisputeSummaryRemedyStateEnum get remedyState;
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
  int get decisions;

  @BuiltValueField(wireName: r'filed_at')
  DateTime? get filedAt;

  @BuiltValueField(wireName: r'updated_at')
  DateTime? get updatedAt;

  DisputeSummary._();

  factory DisputeSummary([void updates(DisputeSummaryBuilder b)]) = _$DisputeSummary;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(DisputeSummaryBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<DisputeSummary> get serializer => _$DisputeSummarySerializer();
}

class _$DisputeSummarySerializer implements PrimitiveSerializer<DisputeSummary> {
  @override
  final Iterable<Type> types = const [DisputeSummary, _$DisputeSummary];

  @override
  final String wireName = r'DisputeSummary';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    DisputeSummary object, {
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
      specifiedType: const FullType(DisputeSummaryStatusEnum),
    );
    yield r'case_kind';
    yield serializers.serialize(
      object.caseKind,
      specifiedType: const FullType(DisputeSummaryCaseKindEnum),
    );
    yield r'issue_type';
    yield serializers.serialize(
      object.issueType,
      specifiedType: const FullType(DisputeSummaryIssueTypeEnum),
    );
    yield r'requested_remedy';
    yield serializers.serialize(
      object.requestedRemedy,
      specifiedType: const FullType(DisputeSummaryRequestedRemedyEnum),
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
      specifiedType: const FullType(DisputeSummaryFiledByPartyEnum),
    );
    yield r'responsible_party';
    yield serializers.serialize(
      object.responsibleParty,
      specifiedType: const FullType(DisputeSummaryResponsiblePartyEnum),
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
      specifiedType: const FullType(DisputeSummaryRemedyStateEnum),
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
      specifiedType: const FullType(int),
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
  }

  @override
  Object serialize(
    Serializers serializers,
    DisputeSummary object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required DisputeSummaryBuilder result,
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
            specifiedType: const FullType(DisputeSummaryStatusEnum),
          ) as DisputeSummaryStatusEnum;
          result.status = valueDes;
          break;
        case r'case_kind':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DisputeSummaryCaseKindEnum),
          ) as DisputeSummaryCaseKindEnum;
          result.caseKind = valueDes;
          break;
        case r'issue_type':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DisputeSummaryIssueTypeEnum),
          ) as DisputeSummaryIssueTypeEnum;
          result.issueType = valueDes;
          break;
        case r'requested_remedy':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DisputeSummaryRequestedRemedyEnum),
          ) as DisputeSummaryRequestedRemedyEnum;
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
            specifiedType: const FullType(DisputeSummaryFiledByPartyEnum),
          ) as DisputeSummaryFiledByPartyEnum;
          result.filedByParty = valueDes;
          break;
        case r'responsible_party':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DisputeSummaryResponsiblePartyEnum),
          ) as DisputeSummaryResponsiblePartyEnum;
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
            specifiedType: const FullType(DisputeSummaryRemedyStateEnum),
          ) as DisputeSummaryRemedyStateEnum;
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
            specifiedType: const FullType(int),
          ) as int;
          result.decisions = valueDes;
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
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  DisputeSummary deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = DisputeSummaryBuilder();
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


class DisputeSummaryStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'OPEN_AWAITING_RESPONSE')
  static const DisputeSummaryStatusEnum OPEN_AWAITING_RESPONSE = _$disputeSummaryStatusEnum_OPEN_AWAITING_RESPONSE;
  @BuiltValueEnumConst(wireName: r'MUTUAL_RESOLUTION')
  static const DisputeSummaryStatusEnum MUTUAL_RESOLUTION = _$disputeSummaryStatusEnum_MUTUAL_RESOLUTION;
  @BuiltValueEnumConst(wireName: r'ESCALATED_ADMIN_REVIEW')
  static const DisputeSummaryStatusEnum ESCALATED_ADMIN_REVIEW = _$disputeSummaryStatusEnum_ESCALATED_ADMIN_REVIEW;
  @BuiltValueEnumConst(wireName: r'AWAITING_CLARIFICATION')
  static const DisputeSummaryStatusEnum AWAITING_CLARIFICATION = _$disputeSummaryStatusEnum_AWAITING_CLARIFICATION;
  @BuiltValueEnumConst(wireName: r'DECIDED')
  static const DisputeSummaryStatusEnum DECIDED = _$disputeSummaryStatusEnum_DECIDED;
  @BuiltValueEnumConst(wireName: r'APPEAL_OPEN')
  static const DisputeSummaryStatusEnum APPEAL_OPEN = _$disputeSummaryStatusEnum_APPEAL_OPEN;
  @BuiltValueEnumConst(wireName: r'RESOLVED')
  static const DisputeSummaryStatusEnum RESOLVED = _$disputeSummaryStatusEnum_RESOLVED;
  @BuiltValueEnumConst(wireName: r'CLOSED_INCONCLUSIVE')
  static const DisputeSummaryStatusEnum CLOSED_INCONCLUSIVE = _$disputeSummaryStatusEnum_CLOSED_INCONCLUSIVE;

  static Serializer<DisputeSummaryStatusEnum> get serializer => _$disputeSummaryStatusEnumSerializer;

  const DisputeSummaryStatusEnum._(String name): super(name);

  static BuiltSet<DisputeSummaryStatusEnum> get values => _$disputeSummaryStatusEnumValues;
  static DisputeSummaryStatusEnum valueOf(String name) => _$disputeSummaryStatusEnumValueOf(name);
}

class DisputeSummaryCaseKindEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'TRANSACTION')
  static const DisputeSummaryCaseKindEnum TRANSACTION = _$disputeSummaryCaseKindEnum_TRANSACTION;
  @BuiltValueEnumConst(wireName: r'POST_COMPLETION_RETURN')
  static const DisputeSummaryCaseKindEnum POST_COMPLETION_RETURN = _$disputeSummaryCaseKindEnum_POST_COMPLETION_RETURN;

  static Serializer<DisputeSummaryCaseKindEnum> get serializer => _$disputeSummaryCaseKindEnumSerializer;

  const DisputeSummaryCaseKindEnum._(String name): super(name);

  static BuiltSet<DisputeSummaryCaseKindEnum> get values => _$disputeSummaryCaseKindEnumValues;
  static DisputeSummaryCaseKindEnum valueOf(String name) => _$disputeSummaryCaseKindEnumValueOf(name);
}

class DisputeSummaryIssueTypeEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'WRONG_ITEM')
  static const DisputeSummaryIssueTypeEnum WRONG_ITEM = _$disputeSummaryIssueTypeEnum_WRONG_ITEM;
  @BuiltValueEnumConst(wireName: r'DEFECTIVE')
  static const DisputeSummaryIssueTypeEnum DEFECTIVE = _$disputeSummaryIssueTypeEnum_DEFECTIVE;
  @BuiltValueEnumConst(wireName: r'INCOMPLETE_DELIVERY')
  static const DisputeSummaryIssueTypeEnum INCOMPLETE_DELIVERY = _$disputeSummaryIssueTypeEnum_INCOMPLETE_DELIVERY;
  @BuiltValueEnumConst(wireName: r'LATE_OR_MISSING')
  static const DisputeSummaryIssueTypeEnum LATE_OR_MISSING = _$disputeSummaryIssueTypeEnum_LATE_OR_MISSING;
  @BuiltValueEnumConst(wireName: r'MISLEADING_LISTING')
  static const DisputeSummaryIssueTypeEnum MISLEADING_LISTING = _$disputeSummaryIssueTypeEnum_MISLEADING_LISTING;
  @BuiltValueEnumConst(wireName: r'PAYMENT')
  static const DisputeSummaryIssueTypeEnum PAYMENT = _$disputeSummaryIssueTypeEnum_PAYMENT;
  @BuiltValueEnumConst(wireName: r'INVOICE')
  static const DisputeSummaryIssueTypeEnum INVOICE = _$disputeSummaryIssueTypeEnum_INVOICE;
  @BuiltValueEnumConst(wireName: r'OTHER_TRANSACTION')
  static const DisputeSummaryIssueTypeEnum OTHER_TRANSACTION = _$disputeSummaryIssueTypeEnum_OTHER_TRANSACTION;
  @BuiltValueEnumConst(wireName: r'PHYSICAL_PAYMENT_NOT_RECEIVED')
  static const DisputeSummaryIssueTypeEnum PHYSICAL_PAYMENT_NOT_RECEIVED = _$disputeSummaryIssueTypeEnum_PHYSICAL_PAYMENT_NOT_RECEIVED;
  @BuiltValueEnumConst(wireName: r'PICKUP_NO_SHOW')
  static const DisputeSummaryIssueTypeEnum PICKUP_NO_SHOW = _$disputeSummaryIssueTypeEnum_PICKUP_NO_SHOW;
  @BuiltValueEnumConst(wireName: r'ABUSIVE_COMMUNICATION')
  static const DisputeSummaryIssueTypeEnum ABUSIVE_COMMUNICATION = _$disputeSummaryIssueTypeEnum_ABUSIVE_COMMUNICATION;
  @BuiltValueEnumConst(wireName: r'FALSE_EVIDENCE')
  static const DisputeSummaryIssueTypeEnum FALSE_EVIDENCE = _$disputeSummaryIssueTypeEnum_FALSE_EVIDENCE;
  @BuiltValueEnumConst(wireName: r'INACCESSIBLE_DELIVERY_SITE')
  static const DisputeSummaryIssueTypeEnum INACCESSIBLE_DELIVERY_SITE = _$disputeSummaryIssueTypeEnum_INACCESSIBLE_DELIVERY_SITE;

  static Serializer<DisputeSummaryIssueTypeEnum> get serializer => _$disputeSummaryIssueTypeEnumSerializer;

  const DisputeSummaryIssueTypeEnum._(String name): super(name);

  static BuiltSet<DisputeSummaryIssueTypeEnum> get values => _$disputeSummaryIssueTypeEnumValues;
  static DisputeSummaryIssueTypeEnum valueOf(String name) => _$disputeSummaryIssueTypeEnumValueOf(name);
}

class DisputeSummaryRequestedRemedyEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'REPLACEMENT')
  static const DisputeSummaryRequestedRemedyEnum REPLACEMENT = _$disputeSummaryRequestedRemedyEnum_REPLACEMENT;
  @BuiltValueEnumConst(wireName: r'FULL_REFUND')
  static const DisputeSummaryRequestedRemedyEnum FULL_REFUND = _$disputeSummaryRequestedRemedyEnum_FULL_REFUND;
  @BuiltValueEnumConst(wireName: r'PARTIAL_REFUND')
  static const DisputeSummaryRequestedRemedyEnum PARTIAL_REFUND = _$disputeSummaryRequestedRemedyEnum_PARTIAL_REFUND;
  @BuiltValueEnumConst(wireName: r'RETURN_AND_REFUND')
  static const DisputeSummaryRequestedRemedyEnum RETURN_AND_REFUND = _$disputeSummaryRequestedRemedyEnum_RETURN_AND_REFUND;
  @BuiltValueEnumConst(wireName: r'INVOICE_CORRECTION')
  static const DisputeSummaryRequestedRemedyEnum INVOICE_CORRECTION = _$disputeSummaryRequestedRemedyEnum_INVOICE_CORRECTION;
  @BuiltValueEnumConst(wireName: r'PAYMENT_OF_BALANCE')
  static const DisputeSummaryRequestedRemedyEnum PAYMENT_OF_BALANCE = _$disputeSummaryRequestedRemedyEnum_PAYMENT_OF_BALANCE;
  @BuiltValueEnumConst(wireName: r'WARNING_ONLY')
  static const DisputeSummaryRequestedRemedyEnum WARNING_ONLY = _$disputeSummaryRequestedRemedyEnum_WARNING_ONLY;
  @BuiltValueEnumConst(wireName: r'OTHER')
  static const DisputeSummaryRequestedRemedyEnum OTHER = _$disputeSummaryRequestedRemedyEnum_OTHER;

  static Serializer<DisputeSummaryRequestedRemedyEnum> get serializer => _$disputeSummaryRequestedRemedyEnumSerializer;

  const DisputeSummaryRequestedRemedyEnum._(String name): super(name);

  static BuiltSet<DisputeSummaryRequestedRemedyEnum> get values => _$disputeSummaryRequestedRemedyEnumValues;
  static DisputeSummaryRequestedRemedyEnum valueOf(String name) => _$disputeSummaryRequestedRemedyEnumValueOf(name);
}

class DisputeSummaryFiledByPartyEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'BUYER')
  static const DisputeSummaryFiledByPartyEnum BUYER = _$disputeSummaryFiledByPartyEnum_BUYER;
  @BuiltValueEnumConst(wireName: r'VENDOR')
  static const DisputeSummaryFiledByPartyEnum VENDOR = _$disputeSummaryFiledByPartyEnum_VENDOR;

  static Serializer<DisputeSummaryFiledByPartyEnum> get serializer => _$disputeSummaryFiledByPartyEnumSerializer;

  const DisputeSummaryFiledByPartyEnum._(String name): super(name);

  static BuiltSet<DisputeSummaryFiledByPartyEnum> get values => _$disputeSummaryFiledByPartyEnumValues;
  static DisputeSummaryFiledByPartyEnum valueOf(String name) => _$disputeSummaryFiledByPartyEnumValueOf(name);
}

class DisputeSummaryResponsiblePartyEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'BUYER')
  static const DisputeSummaryResponsiblePartyEnum BUYER = _$disputeSummaryResponsiblePartyEnum_BUYER;
  @BuiltValueEnumConst(wireName: r'VENDOR')
  static const DisputeSummaryResponsiblePartyEnum VENDOR = _$disputeSummaryResponsiblePartyEnum_VENDOR;
  @BuiltValueEnumConst(wireName: r'BOTH')
  static const DisputeSummaryResponsiblePartyEnum BOTH = _$disputeSummaryResponsiblePartyEnum_BOTH;
  @BuiltValueEnumConst(wireName: r'ADMIN')
  static const DisputeSummaryResponsiblePartyEnum ADMIN = _$disputeSummaryResponsiblePartyEnum_ADMIN;
  @BuiltValueEnumConst(wireName: r'REQUESTED_PARTY')
  static const DisputeSummaryResponsiblePartyEnum REQUESTED_PARTY = _$disputeSummaryResponsiblePartyEnum_REQUESTED_PARTY;
  @BuiltValueEnumConst(wireName: r'NONE')
  static const DisputeSummaryResponsiblePartyEnum NONE = _$disputeSummaryResponsiblePartyEnum_NONE;

  static Serializer<DisputeSummaryResponsiblePartyEnum> get serializer => _$disputeSummaryResponsiblePartyEnumSerializer;

  const DisputeSummaryResponsiblePartyEnum._(String name): super(name);

  static BuiltSet<DisputeSummaryResponsiblePartyEnum> get values => _$disputeSummaryResponsiblePartyEnumValues;
  static DisputeSummaryResponsiblePartyEnum valueOf(String name) => _$disputeSummaryResponsiblePartyEnumValueOf(name);
}

class DisputeSummaryRemedyStateEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'NONE')
  static const DisputeSummaryRemedyStateEnum NONE = _$disputeSummaryRemedyStateEnum_NONE;
  @BuiltValueEnumConst(wireName: r'PENDING')
  static const DisputeSummaryRemedyStateEnum PENDING = _$disputeSummaryRemedyStateEnum_PENDING;
  @BuiltValueEnumConst(wireName: r'COMPLETED')
  static const DisputeSummaryRemedyStateEnum COMPLETED = _$disputeSummaryRemedyStateEnum_COMPLETED;
  @BuiltValueEnumConst(wireName: r'FAILED')
  static const DisputeSummaryRemedyStateEnum FAILED = _$disputeSummaryRemedyStateEnum_FAILED;

  static Serializer<DisputeSummaryRemedyStateEnum> get serializer => _$disputeSummaryRemedyStateEnumSerializer;

  const DisputeSummaryRemedyStateEnum._(String name): super(name);

  static BuiltSet<DisputeSummaryRemedyStateEnum> get values => _$disputeSummaryRemedyStateEnumValues;
  static DisputeSummaryRemedyStateEnum valueOf(String name) => _$disputeSummaryRemedyStateEnumValueOf(name);
}

