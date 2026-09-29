//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'listing_category_ref.g.dart';

/// ListingCategoryRef
///
/// Properties:
/// * [id]
/// * [name]
@BuiltValue()
abstract class ListingCategoryRef implements Built<ListingCategoryRef, ListingCategoryRefBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'name')
  String? get name;

  ListingCategoryRef._();

  factory ListingCategoryRef([void updates(ListingCategoryRefBuilder b)]) = _$ListingCategoryRef;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ListingCategoryRefBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ListingCategoryRef> get serializer => _$ListingCategoryRefSerializer();
}

class _$ListingCategoryRefSerializer implements PrimitiveSerializer<ListingCategoryRef> {
  @override
  final Iterable<Type> types = const [ListingCategoryRef, _$ListingCategoryRef];

  @override
  final String wireName = r'ListingCategoryRef';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ListingCategoryRef object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'name';
    yield object.name == null ? null : serializers.serialize(
      object.name,
      specifiedType: const FullType.nullable(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ListingCategoryRef object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ListingCategoryRefBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.id = valueDes;
          break;
        case r'name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.name = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ListingCategoryRef deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ListingCategoryRefBuilder();
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


