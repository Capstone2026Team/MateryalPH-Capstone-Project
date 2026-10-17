//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:materyalph_api_client/src/model/comparable_specification_attributes_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'comparable_specification.g.dart';

/// ComparableSpecification
///
/// Properties:
/// * [brand]
/// * [model]
/// * [attributes]
@BuiltValue()
abstract class ComparableSpecification implements Built<ComparableSpecification, ComparableSpecificationBuilder> {
  @BuiltValueField(wireName: r'brand')
  String? get brand;

  @BuiltValueField(wireName: r'model')
  String? get model;

  @BuiltValueField(wireName: r'attributes')
  BuiltList<ComparableSpecificationAttributesInner> get attributes;

  ComparableSpecification._();

  factory ComparableSpecification([void updates(ComparableSpecificationBuilder b)]) = _$ComparableSpecification;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ComparableSpecificationBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ComparableSpecification> get serializer => _$ComparableSpecificationSerializer();
}

class _$ComparableSpecificationSerializer implements PrimitiveSerializer<ComparableSpecification> {
  @override
  final Iterable<Type> types = const [ComparableSpecification, _$ComparableSpecification];

  @override
  final String wireName = r'ComparableSpecification';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ComparableSpecification object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.brand != null) {
      yield r'brand';
      yield serializers.serialize(
        object.brand,
        specifiedType: const FullType(String),
      );
    }
    if (object.model != null) {
      yield r'model';
      yield serializers.serialize(
        object.model,
        specifiedType: const FullType(String),
      );
    }
    yield r'attributes';
    yield serializers.serialize(
      object.attributes,
      specifiedType: const FullType(BuiltList, [FullType(ComparableSpecificationAttributesInner)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ComparableSpecification object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ComparableSpecificationBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'brand':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.brand = valueDes;
          break;
        case r'model':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.model = valueDes;
          break;
        case r'attributes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(ComparableSpecificationAttributesInner)]),
          ) as BuiltList<ComparableSpecificationAttributesInner>;
          result.attributes.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ComparableSpecification deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ComparableSpecificationBuilder();
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


