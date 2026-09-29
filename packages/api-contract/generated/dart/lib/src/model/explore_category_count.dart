//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'explore_category_count.g.dart';

/// ExploreCategoryCount
///
/// Properties:
/// * [id]
/// * [code]
/// * [name]
/// * [vendorListings]
@BuiltValue()
abstract class ExploreCategoryCount implements Built<ExploreCategoryCount, ExploreCategoryCountBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'code')
  String get code;

  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'vendor_listings')
  int get vendorListings;

  ExploreCategoryCount._();

  factory ExploreCategoryCount([void updates(ExploreCategoryCountBuilder b)]) = _$ExploreCategoryCount;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ExploreCategoryCountBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ExploreCategoryCount> get serializer => _$ExploreCategoryCountSerializer();
}

class _$ExploreCategoryCountSerializer implements PrimitiveSerializer<ExploreCategoryCount> {
  @override
  final Iterable<Type> types = const [ExploreCategoryCount, _$ExploreCategoryCount];

  @override
  final String wireName = r'ExploreCategoryCount';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ExploreCategoryCount object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'code';
    yield serializers.serialize(
      object.code,
      specifiedType: const FullType(String),
    );
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
    yield r'vendor_listings';
    yield serializers.serialize(
      object.vendorListings,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ExploreCategoryCount object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ExploreCategoryCountBuilder result,
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
        case r'code':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.code = valueDes;
          break;
        case r'name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.name = valueDes;
          break;
        case r'vendor_listings':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.vendorListings = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ExploreCategoryCount deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ExploreCategoryCountBuilder();
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


