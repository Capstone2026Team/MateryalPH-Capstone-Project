//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/vendor_tax_data.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'save_vendor_tax.g.dart';

/// SaveVendorTax
///
/// Properties:
/// * [lockVersion]
/// * [attest]
/// * [profile]
@BuiltValue()
abstract class SaveVendorTax implements Built<SaveVendorTax, SaveVendorTaxBuilder> {
  @BuiltValueField(wireName: r'lock_version')
  int get lockVersion;

  @BuiltValueField(wireName: r'attest')
  bool get attest;

  @BuiltValueField(wireName: r'profile')
  VendorTaxData get profile;

  SaveVendorTax._();

  factory SaveVendorTax([void updates(SaveVendorTaxBuilder b)]) = _$SaveVendorTax;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SaveVendorTaxBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<SaveVendorTax> get serializer => _$SaveVendorTaxSerializer();
}

class _$SaveVendorTaxSerializer implements PrimitiveSerializer<SaveVendorTax> {
  @override
  final Iterable<Type> types = const [SaveVendorTax, _$SaveVendorTax];

  @override
  final String wireName = r'SaveVendorTax';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SaveVendorTax object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'lock_version';
    yield serializers.serialize(
      object.lockVersion,
      specifiedType: const FullType(int),
    );
    yield r'attest';
    yield serializers.serialize(
      object.attest,
      specifiedType: const FullType(bool),
    );
    yield r'profile';
    yield serializers.serialize(
      object.profile,
      specifiedType: const FullType(VendorTaxData),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    SaveVendorTax object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required SaveVendorTaxBuilder result,
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
        case r'attest':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.attest = valueDes;
          break;
        case r'profile':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(VendorTaxData),
          ) as VendorTaxData;
          result.profile.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  SaveVendorTax deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SaveVendorTaxBuilder();
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


