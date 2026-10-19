//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'directory_listing.g.dart';

/// DirectoryListing
///
/// Properties:
/// * [id]
/// * [name]
/// * [sku]
/// * [status]
/// * [updatedAt]
/// * [variantCount]
/// * [minPriceCentavos]
/// * [maxPriceCentavos]
/// * [unitCode]
/// * [stock] - Public availability label; never an exact quantity.
/// * [imageUrl] - Short-lived link to the first scanned image.
/// * [imageAlt]
@BuiltValue()
abstract class DirectoryListing implements Built<DirectoryListing, DirectoryListingBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'sku')
  String? get sku;

  @BuiltValueField(wireName: r'status')
  String get status;

  @BuiltValueField(wireName: r'updated_at')
  DateTime get updatedAt;

  @BuiltValueField(wireName: r'variant_count')
  int get variantCount;

  @BuiltValueField(wireName: r'min_price_centavos')
  int? get minPriceCentavos;

  @BuiltValueField(wireName: r'max_price_centavos')
  int? get maxPriceCentavos;

  @BuiltValueField(wireName: r'unit_code')
  String? get unitCode;

  /// Public availability label; never an exact quantity.
  @BuiltValueField(wireName: r'stock')
  DirectoryListingStockEnum get stock;
  // enum stockEnum {  IN_STOCK,  LIMITED_STOCK,  OUT_OF_STOCK,  };

  /// Short-lived link to the first scanned image.
  @BuiltValueField(wireName: r'image_url')
  String? get imageUrl;

  @BuiltValueField(wireName: r'image_alt')
  String? get imageAlt;

  DirectoryListing._();

  factory DirectoryListing([void updates(DirectoryListingBuilder b)]) = _$DirectoryListing;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(DirectoryListingBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<DirectoryListing> get serializer => _$DirectoryListingSerializer();
}

class _$DirectoryListingSerializer implements PrimitiveSerializer<DirectoryListing> {
  @override
  final Iterable<Type> types = const [DirectoryListing, _$DirectoryListing];

  @override
  final String wireName = r'DirectoryListing';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    DirectoryListing object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
    yield r'sku';
    yield object.sku == null ? null : serializers.serialize(
      object.sku,
      specifiedType: const FullType.nullable(String),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(String),
    );
    yield r'updated_at';
    yield serializers.serialize(
      object.updatedAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'variant_count';
    yield serializers.serialize(
      object.variantCount,
      specifiedType: const FullType(int),
    );
    yield r'min_price_centavos';
    yield object.minPriceCentavos == null ? null : serializers.serialize(
      object.minPriceCentavos,
      specifiedType: const FullType.nullable(int),
    );
    yield r'max_price_centavos';
    yield object.maxPriceCentavos == null ? null : serializers.serialize(
      object.maxPriceCentavos,
      specifiedType: const FullType.nullable(int),
    );
    yield r'unit_code';
    yield object.unitCode == null ? null : serializers.serialize(
      object.unitCode,
      specifiedType: const FullType.nullable(String),
    );
    yield r'stock';
    yield serializers.serialize(
      object.stock,
      specifiedType: const FullType(DirectoryListingStockEnum),
    );
    yield r'image_url';
    yield object.imageUrl == null ? null : serializers.serialize(
      object.imageUrl,
      specifiedType: const FullType.nullable(String),
    );
    yield r'image_alt';
    yield object.imageAlt == null ? null : serializers.serialize(
      object.imageAlt,
      specifiedType: const FullType.nullable(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    DirectoryListing object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required DirectoryListingBuilder result,
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
            specifiedType: const FullType(String),
          ) as String;
          result.name = valueDes;
          break;
        case r'sku':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.sku = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.status = valueDes;
          break;
        case r'updated_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.updatedAt = valueDes;
          break;
        case r'variant_count':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.variantCount = valueDes;
          break;
        case r'min_price_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.minPriceCentavos = valueDes;
          break;
        case r'max_price_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.maxPriceCentavos = valueDes;
          break;
        case r'unit_code':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.unitCode = valueDes;
          break;
        case r'stock':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DirectoryListingStockEnum),
          ) as DirectoryListingStockEnum;
          result.stock = valueDes;
          break;
        case r'image_url':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.imageUrl = valueDes;
          break;
        case r'image_alt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.imageAlt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  DirectoryListing deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = DirectoryListingBuilder();
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


/// Public availability label; never an exact quantity.
class DirectoryListingStockEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'IN_STOCK')
  static const DirectoryListingStockEnum IN_STOCK = _$directoryListingStockEnum_IN_STOCK;
  @BuiltValueEnumConst(wireName: r'LIMITED_STOCK')
  static const DirectoryListingStockEnum LIMITED_STOCK = _$directoryListingStockEnum_LIMITED_STOCK;
  @BuiltValueEnumConst(wireName: r'OUT_OF_STOCK')
  static const DirectoryListingStockEnum OUT_OF_STOCK = _$directoryListingStockEnum_OUT_OF_STOCK;

  static Serializer<DirectoryListingStockEnum> get serializer => _$directoryListingStockEnumSerializer;

  const DirectoryListingStockEnum._(String name): super(name);

  static BuiltSet<DirectoryListingStockEnum> get values => _$directoryListingStockEnumValues;
  static DirectoryListingStockEnum valueOf(String name) => _$directoryListingStockEnumValueOf(name);
}

