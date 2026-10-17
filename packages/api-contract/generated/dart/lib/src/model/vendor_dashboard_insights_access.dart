//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'vendor_dashboard_insights_access.g.dart';

/// VendorDashboardInsightsAccess
///
/// Properties:
/// * [orders]
/// * [salesValue]
/// * [performance]
/// * [stock]
/// * [disputes]
/// * [assignedFulfillment]
@BuiltValue()
abstract class VendorDashboardInsightsAccess implements Built<VendorDashboardInsightsAccess, VendorDashboardInsightsAccessBuilder> {
  @BuiltValueField(wireName: r'orders')
  bool get orders;

  @BuiltValueField(wireName: r'sales_value')
  bool get salesValue;

  @BuiltValueField(wireName: r'performance')
  bool get performance;

  @BuiltValueField(wireName: r'stock')
  bool get stock;

  @BuiltValueField(wireName: r'disputes')
  bool get disputes;

  @BuiltValueField(wireName: r'assigned_fulfillment')
  bool get assignedFulfillment;

  VendorDashboardInsightsAccess._();

  factory VendorDashboardInsightsAccess([void updates(VendorDashboardInsightsAccessBuilder b)]) = _$VendorDashboardInsightsAccess;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(VendorDashboardInsightsAccessBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<VendorDashboardInsightsAccess> get serializer => _$VendorDashboardInsightsAccessSerializer();
}

class _$VendorDashboardInsightsAccessSerializer implements PrimitiveSerializer<VendorDashboardInsightsAccess> {
  @override
  final Iterable<Type> types = const [VendorDashboardInsightsAccess, _$VendorDashboardInsightsAccess];

  @override
  final String wireName = r'VendorDashboardInsightsAccess';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    VendorDashboardInsightsAccess object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'orders';
    yield serializers.serialize(
      object.orders,
      specifiedType: const FullType(bool),
    );
    yield r'sales_value';
    yield serializers.serialize(
      object.salesValue,
      specifiedType: const FullType(bool),
    );
    yield r'performance';
    yield serializers.serialize(
      object.performance,
      specifiedType: const FullType(bool),
    );
    yield r'stock';
    yield serializers.serialize(
      object.stock,
      specifiedType: const FullType(bool),
    );
    yield r'disputes';
    yield serializers.serialize(
      object.disputes,
      specifiedType: const FullType(bool),
    );
    yield r'assigned_fulfillment';
    yield serializers.serialize(
      object.assignedFulfillment,
      specifiedType: const FullType(bool),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    VendorDashboardInsightsAccess object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required VendorDashboardInsightsAccessBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'orders':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.orders = valueDes;
          break;
        case r'sales_value':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.salesValue = valueDes;
          break;
        case r'performance':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.performance = valueDes;
          break;
        case r'stock':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.stock = valueDes;
          break;
        case r'disputes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.disputes = valueDes;
          break;
        case r'assigned_fulfillment':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.assignedFulfillment = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  VendorDashboardInsightsAccess deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = VendorDashboardInsightsAccessBuilder();
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


