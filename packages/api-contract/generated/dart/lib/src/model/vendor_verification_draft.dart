//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/vendor_verification_draft_tax_profile.dart';
import 'package:materyalph_api_client/src/model/date.dart';
import 'package:materyalph_api_client/src/model/vendor_verification_draft_legal_identity.dart';
import 'package:built_collection/built_collection.dart';
import 'package:materyalph_api_client/src/model/vendor_verification_draft_representative.dart';
import 'package:materyalph_api_client/src/model/vendor_verification_draft_classification.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'vendor_verification_draft.g.dart';

/// Store contact information uses store_email and store_phone. The retired contacts field is rejected and is not returned in current Vendor or Admin snapshots.
///
/// Properties:
/// * [formState] - Encrypted unvalidated form progress as a JSON object of field names to string arrays. Saving progress does not submit or update review records. Sensitive identity numbers are omitted on read and merged server-side on final validation.
/// * [draftLockVersion] - Workstream draft version; zero on first save. Send together with the required organization guard. Omission retains legacy behavior without draft-level comparison. A stale draft returns 409 STALE_VERSION; a stale organization returns 409 RESOURCE_VERSION_CONFLICT.
/// * [lockVersion]
/// * [businessType]
/// * [registeredName]
/// * [legalBusinessName]
/// * [storeName]
/// * [dateEstablished]
/// * [storeEmail]
/// * [storePhone]
/// * [classification]
/// * [address] - New or changed addresses require province_code, city_code, psgc_code, street (2–200 characters), four-digit postal_code and canonical display names. source MANUAL is sufficient without geocoding or a token and stores null coordinates. Otherwise resolution_token from resolveVendorAddress is required. Client latitude and longitude are prohibited. Omit address to retain an existing record.
/// * [representative]
/// * [legalIdentity]
/// * [taxProfile]
@BuiltValue()
abstract class VendorVerificationDraft implements Built<VendorVerificationDraft, VendorVerificationDraftBuilder> {
  /// Encrypted unvalidated form progress as a JSON object of field names to string arrays. Saving progress does not submit or update review records. Sensitive identity numbers are omitted on read and merged server-side on final validation.
  @BuiltValueField(wireName: r'form_state')
  String? get formState;

  /// Workstream draft version; zero on first save. Send together with the required organization guard. Omission retains legacy behavior without draft-level comparison. A stale draft returns 409 STALE_VERSION; a stale organization returns 409 RESOURCE_VERSION_CONFLICT.
  @BuiltValueField(wireName: r'draft_lock_version')
  int? get draftLockVersion;

  @BuiltValueField(wireName: r'lock_version')
  int get lockVersion;

  @BuiltValueField(wireName: r'business_type')
  VendorVerificationDraftBusinessTypeEnum? get businessType;
  // enum businessTypeEnum {  SOLE_PROPRIETORSHIP,  PARTNERSHIP,  CORPORATION,  ONE_PERSON_CORPORATION,  COOPERATIVE,  };

  @Deprecated('registeredName has been deprecated')
  @BuiltValueField(wireName: r'registered_name')
  String? get registeredName;

  @BuiltValueField(wireName: r'legal_business_name')
  String? get legalBusinessName;

  @BuiltValueField(wireName: r'store_name')
  String? get storeName;

  @BuiltValueField(wireName: r'date_established')
  Date? get dateEstablished;

  @BuiltValueField(wireName: r'store_email')
  String? get storeEmail;

  @BuiltValueField(wireName: r'store_phone')
  String? get storePhone;

  @BuiltValueField(wireName: r'classification')
  VendorVerificationDraftClassification? get classification;

  /// New or changed addresses require province_code, city_code, psgc_code, street (2–200 characters), four-digit postal_code and canonical display names. source MANUAL is sufficient without geocoding or a token and stores null coordinates. Otherwise resolution_token from resolveVendorAddress is required. Client latitude and longitude are prohibited. Omit address to retain an existing record.
  @BuiltValueField(wireName: r'address')
  BuiltMap<String, JsonObject?>? get address;

  @BuiltValueField(wireName: r'representative')
  VendorVerificationDraftRepresentative? get representative;

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
    if (object.formState != null) {
      yield r'form_state';
      yield serializers.serialize(
        object.formState,
        specifiedType: const FullType(String),
      );
    }
    if (object.draftLockVersion != null) {
      yield r'draft_lock_version';
      yield serializers.serialize(
        object.draftLockVersion,
        specifiedType: const FullType(int),
      );
    }
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
    if (object.legalBusinessName != null) {
      yield r'legal_business_name';
      yield serializers.serialize(
        object.legalBusinessName,
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
    if (object.classification != null) {
      yield r'classification';
      yield serializers.serialize(
        object.classification,
        specifiedType: const FullType(VendorVerificationDraftClassification),
      );
    }
    if (object.address != null) {
      yield r'address';
      yield serializers.serialize(
        object.address,
        specifiedType: const FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
      );
    }
    if (object.representative != null) {
      yield r'representative';
      yield serializers.serialize(
        object.representative,
        specifiedType: const FullType(VendorVerificationDraftRepresentative),
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
        case r'form_state':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.formState = valueDes;
          break;
        case r'draft_lock_version':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.draftLockVersion = valueDes;
          break;
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
        case r'legal_business_name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.legalBusinessName = valueDes;
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
        case r'classification':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(VendorVerificationDraftClassification),
          ) as VendorVerificationDraftClassification?;
          if (valueDes == null) continue;
          result.classification = valueDes.toBuilder();
          break;
        case r'address':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
          ) as BuiltMap<String, JsonObject?>?;
          if (valueDes == null) continue;
          result.address.replace(valueDes);
          break;
        case r'representative':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(VendorVerificationDraftRepresentative),
          ) as VendorVerificationDraftRepresentative?;
          if (valueDes == null) continue;
          result.representative.replace(valueDes);
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

