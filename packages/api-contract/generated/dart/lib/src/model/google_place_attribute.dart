//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'google_place_attribute.g.dart';

/// GooglePlaceAttribute
///
/// Properties:
/// * [label]
/// * [available]
@BuiltValue()
abstract class GooglePlaceAttribute implements Built<GooglePlaceAttribute, GooglePlaceAttributeBuilder> {
  @BuiltValueField(wireName: r'label')
  String get label;

  @BuiltValueField(wireName: r'available')
  bool get available;

  GooglePlaceAttribute._();

  factory GooglePlaceAttribute([void updates(GooglePlaceAttributeBuilder b)]) = _$GooglePlaceAttribute;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(GooglePlaceAttributeBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<GooglePlaceAttribute> get serializer => _$GooglePlaceAttributeSerializer();
}

class _$GooglePlaceAttributeSerializer implements PrimitiveSerializer<GooglePlaceAttribute> {
  @override
  final Iterable<Type> types = const [GooglePlaceAttribute, _$GooglePlaceAttribute];

  @override
  final String wireName = r'GooglePlaceAttribute';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    GooglePlaceAttribute object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'label';
    yield serializers.serialize(
      object.label,
      specifiedType: const FullType(String),
    );
    yield r'available';
    yield serializers.serialize(
      object.available,
      specifiedType: const FullType(bool),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    GooglePlaceAttribute object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required GooglePlaceAttributeBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'label':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.label = valueDes;
          break;
        case r'available':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.available = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  GooglePlaceAttribute deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = GooglePlaceAttributeBuilder();
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


