//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/date.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'vendor_dashboard_orders_unusual_days_days_inner.g.dart';

/// VendorDashboardOrdersUnusualDaysDaysInner
///
/// Properties:
/// * [date]
/// * [orders]
/// * [grossSalesCentavos]
@BuiltValue()
abstract class VendorDashboardOrdersUnusualDaysDaysInner implements Built<VendorDashboardOrdersUnusualDaysDaysInner, VendorDashboardOrdersUnusualDaysDaysInnerBuilder> {
  @BuiltValueField(wireName: r'date')
  Date get date;

  @BuiltValueField(wireName: r'orders')
  int get orders;

  @BuiltValueField(wireName: r'gross_sales_centavos')
  int? get grossSalesCentavos;

  VendorDashboardOrdersUnusualDaysDaysInner._();

  factory VendorDashboardOrdersUnusualDaysDaysInner([void updates(VendorDashboardOrdersUnusualDaysDaysInnerBuilder b)]) = _$VendorDashboardOrdersUnusualDaysDaysInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(VendorDashboardOrdersUnusualDaysDaysInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<VendorDashboardOrdersUnusualDaysDaysInner> get serializer => _$VendorDashboardOrdersUnusualDaysDaysInnerSerializer();
}

class _$VendorDashboardOrdersUnusualDaysDaysInnerSerializer implements PrimitiveSerializer<VendorDashboardOrdersUnusualDaysDaysInner> {
  @override
  final Iterable<Type> types = const [VendorDashboardOrdersUnusualDaysDaysInner, _$VendorDashboardOrdersUnusualDaysDaysInner];

  @override
  final String wireName = r'VendorDashboardOrdersUnusualDaysDaysInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    VendorDashboardOrdersUnusualDaysDaysInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'date';
    yield serializers.serialize(
      object.date,
      specifiedType: const FullType(Date),
    );
    yield r'orders';
    yield serializers.serialize(
      object.orders,
      specifiedType: const FullType(int),
    );
    if (object.grossSalesCentavos != null) {
      yield r'gross_sales_centavos';
      yield serializers.serialize(
        object.grossSalesCentavos,
        specifiedType: const FullType.nullable(int),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    VendorDashboardOrdersUnusualDaysDaysInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required VendorDashboardOrdersUnusualDaysDaysInnerBuilder result,
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
        case r'orders':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.orders = valueDes;
          break;
        case r'gross_sales_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.grossSalesCentavos = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  VendorDashboardOrdersUnusualDaysDaysInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = VendorDashboardOrdersUnusualDaysDaysInnerBuilder();
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


