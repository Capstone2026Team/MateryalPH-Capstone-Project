//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:materyalph_api_client/src/model/dispute_file_link.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'dispute_remedy.g.dart';

/// DisputeRemedy
///
/// Properties:
/// * [id]
/// * [kind]
/// * [state]
/// * [amountCentavos]
/// * [note]
/// * [recorded]
/// * [completedAt]
/// * [decisionId]
/// * [evidence]
/// * [canRecord]
/// * [canConfirm]
@BuiltValue()
abstract class DisputeRemedy implements Built<DisputeRemedy, DisputeRemedyBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'kind')
  DisputeRemedyKindEnum get kind;
  // enum kindEnum {  ONLINE_REFUND,  CASH_REIMBURSEMENT,  REPLACEMENT,  FEE_CREDIT_REVIEW,  ORDER_CANCELLATION,  };

  @BuiltValueField(wireName: r'state')
  DisputeRemedyStateEnum get state;
  // enum stateEnum {  PENDING,  COMPLETED,  FAILED,  };

  @BuiltValueField(wireName: r'amount_centavos')
  int get amountCentavos;

  @BuiltValueField(wireName: r'note')
  String? get note;

  @BuiltValueField(wireName: r'recorded')
  bool get recorded;

  @BuiltValueField(wireName: r'completed_at')
  DateTime? get completedAt;

  @BuiltValueField(wireName: r'decision_id')
  String? get decisionId;

  @BuiltValueField(wireName: r'evidence')
  DisputeFileLink? get evidence;

  @BuiltValueField(wireName: r'can_record')
  bool get canRecord;

  @BuiltValueField(wireName: r'can_confirm')
  bool get canConfirm;

  DisputeRemedy._();

  factory DisputeRemedy([void updates(DisputeRemedyBuilder b)]) = _$DisputeRemedy;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(DisputeRemedyBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<DisputeRemedy> get serializer => _$DisputeRemedySerializer();
}

class _$DisputeRemedySerializer implements PrimitiveSerializer<DisputeRemedy> {
  @override
  final Iterable<Type> types = const [DisputeRemedy, _$DisputeRemedy];

  @override
  final String wireName = r'DisputeRemedy';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    DisputeRemedy object, {
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
      specifiedType: const FullType(DisputeRemedyKindEnum),
    );
    yield r'state';
    yield serializers.serialize(
      object.state,
      specifiedType: const FullType(DisputeRemedyStateEnum),
    );
    yield r'amount_centavos';
    yield serializers.serialize(
      object.amountCentavos,
      specifiedType: const FullType(int),
    );
    if (object.note != null) {
      yield r'note';
      yield serializers.serialize(
        object.note,
        specifiedType: const FullType(String),
      );
    }
    yield r'recorded';
    yield serializers.serialize(
      object.recorded,
      specifiedType: const FullType(bool),
    );
    if (object.completedAt != null) {
      yield r'completed_at';
      yield serializers.serialize(
        object.completedAt,
        specifiedType: const FullType(DateTime),
      );
    }
    if (object.decisionId != null) {
      yield r'decision_id';
      yield serializers.serialize(
        object.decisionId,
        specifiedType: const FullType(String),
      );
    }
    if (object.evidence != null) {
      yield r'evidence';
      yield serializers.serialize(
        object.evidence,
        specifiedType: const FullType.nullable(DisputeFileLink),
      );
    }
    yield r'can_record';
    yield serializers.serialize(
      object.canRecord,
      specifiedType: const FullType(bool),
    );
    yield r'can_confirm';
    yield serializers.serialize(
      object.canConfirm,
      specifiedType: const FullType(bool),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    DisputeRemedy object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required DisputeRemedyBuilder result,
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
            specifiedType: const FullType(DisputeRemedyKindEnum),
          ) as DisputeRemedyKindEnum;
          result.kind = valueDes;
          break;
        case r'state':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DisputeRemedyStateEnum),
          ) as DisputeRemedyStateEnum;
          result.state = valueDes;
          break;
        case r'amount_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.amountCentavos = valueDes;
          break;
        case r'note':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.note = valueDes;
          break;
        case r'recorded':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.recorded = valueDes;
          break;
        case r'completed_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.completedAt = valueDes;
          break;
        case r'decision_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.decisionId = valueDes;
          break;
        case r'evidence':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DisputeFileLink),
          ) as DisputeFileLink?;
          if (valueDes == null) continue;
          result.evidence.replace(valueDes);
          break;
        case r'can_record':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.canRecord = valueDes;
          break;
        case r'can_confirm':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.canConfirm = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  DisputeRemedy deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = DisputeRemedyBuilder();
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


class DisputeRemedyKindEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'ONLINE_REFUND')
  static const DisputeRemedyKindEnum ONLINE_REFUND = _$disputeRemedyKindEnum_ONLINE_REFUND;
  @BuiltValueEnumConst(wireName: r'CASH_REIMBURSEMENT')
  static const DisputeRemedyKindEnum CASH_REIMBURSEMENT = _$disputeRemedyKindEnum_CASH_REIMBURSEMENT;
  @BuiltValueEnumConst(wireName: r'REPLACEMENT')
  static const DisputeRemedyKindEnum REPLACEMENT = _$disputeRemedyKindEnum_REPLACEMENT;
  @BuiltValueEnumConst(wireName: r'FEE_CREDIT_REVIEW')
  static const DisputeRemedyKindEnum FEE_CREDIT_REVIEW = _$disputeRemedyKindEnum_FEE_CREDIT_REVIEW;
  @BuiltValueEnumConst(wireName: r'ORDER_CANCELLATION')
  static const DisputeRemedyKindEnum ORDER_CANCELLATION = _$disputeRemedyKindEnum_ORDER_CANCELLATION;

  static Serializer<DisputeRemedyKindEnum> get serializer => _$disputeRemedyKindEnumSerializer;

  const DisputeRemedyKindEnum._(String name): super(name);

  static BuiltSet<DisputeRemedyKindEnum> get values => _$disputeRemedyKindEnumValues;
  static DisputeRemedyKindEnum valueOf(String name) => _$disputeRemedyKindEnumValueOf(name);
}

class DisputeRemedyStateEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'PENDING')
  static const DisputeRemedyStateEnum PENDING = _$disputeRemedyStateEnum_PENDING;
  @BuiltValueEnumConst(wireName: r'COMPLETED')
  static const DisputeRemedyStateEnum COMPLETED = _$disputeRemedyStateEnum_COMPLETED;
  @BuiltValueEnumConst(wireName: r'FAILED')
  static const DisputeRemedyStateEnum FAILED = _$disputeRemedyStateEnum_FAILED;

  static Serializer<DisputeRemedyStateEnum> get serializer => _$disputeRemedyStateEnumSerializer;

  const DisputeRemedyStateEnum._(String name): super(name);

  static BuiltSet<DisputeRemedyStateEnum> get values => _$disputeRemedyStateEnumValues;
  static DisputeRemedyStateEnum valueOf(String name) => _$disputeRemedyStateEnumValueOf(name);
}

