//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:materyalph_api_client/src/model/dashboard_rate.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'product_analytics_row.g.dart';

/// One store product with its period measures. conversion_lower_bound is the Wilson 95% lower bound of converted ÷ viewers. value_centavos is null unless the caller holds finance.view (Owner).
///
/// Properties:
/// * [listingId]
/// * [name]
/// * [sku]
/// * [category]
/// * [status]
/// * [stockStatus]
/// * [views]
/// * [previousViews]
/// * [viewsChangePercent]
/// * [viewers]
/// * [converted]
/// * [conversion]
/// * [conversionLowerBound]
/// * [orders]
/// * [previousOrders]
/// * [buyers]
/// * [valueCentavos]
/// * [segment]
/// * [rankViews]
/// * [rankOrders]
@BuiltValue()
abstract class ProductAnalyticsRow implements Built<ProductAnalyticsRow, ProductAnalyticsRowBuilder> {
  @BuiltValueField(wireName: r'listing_id')
  String get listingId;

  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'sku')
  String? get sku;

  @BuiltValueField(wireName: r'category')
  String get category;

  @BuiltValueField(wireName: r'status')
  String? get status;

  @BuiltValueField(wireName: r'stock_status')
  ProductAnalyticsRowStockStatusEnum get stockStatus;
  // enum stockStatusEnum {  IN_STOCK,  LIMITED_STOCK,  OUT_OF_STOCK,  };

  @BuiltValueField(wireName: r'views')
  int get views;

  @BuiltValueField(wireName: r'previous_views')
  int get previousViews;

  @BuiltValueField(wireName: r'views_change_percent')
  num? get viewsChangePercent;

  @BuiltValueField(wireName: r'viewers')
  int get viewers;

  @BuiltValueField(wireName: r'converted')
  int get converted;

  @BuiltValueField(wireName: r'conversion')
  DashboardRate get conversion;

  @BuiltValueField(wireName: r'conversion_lower_bound')
  num? get conversionLowerBound;

  @BuiltValueField(wireName: r'orders')
  int get orders;

  @BuiltValueField(wireName: r'previous_orders')
  int get previousOrders;

  @BuiltValueField(wireName: r'buyers')
  int get buyers;

  @BuiltValueField(wireName: r'value_centavos')
  int? get valueCentavos;

  @BuiltValueField(wireName: r'segment')
  String? get segment;

  @BuiltValueField(wireName: r'rank_views')
  int? get rankViews;

  @BuiltValueField(wireName: r'rank_orders')
  int? get rankOrders;

  ProductAnalyticsRow._();

  factory ProductAnalyticsRow([void updates(ProductAnalyticsRowBuilder b)]) = _$ProductAnalyticsRow;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ProductAnalyticsRowBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ProductAnalyticsRow> get serializer => _$ProductAnalyticsRowSerializer();
}

class _$ProductAnalyticsRowSerializer implements PrimitiveSerializer<ProductAnalyticsRow> {
  @override
  final Iterable<Type> types = const [ProductAnalyticsRow, _$ProductAnalyticsRow];

