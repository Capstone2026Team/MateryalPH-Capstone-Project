//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'vendor_store.g.dart';

/// VendorStore
///
/// Properties:
/// * [id]
/// * [description]
/// * [publicEmail]
/// * [publicPhone]
/// * [pickupEnabled]
/// * [deliveryEnabled]
/// * [codEnabled]
/// * [inStorePaymentEnabled]
/// * [paymentMethods]
/// * [refundConfiguration]
@BuiltValue()
abstract class VendorStore implements Built<VendorStore, VendorStoreBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'description')
  String? get description;

  @BuiltValueField(wireName: r'public_email')
  String? get publicEmail;

  @BuiltValueField(wireName: r'public_phone')
  String? get publicPhone;

  @BuiltValueField(wireName: r'pickup_enabled')
  bool get pickupEnabled;

  @BuiltValueField(wireName: r'delivery_enabled')
  bool get deliveryEnabled;

  @BuiltValueField(wireName: r'cod_enabled')
  bool get codEnabled;

  @BuiltValueField(wireName: r'in_store_payment_enabled')
  bool get inStorePaymentEnabled;

  @BuiltValueField(wireName: r'payment_methods')
  BuiltMap<String, JsonObject?> get paymentMethods;

  @BuiltValueField(wireName: r'refund_configuration')
  BuiltMap<String, JsonObject?> get refundConfiguration;

  VendorStore._();

  factory VendorStore([void updates(VendorStoreBuilder b)]) = _$VendorStore;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(VendorStoreBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<VendorStore> get serializer => _$VendorStoreSerializer();
}

class _$VendorStoreSerializer implements PrimitiveSerializer<VendorStore> {
  @override
  final Iterable<Type> types = const [VendorStore, _$VendorStore];

  @override
  final String wireName = r'VendorStore';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    VendorStore object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'description';
    yield object.description == null ? null : serializers.serialize(
      object.description,
      specifiedType: const FullType.nullable(String),
    );
    yield r'public_email';
    yield object.publicEmail == null ? null : serializers.serialize(
      object.publicEmail,
      specifiedType: const FullType.nullable(String),
    );
    yield r'public_phone';
    yield object.publicPhone == null ? null : serializers.serialize(
      object.publicPhone,
      specifiedType: const FullType.nullable(String),
    );
    yield r'pickup_enabled';
    yield serializers.serialize(
      object.pickupEnabled,
      specifiedType: const FullType(bool),
    );
    yield r'delivery_enabled';
    yield serializers.serialize(
      object.deliveryEnabled,
      specifiedType: const FullType(bool),
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
    yield r'payment_methods';
    yield serializers.serialize(
      object.paymentMethods,
      specifiedType: const FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
    );
    yield r'refund_configuration';
    yield serializers.serialize(
      object.refundConfiguration,
      specifiedType: const FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    VendorStore object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required VendorStoreBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.id = valueDes;
          break;
        case r'description':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
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
        case r'pickup_enabled':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.pickupEnabled = valueDes;
          break;
        case r'delivery_enabled':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.deliveryEnabled = valueDes;
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
        case r'payment_methods':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
          ) as BuiltMap<String, JsonObject?>;
          result.paymentMethods.replace(valueDes);
          break;
        case r'refund_configuration':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
          ) as BuiltMap<String, JsonObject?>;
          result.refundConfiguration.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  VendorStore deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = VendorStoreBuilder();
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


