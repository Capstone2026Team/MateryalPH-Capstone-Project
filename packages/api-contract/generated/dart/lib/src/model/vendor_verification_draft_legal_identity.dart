//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'vendor_verification_draft_legal_identity.g.dart';

/// VendorVerificationDraftLegalIdentity
///
/// Properties:
/// * [sameAsOwner]
/// * [surname]
/// * [firstName]
/// * [middleName]
/// * [suffix]
/// * [companyRegisteredName]
/// * [idType]
/// * [idNumber]
@BuiltValue()
abstract class VendorVerificationDraftLegalIdentity implements Built<VendorVerificationDraftLegalIdentity, VendorVerificationDraftLegalIdentityBuilder> {
  @BuiltValueField(wireName: r'same_as_owner')
  bool? get sameAsOwner;

  @BuiltValueField(wireName: r'surname')
  String? get surname;

  @BuiltValueField(wireName: r'first_name')
  String? get firstName;

  @BuiltValueField(wireName: r'middle_name')
  String? get middleName;

  @BuiltValueField(wireName: r'suffix')
  String? get suffix;

  @BuiltValueField(wireName: r'company_registered_name')
  String? get companyRegisteredName;

  @BuiltValueField(wireName: r'id_type')
  String? get idType;

  @BuiltValueField(wireName: r'id_number')
  String? get idNumber;

  VendorVerificationDraftLegalIdentity._();

  factory VendorVerificationDraftLegalIdentity([void updates(VendorVerificationDraftLegalIdentityBuilder b)]) = _$VendorVerificationDraftLegalIdentity;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(VendorVerificationDraftLegalIdentityBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<VendorVerificationDraftLegalIdentity> get serializer => _$VendorVerificationDraftLegalIdentitySerializer();
}

class _$VendorVerificationDraftLegalIdentitySerializer implements PrimitiveSerializer<VendorVerificationDraftLegalIdentity> {
  @override
  final Iterable<Type> types = const [VendorVerificationDraftLegalIdentity, _$VendorVerificationDraftLegalIdentity];

  @override
  final String wireName = r'VendorVerificationDraftLegalIdentity';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    VendorVerificationDraftLegalIdentity object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.sameAsOwner != null) {
      yield r'same_as_owner';
      yield serializers.serialize(
        object.sameAsOwner,
        specifiedType: const FullType(bool),
      );
    }
    if (object.surname != null) {
      yield r'surname';
      yield serializers.serialize(
        object.surname,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.firstName != null) {
      yield r'first_name';
      yield serializers.serialize(
        object.firstName,
        specifiedType: const FullType.nullable(String),
      );
    }
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
    if (object.companyRegisteredName != null) {
      yield r'company_registered_name';
      yield serializers.serialize(
        object.companyRegisteredName,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.idType != null) {
      yield r'id_type';
      yield serializers.serialize(
        object.idType,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.idNumber != null) {
      yield r'id_number';
      yield serializers.serialize(
        object.idNumber,
        specifiedType: const FullType.nullable(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    VendorVerificationDraftLegalIdentity object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required VendorVerificationDraftLegalIdentityBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'same_as_owner':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.sameAsOwner = valueDes;
          break;
        case r'surname':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.surname = valueDes;
          break;
        case r'first_name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
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
        case r'company_registered_name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.companyRegisteredName = valueDes;
          break;
        case r'id_type':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.idType = valueDes;
          break;
        case r'id_number':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.idNumber = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  VendorVerificationDraftLegalIdentity deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = VendorVerificationDraftLegalIdentityBuilder();
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


