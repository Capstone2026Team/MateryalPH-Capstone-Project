//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'vendor_dashboard_orders_kpis_average_order_value_centavos.g.dart';

/// VendorDashboardOrdersKpisAverageOrderValueCentavos
///
/// Properties:
/// * [value]
/// * [previous]
@BuiltValue()
abstract class VendorDashboardOrdersKpisAverageOrderValueCentavos implements Built<VendorDashboardOrdersKpisAverageOrderValueCentavos, VendorDashboardOrdersKpisAverageOrderValueCentavosBuilder> {
  @BuiltValueField(wireName: r'value')
  int? get value;

  @BuiltValueField(wireName: r'previous')
  int? get previous;

  VendorDashboardOrdersKpisAverageOrderValueCentavos._();

  factory VendorDashboardOrdersKpisAverageOrderValueCentavos([void updates(VendorDashboardOrdersKpisAverageOrderValueCentavosBuilder b)]) = _$VendorDashboardOrdersKpisAverageOrderValueCentavos;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(VendorDashboardOrdersKpisAverageOrderValueCentavosBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<VendorDashboardOrdersKpisAverageOrderValueCentavos> get serializer => _$VendorDashboardOrdersKpisAverageOrderValueCentavosSerializer();
}

class _$VendorDashboardOrdersKpisAverageOrderValueCentavosSerializer implements PrimitiveSerializer<VendorDashboardOrdersKpisAverageOrderValueCentavos> {
  @override
  final Iterable<Type> types = const [VendorDashboardOrdersKpisAverageOrderValueCentavos, _$VendorDashboardOrdersKpisAverageOrderValueCentavos];

  @override
  final String wireName = r'VendorDashboardOrdersKpisAverageOrderValueCentavos';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    VendorDashboardOrdersKpisAverageOrderValueCentavos object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.value != null) {
      yield r'value';
      yield serializers.serialize(
        object.value,
        specifiedType: const FullType.nullable(int),
      );
    }
    if (object.previous != null) {
      yield r'previous';
      yield serializers.serialize(
        object.previous,
        specifiedType: const FullType.nullable(int),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    VendorDashboardOrdersKpisAverageOrderValueCentavos object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required VendorDashboardOrdersKpisAverageOrderValueCentavosBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'value':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.value = valueDes;
          break;
        case r'previous':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.previous = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  VendorDashboardOrdersKpisAverageOrderValueCentavos deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = VendorDashboardOrdersKpisAverageOrderValueCentavosBuilder();
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


