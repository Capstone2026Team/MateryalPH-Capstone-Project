//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'vendor_address_geocode.g.dart';

/// VendorAddressGeocode
///
/// Properties:
/// * [latitude]
/// * [longitude]
@BuiltValue()
abstract class VendorAddressGeocode implements Built<VendorAddressGeocode, VendorAddressGeocodeBuilder> {
  @BuiltValueField(wireName: r'latitude')
  num get latitude;

  @BuiltValueField(wireName: r'longitude')
  num get longitude;

  VendorAddressGeocode._();

  factory VendorAddressGeocode([void updates(VendorAddressGeocodeBuilder b)]) = _$VendorAddressGeocode;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(VendorAddressGeocodeBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<VendorAddressGeocode> get serializer => _$VendorAddressGeocodeSerializer();
}

class _$VendorAddressGeocodeSerializer implements PrimitiveSerializer<VendorAddressGeocode> {
  @override
  final Iterable<Type> types = const [VendorAddressGeocode, _$VendorAddressGeocode];

  @override
  final String wireName = r'VendorAddressGeocode';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    VendorAddressGeocode object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'latitude';
    yield serializers.serialize(
      object.latitude,
      specifiedType: const FullType(num),
    );
    yield r'longitude';
    yield serializers.serialize(
      object.longitude,
      specifiedType: const FullType(num),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    VendorAddressGeocode object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required VendorAddressGeocodeBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'latitude':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.latitude = valueDes;
          break;
        case r'longitude':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
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
  VendorAddressGeocode deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = VendorAddressGeocodeBuilder();
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


