//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'vendor_earnings_product.g.dart';

/// VendorEarningsProduct
///
/// Properties:
/// * [listingId]
/// * [name]
/// * [category]
/// * [sku]
/// * [orders]
/// * [valueCentavos]
/// * [vatCentavos]
@BuiltValue()
abstract class VendorEarningsProduct implements Built<VendorEarningsProduct, VendorEarningsProductBuilder> {
  @BuiltValueField(wireName: r'listing_id')
  String? get listingId;

  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'category')
  String get category;

  @BuiltValueField(wireName: r'sku')
  String? get sku;

  @BuiltValueField(wireName: r'orders')
  int get orders;

  @BuiltValueField(wireName: r'value_centavos')
  int get valueCentavos;

  @BuiltValueField(wireName: r'vat_centavos')
  int get vatCentavos;

  VendorEarningsProduct._();

  factory VendorEarningsProduct([void updates(VendorEarningsProductBuilder b)]) = _$VendorEarningsProduct;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(VendorEarningsProductBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<VendorEarningsProduct> get serializer => _$VendorEarningsProductSerializer();
}

class _$VendorEarningsProductSerializer implements PrimitiveSerializer<VendorEarningsProduct> {
  @override
  final Iterable<Type> types = const [VendorEarningsProduct, _$VendorEarningsProduct];

  @override
  final String wireName = r'VendorEarningsProduct';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    VendorEarningsProduct object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'listing_id';
    yield object.listingId == null ? null : serializers.serialize(
      object.listingId,
      specifiedType: const FullType.nullable(String),
    );
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
    yield r'category';
    yield serializers.serialize(
      object.category,
      specifiedType: const FullType(String),
    );
    yield r'sku';
    yield object.sku == null ? null : serializers.serialize(
      object.sku,
      specifiedType: const FullType.nullable(String),
    );
    yield r'orders';
    yield serializers.serialize(
      object.orders,
      specifiedType: const FullType(int),
    );
    yield r'value_centavos';
    yield serializers.serialize(
      object.valueCentavos,
      specifiedType: const FullType(int),
    );
    yield r'vat_centavos';
    yield serializers.serialize(
      object.vatCentavos,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    VendorEarningsProduct object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required VendorEarningsProductBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'listing_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.listingId = valueDes;
          break;
        case r'name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.name = valueDes;
          break;
        case r'category':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.category = valueDes;
          break;
        case r'sku':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.sku = valueDes;
          break;
        case r'orders':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.orders = valueDes;
          break;
        case r'value_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.valueCentavos = valueDes;
          break;
        case r'vat_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.vatCentavos = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  VendorEarningsProduct deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = VendorEarningsProductBuilder();
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


