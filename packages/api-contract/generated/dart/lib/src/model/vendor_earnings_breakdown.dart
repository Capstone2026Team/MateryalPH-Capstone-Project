//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/vendor_earnings_breakdown_physical.dart';
import 'package:materyalph_api_client/src/model/vendor_earnings_breakdown_online.dart';
import 'package:materyalph_api_client/src/model/vendor_earnings_breakdown_sales.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'vendor_earnings_breakdown.g.dart';

/// The components behind the headline Earnings cards, in the same scope and dates as each card's own total: sales (materials before discounts less vendor discounts plus delivery equals commercial sales), online (verified principal less confirmed refunded principal equals online collections) and physical (Cash on Delivery plus In-Store Payment equals physical collections). Records only; no derived income figure.
///
/// Properties:
/// * [sales]
/// * [online]
/// * [physical]
@BuiltValue()
abstract class VendorEarningsBreakdown implements Built<VendorEarningsBreakdown, VendorEarningsBreakdownBuilder> {
  @BuiltValueField(wireName: r'sales')
  VendorEarningsBreakdownSales get sales;

  @BuiltValueField(wireName: r'online')
  VendorEarningsBreakdownOnline get online;

  @BuiltValueField(wireName: r'physical')
  VendorEarningsBreakdownPhysical get physical;

  VendorEarningsBreakdown._();

  factory VendorEarningsBreakdown([void updates(VendorEarningsBreakdownBuilder b)]) = _$VendorEarningsBreakdown;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(VendorEarningsBreakdownBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<VendorEarningsBreakdown> get serializer => _$VendorEarningsBreakdownSerializer();
}

class _$VendorEarningsBreakdownSerializer implements PrimitiveSerializer<VendorEarningsBreakdown> {
  @override
  final Iterable<Type> types = const [VendorEarningsBreakdown, _$VendorEarningsBreakdown];

  @override
  final String wireName = r'VendorEarningsBreakdown';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    VendorEarningsBreakdown object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'sales';
    yield serializers.serialize(
      object.sales,
      specifiedType: const FullType(VendorEarningsBreakdownSales),
    );
    yield r'online';
    yield serializers.serialize(
      object.online,
      specifiedType: const FullType(VendorEarningsBreakdownOnline),
    );
    yield r'physical';
    yield serializers.serialize(
      object.physical,
      specifiedType: const FullType(VendorEarningsBreakdownPhysical),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    VendorEarningsBreakdown object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required VendorEarningsBreakdownBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'sales':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(VendorEarningsBreakdownSales),
          ) as VendorEarningsBreakdownSales;
          result.sales.replace(valueDes);
          break;
        case r'online':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(VendorEarningsBreakdownOnline),
          ) as VendorEarningsBreakdownOnline;
          result.online.replace(valueDes);
          break;
        case r'physical':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(VendorEarningsBreakdownPhysical),
          ) as VendorEarningsBreakdownPhysical;
          result.physical.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  VendorEarningsBreakdown deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = VendorEarningsBreakdownBuilder();
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