  @override
  final String wireName = r'ProductAnalyticsRow';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ProductAnalyticsRow object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'listing_id';
    yield serializers.serialize(
      object.listingId,
      specifiedType: const FullType(String),
    );
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
    if (object.sku != null) {
      yield r'sku';
      yield serializers.serialize(
        object.sku,
        specifiedType: const FullType.nullable(String),
      );
    }
    yield r'category';
    yield serializers.serialize(
      object.category,
      specifiedType: const FullType(String),
    );
    if (object.status != null) {
      yield r'status';
      yield serializers.serialize(
        object.status,
        specifiedType: const FullType.nullable(String),
      );
    }
    yield r'stock_status';
    yield serializers.serialize(
      object.stockStatus,
      specifiedType: const FullType(ProductAnalyticsRowStockStatusEnum),
    );
    yield r'views';
    yield serializers.serialize(
      object.views,
      specifiedType: const FullType(int),
    );
    yield r'previous_views';
    yield serializers.serialize(
      object.previousViews,
      specifiedType: const FullType(int),
    );
    if (object.viewsChangePercent != null) {
      yield r'views_change_percent';
      yield serializers.serialize(
        object.viewsChangePercent,
        specifiedType: const FullType.nullable(num),
      );
    }
    yield r'viewers';
    yield serializers.serialize(
      object.viewers,
      specifiedType: const FullType(int),
    );
    yield r'converted';
    yield serializers.serialize(
      object.converted,
      specifiedType: const FullType(int),
    );
    yield r'conversion';
    yield serializers.serialize(
      object.conversion,
      specifiedType: const FullType(DashboardRate),
    );
    if (object.conversionLowerBound != null) {
      yield r'conversion_lower_bound';
      yield serializers.serialize(
        object.conversionLowerBound,
        specifiedType: const FullType.nullable(num),
      );
    }
    yield r'orders';
    yield serializers.serialize(
      object.orders,
      specifiedType: const FullType(int),
    );
    yield r'previous_orders';
    yield serializers.serialize(
      object.previousOrders,
      specifiedType: const FullType(int),
    );
    yield r'buyers';
    yield serializers.serialize(
      object.buyers,
      specifiedType: const FullType(int),
    );
    if (object.valueCentavos != null) {
      yield r'value_centavos';
      yield serializers.serialize(
        object.valueCentavos,
        specifiedType: const FullType.nullable(int),
      );
    }
    if (object.segment != null) {
      yield r'segment';
      yield serializers.serialize(
        object.segment,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.rankViews != null) {
      yield r'rank_views';
      yield serializers.serialize(
        object.rankViews,
        specifiedType: const FullType.nullable(int),
      );
    }
    if (object.rankOrders != null) {
      yield r'rank_orders';
      yield serializers.serialize(
        object.rankOrders,
        specifiedType: const FullType.nullable(int),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    ProductAnalyticsRow object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ProductAnalyticsRowBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'listing_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.listingId = valueDes;
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
        case r'category':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.category = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.status = valueDes;
          break;
        case r'stock_status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ProductAnalyticsRowStockStatusEnum),
          ) as ProductAnalyticsRowStockStatusEnum;
          result.stockStatus = valueDes;
          break;
        case r'views':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.views = valueDes;
          break;
        case r'previous_views':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.previousViews = valueDes;
          break;
        case r'views_change_percent':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(num),
          ) as num?;
          if (valueDes == null) continue;
          result.viewsChangePercent = valueDes;
          break;
        case r'viewers':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.viewers = valueDes;
          break;
        case r'converted':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.converted = valueDes;
          break;
        case r'conversion':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DashboardRate),
          ) as DashboardRate;
          result.conversion.replace(valueDes);
          break;
        case r'conversion_lower_bound':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(num),
          ) as num?;
          if (valueDes == null) continue;
          result.conversionLowerBound = valueDes;
          break;
        case r'orders':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.orders = valueDes;
          break;
        case r'previous_orders':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.previousOrders = valueDes;
          break;
        case r'buyers':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.buyers = valueDes;
          break;
        case r'value_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.valueCentavos = valueDes;
          break;
        case r'segment':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.segment = valueDes;
          break;
        case r'rank_views':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.rankViews = valueDes;
          break;
        case r'rank_orders':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.rankOrders = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ProductAnalyticsRow deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ProductAnalyticsRowBuilder();
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


class ProductAnalyticsRowStockStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'IN_STOCK')
  static const ProductAnalyticsRowStockStatusEnum IN_STOCK = _$productAnalyticsRowStockStatusEnum_IN_STOCK;
  @BuiltValueEnumConst(wireName: r'LIMITED_STOCK')
  static const ProductAnalyticsRowStockStatusEnum LIMITED_STOCK = _$productAnalyticsRowStockStatusEnum_LIMITED_STOCK;
  @BuiltValueEnumConst(wireName: r'OUT_OF_STOCK')
  static const ProductAnalyticsRowStockStatusEnum OUT_OF_STOCK = _$productAnalyticsRowStockStatusEnum_OUT_OF_STOCK;

  static Serializer<ProductAnalyticsRowStockStatusEnum> get serializer => _$productAnalyticsRowStockStatusEnumSerializer;

  const ProductAnalyticsRowStockStatusEnum._(String name): super(name);

  static BuiltSet<ProductAnalyticsRowStockStatusEnum> get values => _$productAnalyticsRowStockStatusEnumValues;
  static ProductAnalyticsRowStockStatusEnum valueOf(String name) => _$productAnalyticsRowStockStatusEnumValueOf(name);
}

