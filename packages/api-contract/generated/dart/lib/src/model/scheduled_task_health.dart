//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'scheduled_task_health.g.dart';

/// ScheduledTaskHealth
///
/// Properties:
/// * [task]
/// * [status]
/// * [lastOutcome]
/// * [lastStartedAt]
/// * [durationMs]
/// * [expectedWithinMinutes]
@BuiltValue()
abstract class ScheduledTaskHealth implements Built<ScheduledTaskHealth, ScheduledTaskHealthBuilder> {
  @BuiltValueField(wireName: r'task')
  String get task;

  @BuiltValueField(wireName: r'status')
  ScheduledTaskHealthStatusEnum get status;
  // enum statusEnum {  HEALTHY,  RUNNING,  FAILED,  OVERDUE,  NO_RUN_RECORDED,  };

  @BuiltValueField(wireName: r'last_outcome')
  String? get lastOutcome;

  @BuiltValueField(wireName: r'last_started_at')
  DateTime? get lastStartedAt;

  @BuiltValueField(wireName: r'duration_ms')
  int? get durationMs;

  @BuiltValueField(wireName: r'expected_within_minutes')
  int get expectedWithinMinutes;

  ScheduledTaskHealth._();

  factory ScheduledTaskHealth([void updates(ScheduledTaskHealthBuilder b)]) = _$ScheduledTaskHealth;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ScheduledTaskHealthBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ScheduledTaskHealth> get serializer => _$ScheduledTaskHealthSerializer();
}

class _$ScheduledTaskHealthSerializer implements PrimitiveSerializer<ScheduledTaskHealth> {
  @override
  final Iterable<Type> types = const [ScheduledTaskHealth, _$ScheduledTaskHealth];

  @override
  final String wireName = r'ScheduledTaskHealth';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ScheduledTaskHealth object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'task';
    yield serializers.serialize(
      object.task,
      specifiedType: const FullType(String),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(ScheduledTaskHealthStatusEnum),
    );
    if (object.lastOutcome != null) {
      yield r'last_outcome';
      yield serializers.serialize(
        object.lastOutcome,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.lastStartedAt != null) {
      yield r'last_started_at';
      yield serializers.serialize(
        object.lastStartedAt,
        specifiedType: const FullType.nullable(DateTime),
      );
    }
    if (object.durationMs != null) {
      yield r'duration_ms';
      yield serializers.serialize(
        object.durationMs,
        specifiedType: const FullType.nullable(int),
      );
    }
    yield r'expected_within_minutes';
    yield serializers.serialize(
      object.expectedWithinMinutes,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ScheduledTaskHealth object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ScheduledTaskHealthBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'task':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.task = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ScheduledTaskHealthStatusEnum),
          ) as ScheduledTaskHealthStatusEnum;
          result.status = valueDes;
          break;
        case r'last_outcome':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.lastOutcome = valueDes;
          break;
        case r'last_started_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.lastStartedAt = valueDes;
          break;
        case r'duration_ms':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.durationMs = valueDes;
          break;
        case r'expected_within_minutes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.expectedWithinMinutes = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ScheduledTaskHealth deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ScheduledTaskHealthBuilder();
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


class ScheduledTaskHealthStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'HEALTHY')
  static const ScheduledTaskHealthStatusEnum HEALTHY = _$scheduledTaskHealthStatusEnum_HEALTHY;
  @BuiltValueEnumConst(wireName: r'RUNNING')
  static const ScheduledTaskHealthStatusEnum RUNNING = _$scheduledTaskHealthStatusEnum_RUNNING;
  @BuiltValueEnumConst(wireName: r'FAILED')
  static const ScheduledTaskHealthStatusEnum FAILED = _$scheduledTaskHealthStatusEnum_FAILED;
  @BuiltValueEnumConst(wireName: r'OVERDUE')
  static const ScheduledTaskHealthStatusEnum OVERDUE = _$scheduledTaskHealthStatusEnum_OVERDUE;
  @BuiltValueEnumConst(wireName: r'NO_RUN_RECORDED')
  static const ScheduledTaskHealthStatusEnum NO_RUN_RECORDED = _$scheduledTaskHealthStatusEnum_NO_RUN_RECORDED;

  static Serializer<ScheduledTaskHealthStatusEnum> get serializer => _$scheduledTaskHealthStatusEnumSerializer;

  const ScheduledTaskHealthStatusEnum._(String name): super(name);

  static BuiltSet<ScheduledTaskHealthStatusEnum> get values => _$scheduledTaskHealthStatusEnumValues;
  static ScheduledTaskHealthStatusEnum valueOf(String name) => _$scheduledTaskHealthStatusEnumValueOf(name);
}

