//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'comparable_specification_attributes_inner.g.dart';

/// ComparableSpecificationAttributesInner
///
/// Properties:
/// * [key]
/// * [value]
@BuiltValue()
abstract class ComparableSpecificationAttributesInner implements Built<ComparableSpecificationAttributesInner, ComparableSpecificationAttributesInnerBuilder> {
  @BuiltValueField(wireName: r'key')
  String get key;

  @BuiltValueField(wireName: r'value')
  String get value;

  ComparableSpecificationAttributesInner._();

  factory ComparableSpecificationAttributesInner([void updates(ComparableSpecificationAttributesInnerBuilder b)]) = _$ComparableSpecificationAttributesInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ComparableSpecificationAttributesInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ComparableSpecificationAttributesInner> get serializer => _$ComparableSpecificationAttributesInnerSerializer();
}

class _$ComparableSpecificationAttributesInnerSerializer implements PrimitiveSerializer<ComparableSpecificationAttributesInner> {
  @override
  final Iterable<Type> types = const [ComparableSpecificationAttributesInner, _$ComparableSpecificationAttributesInner];

  @override
  final String wireName = r'ComparableSpecificationAttributesInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ComparableSpecificationAttributesInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'key';
    yield serializers.serialize(
      object.key,
      specifiedType: const FullType(String),
    );
    yield r'value';
    yield serializers.serialize(
      object.value,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ComparableSpecificationAttributesInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ComparableSpecificationAttributesInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'key':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.key = valueDes;
          break;
        case r'value':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.value = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ComparableSpecificationAttributesInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ComparableSpecificationAttributesInnerBuilder();
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


