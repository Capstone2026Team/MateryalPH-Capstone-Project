//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/vendor_verification_draft_tax_profile.dart';
import 'package:materyalph_api_client/src/model/date.dart';
import 'package:materyalph_api_client/src/model/vendor_verification_draft_legal_identity.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'vendor_verification_draft.g.dart';

/// VendorVerificationDraft
///
/// Properties:
/// * [lockVersion]
/// * [businessType]
/// * [registeredName]
/// * [storeName]
/// * [dateEstablished]
/// * [storeEmail]
/// * [storePhone]
/// * [contacts]
/// * [classification]
/// * [address]
/// * [legalIdentity]
/// * [taxProfile]
@BuiltValue()
abstract class VendorVerificationDraft implements Built<VendorVerificationDraft, VendorVerificationDraftBuilder> {
  @BuiltValueField(wireName: r'lock_version')
  int get lockVersion;

  @BuiltValueField(wireName: r'business_type')
  VendorVerificationDraftBusinessTypeEnum? get businessType;
  // enum businessTypeEnum {  SOLE_PROPRIETORSHIP,  PARTNERSHIP,  CORPORATION,  ONE_PERSON_CORPORATION,  COOPERATIVE,  };

  @BuiltValueField(wireName: r'registered_name')
  String? get registeredName;

  @BuiltValueField(wireName: r'store_name')
  String? get storeName;

  @BuiltValueField(wireName: r'date_established')
  Date? get dateEstablished;

  @BuiltValueField(wireName: r'store_email')
  String? get storeEmail;

  @BuiltValueField(wireName: r'store_phone')
  String? get storePhone;

  @BuiltValueField(wireName: r'contacts')
  BuiltList<BuiltMap<String, JsonObject?>>? get contacts;

  @BuiltValueField(wireName: r'classification')
  BuiltMap<String, JsonObject?>? get classification;

  @BuiltValueField(wireName: r'address')
  BuiltMap<String, JsonObject?>? get address;

  @BuiltValueField(wireName: r'legal_identity')
  VendorVerificationDraftLegalIdentity? get legalIdentity;

  @BuiltValueField(wireName: r'tax_profile')
  VendorVerificationDraftTaxProfile? get taxProfile;

  VendorVerificationDraft._();

  factory VendorVerificationDraft([void updates(VendorVerificationDraftBuilder b)]) = _$VendorVerificationDraft;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(VendorVerificationDraftBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<VendorVerificationDraft> get serializer => _$VendorVerificationDraftSerializer();
}

class _$VendorVerificationDraftSerializer implements PrimitiveSerializer<VendorVerificationDraft> {
  @override
  final Iterable<Type> types = const [VendorVerificationDraft, _$VendorVerificationDraft];

