//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_refund_row.g.dart';

/// AdminRefundRow
///
/// Properties:
/// * [id]
/// * [targetType]
/// * [trigger]
/// * [state]
/// * [displayState]
/// * [amountCentavos]
/// * [attemptNumber]
/// * [failureCode]
/// * [evidenceOrigin]
/// * [orderId]
/// * [orderReference]
/// * [statementReference]
/// * [vendorName]
/// * [requestedAt]
/// * [completedAt]
/// * [canRetry]
@BuiltValue()
abstract class AdminRefundRow implements Built<AdminRefundRow, AdminRefundRowBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'target_type')
  AdminRefundRowTargetTypeEnum get targetType;
  // enum targetTypeEnum {  ORDER,  PLATFORM_FEE,  };

  @BuiltValueField(wireName: r'trigger')
  AdminRefundRowTriggerEnum get trigger;
  // enum triggerEnum {  CANCELLATION,  DISPUTE_CONCLUSION,  TECHNICAL_COMPENSATION,  FEE_CREDIT,  };

  @BuiltValueField(wireName: r'state')
  AdminRefundRowStateEnum get state;
  // enum stateEnum {  REFUND_PENDING,  REFUNDED,  REFUND_FAILED,  };

  @BuiltValueField(wireName: r'display_state')
  AdminRefundRowDisplayStateEnum get displayState;
  // enum displayStateEnum {  QUEUED,  INITIATED,  PROCESSED,  FAILED,  };

  @BuiltValueField(wireName: r'amount_centavos')
  int get amountCentavos;

  @BuiltValueField(wireName: r'attempt_number')
  int get attemptNumber;

  @BuiltValueField(wireName: r'failure_code')
  String? get failureCode;

  @BuiltValueField(wireName: r'evidence_origin')
  String? get evidenceOrigin;

  @BuiltValueField(wireName: r'order_id')
  String? get orderId;

  @BuiltValueField(wireName: r'order_reference')
  String? get orderReference;

  @BuiltValueField(wireName: r'statement_reference')
  String? get statementReference;

  @BuiltValueField(wireName: r'vendor_name')
  String? get vendorName;

  @BuiltValueField(wireName: r'requested_at')
  DateTime? get requestedAt;

  @BuiltValueField(wireName: r'completed_at')
  DateTime? get completedAt;

  @BuiltValueField(wireName: r'can_retry')
  bool get canRetry;

  AdminRefundRow._();

  factory AdminRefundRow([void updates(AdminRefundRowBuilder b)]) = _$AdminRefundRow;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminRefundRowBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminRefundRow> get serializer => _$AdminRefundRowSerializer();
}

class _$AdminRefundRowSerializer implements PrimitiveSerializer<AdminRefundRow> {
  @override
  final Iterable<Type> types = const [AdminRefundRow, _$AdminRefundRow];

  @override
  final String wireName = r'AdminRefundRow';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminRefundRow object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'target_type';
    yield serializers.serialize(
      object.targetType,
      specifiedType: const FullType(AdminRefundRowTargetTypeEnum),
    );
    yield r'trigger';
    yield serializers.serialize(
      object.trigger,
      specifiedType: const FullType(AdminRefundRowTriggerEnum),
    );
    yield r'state';
    yield serializers.serialize(
      object.state,
      specifiedType: const FullType(AdminRefundRowStateEnum),
    );
    yield r'display_state';
    yield serializers.serialize(
      object.displayState,
      specifiedType: const FullType(AdminRefundRowDisplayStateEnum),
    );
    yield r'amount_centavos';
    yield serializers.serialize(
      object.amountCentavos,
      specifiedType: const FullType(int),
    );
    yield r'attempt_number';
    yield serializers.serialize(
      object.attemptNumber,
      specifiedType: const FullType(int),
    );
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
    if (object.orderId != null) {
      yield r'order_id';
      yield serializers.serialize(
        object.orderId,
        specifiedType: const FullType(String),
      );
    }
    if (object.orderReference != null) {
      yield r'order_reference';
      yield serializers.serialize(
        object.orderReference,
        specifiedType: const FullType(String),
      );
    }
    if (object.statementReference != null) {
      yield r'statement_reference';
      yield serializers.serialize(
        object.statementReference,
        specifiedType: const FullType(String),
      );
    }
    if (object.vendorName != null) {
      yield r'vendor_name';
      yield serializers.serialize(
        object.vendorName,
        specifiedType: const FullType(String),
      );
    }
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
    yield r'can_retry';
    yield serializers.serialize(
      object.canRetry,
      specifiedType: const FullType(bool),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminRefundRow object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminRefundRowBuilder result,
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
        case r'target_type':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AdminRefundRowTargetTypeEnum),
          ) as AdminRefundRowTargetTypeEnum;
          result.targetType = valueDes;
          break;
        case r'trigger':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AdminRefundRowTriggerEnum),
          ) as AdminRefundRowTriggerEnum;
          result.trigger = valueDes;
          break;
        case r'state':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AdminRefundRowStateEnum),
          ) as AdminRefundRowStateEnum;
          result.state = valueDes;
          break;
        case r'display_state':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AdminRefundRowDisplayStateEnum),
          ) as AdminRefundRowDisplayStateEnum;
          result.displayState = valueDes;
          break;
        case r'amount_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.amountCentavos = valueDes;
          break;
        case r'attempt_number':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.attemptNumber = valueDes;
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
        case r'order_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.orderId = valueDes;
          break;
        case r'order_reference':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.orderReference = valueDes;
          break;
        case r'statement_reference':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.statementReference = valueDes;
          break;
        case r'vendor_name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.vendorName = valueDes;
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
        case r'can_retry':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.canRetry = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminRefundRow deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminRefundRowBuilder();
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


class AdminRefundRowTargetTypeEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'ORDER')
  static const AdminRefundRowTargetTypeEnum ORDER = _$adminRefundRowTargetTypeEnum_ORDER;
  @BuiltValueEnumConst(wireName: r'PLATFORM_FEE')
  static const AdminRefundRowTargetTypeEnum PLATFORM_FEE = _$adminRefundRowTargetTypeEnum_PLATFORM_FEE;

  static Serializer<AdminRefundRowTargetTypeEnum> get serializer => _$adminRefundRowTargetTypeEnumSerializer;

  const AdminRefundRowTargetTypeEnum._(String name): super(name);

  static BuiltSet<AdminRefundRowTargetTypeEnum> get values => _$adminRefundRowTargetTypeEnumValues;
  static AdminRefundRowTargetTypeEnum valueOf(String name) => _$adminRefundRowTargetTypeEnumValueOf(name);
}

class AdminRefundRowTriggerEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'CANCELLATION')
  static const AdminRefundRowTriggerEnum CANCELLATION = _$adminRefundRowTriggerEnum_CANCELLATION;
  @BuiltValueEnumConst(wireName: r'DISPUTE_CONCLUSION')
  static const AdminRefundRowTriggerEnum DISPUTE_CONCLUSION = _$adminRefundRowTriggerEnum_DISPUTE_CONCLUSION;
  @BuiltValueEnumConst(wireName: r'TECHNICAL_COMPENSATION')
  static const AdminRefundRowTriggerEnum TECHNICAL_COMPENSATION = _$adminRefundRowTriggerEnum_TECHNICAL_COMPENSATION;
  @BuiltValueEnumConst(wireName: r'FEE_CREDIT')
  static const AdminRefundRowTriggerEnum FEE_CREDIT = _$adminRefundRowTriggerEnum_FEE_CREDIT;

  static Serializer<AdminRefundRowTriggerEnum> get serializer => _$adminRefundRowTriggerEnumSerializer;

  const AdminRefundRowTriggerEnum._(String name): super(name);

  static BuiltSet<AdminRefundRowTriggerEnum> get values => _$adminRefundRowTriggerEnumValues;
  static AdminRefundRowTriggerEnum valueOf(String name) => _$adminRefundRowTriggerEnumValueOf(name);
}

class AdminRefundRowStateEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'REFUND_PENDING')
  static const AdminRefundRowStateEnum REFUND_PENDING = _$adminRefundRowStateEnum_REFUND_PENDING;
  @BuiltValueEnumConst(wireName: r'REFUNDED')
  static const AdminRefundRowStateEnum REFUNDED = _$adminRefundRowStateEnum_REFUNDED;
  @BuiltValueEnumConst(wireName: r'REFUND_FAILED')
  static const AdminRefundRowStateEnum REFUND_FAILED = _$adminRefundRowStateEnum_REFUND_FAILED;

  static Serializer<AdminRefundRowStateEnum> get serializer => _$adminRefundRowStateEnumSerializer;

  const AdminRefundRowStateEnum._(String name): super(name);

  static BuiltSet<AdminRefundRowStateEnum> get values => _$adminRefundRowStateEnumValues;
  static AdminRefundRowStateEnum valueOf(String name) => _$adminRefundRowStateEnumValueOf(name);
}

class AdminRefundRowDisplayStateEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'QUEUED')
  static const AdminRefundRowDisplayStateEnum QUEUED = _$adminRefundRowDisplayStateEnum_QUEUED;
  @BuiltValueEnumConst(wireName: r'INITIATED')
  static const AdminRefundRowDisplayStateEnum INITIATED = _$adminRefundRowDisplayStateEnum_INITIATED;
  @BuiltValueEnumConst(wireName: r'PROCESSED')
  static const AdminRefundRowDisplayStateEnum PROCESSED = _$adminRefundRowDisplayStateEnum_PROCESSED;
  @BuiltValueEnumConst(wireName: r'FAILED')
  static const AdminRefundRowDisplayStateEnum FAILED = _$adminRefundRowDisplayStateEnum_FAILED;

  static Serializer<AdminRefundRowDisplayStateEnum> get serializer => _$adminRefundRowDisplayStateEnumSerializer;

  const AdminRefundRowDisplayStateEnum._(String name): super(name);

  static BuiltSet<AdminRefundRowDisplayStateEnum> get values => _$adminRefundRowDisplayStateEnumValues;
  static AdminRefundRowDisplayStateEnum valueOf(String name) => _$adminRefundRowDisplayStateEnumValueOf(name);
}

