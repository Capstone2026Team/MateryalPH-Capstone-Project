//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'score_metric.g.dart';

/// ScoreMetric
///
/// Properties:
/// * [key]
/// * [value]
/// * [published]
/// * [sampleCount]
/// * [minimumSample]
/// * [window]
/// * [statusText]
@BuiltValue()
abstract class ScoreMetric implements Built<ScoreMetric, ScoreMetricBuilder> {
  @BuiltValueField(wireName: r'key')
  ScoreMetricKeyEnum get key;
  // enum keyEnum {  VPS,  VCS,  MQS,  OHS,  };

  @BuiltValueField(wireName: r'value')
  String? get value;

  @BuiltValueField(wireName: r'published')
  bool get published;

  @BuiltValueField(wireName: r'sample_count')
  int get sampleCount;

  @BuiltValueField(wireName: r'minimum_sample')
  int get minimumSample;

  @BuiltValueField(wireName: r'window')
  String get window;

  @BuiltValueField(wireName: r'status_text')
  String get statusText;

  ScoreMetric._();

  factory ScoreMetric([void updates(ScoreMetricBuilder b)]) = _$ScoreMetric;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ScoreMetricBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ScoreMetric> get serializer => _$ScoreMetricSerializer();
}

class _$ScoreMetricSerializer implements PrimitiveSerializer<ScoreMetric> {
  @override
  final Iterable<Type> types = const [ScoreMetric, _$ScoreMetric];

  @override
  final String wireName = r'ScoreMetric';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ScoreMetric object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'key';
    yield serializers.serialize(
      object.key,
      specifiedType: const FullType(ScoreMetricKeyEnum),
    );
    if (object.value != null) {
      yield r'value';
      yield serializers.serialize(
        object.value,
        specifiedType: const FullType(String),
      );
    }
    yield r'published';
    yield serializers.serialize(
      object.published,
      specifiedType: const FullType(bool),
    );
    yield r'sample_count';
    yield serializers.serialize(
      object.sampleCount,
      specifiedType: const FullType(int),
    );
    yield r'minimum_sample';
    yield serializers.serialize(
      object.minimumSample,
      specifiedType: const FullType(int),
    );
    yield r'window';
    yield serializers.serialize(
      object.window,
      specifiedType: const FullType(String),
    );
    yield r'status_text';
    yield serializers.serialize(
      object.statusText,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ScoreMetric object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ScoreMetricBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'key':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ScoreMetricKeyEnum),
          ) as ScoreMetricKeyEnum;
          result.key = valueDes;
          break;
        case r'value':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.value = valueDes;
          break;
        case r'published':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.published = valueDes;
          break;
        case r'sample_count':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.sampleCount = valueDes;
          break;
        case r'minimum_sample':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.minimumSample = valueDes;
          break;
        case r'window':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.window = valueDes;
          break;
        case r'status_text':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.statusText = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ScoreMetric deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ScoreMetricBuilder();
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


class ScoreMetricKeyEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'VPS')
  static const ScoreMetricKeyEnum VPS = _$scoreMetricKeyEnum_VPS;
  @BuiltValueEnumConst(wireName: r'VCS')
  static const ScoreMetricKeyEnum VCS = _$scoreMetricKeyEnum_VCS;
  @BuiltValueEnumConst(wireName: r'MQS')
  static const ScoreMetricKeyEnum MQS = _$scoreMetricKeyEnum_MQS;
  @BuiltValueEnumConst(wireName: r'OHS')
  static const ScoreMetricKeyEnum OHS = _$scoreMetricKeyEnum_OHS;

  static Serializer<ScoreMetricKeyEnum> get serializer => _$scoreMetricKeyEnumSerializer;

  const ScoreMetricKeyEnum._(String name): super(name);

  static BuiltSet<ScoreMetricKeyEnum> get values => _$scoreMetricKeyEnumValues;
  static ScoreMetricKeyEnum valueOf(String name) => _$scoreMetricKeyEnumValueOf(name);
}

