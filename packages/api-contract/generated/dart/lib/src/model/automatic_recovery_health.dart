//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'automatic_recovery_health.g.dart';

/// AutomaticRecoveryHealth
///
/// Properties:
/// * [status]
/// * [maxCycles]
/// * [delaysMinutes] - Recovery cooldowns: 15, 60 and 360 minutes after the most recent failure; active dispatcher leases can delay eligibility.
/// * [lastStartedAt]
@BuiltValue()
abstract class AutomaticRecoveryHealth implements Built<AutomaticRecoveryHealth, AutomaticRecoveryHealthBuilder> {
  @BuiltValueField(wireName: r'status')
  AutomaticRecoveryHealthStatusEnum get status;
  // enum statusEnum {  HEALTHY,  RUNNING,  FAILED,  OVERDUE,  NO_RUN_RECORDED,  };

  @BuiltValueField(wireName: r'max_cycles')
  AutomaticRecoveryHealthMaxCyclesEnum get maxCycles;
  // enum maxCyclesEnum {  3,  };

  /// Recovery cooldowns: 15, 60 and 360 minutes after the most recent failure; active dispatcher leases can delay eligibility.
  @BuiltValueField(wireName: r'delays_minutes')
  BuiltList<int> get delaysMinutes;

  @BuiltValueField(wireName: r'last_started_at')
  DateTime? get lastStartedAt;

  AutomaticRecoveryHealth._();

  factory AutomaticRecoveryHealth([void updates(AutomaticRecoveryHealthBuilder b)]) = _$AutomaticRecoveryHealth;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AutomaticRecoveryHealthBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AutomaticRecoveryHealth> get serializer => _$AutomaticRecoveryHealthSerializer();
}

class _$AutomaticRecoveryHealthSerializer implements PrimitiveSerializer<AutomaticRecoveryHealth> {
  @override
  final Iterable<Type> types = const [AutomaticRecoveryHealth, _$AutomaticRecoveryHealth];

  @override
  final String wireName = r'AutomaticRecoveryHealth';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AutomaticRecoveryHealth object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(AutomaticRecoveryHealthStatusEnum),
    );
    yield r'max_cycles';
    yield serializers.serialize(
      object.maxCycles,
      specifiedType: const FullType(AutomaticRecoveryHealthMaxCyclesEnum),
    );
    yield r'delays_minutes';
    yield serializers.serialize(
      object.delaysMinutes,
      specifiedType: const FullType(BuiltList, [FullType(int)]),
    );
    yield r'last_started_at';
    yield object.lastStartedAt == null ? null : serializers.serialize(
      object.lastStartedAt,
      specifiedType: const FullType.nullable(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AutomaticRecoveryHealth object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AutomaticRecoveryHealthBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AutomaticRecoveryHealthStatusEnum),
          ) as AutomaticRecoveryHealthStatusEnum;
          result.status = valueDes;
          break;
        case r'max_cycles':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AutomaticRecoveryHealthMaxCyclesEnum),
          ) as AutomaticRecoveryHealthMaxCyclesEnum;
          result.maxCycles = valueDes;
          break;
        case r'delays_minutes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(int)]),
          ) as BuiltList<int>;
          result.delaysMinutes.replace(valueDes);
          break;
        case r'last_started_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.lastStartedAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AutomaticRecoveryHealth deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AutomaticRecoveryHealthBuilder();
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


class AutomaticRecoveryHealthStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'HEALTHY')
  static const AutomaticRecoveryHealthStatusEnum HEALTHY = _$automaticRecoveryHealthStatusEnum_HEALTHY;
  @BuiltValueEnumConst(wireName: r'RUNNING')
  static const AutomaticRecoveryHealthStatusEnum RUNNING = _$automaticRecoveryHealthStatusEnum_RUNNING;
  @BuiltValueEnumConst(wireName: r'FAILED')
  static const AutomaticRecoveryHealthStatusEnum FAILED = _$automaticRecoveryHealthStatusEnum_FAILED;
  @BuiltValueEnumConst(wireName: r'OVERDUE')
  static const AutomaticRecoveryHealthStatusEnum OVERDUE = _$automaticRecoveryHealthStatusEnum_OVERDUE;
  @BuiltValueEnumConst(wireName: r'NO_RUN_RECORDED')
  static const AutomaticRecoveryHealthStatusEnum NO_RUN_RECORDED = _$automaticRecoveryHealthStatusEnum_NO_RUN_RECORDED;

  static Serializer<AutomaticRecoveryHealthStatusEnum> get serializer => _$automaticRecoveryHealthStatusEnumSerializer;

  const AutomaticRecoveryHealthStatusEnum._(String name): super(name);

  static BuiltSet<AutomaticRecoveryHealthStatusEnum> get values => _$automaticRecoveryHealthStatusEnumValues;
  static AutomaticRecoveryHealthStatusEnum valueOf(String name) => _$automaticRecoveryHealthStatusEnumValueOf(name);
}

class AutomaticRecoveryHealthMaxCyclesEnum extends EnumClass {

  @BuiltValueEnumConst(wireNumber: 3)
  static const AutomaticRecoveryHealthMaxCyclesEnum number3 = _$automaticRecoveryHealthMaxCyclesEnum_number3;

  static Serializer<AutomaticRecoveryHealthMaxCyclesEnum> get serializer => _$automaticRecoveryHealthMaxCyclesEnumSerializer;

  const AutomaticRecoveryHealthMaxCyclesEnum._(String name): super(name);

  static BuiltSet<AutomaticRecoveryHealthMaxCyclesEnum> get values => _$automaticRecoveryHealthMaxCyclesEnumValues;
  static AutomaticRecoveryHealthMaxCyclesEnum valueOf(String name) => _$automaticRecoveryHealthMaxCyclesEnumValueOf(name);
}

