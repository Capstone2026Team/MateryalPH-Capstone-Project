//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:materyalph_api_client/src/model/dispute_affected_line.dart';
import 'package:materyalph_api_client/src/model/dispute_eligibility_method.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'dispute_eligibility.g.dart';

/// Filing creates a Case ID and dispute state only, never a refund.
///
/// Properties:
/// * [available]
/// * [reason]
/// * [activeCaseId]
/// * [caseKind]
/// * [postCompletionDeadline]
/// * [issueTypes]
/// * [requestedRemedies]
/// * [lines]
/// * [originalPaymentMethod]
/// * [refundDestinationNotice]
/// * [filingCreatesRefund]
@BuiltValue()
abstract class DisputeEligibility implements Built<DisputeEligibility, DisputeEligibilityBuilder> {
  @BuiltValueField(wireName: r'available')
  bool get available;

  @BuiltValueField(wireName: r'reason')
  String get reason;

  @BuiltValueField(wireName: r'active_case_id')
  String? get activeCaseId;

  @BuiltValueField(wireName: r'case_kind')
  DisputeEligibilityCaseKindEnum get caseKind;
  // enum caseKindEnum {  TRANSACTION,  POST_COMPLETION_RETURN,  };

  @BuiltValueField(wireName: r'post_completion_deadline')
  DateTime? get postCompletionDeadline;

  @BuiltValueField(wireName: r'issue_types')
  BuiltList<DisputeEligibilityIssueTypesEnum> get issueTypes;
  // enum issueTypesEnum {  WRONG_ITEM,  DEFECTIVE,  INCOMPLETE_DELIVERY,  LATE_OR_MISSING,  MISLEADING_LISTING,  PAYMENT,  INVOICE,  OTHER_TRANSACTION,  PHYSICAL_PAYMENT_NOT_RECEIVED,  PICKUP_NO_SHOW,  ABUSIVE_COMMUNICATION,  FALSE_EVIDENCE,  INACCESSIBLE_DELIVERY_SITE,  };

  @BuiltValueField(wireName: r'requested_remedies')
  BuiltList<DisputeEligibilityRequestedRemediesEnum> get requestedRemedies;
  // enum requestedRemediesEnum {  REPLACEMENT,  FULL_REFUND,  PARTIAL_REFUND,  RETURN_AND_REFUND,  INVOICE_CORRECTION,  PAYMENT_OF_BALANCE,  WARNING_ONLY,  OTHER,  };

  @BuiltValueField(wireName: r'lines')
  BuiltList<DisputeAffectedLine> get lines;

  @BuiltValueField(wireName: r'original_payment_method')
  DisputeEligibilityMethod get originalPaymentMethod;

  @BuiltValueField(wireName: r'refund_destination_notice')
  String get refundDestinationNotice;

  @BuiltValueField(wireName: r'filing_creates_refund')
  bool get filingCreatesRefund;

  DisputeEligibility._();

  factory DisputeEligibility([void updates(DisputeEligibilityBuilder b)]) = _$DisputeEligibility;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(DisputeEligibilityBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<DisputeEligibility> get serializer => _$DisputeEligibilitySerializer();
}

class _$DisputeEligibilitySerializer implements PrimitiveSerializer<DisputeEligibility> {
  @override
  final Iterable<Type> types = const [DisputeEligibility, _$DisputeEligibility];

