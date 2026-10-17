//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'dashboard_response_time.g.dart';

/// DashboardResponseTime
///
/// Properties:
/// * [meanSeconds]
/// * [medianSeconds]
/// * [p90Seconds]
/// * [answered]
/// * [unanswered]
@BuiltValue()
abstract class DashboardResponseTime implements Built<DashboardResponseTime, DashboardResponseTimeBuilder> {
  @BuiltValueField(wireName: r'mean_seconds')
  int? get meanSeconds;

  @BuiltValueField(wireName: r'median_seconds')
  int? get medianSeconds;

  @BuiltValueField(wireName: r'p90_seconds')
  int? get p90Seconds;

  @BuiltValueField(wireName: r'answered')
  int get answered;

  @BuiltValueField(wireName: r'unanswered')
  int get unanswered;

  DashboardResponseTime._();

  factory DashboardResponseTime([void updates(DashboardResponseTimeBuilder b)]) = _$DashboardResponseTime;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(DashboardResponseTimeBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<DashboardResponseTime> get serializer => _$DashboardResponseTimeSerializer();
}

class _$DashboardResponseTimeSerializer implements PrimitiveSerializer<DashboardResponseTime> {
  @override
  final Iterable<Type> types = const [DashboardResponseTime, _$DashboardResponseTime];

  @override
  final String wireName = r'DashboardResponseTime';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    DashboardResponseTime object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.meanSeconds != null) {
      yield r'mean_seconds';
      yield serializers.serialize(
        object.meanSeconds,
        specifiedType: const FullType.nullable(int),
      );
    }
    if (object.medianSeconds != null) {
      yield r'median_seconds';
      yield serializers.serialize(
        object.medianSeconds,
        specifiedType: const FullType.nullable(int),
      );
    }
    if (object.p90Seconds != null) {
      yield r'p90_seconds';
      yield serializers.serialize(
        object.p90Seconds,
        specifiedType: const FullType.nullable(int),
      );
    }
    yield r'answered';
    yield serializers.serialize(
      object.answered,
      specifiedType: const FullType(int),
    );
    yield r'unanswered';
    yield serializers.serialize(
      object.unanswered,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    DashboardResponseTime object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required DashboardResponseTimeBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'mean_seconds':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.meanSeconds = valueDes;
          break;
        case r'median_seconds':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.medianSeconds = valueDes;
          break;
        case r'p90_seconds':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.p90Seconds = valueDes;
          break;
        case r'answered':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.answered = valueDes;
          break;
        case r'unanswered':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.unanswered = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  DashboardResponseTime deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = DashboardResponseTimeBuilder();
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


