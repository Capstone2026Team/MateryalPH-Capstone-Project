//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'feature_availability.g.dart';

/// FeatureAvailability
///
/// Properties:
/// * [enabled]
/// * [status]
/// * [message]
@BuiltValue()
abstract class FeatureAvailability implements Built<FeatureAvailability, FeatureAvailabilityBuilder> {
  @BuiltValueField(wireName: r'enabled')
  bool get enabled;

  @BuiltValueField(wireName: r'status')
  FeatureAvailabilityStatusEnum get status;
  // enum statusEnum {  NOT_YET_AVAILABLE,  AVAILABLE,  };

  @BuiltValueField(wireName: r'message')
  String get message;

  FeatureAvailability._();

  factory FeatureAvailability([void updates(FeatureAvailabilityBuilder b)]) = _$FeatureAvailability;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(FeatureAvailabilityBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<FeatureAvailability> get serializer => _$FeatureAvailabilitySerializer();
}

class _$FeatureAvailabilitySerializer implements PrimitiveSerializer<FeatureAvailability> {
  @override
  final Iterable<Type> types = const [FeatureAvailability, _$FeatureAvailability];

  @override
  final String wireName = r'FeatureAvailability';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    FeatureAvailability object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'enabled';
    yield serializers.serialize(
      object.enabled,
      specifiedType: const FullType(bool),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(FeatureAvailabilityStatusEnum),
    );
    yield r'message';
    yield serializers.serialize(
      object.message,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    FeatureAvailability object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required FeatureAvailabilityBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'enabled':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.enabled = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(FeatureAvailabilityStatusEnum),
          ) as FeatureAvailabilityStatusEnum;
          result.status = valueDes;
          break;
        case r'message':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.message = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  FeatureAvailability deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = FeatureAvailabilityBuilder();
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


class FeatureAvailabilityStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'NOT_YET_AVAILABLE')
  static const FeatureAvailabilityStatusEnum NOT_YET_AVAILABLE = _$featureAvailabilityStatusEnum_NOT_YET_AVAILABLE;
  @BuiltValueEnumConst(wireName: r'AVAILABLE')
  static const FeatureAvailabilityStatusEnum AVAILABLE = _$featureAvailabilityStatusEnum_AVAILABLE;

  static Serializer<FeatureAvailabilityStatusEnum> get serializer => _$featureAvailabilityStatusEnumSerializer;

  const FeatureAvailabilityStatusEnum._(String name): super(name);

  static BuiltSet<FeatureAvailabilityStatusEnum> get values => _$featureAvailabilityStatusEnumValues;
  static FeatureAvailabilityStatusEnum valueOf(String name) => _$featureAvailabilityStatusEnumValueOf(name);
}

