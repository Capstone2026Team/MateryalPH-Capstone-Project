//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'catalog_listing_create.g.dart';

/// CatalogListingCreate
///
/// Properties:
/// * [displayName]
/// * [vendorSku]
@BuiltValue()
abstract class CatalogListingCreate implements Built<CatalogListingCreate, CatalogListingCreateBuilder> {
  @BuiltValueField(wireName: r'display_name')
  String get displayName;

  @BuiltValueField(wireName: r'vendor_sku')
  String get vendorSku;

  CatalogListingCreate._();

  factory CatalogListingCreate([void updates(CatalogListingCreateBuilder b)]) = _$CatalogListingCreate;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CatalogListingCreateBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CatalogListingCreate> get serializer => _$CatalogListingCreateSerializer();
}

class _$CatalogListingCreateSerializer implements PrimitiveSerializer<CatalogListingCreate> {
  @override
  final Iterable<Type> types = const [CatalogListingCreate, _$CatalogListingCreate];

  @override
  final String wireName = r'CatalogListingCreate';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CatalogListingCreate object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'display_name';
    yield serializers.serialize(
      object.displayName,
      specifiedType: const FullType(String),
    );
    yield r'vendor_sku';
    yield serializers.serialize(
      object.vendorSku,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CatalogListingCreate object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CatalogListingCreateBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'display_name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.displayName = valueDes;
          break;
        case r'vendor_sku':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.vendorSku = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CatalogListingCreate deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CatalogListingCreateBuilder();
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