  @override
  final String wireName = r'VendorVerificationDraft';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    VendorVerificationDraft object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'lock_version';
    yield serializers.serialize(
      object.lockVersion,
      specifiedType: const FullType(int),
    );
    if (object.businessType != null) {
      yield r'business_type';
      yield serializers.serialize(
        object.businessType,
        specifiedType: const FullType(VendorVerificationDraftBusinessTypeEnum),
      );
    }
    if (object.registeredName != null) {
      yield r'registered_name';
      yield serializers.serialize(
        object.registeredName,
        specifiedType: const FullType(String),
      );
    }
    if (object.storeName != null) {
      yield r'store_name';
      yield serializers.serialize(
        object.storeName,
        specifiedType: const FullType(String),
      );
    }
    if (object.dateEstablished != null) {
      yield r'date_established';
      yield serializers.serialize(
        object.dateEstablished,
        specifiedType: const FullType(Date),
      );
    }
    if (object.storeEmail != null) {
      yield r'store_email';
      yield serializers.serialize(
        object.storeEmail,
        specifiedType: const FullType(String),
      );
    }
    if (object.storePhone != null) {
      yield r'store_phone';
      yield serializers.serialize(
        object.storePhone,
        specifiedType: const FullType(String),
      );
    }
    if (object.contacts != null) {
      yield r'contacts';
      yield serializers.serialize(
        object.contacts,
        specifiedType: const FullType(BuiltList, [FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)])]),
      );
    }
    if (object.classification != null) {
      yield r'classification';
      yield serializers.serialize(
        object.classification,
        specifiedType: const FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
      );
    }
    if (object.address != null) {
      yield r'address';
      yield serializers.serialize(
        object.address,
        specifiedType: const FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
      );
    }
    if (object.legalIdentity != null) {
      yield r'legal_identity';
      yield serializers.serialize(
        object.legalIdentity,
        specifiedType: const FullType(VendorVerificationDraftLegalIdentity),
      );
    }
    if (object.taxProfile != null) {
      yield r'tax_profile';
      yield serializers.serialize(
        object.taxProfile,
        specifiedType: const FullType(VendorVerificationDraftTaxProfile),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    VendorVerificationDraft object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required VendorVerificationDraftBuilder result,
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
        case r'business_type':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(VendorVerificationDraftBusinessTypeEnum),
          ) as VendorVerificationDraftBusinessTypeEnum?;
          if (valueDes == null) continue;
          result.businessType = valueDes;
          break;
        case r'registered_name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.registeredName = valueDes;
          break;
        case r'store_name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.storeName = valueDes;
          break;
        case r'date_established':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(Date),
          ) as Date?;
          if (valueDes == null) continue;
          result.dateEstablished = valueDes;
          break;
        case r'store_email':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.storeEmail = valueDes;
          break;
        case r'store_phone':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.storePhone = valueDes;
          break;
        case r'contacts':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BuiltList, [FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)])]),
          ) as BuiltList<BuiltMap<String, JsonObject?>>?;
          if (valueDes == null) continue;
          result.contacts.replace(valueDes);
          break;
        case r'classification':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
          ) as BuiltMap<String, JsonObject?>?;
          if (valueDes == null) continue;
          result.classification.replace(valueDes);
          break;
        case r'address':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
          ) as BuiltMap<String, JsonObject?>?;
          if (valueDes == null) continue;
          result.address.replace(valueDes);
          break;
        case r'legal_identity':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(VendorVerificationDraftLegalIdentity),
          ) as VendorVerificationDraftLegalIdentity?;
          if (valueDes == null) continue;
          result.legalIdentity = valueDes.toBuilder();
          break;
        case r'tax_profile':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(VendorVerificationDraftTaxProfile),
          ) as VendorVerificationDraftTaxProfile?;
          if (valueDes == null) continue;
          result.taxProfile = valueDes.toBuilder();
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  VendorVerificationDraft deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = VendorVerificationDraftBuilder();
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


class VendorVerificationDraftBusinessTypeEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'SOLE_PROPRIETORSHIP')
  static const VendorVerificationDraftBusinessTypeEnum SOLE_PROPRIETORSHIP = _$vendorVerificationDraftBusinessTypeEnum_SOLE_PROPRIETORSHIP;
  @BuiltValueEnumConst(wireName: r'PARTNERSHIP')
  static const VendorVerificationDraftBusinessTypeEnum PARTNERSHIP = _$vendorVerificationDraftBusinessTypeEnum_PARTNERSHIP;
  @BuiltValueEnumConst(wireName: r'CORPORATION')
  static const VendorVerificationDraftBusinessTypeEnum CORPORATION = _$vendorVerificationDraftBusinessTypeEnum_CORPORATION;
  @BuiltValueEnumConst(wireName: r'ONE_PERSON_CORPORATION')
  static const VendorVerificationDraftBusinessTypeEnum ONE_PERSON_CORPORATION = _$vendorVerificationDraftBusinessTypeEnum_ONE_PERSON_CORPORATION;
  @BuiltValueEnumConst(wireName: r'COOPERATIVE')
  static const VendorVerificationDraftBusinessTypeEnum COOPERATIVE = _$vendorVerificationDraftBusinessTypeEnum_COOPERATIVE;

  static Serializer<VendorVerificationDraftBusinessTypeEnum> get serializer => _$vendorVerificationDraftBusinessTypeEnumSerializer;

  const VendorVerificationDraftBusinessTypeEnum._(String name): super(name);

  static BuiltSet<VendorVerificationDraftBusinessTypeEnum> get values => _$vendorVerificationDraftBusinessTypeEnumValues;
  static VendorVerificationDraftBusinessTypeEnum valueOf(String name) => _$vendorVerificationDraftBusinessTypeEnumValueOf(name);
}

