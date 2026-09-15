//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/vendor_operating_day.dart';
import 'package:built_collection/built_collection.dart';
import 'package:materyalph_api_client/src/model/vendor_vehicle.dart';
import 'package:materyalph_api_client/src/model/save_vendor_store_refund_configuration.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'save_vendor_store.g.dart';

/// SaveVendorStore
///
/// Properties:
/// * [lockVersion]
/// * [description]
/// * [publicEmail]
/// * [publicPhone]
/// * [bulkOrderCapable]
/// * [fulfillment]
/// * [codEnabled]
/// * [inStorePaymentEnabled]
/// * [onlinePaymentEnabled]
/// * [refundConfiguration]
/// * [deliveryVehicles]
/// * [hours]
@BuiltValue()
abstract class SaveVendorStore implements Built<SaveVendorStore, SaveVendorStoreBuilder> {
  @BuiltValueField(wireName: r'lock_version')
  int get lockVersion;

  @BuiltValueField(wireName: r'description')
  String get description;

  @BuiltValueField(wireName: r'public_email')
  String? get publicEmail;

  @BuiltValueField(wireName: r'public_phone')
  String? get publicPhone;

  @BuiltValueField(wireName: r'bulk_order_capable')
  bool get bulkOrderCapable;

  @BuiltValueField(wireName: r'fulfillment')
  SaveVendorStoreFulfillmentEnum get fulfillment;
  // enum fulfillmentEnum {  SELF_PICKUP,  VENDOR_DELIVERY,  BOTH,  };

  @BuiltValueField(wireName: r'cod_enabled')
  bool get codEnabled;

  @BuiltValueField(wireName: r'in_store_payment_enabled')
  bool get inStorePaymentEnabled;

  @BuiltValueField(wireName: r'online_payment_enabled')
  bool get onlinePaymentEnabled;

  @BuiltValueField(wireName: r'refund_configuration')
  SaveVendorStoreRefundConfiguration get refundConfiguration;

  @BuiltValueField(wireName: r'delivery_vehicles')
  BuiltList<VendorVehicle> get deliveryVehicles;

  @BuiltValueField(wireName: r'hours')
  BuiltList<VendorOperatingDay> get hours;

  SaveVendorStore._();

  factory SaveVendorStore([void updates(SaveVendorStoreBuilder b)]) = _$SaveVendorStore;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SaveVendorStoreBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<SaveVendorStore> get serializer => _$SaveVendorStoreSerializer();
}

class _$SaveVendorStoreSerializer implements PrimitiveSerializer<SaveVendorStore> {
  @override
  final Iterable<Type> types = const [SaveVendorStore, _$SaveVendorStore];

  @override
  final String wireName = r'SaveVendorStore';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SaveVendorStore object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'lock_version';
    yield serializers.serialize(
      object.lockVersion,
      specifiedType: const FullType(int),
    );
    yield r'description';
    yield serializers.serialize(
      object.description,
      specifiedType: const FullType(String),
    );
    if (object.publicEmail != null) {
      yield r'public_email';
      yield serializers.serialize(
        object.publicEmail,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.publicPhone != null) {
      yield r'public_phone';
      yield serializers.serialize(
        object.publicPhone,
        specifiedType: const FullType.nullable(String),
      );
    }
    yield r'bulk_order_capable';
    yield serializers.serialize(
      object.bulkOrderCapable,
      specifiedType: const FullType(bool),
    );
    yield r'fulfillment';
    yield serializers.serialize(
      object.fulfillment,
      specifiedType: const FullType(SaveVendorStoreFulfillmentEnum),
    );
    yield r'cod_enabled';
    yield serializers.serialize(
      object.codEnabled,
      specifiedType: const FullType(bool),
    );
    yield r'in_store_payment_enabled';
    yield serializers.serialize(
      object.inStorePaymentEnabled,
      specifiedType: const FullType(bool),
    );
    yield r'online_payment_enabled';
    yield serializers.serialize(
      object.onlinePaymentEnabled,
      specifiedType: const FullType(bool),
    );
    yield r'refund_configuration';
    yield serializers.serialize(
      object.refundConfiguration,
      specifiedType: const FullType(SaveVendorStoreRefundConfiguration),
    );
    yield r'delivery_vehicles';
    yield serializers.serialize(
      object.deliveryVehicles,
      specifiedType: const FullType(BuiltList, [FullType(VendorVehicle)]),
    );
    yield r'hours';
    yield serializers.serialize(
      object.hours,
      specifiedType: const FullType(BuiltList, [FullType(VendorOperatingDay)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    SaveVendorStore object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required SaveVendorStoreBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'lock_version':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.lockVersion = valueDes;
          break;
        case r'description':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.description = valueDes;
          break;
        case r'public_email':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.publicEmail = valueDes;
          break;
        case r'public_phone':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.publicPhone = valueDes;
          break;
        case r'bulk_order_capable':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.bulkOrderCapable = valueDes;
          break;
        case r'fulfillment':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(SaveVendorStoreFulfillmentEnum),
          ) as SaveVendorStoreFulfillmentEnum;
          result.fulfillment = valueDes;
          break;
        case r'cod_enabled':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.codEnabled = valueDes;
          break;
        case r'in_store_payment_enabled':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.inStorePaymentEnabled = valueDes;
          break;
        case r'online_payment_enabled':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.onlinePaymentEnabled = valueDes;
          break;
        case r'refund_configuration':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(SaveVendorStoreRefundConfiguration),
          ) as SaveVendorStoreRefundConfiguration;
          result.refundConfiguration.replace(valueDes);
          break;
        case r'delivery_vehicles':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(VendorVehicle)]),
          ) as BuiltList<VendorVehicle>;
          result.deliveryVehicles.replace(valueDes);
          break;
        case r'hours':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(VendorOperatingDay)]),
          ) as BuiltList<VendorOperatingDay>;
          result.hours.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  SaveVendorStore deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SaveVendorStoreBuilder();
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


class SaveVendorStoreFulfillmentEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'SELF_PICKUP')
  static const SaveVendorStoreFulfillmentEnum SELF_PICKUP = _$saveVendorStoreFulfillmentEnum_SELF_PICKUP;
  @BuiltValueEnumConst(wireName: r'VENDOR_DELIVERY')
  static const SaveVendorStoreFulfillmentEnum VENDOR_DELIVERY = _$saveVendorStoreFulfillmentEnum_VENDOR_DELIVERY;
  @BuiltValueEnumConst(wireName: r'BOTH')
  static const SaveVendorStoreFulfillmentEnum BOTH = _$saveVendorStoreFulfillmentEnum_BOTH;

  static Serializer<SaveVendorStoreFulfillmentEnum> get serializer => _$saveVendorStoreFulfillmentEnumSerializer;

  const SaveVendorStoreFulfillmentEnum._(String name): super(name);

  static BuiltSet<SaveVendorStoreFulfillmentEnum> get values => _$saveVendorStoreFulfillmentEnumValues;
  static SaveVendorStoreFulfillmentEnum valueOf(String name) => _$saveVendorStoreFulfillmentEnumValueOf(name);
}

