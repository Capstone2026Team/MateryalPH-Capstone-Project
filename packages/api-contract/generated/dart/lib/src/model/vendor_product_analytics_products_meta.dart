//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'vendor_product_analytics_products_meta.g.dart';

/// VendorProductAnalyticsProductsMeta
///
/// Properties:
/// * [page]
/// * [perPage]
/// * [total]
/// * [lastPage]
/// * [sort]
@BuiltValue()
abstract class VendorProductAnalyticsProductsMeta implements Built<VendorProductAnalyticsProductsMeta, VendorProductAnalyticsProductsMetaBuilder> {
  @BuiltValueField(wireName: r'page')
  int get page;

  @BuiltValueField(wireName: r'per_page')
  int get perPage;

  @BuiltValueField(wireName: r'total')
  int get total;

  @BuiltValueField(wireName: r'last_page')
  int get lastPage;

  @BuiltValueField(wireName: r'sort')
  VendorProductAnalyticsProductsMetaSortEnum get sort;
  // enum sortEnum {  views,  orders,  conversion,  value,  };

  VendorProductAnalyticsProductsMeta._();

  factory VendorProductAnalyticsProductsMeta([void updates(VendorProductAnalyticsProductsMetaBuilder b)]) = _$VendorProductAnalyticsProductsMeta;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(VendorProductAnalyticsProductsMetaBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<VendorProductAnalyticsProductsMeta> get serializer => _$VendorProductAnalyticsProductsMetaSerializer();
}

class _$VendorProductAnalyticsProductsMetaSerializer implements PrimitiveSerializer<VendorProductAnalyticsProductsMeta> {
  @override
  final Iterable<Type> types = const [VendorProductAnalyticsProductsMeta, _$VendorProductAnalyticsProductsMeta];

  @override
  final String wireName = r'VendorProductAnalyticsProductsMeta';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    VendorProductAnalyticsProductsMeta object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'page';
    yield serializers.serialize(
      object.page,
      specifiedType: const FullType(int),
    );
    yield r'per_page';
    yield serializers.serialize(
      object.perPage,
      specifiedType: const FullType(int),
    );
    yield r'total';
    yield serializers.serialize(
      object.total,
      specifiedType: const FullType(int),
    );
    yield r'last_page';
    yield serializers.serialize(
      object.lastPage,
      specifiedType: const FullType(int),
    );
    yield r'sort';
    yield serializers.serialize(
      object.sort,
      specifiedType: const FullType(VendorProductAnalyticsProductsMetaSortEnum),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    VendorProductAnalyticsProductsMeta object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required VendorProductAnalyticsProductsMetaBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'page':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.page = valueDes;
          break;
        case r'per_page':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.perPage = valueDes;
          break;
        case r'total':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.total = valueDes;
          break;
        case r'last_page':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.lastPage = valueDes;
          break;
        case r'sort':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(VendorProductAnalyticsProductsMetaSortEnum),
          ) as VendorProductAnalyticsProductsMetaSortEnum;
          result.sort = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  VendorProductAnalyticsProductsMeta deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = VendorProductAnalyticsProductsMetaBuilder();
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


class VendorProductAnalyticsProductsMetaSortEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'views')
  static const VendorProductAnalyticsProductsMetaSortEnum views = _$vendorProductAnalyticsProductsMetaSortEnum_views;
  @BuiltValueEnumConst(wireName: r'orders')
  static const VendorProductAnalyticsProductsMetaSortEnum orders = _$vendorProductAnalyticsProductsMetaSortEnum_orders;
  @BuiltValueEnumConst(wireName: r'conversion')
  static const VendorProductAnalyticsProductsMetaSortEnum conversion = _$vendorProductAnalyticsProductsMetaSortEnum_conversion;
  @BuiltValueEnumConst(wireName: r'value')
  static const VendorProductAnalyticsProductsMetaSortEnum value = _$vendorProductAnalyticsProductsMetaSortEnum_value;

  static Serializer<VendorProductAnalyticsProductsMetaSortEnum> get serializer => _$vendorProductAnalyticsProductsMetaSortEnumSerializer;

  const VendorProductAnalyticsProductsMetaSortEnum._(String name): super(name);

  static BuiltSet<VendorProductAnalyticsProductsMetaSortEnum> get values => _$vendorProductAnalyticsProductsMetaSortEnumValues;
  static VendorProductAnalyticsProductsMetaSortEnum valueOf(String name) => _$vendorProductAnalyticsProductsMetaSortEnumValueOf(name);
}

