//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:materyalph_api_client/src/model/dashboard_count.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'vendor_dashboard_orders_mix.g.dart';

/// VendorDashboardOrdersMix
///
/// Properties:
/// * [procurement]
/// * [fulfillment]
/// * [payment]
@BuiltValue()
abstract class VendorDashboardOrdersMix implements Built<VendorDashboardOrdersMix, VendorDashboardOrdersMixBuilder> {
  @BuiltValueField(wireName: r'procurement')
  BuiltList<DashboardCount> get procurement;

  @BuiltValueField(wireName: r'fulfillment')
  BuiltList<DashboardCount> get fulfillment;

  @BuiltValueField(wireName: r'payment')
  BuiltList<DashboardCount> get payment;

  VendorDashboardOrdersMix._();

  factory VendorDashboardOrdersMix([void updates(VendorDashboardOrdersMixBuilder b)]) = _$VendorDashboardOrdersMix;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(VendorDashboardOrdersMixBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<VendorDashboardOrdersMix> get serializer => _$VendorDashboardOrdersMixSerializer();
}

class _$VendorDashboardOrdersMixSerializer implements PrimitiveSerializer<VendorDashboardOrdersMix> {
  @override
  final Iterable<Type> types = const [VendorDashboardOrdersMix, _$VendorDashboardOrdersMix];

  @override
  final String wireName = r'VendorDashboardOrdersMix';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    VendorDashboardOrdersMix object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'procurement';
    yield serializers.serialize(
      object.procurement,
      specifiedType: const FullType(BuiltList, [FullType(DashboardCount)]),
    );
    yield r'fulfillment';
    yield serializers.serialize(
      object.fulfillment,
      specifiedType: const FullType(BuiltList, [FullType(DashboardCount)]),
    );
    yield r'payment';
    yield serializers.serialize(
      object.payment,
      specifiedType: const FullType(BuiltList, [FullType(DashboardCount)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    VendorDashboardOrdersMix object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required VendorDashboardOrdersMixBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'procurement':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(DashboardCount)]),
          ) as BuiltList<DashboardCount>;
          result.procurement.replace(valueDes);
          break;
        case r'fulfillment':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(DashboardCount)]),
          ) as BuiltList<DashboardCount>;
          result.fulfillment.replace(valueDes);
          break;
        case r'payment':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(DashboardCount)]),
          ) as BuiltList<DashboardCount>;
          result.payment.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  VendorDashboardOrdersMix deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = VendorDashboardOrdersMixBuilder();
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


