//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'fee_statement.g.dart';

/// FeeStatement
///
/// Properties:
/// * [id]
/// * [reference]
/// * [state]
/// * [overdue]
/// * [periodStart]
/// * [periodEnd]
/// * [issuedOn]
/// * [dueOn]
/// * [chargesCentavos]
/// * [creditsCentavos]
/// * [paidCentavos]
/// * [outstandingCentavos]
/// * [disputedHeldCentavos]
/// * [lockVersion]
/// * [sampleNotice]
@BuiltValue()
abstract class FeeStatement implements Built<FeeStatement, FeeStatementBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'reference')
  String get reference;

  @BuiltValueField(wireName: r'state')
  FeeStatementStateEnum get state;
  // enum stateEnum {  DRAFT,  ISSUED,  PARTIALLY_PAID,  PAID,  VOIDED,  };

  @BuiltValueField(wireName: r'overdue')
  bool get overdue;

  @BuiltValueField(wireName: r'period_start')
  String get periodStart;

  @BuiltValueField(wireName: r'period_end')
  String get periodEnd;

  @BuiltValueField(wireName: r'issued_on')
  String get issuedOn;

  @BuiltValueField(wireName: r'due_on')
  String get dueOn;

  @BuiltValueField(wireName: r'charges_centavos')
  int get chargesCentavos;

  @BuiltValueField(wireName: r'credits_centavos')
  int get creditsCentavos;

  @BuiltValueField(wireName: r'paid_centavos')
  int get paidCentavos;

  @BuiltValueField(wireName: r'outstanding_centavos')
  int get outstandingCentavos;

  @BuiltValueField(wireName: r'disputed_held_centavos')
  int get disputedHeldCentavos;

  @BuiltValueField(wireName: r'lock_version')
  int get lockVersion;

  @BuiltValueField(wireName: r'sample_notice')
  String get sampleNotice;

  FeeStatement._();

  factory FeeStatement([void updates(FeeStatementBuilder b)]) = _$FeeStatement;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(FeeStatementBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<FeeStatement> get serializer => _$FeeStatementSerializer();
}

class _$FeeStatementSerializer implements PrimitiveSerializer<FeeStatement> {
  @override
  final Iterable<Type> types = const [FeeStatement, _$FeeStatement];

  @override
  final String wireName = r'FeeStatement';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    FeeStatement object, {
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
    yield r'state';
    yield serializers.serialize(
      object.state,
      specifiedType: const FullType(FeeStatementStateEnum),
    );
    yield r'overdue';
    yield serializers.serialize(
      object.overdue,
      specifiedType: const FullType(bool),
    );
    yield r'period_start';
    yield serializers.serialize(
      object.periodStart,
      specifiedType: const FullType(String),
    );
    yield r'period_end';
    yield serializers.serialize(
      object.periodEnd,
      specifiedType: const FullType(String),
    );
    yield r'issued_on';
    yield serializers.serialize(
      object.issuedOn,
      specifiedType: const FullType(String),
    );
    yield r'due_on';
    yield serializers.serialize(
      object.dueOn,
      specifiedType: const FullType(String),
    );
    yield r'charges_centavos';
    yield serializers.serialize(
      object.chargesCentavos,
      specifiedType: const FullType(int),
    );
    yield r'credits_centavos';
    yield serializers.serialize(
      object.creditsCentavos,
      specifiedType: const FullType(int),
    );
    yield r'paid_centavos';
    yield serializers.serialize(
      object.paidCentavos,
      specifiedType: const FullType(int),
    );
    yield r'outstanding_centavos';
    yield serializers.serialize(
      object.outstandingCentavos,
      specifiedType: const FullType(int),
    );
    yield r'disputed_held_centavos';
    yield serializers.serialize(
      object.disputedHeldCentavos,
      specifiedType: const FullType(int),
    );
    yield r'lock_version';
    yield serializers.serialize(
      object.lockVersion,
      specifiedType: const FullType(int),
    );
    yield r'sample_notice';
    yield serializers.serialize(
      object.sampleNotice,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    FeeStatement object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required FeeStatementBuilder result,
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
        case r'state':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(FeeStatementStateEnum),
          ) as FeeStatementStateEnum;
          result.state = valueDes;
          break;
        case r'overdue':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.overdue = valueDes;
          break;
        case r'period_start':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.periodStart = valueDes;
          break;
        case r'period_end':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.periodEnd = valueDes;
          break;
        case r'issued_on':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.issuedOn = valueDes;
          break;
        case r'due_on':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.dueOn = valueDes;
          break;
        case r'charges_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.chargesCentavos = valueDes;
          break;
        case r'credits_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.creditsCentavos = valueDes;
          break;
        case r'paid_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.paidCentavos = valueDes;
          break;
        case r'outstanding_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.outstandingCentavos = valueDes;
          break;
        case r'disputed_held_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.disputedHeldCentavos = valueDes;
          break;
        case r'lock_version':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.lockVersion = valueDes;
          break;
        case r'sample_notice':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.sampleNotice = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  FeeStatement deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = FeeStatementBuilder();
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


class FeeStatementStateEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'DRAFT')
  static const FeeStatementStateEnum DRAFT = _$feeStatementStateEnum_DRAFT;
  @BuiltValueEnumConst(wireName: r'ISSUED')
  static const FeeStatementStateEnum ISSUED = _$feeStatementStateEnum_ISSUED;
  @BuiltValueEnumConst(wireName: r'PARTIALLY_PAID')
  static const FeeStatementStateEnum PARTIALLY_PAID = _$feeStatementStateEnum_PARTIALLY_PAID;
  @BuiltValueEnumConst(wireName: r'PAID')
  static const FeeStatementStateEnum PAID = _$feeStatementStateEnum_PAID;
  @BuiltValueEnumConst(wireName: r'VOIDED')
  static const FeeStatementStateEnum VOIDED = _$feeStatementStateEnum_VOIDED;

  static Serializer<FeeStatementStateEnum> get serializer => _$feeStatementStateEnumSerializer;

  const FeeStatementStateEnum._(String name): super(name);

  static BuiltSet<FeeStatementStateEnum> get values => _$feeStatementStateEnumValues;
  static FeeStatementStateEnum valueOf(String name) => _$feeStatementStateEnumValueOf(name);
}

