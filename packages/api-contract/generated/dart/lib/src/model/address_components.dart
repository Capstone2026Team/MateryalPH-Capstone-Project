//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'address_components.g.dart';

/// AddressComponents
///
/// Properties:
/// * [street]
/// * [barangay]
/// * [cityMunicipality]
/// * [province]
/// * [postalCode]
@BuiltValue()
abstract class AddressComponents implements Built<AddressComponents, AddressComponentsBuilder> {
  @BuiltValueField(wireName: r'street')
  String? get street;

  @BuiltValueField(wireName: r'barangay')
  String? get barangay;

  @BuiltValueField(wireName: r'city_municipality')
  String? get cityMunicipality;

  @BuiltValueField(wireName: r'province')
  String? get province;

  @BuiltValueField(wireName: r'postal_code')
  String? get postalCode;

  AddressComponents._();

  factory AddressComponents([void updates(AddressComponentsBuilder b)]) = _$AddressComponents;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AddressComponentsBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AddressComponents> get serializer => _$AddressComponentsSerializer();
}

class _$AddressComponentsSerializer implements PrimitiveSerializer<AddressComponents> {
  @override
  final Iterable<Type> types = const [AddressComponents, _$AddressComponents];

  @override
  final String wireName = r'AddressComponents';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AddressComponents object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'street';
    yield object.street == null ? null : serializers.serialize(
      object.street,
      specifiedType: const FullType.nullable(String),
    );
    yield r'barangay';
    yield object.barangay == null ? null : serializers.serialize(
      object.barangay,
      specifiedType: const FullType.nullable(String),
    );
    yield r'city_municipality';
    yield object.cityMunicipality == null ? null : serializers.serialize(
      object.cityMunicipality,
      specifiedType: const FullType.nullable(String),
    );
    yield r'province';
    yield object.province == null ? null : serializers.serialize(
      object.province,
      specifiedType: const FullType.nullable(String),
    );
    yield r'postal_code';
    yield object.postalCode == null ? null : serializers.serialize(
      object.postalCode,
      specifiedType: const FullType.nullable(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AddressComponents object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AddressComponentsBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'street':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.street = valueDes;
          break;
        case r'barangay':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.barangay = valueDes;
          break;
        case r'city_municipality':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.cityMunicipality = valueDes;
          break;
        case r'province':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.province = valueDes;
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
  AddressComponents deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AddressComponentsBuilder();
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


