//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'vendor_verification_draft_representative.g.dart';

/// VendorVerificationDraftRepresentative
///
/// Properties:
/// * [sameAsOwner]
/// * [fullName]
/// * [position]
/// * [email]
/// * [phone]
/// * [relationship]
/// * [idType]
/// * [idNumber]
@BuiltValue()
abstract class VendorVerificationDraftRepresentative implements Built<VendorVerificationDraftRepresentative, VendorVerificationDraftRepresentativeBuilder> {
  @BuiltValueField(wireName: r'same_as_owner')
  bool? get sameAsOwner;

  @BuiltValueField(wireName: r'full_name')
  String get fullName;

  @BuiltValueField(wireName: r'position')
  String? get position;

  @BuiltValueField(wireName: r'email')
  String? get email;

  @BuiltValueField(wireName: r'phone')
  String? get phone;

  @BuiltValueField(wireName: r'relationship')
  String? get relationship;

  @BuiltValueField(wireName: r'id_type')
  VendorVerificationDraftRepresentativeIdTypeEnum? get idType;
  // enum idTypeEnum {  NATIONAL_ID,  DRIVERS_LICENSE,  PASSPORT,  UMID,  OTHER,  };

  @BuiltValueField(wireName: r'id_number')
  String? get idNumber;

  VendorVerificationDraftRepresentative._();

  factory VendorVerificationDraftRepresentative([void updates(VendorVerificationDraftRepresentativeBuilder b)]) = _$VendorVerificationDraftRepresentative;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(VendorVerificationDraftRepresentativeBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<VendorVerificationDraftRepresentative> get serializer => _$VendorVerificationDraftRepresentativeSerializer();
}

class _$VendorVerificationDraftRepresentativeSerializer implements PrimitiveSerializer<VendorVerificationDraftRepresentative> {
  @override
  final Iterable<Type> types = const [VendorVerificationDraftRepresentative, _$VendorVerificationDraftRepresentative];

  @override
  final String wireName = r'VendorVerificationDraftRepresentative';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    VendorVerificationDraftRepresentative object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.sameAsOwner != null) {
      yield r'same_as_owner';
      yield serializers.serialize(
        object.sameAsOwner,
        specifiedType: const FullType(bool),
      );
    }
    yield r'full_name';
    yield serializers.serialize(
      object.fullName,
      specifiedType: const FullType(String),
    );
    if (object.position != null) {
      yield r'position';
      yield serializers.serialize(
        object.position,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.email != null) {
      yield r'email';
      yield serializers.serialize(
        object.email,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.phone != null) {
      yield r'phone';
      yield serializers.serialize(
        object.phone,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.relationship != null) {
      yield r'relationship';
      yield serializers.serialize(
        object.relationship,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.idType != null) {
      yield r'id_type';
      yield serializers.serialize(
        object.idType,
        specifiedType: const FullType.nullable(VendorVerificationDraftRepresentativeIdTypeEnum),
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
    VendorVerificationDraftRepresentative object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required VendorVerificationDraftRepresentativeBuilder result,
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
        case r'full_name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.fullName = valueDes;
          break;
        case r'position':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.position = valueDes;
          break;
        case r'email':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.email = valueDes;
          break;
        case r'phone':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.phone = valueDes;
          break;
        case r'relationship':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.relationship = valueDes;
          break;
        case r'id_type':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(VendorVerificationDraftRepresentativeIdTypeEnum),
          ) as VendorVerificationDraftRepresentativeIdTypeEnum?;
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
  VendorVerificationDraftRepresentative deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = VendorVerificationDraftRepresentativeBuilder();
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


class VendorVerificationDraftRepresentativeIdTypeEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'NATIONAL_ID')
  static const VendorVerificationDraftRepresentativeIdTypeEnum NATIONAL_ID = _$vendorVerificationDraftRepresentativeIdTypeEnum_NATIONAL_ID;
  @BuiltValueEnumConst(wireName: r'DRIVERS_LICENSE')
  static const VendorVerificationDraftRepresentativeIdTypeEnum DRIVERS_LICENSE = _$vendorVerificationDraftRepresentativeIdTypeEnum_DRIVERS_LICENSE;
  @BuiltValueEnumConst(wireName: r'PASSPORT')
  static const VendorVerificationDraftRepresentativeIdTypeEnum PASSPORT = _$vendorVerificationDraftRepresentativeIdTypeEnum_PASSPORT;
  @BuiltValueEnumConst(wireName: r'UMID')
  static const VendorVerificationDraftRepresentativeIdTypeEnum UMID = _$vendorVerificationDraftRepresentativeIdTypeEnum_UMID;
  @BuiltValueEnumConst(wireName: r'OTHER')
  static const VendorVerificationDraftRepresentativeIdTypeEnum OTHER = _$vendorVerificationDraftRepresentativeIdTypeEnum_OTHER;

  static Serializer<VendorVerificationDraftRepresentativeIdTypeEnum> get serializer => _$vendorVerificationDraftRepresentativeIdTypeEnumSerializer;

  const VendorVerificationDraftRepresentativeIdTypeEnum._(String name): super(name);

  static BuiltSet<VendorVerificationDraftRepresentativeIdTypeEnum> get values => _$vendorVerificationDraftRepresentativeIdTypeEnumValues;
  static VendorVerificationDraftRepresentativeIdTypeEnum valueOf(String name) => _$vendorVerificationDraftRepresentativeIdTypeEnumValueOf(name);
}

