//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'vendor_individual_registered_name.g.dart';

/// VendorIndividualRegisteredName
///
/// Properties:
/// * [surname]
/// * [firstName]
/// * [middleName]
/// * [suffix]
/// * [sameAsOwner]
@BuiltValue()
abstract class VendorIndividualRegisteredName implements Built<VendorIndividualRegisteredName, VendorIndividualRegisteredNameBuilder> {
  @BuiltValueField(wireName: r'surname')
  String get surname;

  @BuiltValueField(wireName: r'first_name')
  String get firstName;

  @BuiltValueField(wireName: r'middle_name')
  String? get middleName;

  @BuiltValueField(wireName: r'suffix')
  String? get suffix;

  @BuiltValueField(wireName: r'same_as_owner')
  bool? get sameAsOwner;

  VendorIndividualRegisteredName._();

  factory VendorIndividualRegisteredName([void updates(VendorIndividualRegisteredNameBuilder b)]) = _$VendorIndividualRegisteredName;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(VendorIndividualRegisteredNameBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<VendorIndividualRegisteredName> get serializer => _$VendorIndividualRegisteredNameSerializer();
}

class _$VendorIndividualRegisteredNameSerializer implements PrimitiveSerializer<VendorIndividualRegisteredName> {
  @override
  final Iterable<Type> types = const [VendorIndividualRegisteredName, _$VendorIndividualRegisteredName];

  @override
  final String wireName = r'VendorIndividualRegisteredName';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    VendorIndividualRegisteredName object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'surname';
    yield serializers.serialize(
      object.surname,
      specifiedType: const FullType(String),
    );
    yield r'first_name';
    yield serializers.serialize(
      object.firstName,
      specifiedType: const FullType(String),
    );
    if (object.middleName != null) {
      yield r'middle_name';
      yield serializers.serialize(
        object.middleName,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.suffix != null) {
      yield r'suffix';
      yield serializers.serialize(
        object.suffix,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.sameAsOwner != null) {
      yield r'same_as_owner';
      yield serializers.serialize(
        object.sameAsOwner,
        specifiedType: const FullType(bool),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    VendorIndividualRegisteredName object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required VendorIndividualRegisteredNameBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'surname':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.surname = valueDes;
          break;
        case r'first_name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.firstName = valueDes;
          break;
        case r'middle_name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.middleName = valueDes;
          break;
        case r'suffix':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.suffix = valueDes;
          break;
        case r'same_as_owner':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.sameAsOwner = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  VendorIndividualRegisteredName deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = VendorIndividualRegisteredNameBuilder();
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


