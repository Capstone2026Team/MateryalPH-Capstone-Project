//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'vendor_dashboard_insights_traffic_store_visits.g.dart';

/// VendorDashboardInsightsTrafficStoreVisits
///
/// Properties:
/// * [tracked]
/// * [reason]
@BuiltValue()
abstract class VendorDashboardInsightsTrafficStoreVisits implements Built<VendorDashboardInsightsTrafficStoreVisits, VendorDashboardInsightsTrafficStoreVisitsBuilder> {
  @BuiltValueField(wireName: r'tracked')
  bool get tracked;

  @BuiltValueField(wireName: r'reason')
  String get reason;

  VendorDashboardInsightsTrafficStoreVisits._();

  factory VendorDashboardInsightsTrafficStoreVisits([void updates(VendorDashboardInsightsTrafficStoreVisitsBuilder b)]) = _$VendorDashboardInsightsTrafficStoreVisits;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(VendorDashboardInsightsTrafficStoreVisitsBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<VendorDashboardInsightsTrafficStoreVisits> get serializer => _$VendorDashboardInsightsTrafficStoreVisitsSerializer();
}

class _$VendorDashboardInsightsTrafficStoreVisitsSerializer implements PrimitiveSerializer<VendorDashboardInsightsTrafficStoreVisits> {
  @override
  final Iterable<Type> types = const [VendorDashboardInsightsTrafficStoreVisits, _$VendorDashboardInsightsTrafficStoreVisits];

  @override
  final String wireName = r'VendorDashboardInsightsTrafficStoreVisits';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    VendorDashboardInsightsTrafficStoreVisits object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'tracked';
    yield serializers.serialize(
      object.tracked,
      specifiedType: const FullType(bool),
    );
    yield r'reason';
    yield serializers.serialize(
      object.reason,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    VendorDashboardInsightsTrafficStoreVisits object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required VendorDashboardInsightsTrafficStoreVisitsBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'tracked':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.tracked = valueDes;
          break;
        case r'reason':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.reason = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  VendorDashboardInsightsTrafficStoreVisits deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = VendorDashboardInsightsTrafficStoreVisitsBuilder();
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


