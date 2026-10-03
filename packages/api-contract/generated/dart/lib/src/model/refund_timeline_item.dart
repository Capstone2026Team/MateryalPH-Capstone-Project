//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'refund_timeline_item.g.dart';

/// One timeline per original online payment. INITIATED is never success; PROCESSED requires a verified provider event or reconciliation.
///
/// Properties:
/// * [id]
/// * [trigger]
/// * [state]
/// * [displayState]
/// * [amountCentavos]
/// * [principalCentavos]
/// * [processingFeeCentavos]
/// * [paymentPurpose]
/// * [originalMethod]
/// * [attemptNumber]
/// * [requestedAt]
/// * [completedAt]
/// * [failureCode]
/// * [evidenceOrigin]
/// * [canRetry]
/// * [arrivalNote]
/// * [message]
@BuiltValue()
abstract class RefundTimelineItem implements Built<RefundTimelineItem, RefundTimelineItemBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'trigger')
  RefundTimelineItemTriggerEnum get trigger;
  // enum triggerEnum {  CANCELLATION,  DISPUTE_CONCLUSION,  TECHNICAL_COMPENSATION,  FEE_CREDIT,  };

  @BuiltValueField(wireName: r'state')
  RefundTimelineItemStateEnum get state;
  // enum stateEnum {  REFUND_PENDING,  REFUNDED,  REFUND_FAILED,  };

  @BuiltValueField(wireName: r'display_state')
  RefundTimelineItemDisplayStateEnum get displayState;
  // enum displayStateEnum {  QUEUED,  INITIATED,  PROCESSED,  FAILED,  };

  @BuiltValueField(wireName: r'amount_centavos')
  int get amountCentavos;

  @BuiltValueField(wireName: r'principal_centavos')
  int? get principalCentavos;

  @BuiltValueField(wireName: r'processing_fee_centavos')
  int get processingFeeCentavos;

  @BuiltValueField(wireName: r'payment_purpose')
  String get paymentPurpose;

  @BuiltValueField(wireName: r'original_method')
  String get originalMethod;

  @BuiltValueField(wireName: r'attempt_number')
  int get attemptNumber;

  @BuiltValueField(wireName: r'requested_at')
  DateTime? get requestedAt;

  @BuiltValueField(wireName: r'completed_at')
  DateTime? get completedAt;

  @BuiltValueField(wireName: r'failure_code')
  String? get failureCode;

  @BuiltValueField(wireName: r'evidence_origin')
  String? get evidenceOrigin;

  @BuiltValueField(wireName: r'can_retry')
  bool get canRetry;

  @BuiltValueField(wireName: r'arrival_note')
  String? get arrivalNote;

  @BuiltValueField(wireName: r'message')
  String get message;

  RefundTimelineItem._();

  factory RefundTimelineItem([void updates(RefundTimelineItemBuilder b)]) = _$RefundTimelineItem;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(RefundTimelineItemBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<RefundTimelineItem> get serializer => _$RefundTimelineItemSerializer();
}

class _$RefundTimelineItemSerializer implements PrimitiveSerializer<RefundTimelineItem> {
  @override
  final Iterable<Type> types = const [RefundTimelineItem, _$RefundTimelineItem];

  @override
  final String wireName = r'RefundTimelineItem';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    RefundTimelineItem object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'trigger';
    yield serializers.serialize(
      object.trigger,
      specifiedType: const FullType(RefundTimelineItemTriggerEnum),
    );
    yield r'state';
    yield serializers.serialize(
      object.state,
      specifiedType: const FullType(RefundTimelineItemStateEnum),
    );
    yield r'display_state';
    yield serializers.serialize(
      object.displayState,
      specifiedType: const FullType(RefundTimelineItemDisplayStateEnum),
    );
    yield r'amount_centavos';
    yield serializers.serialize(
      object.amountCentavos,
      specifiedType: const FullType(int),
    );
    if (object.principalCentavos != null) {
      yield r'principal_centavos';
      yield serializers.serialize(
        object.principalCentavos,
        specifiedType: const FullType(int),
      );
    }
    yield r'processing_fee_centavos';
    yield serializers.serialize(
      object.processingFeeCentavos,
      specifiedType: const FullType(int),
    );
    yield r'payment_purpose';
    yield serializers.serialize(
      object.paymentPurpose,
      specifiedType: const FullType(String),
    );
    yield r'original_method';
    yield serializers.serialize(
      object.originalMethod,
      specifiedType: const FullType(String),
    );
    yield r'attempt_number';
    yield serializers.serialize(
      object.attemptNumber,
      specifiedType: const FullType(int),
    );
    if (object.requestedAt != null) {
      yield r'requested_at';
      yield serializers.serialize(
        object.requestedAt,
        specifiedType: const FullType(DateTime),
      );
    }
    if (object.completedAt != null) {
      yield r'completed_at';
      yield serializers.serialize(
        object.completedAt,
        specifiedType: const FullType(DateTime),
      );
    }
    if (object.failureCode != null) {
      yield r'failure_code';
      yield serializers.serialize(
        object.failureCode,
        specifiedType: const FullType(String),
      );
    }
    if (object.evidenceOrigin != null) {
      yield r'evidence_origin';
      yield serializers.serialize(
        object.evidenceOrigin,
        specifiedType: const FullType(String),
      );
    }
    yield r'can_retry';
    yield serializers.serialize(
      object.canRetry,
      specifiedType: const FullType(bool),
    );
    if (object.arrivalNote != null) {
      yield r'arrival_note';
      yield serializers.serialize(
        object.arrivalNote,
        specifiedType: const FullType(String),
      );
    }
    yield r'message';
    yield serializers.serialize(
      object.message,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    RefundTimelineItem object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required RefundTimelineItemBuilder result,
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
        case r'trigger':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(RefundTimelineItemTriggerEnum),
          ) as RefundTimelineItemTriggerEnum;
          result.trigger = valueDes;
          break;
        case r'state':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(RefundTimelineItemStateEnum),
          ) as RefundTimelineItemStateEnum;
          result.state = valueDes;
          break;
        case r'display_state':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(RefundTimelineItemDisplayStateEnum),
          ) as RefundTimelineItemDisplayStateEnum;
          result.displayState = valueDes;
          break;
        case r'amount_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.amountCentavos = valueDes;
          break;
        case r'principal_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.principalCentavos = valueDes;
          break;
        case r'processing_fee_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.processingFeeCentavos = valueDes;
          break;
        case r'payment_purpose':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.paymentPurpose = valueDes;
          break;
        case r'original_method':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.originalMethod = valueDes;
          break;
        case r'attempt_number':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.attemptNumber = valueDes;
          break;
        case r'requested_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.requestedAt = valueDes;
          break;
        case r'completed_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.completedAt = valueDes;
          break;
        case r'failure_code':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.failureCode = valueDes;
          break;
        case r'evidence_origin':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.evidenceOrigin = valueDes;
          break;
        case r'can_retry':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.canRetry = valueDes;
          break;
        case r'arrival_note':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.arrivalNote = valueDes;
          break;
        case r'message':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.message = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  RefundTimelineItem deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = RefundTimelineItemBuilder();
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


class RefundTimelineItemTriggerEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'CANCELLATION')
  static const RefundTimelineItemTriggerEnum CANCELLATION = _$refundTimelineItemTriggerEnum_CANCELLATION;
  @BuiltValueEnumConst(wireName: r'DISPUTE_CONCLUSION')
  static const RefundTimelineItemTriggerEnum DISPUTE_CONCLUSION = _$refundTimelineItemTriggerEnum_DISPUTE_CONCLUSION;
  @BuiltValueEnumConst(wireName: r'TECHNICAL_COMPENSATION')
  static const RefundTimelineItemTriggerEnum TECHNICAL_COMPENSATION = _$refundTimelineItemTriggerEnum_TECHNICAL_COMPENSATION;
  @BuiltValueEnumConst(wireName: r'FEE_CREDIT')
  static const RefundTimelineItemTriggerEnum FEE_CREDIT = _$refundTimelineItemTriggerEnum_FEE_CREDIT;

  static Serializer<RefundTimelineItemTriggerEnum> get serializer => _$refundTimelineItemTriggerEnumSerializer;

  const RefundTimelineItemTriggerEnum._(String name): super(name);

  static BuiltSet<RefundTimelineItemTriggerEnum> get values => _$refundTimelineItemTriggerEnumValues;
  static RefundTimelineItemTriggerEnum valueOf(String name) => _$refundTimelineItemTriggerEnumValueOf(name);
}

class RefundTimelineItemStateEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'REFUND_PENDING')
  static const RefundTimelineItemStateEnum REFUND_PENDING = _$refundTimelineItemStateEnum_REFUND_PENDING;
  @BuiltValueEnumConst(wireName: r'REFUNDED')
  static const RefundTimelineItemStateEnum REFUNDED = _$refundTimelineItemStateEnum_REFUNDED;
  @BuiltValueEnumConst(wireName: r'REFUND_FAILED')
  static const RefundTimelineItemStateEnum REFUND_FAILED = _$refundTimelineItemStateEnum_REFUND_FAILED;

  static Serializer<RefundTimelineItemStateEnum> get serializer => _$refundTimelineItemStateEnumSerializer;

  const RefundTimelineItemStateEnum._(String name): super(name);

  static BuiltSet<RefundTimelineItemStateEnum> get values => _$refundTimelineItemStateEnumValues;
  static RefundTimelineItemStateEnum valueOf(String name) => _$refundTimelineItemStateEnumValueOf(name);
}

class RefundTimelineItemDisplayStateEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'QUEUED')
  static const RefundTimelineItemDisplayStateEnum QUEUED = _$refundTimelineItemDisplayStateEnum_QUEUED;
  @BuiltValueEnumConst(wireName: r'INITIATED')
  static const RefundTimelineItemDisplayStateEnum INITIATED = _$refundTimelineItemDisplayStateEnum_INITIATED;
  @BuiltValueEnumConst(wireName: r'PROCESSED')
  static const RefundTimelineItemDisplayStateEnum PROCESSED = _$refundTimelineItemDisplayStateEnum_PROCESSED;
  @BuiltValueEnumConst(wireName: r'FAILED')
  static const RefundTimelineItemDisplayStateEnum FAILED = _$refundTimelineItemDisplayStateEnum_FAILED;

  static Serializer<RefundTimelineItemDisplayStateEnum> get serializer => _$refundTimelineItemDisplayStateEnumSerializer;

  const RefundTimelineItemDisplayStateEnum._(String name): super(name);

  static BuiltSet<RefundTimelineItemDisplayStateEnum> get values => _$refundTimelineItemDisplayStateEnumValues;
  static RefundTimelineItemDisplayStateEnum valueOf(String name) => _$refundTimelineItemDisplayStateEnumValueOf(name);
}

