//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:materyalph_api_client/src/model/dashboard_rate.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'vendor_product_analytics_summaries_items_inner.g.dart';

/// VendorProductAnalyticsSummariesItemsInner
///
/// Properties:
/// * [listingId]
/// * [views]
/// * [previousViews]
/// * [viewsChangePercent]
/// * [viewers]
/// * [orders]
/// * [conversion]
/// * [dailyViews]
@BuiltValue()
abstract class VendorProductAnalyticsSummariesItemsInner implements Built<VendorProductAnalyticsSummariesItemsInner, VendorProductAnalyticsSummariesItemsInnerBuilder> {
  @BuiltValueField(wireName: r'listing_id')
  String get listingId;

  @BuiltValueField(wireName: r'views')
  int get views;

  @BuiltValueField(wireName: r'previous_views')
  int get previousViews;

  @BuiltValueField(wireName: r'views_change_percent')
  num? get viewsChangePercent;

  @BuiltValueField(wireName: r'viewers')
  int get viewers;

  @BuiltValueField(wireName: r'orders')
  int get orders;

  @BuiltValueField(wireName: r'conversion')
  DashboardRate get conversion;

  @BuiltValueField(wireName: r'daily_views')
  BuiltList<int> get dailyViews;

  VendorProductAnalyticsSummariesItemsInner._();

  factory VendorProductAnalyticsSummariesItemsInner([void updates(VendorProductAnalyticsSummariesItemsInnerBuilder b)]) = _$VendorProductAnalyticsSummariesItemsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(VendorProductAnalyticsSummariesItemsInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<VendorProductAnalyticsSummariesItemsInner> get serializer => _$VendorProductAnalyticsSummariesItemsInnerSerializer();
}

class _$VendorProductAnalyticsSummariesItemsInnerSerializer implements PrimitiveSerializer<VendorProductAnalyticsSummariesItemsInner> {
  @override
  final Iterable<Type> types = const [VendorProductAnalyticsSummariesItemsInner, _$VendorProductAnalyticsSummariesItemsInner];

  @override
  final String wireName = r'VendorProductAnalyticsSummariesItemsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    VendorProductAnalyticsSummariesItemsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'listing_id';
    yield serializers.serialize(
      object.listingId,
      specifiedType: const FullType(String),
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
    yield r'orders';
    yield serializers.serialize(
      object.orders,
      specifiedType: const FullType(int),
    );
    yield r'conversion';
    yield serializers.serialize(
      object.conversion,
      specifiedType: const FullType(DashboardRate),
    );
    yield r'daily_views';
    yield serializers.serialize(
      object.dailyViews,
      specifiedType: const FullType(BuiltList, [FullType(int)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    VendorProductAnalyticsSummariesItemsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required VendorProductAnalyticsSummariesItemsInnerBuilder result,
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
        case r'orders':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.orders = valueDes;
          break;
        case r'conversion':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DashboardRate),
          ) as DashboardRate;
          result.conversion.replace(valueDes);
          break;
        case r'daily_views':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(int)]),
          ) as BuiltList<int>;
          result.dailyViews.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  VendorProductAnalyticsSummariesItemsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = VendorProductAnalyticsSummariesItemsInnerBuilder();
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


