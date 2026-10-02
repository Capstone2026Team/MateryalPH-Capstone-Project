//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'physical_payment_record.g.dart';

/// PhysicalPaymentRecord
///
/// Properties:
/// * [id]
/// * [kind]
/// * [method]
/// * [amountCentavos]
/// * [remainingCentavos]
/// * [state]
/// * [recordedAt]
/// * [recordedRole]
/// * [hasEvidence]
/// * [source_]
/// * [buyerAcknowledgedAt]
@BuiltValue()
abstract class PhysicalPaymentRecord implements Built<PhysicalPaymentRecord, PhysicalPaymentRecordBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'kind')
  PhysicalPaymentRecordKindEnum get kind;
  // enum kindEnum {  OBLIGATION_OPENED,  COLLECTION,  ONLINE_BALANCE_CREDIT,  CORRECTION,  CANCELLATION_RELEASE,  };

  @BuiltValueField(wireName: r'method')
  String get method;

  @BuiltValueField(wireName: r'amount_centavos')
  int get amountCentavos;

  @BuiltValueField(wireName: r'remaining_centavos')
  int get remainingCentavos;

  @BuiltValueField(wireName: r'state')
  PhysicalPaymentRecordStateEnum get state;
  // enum stateEnum {  UNPAID,  PARTIALLY_RECORDED,  PHYSICAL_PAYMENT_RECORDED,  CANCELLED_UNPAID,  };

  @BuiltValueField(wireName: r'recorded_at')
  DateTime get recordedAt;

  @BuiltValueField(wireName: r'recorded_role')
  String? get recordedRole;

  @BuiltValueField(wireName: r'has_evidence')
  bool get hasEvidence;

  @BuiltValueField(wireName: r'source')
  PhysicalPaymentRecordSource_Enum get source_;
  // enum source_Enum {  VENDOR_RECORD,  VERIFIED_ONLINE_PAYMENT,  SYSTEM,  };

  @BuiltValueField(wireName: r'buyer_acknowledged_at')
  DateTime? get buyerAcknowledgedAt;

  PhysicalPaymentRecord._();

  factory PhysicalPaymentRecord([void updates(PhysicalPaymentRecordBuilder b)]) = _$PhysicalPaymentRecord;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PhysicalPaymentRecordBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PhysicalPaymentRecord> get serializer => _$PhysicalPaymentRecordSerializer();
}

class _$PhysicalPaymentRecordSerializer implements PrimitiveSerializer<PhysicalPaymentRecord> {
  @override
  final Iterable<Type> types = const [PhysicalPaymentRecord, _$PhysicalPaymentRecord];

  @override
  final String wireName = r'PhysicalPaymentRecord';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PhysicalPaymentRecord object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'kind';
    yield serializers.serialize(
      object.kind,
      specifiedType: const FullType(PhysicalPaymentRecordKindEnum),
    );
    yield r'method';
    yield serializers.serialize(
      object.method,
      specifiedType: const FullType(String),
    );
    yield r'amount_centavos';
    yield serializers.serialize(
      object.amountCentavos,
      specifiedType: const FullType(int),
    );
    yield r'remaining_centavos';
    yield serializers.serialize(
      object.remainingCentavos,
      specifiedType: const FullType(int),
    );
    yield r'state';
    yield serializers.serialize(
      object.state,
      specifiedType: const FullType(PhysicalPaymentRecordStateEnum),
    );
    yield r'recorded_at';
    yield serializers.serialize(
      object.recordedAt,
      specifiedType: const FullType(DateTime),
    );
    if (object.recordedRole != null) {
      yield r'recorded_role';
      yield serializers.serialize(
        object.recordedRole,
        specifiedType: const FullType(String),
      );
    }
    yield r'has_evidence';
    yield serializers.serialize(
      object.hasEvidence,
      specifiedType: const FullType(bool),
    );
    yield r'source';
    yield serializers.serialize(
      object.source_,
      specifiedType: const FullType(PhysicalPaymentRecordSource_Enum),
    );
    if (object.buyerAcknowledgedAt != null) {
      yield r'buyer_acknowledged_at';
      yield serializers.serialize(
        object.buyerAcknowledgedAt,
        specifiedType: const FullType(DateTime),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    PhysicalPaymentRecord object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PhysicalPaymentRecordBuilder result,
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
        case r'kind':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(PhysicalPaymentRecordKindEnum),
          ) as PhysicalPaymentRecordKindEnum;
          result.kind = valueDes;
          break;
        case r'method':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.method = valueDes;
          break;
        case r'amount_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.amountCentavos = valueDes;
          break;
        case r'remaining_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.remainingCentavos = valueDes;
          break;
        case r'state':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(PhysicalPaymentRecordStateEnum),
          ) as PhysicalPaymentRecordStateEnum;
          result.state = valueDes;
          break;
        case r'recorded_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.recordedAt = valueDes;
          break;
        case r'recorded_role':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.recordedRole = valueDes;
          break;
        case r'has_evidence':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.hasEvidence = valueDes;
          break;
        case r'source':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(PhysicalPaymentRecordSource_Enum),
          ) as PhysicalPaymentRecordSource_Enum;
          result.source_ = valueDes;
          break;
        case r'buyer_acknowledged_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.buyerAcknowledgedAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  PhysicalPaymentRecord deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PhysicalPaymentRecordBuilder();
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


class PhysicalPaymentRecordKindEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'OBLIGATION_OPENED')
  static const PhysicalPaymentRecordKindEnum OBLIGATION_OPENED = _$physicalPaymentRecordKindEnum_OBLIGATION_OPENED;
  @BuiltValueEnumConst(wireName: r'COLLECTION')
  static const PhysicalPaymentRecordKindEnum COLLECTION = _$physicalPaymentRecordKindEnum_COLLECTION;
  @BuiltValueEnumConst(wireName: r'ONLINE_BALANCE_CREDIT')
  static const PhysicalPaymentRecordKindEnum ONLINE_BALANCE_CREDIT = _$physicalPaymentRecordKindEnum_ONLINE_BALANCE_CREDIT;
  @BuiltValueEnumConst(wireName: r'CORRECTION')
  static const PhysicalPaymentRecordKindEnum CORRECTION = _$physicalPaymentRecordKindEnum_CORRECTION;
  @BuiltValueEnumConst(wireName: r'CANCELLATION_RELEASE')
  static const PhysicalPaymentRecordKindEnum CANCELLATION_RELEASE = _$physicalPaymentRecordKindEnum_CANCELLATION_RELEASE;

  static Serializer<PhysicalPaymentRecordKindEnum> get serializer => _$physicalPaymentRecordKindEnumSerializer;

  const PhysicalPaymentRecordKindEnum._(String name): super(name);

  static BuiltSet<PhysicalPaymentRecordKindEnum> get values => _$physicalPaymentRecordKindEnumValues;
  static PhysicalPaymentRecordKindEnum valueOf(String name) => _$physicalPaymentRecordKindEnumValueOf(name);
}

class PhysicalPaymentRecordStateEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'UNPAID')
  static const PhysicalPaymentRecordStateEnum UNPAID = _$physicalPaymentRecordStateEnum_UNPAID;
  @BuiltValueEnumConst(wireName: r'PARTIALLY_RECORDED')
  static const PhysicalPaymentRecordStateEnum PARTIALLY_RECORDED = _$physicalPaymentRecordStateEnum_PARTIALLY_RECORDED;
  @BuiltValueEnumConst(wireName: r'PHYSICAL_PAYMENT_RECORDED')
  static const PhysicalPaymentRecordStateEnum PHYSICAL_PAYMENT_RECORDED = _$physicalPaymentRecordStateEnum_PHYSICAL_PAYMENT_RECORDED;
  @BuiltValueEnumConst(wireName: r'CANCELLED_UNPAID')
  static const PhysicalPaymentRecordStateEnum CANCELLED_UNPAID = _$physicalPaymentRecordStateEnum_CANCELLED_UNPAID;

  static Serializer<PhysicalPaymentRecordStateEnum> get serializer => _$physicalPaymentRecordStateEnumSerializer;

  const PhysicalPaymentRecordStateEnum._(String name): super(name);

  static BuiltSet<PhysicalPaymentRecordStateEnum> get values => _$physicalPaymentRecordStateEnumValues;
  static PhysicalPaymentRecordStateEnum valueOf(String name) => _$physicalPaymentRecordStateEnumValueOf(name);
}

class PhysicalPaymentRecordSource_Enum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'VENDOR_RECORD')
  static const PhysicalPaymentRecordSource_Enum VENDOR_RECORD = _$physicalPaymentRecordSourceEnum_VENDOR_RECORD;
  @BuiltValueEnumConst(wireName: r'VERIFIED_ONLINE_PAYMENT')
  static const PhysicalPaymentRecordSource_Enum VERIFIED_ONLINE_PAYMENT = _$physicalPaymentRecordSourceEnum_VERIFIED_ONLINE_PAYMENT;
  @BuiltValueEnumConst(wireName: r'SYSTEM')
  static const PhysicalPaymentRecordSource_Enum SYSTEM = _$physicalPaymentRecordSourceEnum_SYSTEM;

  static Serializer<PhysicalPaymentRecordSource_Enum> get serializer => _$physicalPaymentRecordSourceEnumSerializer;

  const PhysicalPaymentRecordSource_Enum._(String name): super(name);

  static BuiltSet<PhysicalPaymentRecordSource_Enum> get values => _$physicalPaymentRecordSourceEnumValues;
  static PhysicalPaymentRecordSource_Enum valueOf(String name) => _$physicalPaymentRecordSourceEnumValueOf(name);
}