  @override
  final String wireName = r'DisputeEligibility';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    DisputeEligibility object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'available';
    yield serializers.serialize(
      object.available,
      specifiedType: const FullType(bool),
    );
    yield r'reason';
    yield serializers.serialize(
      object.reason,
      specifiedType: const FullType(String),
    );
    if (object.activeCaseId != null) {
      yield r'active_case_id';
      yield serializers.serialize(
        object.activeCaseId,
        specifiedType: const FullType(String),
      );
    }
    yield r'case_kind';
    yield serializers.serialize(
      object.caseKind,
      specifiedType: const FullType(DisputeEligibilityCaseKindEnum),
    );
    if (object.postCompletionDeadline != null) {
      yield r'post_completion_deadline';
      yield serializers.serialize(
        object.postCompletionDeadline,
        specifiedType: const FullType(DateTime),
      );
    }
    yield r'issue_types';
    yield serializers.serialize(
      object.issueTypes,
      specifiedType: const FullType(BuiltList, [FullType(DisputeEligibilityIssueTypesEnum)]),
    );
    yield r'requested_remedies';
    yield serializers.serialize(
      object.requestedRemedies,
      specifiedType: const FullType(BuiltList, [FullType(DisputeEligibilityRequestedRemediesEnum)]),
    );
    yield r'lines';
    yield serializers.serialize(
      object.lines,
      specifiedType: const FullType(BuiltList, [FullType(DisputeAffectedLine)]),
    );
    yield r'original_payment_method';
    yield serializers.serialize(
      object.originalPaymentMethod,
      specifiedType: const FullType(DisputeEligibilityMethod),
    );
    yield r'refund_destination_notice';
    yield serializers.serialize(
      object.refundDestinationNotice,
      specifiedType: const FullType(String),
    );
    yield r'filing_creates_refund';
    yield serializers.serialize(
      object.filingCreatesRefund,
      specifiedType: const FullType(bool),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    DisputeEligibility object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required DisputeEligibilityBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'available':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.available = valueDes;
          break;
        case r'reason':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.reason = valueDes;
          break;
        case r'active_case_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.activeCaseId = valueDes;
          break;
        case r'case_kind':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DisputeEligibilityCaseKindEnum),
          ) as DisputeEligibilityCaseKindEnum;
          result.caseKind = valueDes;
          break;
        case r'post_completion_deadline':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.postCompletionDeadline = valueDes;
          break;
        case r'issue_types':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(DisputeEligibilityIssueTypesEnum)]),
          ) as BuiltList<DisputeEligibilityIssueTypesEnum>;
          result.issueTypes.replace(valueDes);
          break;
        case r'requested_remedies':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(DisputeEligibilityRequestedRemediesEnum)]),
          ) as BuiltList<DisputeEligibilityRequestedRemediesEnum>;
          result.requestedRemedies.replace(valueDes);
          break;
        case r'lines':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(DisputeAffectedLine)]),
          ) as BuiltList<DisputeAffectedLine>;
          result.lines.replace(valueDes);
          break;
        case r'original_payment_method':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DisputeEligibilityMethod),
          ) as DisputeEligibilityMethod;
          result.originalPaymentMethod.replace(valueDes);
          break;
        case r'refund_destination_notice':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.refundDestinationNotice = valueDes;
          break;
        case r'filing_creates_refund':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.filingCreatesRefund = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  DisputeEligibility deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = DisputeEligibilityBuilder();
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


class DisputeEligibilityCaseKindEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'TRANSACTION')
  static const DisputeEligibilityCaseKindEnum TRANSACTION = _$disputeEligibilityCaseKindEnum_TRANSACTION;
  @BuiltValueEnumConst(wireName: r'POST_COMPLETION_RETURN')
  static const DisputeEligibilityCaseKindEnum POST_COMPLETION_RETURN = _$disputeEligibilityCaseKindEnum_POST_COMPLETION_RETURN;

  static Serializer<DisputeEligibilityCaseKindEnum> get serializer => _$disputeEligibilityCaseKindEnumSerializer;

  const DisputeEligibilityCaseKindEnum._(String name): super(name);

  static BuiltSet<DisputeEligibilityCaseKindEnum> get values => _$disputeEligibilityCaseKindEnumValues;
  static DisputeEligibilityCaseKindEnum valueOf(String name) => _$disputeEligibilityCaseKindEnumValueOf(name);
}

class DisputeEligibilityIssueTypesEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'WRONG_ITEM')
  static const DisputeEligibilityIssueTypesEnum WRONG_ITEM = _$disputeEligibilityIssueTypesEnum_WRONG_ITEM;
  @BuiltValueEnumConst(wireName: r'DEFECTIVE')
  static const DisputeEligibilityIssueTypesEnum DEFECTIVE = _$disputeEligibilityIssueTypesEnum_DEFECTIVE;
  @BuiltValueEnumConst(wireName: r'INCOMPLETE_DELIVERY')
  static const DisputeEligibilityIssueTypesEnum INCOMPLETE_DELIVERY = _$disputeEligibilityIssueTypesEnum_INCOMPLETE_DELIVERY;
  @BuiltValueEnumConst(wireName: r'LATE_OR_MISSING')
  static const DisputeEligibilityIssueTypesEnum LATE_OR_MISSING = _$disputeEligibilityIssueTypesEnum_LATE_OR_MISSING;
  @BuiltValueEnumConst(wireName: r'MISLEADING_LISTING')
  static const DisputeEligibilityIssueTypesEnum MISLEADING_LISTING = _$disputeEligibilityIssueTypesEnum_MISLEADING_LISTING;
  @BuiltValueEnumConst(wireName: r'PAYMENT')
  static const DisputeEligibilityIssueTypesEnum PAYMENT = _$disputeEligibilityIssueTypesEnum_PAYMENT;
  @BuiltValueEnumConst(wireName: r'INVOICE')
  static const DisputeEligibilityIssueTypesEnum INVOICE = _$disputeEligibilityIssueTypesEnum_INVOICE;
  @BuiltValueEnumConst(wireName: r'OTHER_TRANSACTION')
  static const DisputeEligibilityIssueTypesEnum OTHER_TRANSACTION = _$disputeEligibilityIssueTypesEnum_OTHER_TRANSACTION;
  @BuiltValueEnumConst(wireName: r'PHYSICAL_PAYMENT_NOT_RECEIVED')
  static const DisputeEligibilityIssueTypesEnum PHYSICAL_PAYMENT_NOT_RECEIVED = _$disputeEligibilityIssueTypesEnum_PHYSICAL_PAYMENT_NOT_RECEIVED;
  @BuiltValueEnumConst(wireName: r'PICKUP_NO_SHOW')
  static const DisputeEligibilityIssueTypesEnum PICKUP_NO_SHOW = _$disputeEligibilityIssueTypesEnum_PICKUP_NO_SHOW;
  @BuiltValueEnumConst(wireName: r'ABUSIVE_COMMUNICATION')
  static const DisputeEligibilityIssueTypesEnum ABUSIVE_COMMUNICATION = _$disputeEligibilityIssueTypesEnum_ABUSIVE_COMMUNICATION;
  @BuiltValueEnumConst(wireName: r'FALSE_EVIDENCE')
  static const DisputeEligibilityIssueTypesEnum FALSE_EVIDENCE = _$disputeEligibilityIssueTypesEnum_FALSE_EVIDENCE;
  @BuiltValueEnumConst(wireName: r'INACCESSIBLE_DELIVERY_SITE')
  static const DisputeEligibilityIssueTypesEnum INACCESSIBLE_DELIVERY_SITE = _$disputeEligibilityIssueTypesEnum_INACCESSIBLE_DELIVERY_SITE;

  static Serializer<DisputeEligibilityIssueTypesEnum> get serializer => _$disputeEligibilityIssueTypesEnumSerializer;

  const DisputeEligibilityIssueTypesEnum._(String name): super(name);

  static BuiltSet<DisputeEligibilityIssueTypesEnum> get values => _$disputeEligibilityIssueTypesEnumValues;
  static DisputeEligibilityIssueTypesEnum valueOf(String name) => _$disputeEligibilityIssueTypesEnumValueOf(name);
}

class DisputeEligibilityRequestedRemediesEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'REPLACEMENT')
  static const DisputeEligibilityRequestedRemediesEnum REPLACEMENT = _$disputeEligibilityRequestedRemediesEnum_REPLACEMENT;
  @BuiltValueEnumConst(wireName: r'FULL_REFUND')
  static const DisputeEligibilityRequestedRemediesEnum FULL_REFUND = _$disputeEligibilityRequestedRemediesEnum_FULL_REFUND;
  @BuiltValueEnumConst(wireName: r'PARTIAL_REFUND')
  static const DisputeEligibilityRequestedRemediesEnum PARTIAL_REFUND = _$disputeEligibilityRequestedRemediesEnum_PARTIAL_REFUND;
  @BuiltValueEnumConst(wireName: r'RETURN_AND_REFUND')
  static const DisputeEligibilityRequestedRemediesEnum RETURN_AND_REFUND = _$disputeEligibilityRequestedRemediesEnum_RETURN_AND_REFUND;
  @BuiltValueEnumConst(wireName: r'INVOICE_CORRECTION')
  static const DisputeEligibilityRequestedRemediesEnum INVOICE_CORRECTION = _$disputeEligibilityRequestedRemediesEnum_INVOICE_CORRECTION;
  @BuiltValueEnumConst(wireName: r'PAYMENT_OF_BALANCE')
  static const DisputeEligibilityRequestedRemediesEnum PAYMENT_OF_BALANCE = _$disputeEligibilityRequestedRemediesEnum_PAYMENT_OF_BALANCE;
  @BuiltValueEnumConst(wireName: r'WARNING_ONLY')
  static const DisputeEligibilityRequestedRemediesEnum WARNING_ONLY = _$disputeEligibilityRequestedRemediesEnum_WARNING_ONLY;
  @BuiltValueEnumConst(wireName: r'OTHER')
  static const DisputeEligibilityRequestedRemediesEnum OTHER = _$disputeEligibilityRequestedRemediesEnum_OTHER;

  static Serializer<DisputeEligibilityRequestedRemediesEnum> get serializer => _$disputeEligibilityRequestedRemediesEnumSerializer;

  const DisputeEligibilityRequestedRemediesEnum._(String name): super(name);

  static BuiltSet<DisputeEligibilityRequestedRemediesEnum> get values => _$disputeEligibilityRequestedRemediesEnumValues;
  static DisputeEligibilityRequestedRemediesEnum valueOf(String name) => _$disputeEligibilityRequestedRemediesEnumValueOf(name);
}

