//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'vendor_business_address.g.dart';

/// VendorBusinessAddress
///
/// Properties:
/// * [street]
/// * [barangay]
/// * [city]
/// * [province]
/// * [postalCode]
/// * [latitude]
/// * [longitude]
@BuiltValue()
abstract class VendorBusinessAddress implements Built<VendorBusinessAddress, VendorBusinessAddressBuilder> {
  @BuiltValueField(wireName: r'street')
  String get street;

  @BuiltValueField(wireName: r'barangay')
  String get barangay;

  @BuiltValueField(wireName: r'city')
  String get city;

  @BuiltValueField(wireName: r'province')
  String get province;

  @BuiltValueField(wireName: r'postal_code')
  String get postalCode;

  @BuiltValueField(wireName: r'latitude')
  num? get latitude;

  @BuiltValueField(wireName: r'longitude')
  num? get longitude;

  VendorBusinessAddress._();

  factory VendorBusinessAddress([void updates(VendorBusinessAddressBuilder b)]) = _$VendorBusinessAddress;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(VendorBusinessAddressBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<VendorBusinessAddress> get serializer => _$VendorBusinessAddressSerializer();
}

class _$VendorBusinessAddressSerializer implements PrimitiveSerializer<VendorBusinessAddress> {
  @override
  final Iterable<Type> types = const [VendorBusinessAddress, _$VendorBusinessAddress];

  @override
  final String wireName = r'VendorBusinessAddress';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    VendorBusinessAddress object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'street';
    yield serializers.serialize(
      object.street,
      specifiedType: const FullType(String),
    );
    yield r'barangay';
    yield serializers.serialize(
      object.barangay,
      specifiedType: const FullType(String),
    );
    yield r'city';
    yield serializers.serialize(
      object.city,
      specifiedType: const FullType(String),
    );
    yield r'province';
    yield serializers.serialize(
      object.province,
      specifiedType: const FullType(String),
    );
    yield r'postal_code';
    yield serializers.serialize(
      object.postalCode,
      specifiedType: const FullType(String),
    );
    if (object.latitude != null) {
      yield r'latitude';
      yield serializers.serialize(
        object.latitude,
        specifiedType: const FullType.nullable(num),
      );
    }
    if (object.longitude != null) {
      yield r'longitude';
      yield serializers.serialize(
        object.longitude,
        specifiedType: const FullType.nullable(num),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    VendorBusinessAddress object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required VendorBusinessAddressBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'street':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.street = valueDes;
          break;
        case r'barangay':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.barangay = valueDes;
          break;
        case r'city':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.city = valueDes;
          break;
        case r'province':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.province = valueDes;
          break;
        case r'postal_code':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.postalCode = valueDes;
          break;
        case r'latitude':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(num),
          ) as num?;
          if (valueDes == null) continue;
          result.latitude = valueDes;
          break;
        case r'longitude':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(num),
          ) as num?;
          if (valueDes == null) continue;
          result.longitude = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  VendorBusinessAddress deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = VendorBusinessAddressBuilder();
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


