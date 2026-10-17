//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/vendor_dashboard_insights_traffic_store_visits.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'vendor_dashboard_insights_traffic.g.dart';

/// Storefront visits are not recorded by the platform, so no visit figure exists. Product views are reported by Vendor Product Analytics.
///
/// Properties:
/// * [storeVisits]
@BuiltValue()
abstract class VendorDashboardInsightsTraffic implements Built<VendorDashboardInsightsTraffic, VendorDashboardInsightsTrafficBuilder> {
  @BuiltValueField(wireName: r'store_visits')
  VendorDashboardInsightsTrafficStoreVisits get storeVisits;

  VendorDashboardInsightsTraffic._();

  factory VendorDashboardInsightsTraffic([void updates(VendorDashboardInsightsTrafficBuilder b)]) = _$VendorDashboardInsightsTraffic;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(VendorDashboardInsightsTrafficBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<VendorDashboardInsightsTraffic> get serializer => _$VendorDashboardInsightsTrafficSerializer();
}

class _$VendorDashboardInsightsTrafficSerializer implements PrimitiveSerializer<VendorDashboardInsightsTraffic> {
  @override
  final Iterable<Type> types = const [VendorDashboardInsightsTraffic, _$VendorDashboardInsightsTraffic];

  @override
  final String wireName = r'VendorDashboardInsightsTraffic';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    VendorDashboardInsightsTraffic object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'store_visits';
    yield serializers.serialize(
      object.storeVisits,
      specifiedType: const FullType(VendorDashboardInsightsTrafficStoreVisits),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    VendorDashboardInsightsTraffic object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required VendorDashboardInsightsTrafficBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'store_visits':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(VendorDashboardInsightsTrafficStoreVisits),
          ) as VendorDashboardInsightsTrafficStoreVisits;
          result.storeVisits.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  VendorDashboardInsightsTraffic deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = VendorDashboardInsightsTrafficBuilder();
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


