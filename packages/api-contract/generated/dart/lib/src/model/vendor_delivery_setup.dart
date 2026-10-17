//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'vendor_delivery_setup.g.dart';

/// Live eligibility for new deliveries only. Existing delivery orders, assignments and accepted snapshots remain intact. Private to the Owner and Store Manager.
///
/// Properties:
/// * [fulfillmentMethod]
/// * [staffReady]
/// * [vehicleReady]
/// * [pickupLocationReady]
/// * [serviceSettingsReady]
/// * [ready]
/// * [enabled] - Saved activation intent; current eligibility additionally controls availability.
/// * [available] - All delivery requirements currently pass and delivery is activated.
/// * [activeDeliveryObligations]
@BuiltValue()
abstract class VendorDeliverySetup implements Built<VendorDeliverySetup, VendorDeliverySetupBuilder> {
  @BuiltValueField(wireName: r'fulfillment_method')
  VendorDeliverySetupFulfillmentMethodEnum? get fulfillmentMethod;
  // enum fulfillmentMethodEnum {  SELF_PICKUP,  VENDOR_DELIVERY,  BOTH,  ,  };

  @BuiltValueField(wireName: r'staff_ready')
  bool get staffReady;

  @BuiltValueField(wireName: r'vehicle_ready')
  bool get vehicleReady;

  @BuiltValueField(wireName: r'pickup_location_ready')
  bool get pickupLocationReady;

  @BuiltValueField(wireName: r'service_settings_ready')
  bool get serviceSettingsReady;

  @BuiltValueField(wireName: r'ready')
  bool get ready;

  /// Saved activation intent; current eligibility additionally controls availability.
  @BuiltValueField(wireName: r'enabled')
  bool get enabled;

  /// All delivery requirements currently pass and delivery is activated.
  @BuiltValueField(wireName: r'available')
  bool get available;

  @BuiltValueField(wireName: r'active_delivery_obligations')
  int get activeDeliveryObligations;

  VendorDeliverySetup._();

  factory VendorDeliverySetup([void updates(VendorDeliverySetupBuilder b)]) = _$VendorDeliverySetup;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(VendorDeliverySetupBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<VendorDeliverySetup> get serializer => _$VendorDeliverySetupSerializer();
}

class _$VendorDeliverySetupSerializer implements PrimitiveSerializer<VendorDeliverySetup> {
  @override
  final Iterable<Type> types = const [VendorDeliverySetup, _$VendorDeliverySetup];

  @override
  final String wireName = r'VendorDeliverySetup';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    VendorDeliverySetup object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'fulfillment_method';
    yield object.fulfillmentMethod == null ? null : serializers.serialize(
      object.fulfillmentMethod,
      specifiedType: const FullType.nullable(VendorDeliverySetupFulfillmentMethodEnum),
    );
    yield r'staff_ready';
    yield serializers.serialize(
      object.staffReady,
      specifiedType: const FullType(bool),
    );
    yield r'vehicle_ready';
    yield serializers.serialize(
      object.vehicleReady,
      specifiedType: const FullType(bool),
    );
    yield r'pickup_location_ready';
    yield serializers.serialize(
      object.pickupLocationReady,
      specifiedType: const FullType(bool),
    );
    yield r'service_settings_ready';
    yield serializers.serialize(
      object.serviceSettingsReady,
      specifiedType: const FullType(bool),
    );
    yield r'ready';
    yield serializers.serialize(
      object.ready,
      specifiedType: const FullType(bool),
    );
    yield r'enabled';
    yield serializers.serialize(
      object.enabled,
      specifiedType: const FullType(bool),
    );
    yield r'available';
    yield serializers.serialize(
      object.available,
      specifiedType: const FullType(bool),
    );
    yield r'active_delivery_obligations';
    yield serializers.serialize(
      object.activeDeliveryObligations,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    VendorDeliverySetup object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required VendorDeliverySetupBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'fulfillment_method':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(VendorDeliverySetupFulfillmentMethodEnum),
          ) as VendorDeliverySetupFulfillmentMethodEnum?;
          if (valueDes == null) continue;
          result.fulfillmentMethod = valueDes;
          break;
        case r'staff_ready':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.staffReady = valueDes;
          break;
        case r'vehicle_ready':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.vehicleReady = valueDes;
          break;
        case r'pickup_location_ready':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.pickupLocationReady = valueDes;
          break;
        case r'service_settings_ready':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.serviceSettingsReady = valueDes;
          break;
        case r'ready':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.ready = valueDes;
          break;
        case r'enabled':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.enabled = valueDes;
          break;
        case r'available':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.available = valueDes;
          break;
        case r'active_delivery_obligations':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.activeDeliveryObligations = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  VendorDeliverySetup deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = VendorDeliverySetupBuilder();
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


class VendorDeliverySetupFulfillmentMethodEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'SELF_PICKUP')
  static const VendorDeliverySetupFulfillmentMethodEnum SELF_PICKUP = _$vendorDeliverySetupFulfillmentMethodEnum_SELF_PICKUP;
  @BuiltValueEnumConst(wireName: r'VENDOR_DELIVERY')
  static const VendorDeliverySetupFulfillmentMethodEnum VENDOR_DELIVERY = _$vendorDeliverySetupFulfillmentMethodEnum_VENDOR_DELIVERY;
  @BuiltValueEnumConst(wireName: r'BOTH')
  static const VendorDeliverySetupFulfillmentMethodEnum BOTH = _$vendorDeliverySetupFulfillmentMethodEnum_BOTH;

  static Serializer<VendorDeliverySetupFulfillmentMethodEnum> get serializer => _$vendorDeliverySetupFulfillmentMethodEnumSerializer;

  const VendorDeliverySetupFulfillmentMethodEnum._(String name): super(name);

  static BuiltSet<VendorDeliverySetupFulfillmentMethodEnum> get values => _$vendorDeliverySetupFulfillmentMethodEnumValues;
  static VendorDeliverySetupFulfillmentMethodEnum valueOf(String name) => _$vendorDeliverySetupFulfillmentMethodEnumValueOf(name);
}

