//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'budget_override_record.g.dart';

/// BudgetOverrideRecord
///
/// Properties:
/// * [id]
/// * [project]
/// * [workPackage]
/// * [orderReference]
/// * [priorBudgetCentavos]
/// * [orderAmountCentavos]
/// * [overageCentavos]
/// * [reason]
/// * [actor]
/// * [recordedAt]
@BuiltValue()
abstract class BudgetOverrideRecord implements Built<BudgetOverrideRecord, BudgetOverrideRecordBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'project')
  String get project;

  @BuiltValueField(wireName: r'work_package')
  String get workPackage;

  @BuiltValueField(wireName: r'order_reference')
  String? get orderReference;

  @BuiltValueField(wireName: r'prior_budget_centavos')
  int get priorBudgetCentavos;

  @BuiltValueField(wireName: r'order_amount_centavos')
  int get orderAmountCentavos;

  @BuiltValueField(wireName: r'overage_centavos')
  int get overageCentavos;

  @BuiltValueField(wireName: r'reason')
  String get reason;

  @BuiltValueField(wireName: r'actor')
  String get actor;

  @BuiltValueField(wireName: r'recorded_at')
  DateTime get recordedAt;

  BudgetOverrideRecord._();

  factory BudgetOverrideRecord([void updates(BudgetOverrideRecordBuilder b)]) = _$BudgetOverrideRecord;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(BudgetOverrideRecordBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<BudgetOverrideRecord> get serializer => _$BudgetOverrideRecordSerializer();
}

class _$BudgetOverrideRecordSerializer implements PrimitiveSerializer<BudgetOverrideRecord> {
  @override
  final Iterable<Type> types = const [BudgetOverrideRecord, _$BudgetOverrideRecord];

  @override
  final String wireName = r'BudgetOverrideRecord';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    BudgetOverrideRecord object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'project';
    yield serializers.serialize(
      object.project,
      specifiedType: const FullType(String),
    );
    yield r'work_package';
    yield serializers.serialize(
      object.workPackage,
      specifiedType: const FullType(String),
    );
    if (object.orderReference != null) {
      yield r'order_reference';
      yield serializers.serialize(
        object.orderReference,
        specifiedType: const FullType.nullable(String),
      );
    }
    yield r'prior_budget_centavos';
    yield serializers.serialize(
      object.priorBudgetCentavos,
      specifiedType: const FullType(int),
    );
    yield r'order_amount_centavos';
    yield serializers.serialize(
      object.orderAmountCentavos,
      specifiedType: const FullType(int),
    );
    yield r'overage_centavos';
    yield serializers.serialize(
      object.overageCentavos,
      specifiedType: const FullType(int),
    );
    yield r'reason';
    yield serializers.serialize(
      object.reason,
      specifiedType: const FullType(String),
    );
    yield r'actor';
    yield serializers.serialize(
      object.actor,
      specifiedType: const FullType(String),
    );
    yield r'recorded_at';
    yield serializers.serialize(
      object.recordedAt,
      specifiedType: const FullType(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    BudgetOverrideRecord object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required BudgetOverrideRecordBuilder result,
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
        case r'project':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.project = valueDes;
          break;
        case r'work_package':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.workPackage = valueDes;
          break;
        case r'order_reference':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.orderReference = valueDes;
          break;
        case r'prior_budget_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.priorBudgetCentavos = valueDes;
          break;
        case r'order_amount_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.orderAmountCentavos = valueDes;
          break;
        case r'overage_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.overageCentavos = valueDes;
          break;
        case r'reason':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.reason = valueDes;
          break;
        case r'actor':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.actor = valueDes;
          break;
        case r'recorded_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.recordedAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  BudgetOverrideRecord deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = BudgetOverrideRecordBuilder();
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


