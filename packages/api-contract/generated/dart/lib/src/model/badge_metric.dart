//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'badge_metric.g.dart';

/// BadgeMetric
///
/// Properties:
/// * [key]
/// * [value]
/// * [sampleCount]
/// * [window]
/// * [definition]
@BuiltValue()
abstract class BadgeMetric implements Built<BadgeMetric, BadgeMetricBuilder> {
  @BuiltValueField(wireName: r'key')
  BadgeMetricKeyEnum get key;
  // enum keyEnum {  CRR,  FRR,  };

  @BuiltValueField(wireName: r'value')
  String? get value;

  @BuiltValueField(wireName: r'sample_count')
  int get sampleCount;

  @BuiltValueField(wireName: r'window')
  String get window;

  @BuiltValueField(wireName: r'definition')
  String get definition;

  BadgeMetric._();

  factory BadgeMetric([void updates(BadgeMetricBuilder b)]) = _$BadgeMetric;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(BadgeMetricBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<BadgeMetric> get serializer => _$BadgeMetricSerializer();
}

class _$BadgeMetricSerializer implements PrimitiveSerializer<BadgeMetric> {
  @override
  final Iterable<Type> types = const [BadgeMetric, _$BadgeMetric];

  @override
  final String wireName = r'BadgeMetric';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    BadgeMetric object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'key';
    yield serializers.serialize(
      object.key,
      specifiedType: const FullType(BadgeMetricKeyEnum),
    );
    if (object.value != null) {
      yield r'value';
      yield serializers.serialize(
        object.value,
        specifiedType: const FullType(String),
      );
    }
    yield r'sample_count';
    yield serializers.serialize(
      object.sampleCount,
      specifiedType: const FullType(int),
    );
    yield r'window';
    yield serializers.serialize(
      object.window,
      specifiedType: const FullType(String),
    );
    yield r'definition';
    yield serializers.serialize(
      object.definition,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    BadgeMetric object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required BadgeMetricBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'key':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BadgeMetricKeyEnum),
          ) as BadgeMetricKeyEnum;
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
        case r'sample_count':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.sampleCount = valueDes;
          break;
        case r'window':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.window = valueDes;
          break;
        case r'definition':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.definition = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  BadgeMetric deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = BadgeMetricBuilder();
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


class BadgeMetricKeyEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'CRR')
  static const BadgeMetricKeyEnum CRR = _$badgeMetricKeyEnum_CRR;
  @BuiltValueEnumConst(wireName: r'FRR')
  static const BadgeMetricKeyEnum FRR = _$badgeMetricKeyEnum_FRR;

  static Serializer<BadgeMetricKeyEnum> get serializer => _$badgeMetricKeyEnumSerializer;

  const BadgeMetricKeyEnum._(String name): super(name);

  static BuiltSet<BadgeMetricKeyEnum> get values => _$badgeMetricKeyEnumValues;
  static BadgeMetricKeyEnum valueOf(String name) => _$badgeMetricKeyEnumValueOf(name);
}

