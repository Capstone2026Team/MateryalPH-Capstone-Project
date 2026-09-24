//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'vendor_address_selection.g.dart';

/// VendorAddressSelection
///
/// Properties:
/// * [pinToken] - Optional server-issued map pin token; never raw coordinates.
/// * [provinceCode] - Province code or region code for a city without a province parent.
/// * [cityCode]
/// * [psgcCode] - Official barangay code.
/// * [street]
/// * [unit]
/// * [postalCode]
@BuiltValue()
abstract class VendorAddressSelection implements Built<VendorAddressSelection, VendorAddressSelectionBuilder> {
  /// Optional server-issued map pin token; never raw coordinates.
  @BuiltValueField(wireName: r'pin_token')
  String? get pinToken;

  /// Province code or region code for a city without a province parent.
  @BuiltValueField(wireName: r'province_code')
  String get provinceCode;

  @BuiltValueField(wireName: r'city_code')
  String get cityCode;

  /// Official barangay code.
  @BuiltValueField(wireName: r'psgc_code')
  String get psgcCode;

  @BuiltValueField(wireName: r'street')
  String? get street;

  @BuiltValueField(wireName: r'unit')
  String? get unit;

  @BuiltValueField(wireName: r'postal_code')
  String? get postalCode;

  VendorAddressSelection._();

  factory VendorAddressSelection([void updates(VendorAddressSelectionBuilder b)]) = _$VendorAddressSelection;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(VendorAddressSelectionBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<VendorAddressSelection> get serializer => _$VendorAddressSelectionSerializer();
}

class _$VendorAddressSelectionSerializer implements PrimitiveSerializer<VendorAddressSelection> {
  @override
  final Iterable<Type> types = const [VendorAddressSelection, _$VendorAddressSelection];

  @override
  final String wireName = r'VendorAddressSelection';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    VendorAddressSelection object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.pinToken != null) {
      yield r'pin_token';
      yield serializers.serialize(
        object.pinToken,
        specifiedType: const FullType.nullable(String),
      );
    }
    yield r'province_code';
    yield serializers.serialize(
      object.provinceCode,
      specifiedType: const FullType(String),
    );
    yield r'city_code';
    yield serializers.serialize(
      object.cityCode,
      specifiedType: const FullType(String),
    );
    yield r'psgc_code';
    yield serializers.serialize(
      object.psgcCode,
      specifiedType: const FullType(String),
    );
    if (object.street != null) {
      yield r'street';
      yield serializers.serialize(
        object.street,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.unit != null) {
      yield r'unit';
      yield serializers.serialize(
        object.unit,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.postalCode != null) {
      yield r'postal_code';
      yield serializers.serialize(
        object.postalCode,
        specifiedType: const FullType.nullable(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    VendorAddressSelection object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required VendorAddressSelectionBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'pin_token':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.pinToken = valueDes;
          break;
        case r'province_code':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.provinceCode = valueDes;
          break;
        case r'city_code':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.cityCode = valueDes;
          break;
        case r'psgc_code':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.psgcCode = valueDes;
          break;
        case r'street':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.street = valueDes;
          break;
        case r'unit':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.unit = valueDes;
          break;
        case r'postal_code':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.postalCode = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  VendorAddressSelection deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = VendorAddressSelectionBuilder();
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


