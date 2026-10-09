//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'geo_response_time.g.dart';

/// GeoResponseTime
///
/// Properties:
/// * [suppressed]
/// * [reason]
/// * [meanSeconds]
/// * [medianSeconds]
/// * [p90Seconds]
/// * [answered]
/// * [unanswered]
@BuiltValue()
abstract class GeoResponseTime implements Built<GeoResponseTime, GeoResponseTimeBuilder> {
  @BuiltValueField(wireName: r'suppressed')
  bool get suppressed;

  @BuiltValueField(wireName: r'reason')
  String? get reason;

  @BuiltValueField(wireName: r'mean_seconds')
  int? get meanSeconds;

  @BuiltValueField(wireName: r'median_seconds')
  int? get medianSeconds;

  @BuiltValueField(wireName: r'p90_seconds')
  int? get p90Seconds;

  @BuiltValueField(wireName: r'answered')
  int? get answered;

  @BuiltValueField(wireName: r'unanswered')
  int? get unanswered;

  GeoResponseTime._();

  factory GeoResponseTime([void updates(GeoResponseTimeBuilder b)]) = _$GeoResponseTime;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(GeoResponseTimeBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<GeoResponseTime> get serializer => _$GeoResponseTimeSerializer();
}

class _$GeoResponseTimeSerializer implements PrimitiveSerializer<GeoResponseTime> {
  @override
  final Iterable<Type> types = const [GeoResponseTime, _$GeoResponseTime];

  @override
  final String wireName = r'GeoResponseTime';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    GeoResponseTime object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'suppressed';
    yield serializers.serialize(
      object.suppressed,
      specifiedType: const FullType(bool),
    );
    if (object.reason != null) {
      yield r'reason';
      yield serializers.serialize(
        object.reason,
        specifiedType: const FullType.nullable(String),
      );
    }
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
    if (object.answered != null) {
      yield r'answered';
      yield serializers.serialize(
        object.answered,
        specifiedType: const FullType.nullable(int),
      );
    }
    if (object.unanswered != null) {
      yield r'unanswered';
      yield serializers.serialize(
        object.unanswered,
        specifiedType: const FullType.nullable(int),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    GeoResponseTime object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required GeoResponseTimeBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'suppressed':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.suppressed = valueDes;
          break;
        case r'reason':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.reason = valueDes;
          break;
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
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.answered = valueDes;
          break;
        case r'unanswered':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
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
  GeoResponseTime deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = GeoResponseTimeBuilder();
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


