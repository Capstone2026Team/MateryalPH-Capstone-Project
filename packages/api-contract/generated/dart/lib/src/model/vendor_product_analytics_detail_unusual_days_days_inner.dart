//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/date.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'vendor_product_analytics_detail_unusual_days_days_inner.g.dart';

/// VendorProductAnalyticsDetailUnusualDaysDaysInner
///
/// Properties:
/// * [date]
/// * [views]
/// * [orders]
@BuiltValue()
abstract class VendorProductAnalyticsDetailUnusualDaysDaysInner implements Built<VendorProductAnalyticsDetailUnusualDaysDaysInner, VendorProductAnalyticsDetailUnusualDaysDaysInnerBuilder> {
  @BuiltValueField(wireName: r'date')
  Date get date;

  @BuiltValueField(wireName: r'views')
  int get views;

  @BuiltValueField(wireName: r'orders')
  int get orders;

  VendorProductAnalyticsDetailUnusualDaysDaysInner._();

  factory VendorProductAnalyticsDetailUnusualDaysDaysInner([void updates(VendorProductAnalyticsDetailUnusualDaysDaysInnerBuilder b)]) = _$VendorProductAnalyticsDetailUnusualDaysDaysInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(VendorProductAnalyticsDetailUnusualDaysDaysInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<VendorProductAnalyticsDetailUnusualDaysDaysInner> get serializer => _$VendorProductAnalyticsDetailUnusualDaysDaysInnerSerializer();
}

class _$VendorProductAnalyticsDetailUnusualDaysDaysInnerSerializer implements PrimitiveSerializer<VendorProductAnalyticsDetailUnusualDaysDaysInner> {
  @override
  final Iterable<Type> types = const [VendorProductAnalyticsDetailUnusualDaysDaysInner, _$VendorProductAnalyticsDetailUnusualDaysDaysInner];

  @override
  final String wireName = r'VendorProductAnalyticsDetailUnusualDaysDaysInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    VendorProductAnalyticsDetailUnusualDaysDaysInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'date';
    yield serializers.serialize(
      object.date,
      specifiedType: const FullType(Date),
    );
    yield r'views';
    yield serializers.serialize(
      object.views,
      specifiedType: const FullType(int),
    );
    yield r'orders';
    yield serializers.serialize(
      object.orders,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    VendorProductAnalyticsDetailUnusualDaysDaysInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required VendorProductAnalyticsDetailUnusualDaysDaysInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'date':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(Date),
          ) as Date;
          result.date = valueDes;
          break;
        case r'views':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.views = valueDes;
          break;
        case r'orders':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.orders = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  VendorProductAnalyticsDetailUnusualDaysDaysInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = VendorProductAnalyticsDetailUnusualDaysDaysInnerBuilder();
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


