//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/vendor_tax_profile_evidence_versions_inner.dart';
import 'package:built_collection/built_collection.dart';
import 'package:materyalph_api_client/src/model/vendor_tax_version_history.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'vendor_tax_profile.g.dart';

/// VendorTaxProfile
///
/// Properties:
/// * [reviewReason]
/// * [lockVersion]
/// * [evidenceVersions]
/// * [profileId]
/// * [versionId]
/// * [version]
/// * [status]
/// * [environment]
/// * [evidenceOrigin]
/// * [data]
/// * [ownerAttestedAt]
/// * [withholdingTreatment]
/// * [history]
/// * [legalEffect]
@BuiltValue()
abstract class VendorTaxProfile implements Built<VendorTaxProfile, VendorTaxProfileBuilder> {
  @BuiltValueField(wireName: r'review_reason')
  String? get reviewReason;

  @BuiltValueField(wireName: r'lock_version')
  int get lockVersion;

  @BuiltValueField(wireName: r'evidence_versions')
  BuiltList<VendorTaxProfileEvidenceVersionsInner> get evidenceVersions;

  @BuiltValueField(wireName: r'profile_id')
  String? get profileId;

  @BuiltValueField(wireName: r'version_id')
  String? get versionId;

  @BuiltValueField(wireName: r'version')
  int? get version;

  @BuiltValueField(wireName: r'status')
  String get status;

  @BuiltValueField(wireName: r'environment')
  String get environment;

  @BuiltValueField(wireName: r'evidence_origin')
  String get evidenceOrigin;

  @BuiltValueField(wireName: r'data')
  BuiltMap<String, JsonObject?> get data;

  @BuiltValueField(wireName: r'owner_attested_at')
  String? get ownerAttestedAt;

  @BuiltValueField(wireName: r'withholding_treatment')
  String get withholdingTreatment;

  @BuiltValueField(wireName: r'history')
  BuiltList<VendorTaxVersionHistory> get history;

  @BuiltValueField(wireName: r'legal_effect')
  VendorTaxProfileLegalEffectEnum get legalEffect;
  // enum legalEffectEnum {  TEST_DEMO_ONLY_NOT_REGULATORY_APPROVAL,  };

  VendorTaxProfile._();

  factory VendorTaxProfile([void updates(VendorTaxProfileBuilder b)]) = _$VendorTaxProfile;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(VendorTaxProfileBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<VendorTaxProfile> get serializer => _$VendorTaxProfileSerializer();
}

class _$VendorTaxProfileSerializer implements PrimitiveSerializer<VendorTaxProfile> {
  @override
  final Iterable<Type> types = const [VendorTaxProfile, _$VendorTaxProfile];

  @override
  final String wireName = r'VendorTaxProfile';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    VendorTaxProfile object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'review_reason';
    yield object.reviewReason == null ? null : serializers.serialize(
      object.reviewReason,
      specifiedType: const FullType.nullable(String),
    );
    yield r'lock_version';
    yield serializers.serialize(
      object.lockVersion,
      specifiedType: const FullType(int),
    );
    yield r'evidence_versions';
    yield serializers.serialize(
      object.evidenceVersions,
      specifiedType: const FullType(BuiltList, [FullType(VendorTaxProfileEvidenceVersionsInner)]),
    );
    yield r'profile_id';
    yield object.profileId == null ? null : serializers.serialize(
      object.profileId,
      specifiedType: const FullType.nullable(String),
    );
    yield r'version_id';
    yield object.versionId == null ? null : serializers.serialize(
      object.versionId,
      specifiedType: const FullType.nullable(String),
    );
    yield r'version';
    yield object.version == null ? null : serializers.serialize(
      object.version,
      specifiedType: const FullType.nullable(int),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(String),
    );
    yield r'environment';
    yield serializers.serialize(
      object.environment,
      specifiedType: const FullType(String),
    );
    yield r'evidence_origin';
    yield serializers.serialize(
      object.evidenceOrigin,
      specifiedType: const FullType(String),
    );
    yield r'data';
    yield serializers.serialize(
      object.data,
      specifiedType: const FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
    );
    yield r'owner_attested_at';
    yield object.ownerAttestedAt == null ? null : serializers.serialize(
      object.ownerAttestedAt,
      specifiedType: const FullType.nullable(String),
    );
    yield r'withholding_treatment';
    yield serializers.serialize(
      object.withholdingTreatment,
      specifiedType: const FullType(String),
    );
    yield r'history';
    yield serializers.serialize(
      object.history,
      specifiedType: const FullType(BuiltList, [FullType(VendorTaxVersionHistory)]),
    );
    yield r'legal_effect';
    yield serializers.serialize(
      object.legalEffect,
      specifiedType: const FullType(VendorTaxProfileLegalEffectEnum),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    VendorTaxProfile object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required VendorTaxProfileBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'review_reason':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.reviewReason = valueDes;
          break;
        case r'lock_version':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.lockVersion = valueDes;
          break;
        case r'evidence_versions':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(VendorTaxProfileEvidenceVersionsInner)]),
          ) as BuiltList<VendorTaxProfileEvidenceVersionsInner>;
          result.evidenceVersions.replace(valueDes);
          break;
        case r'profile_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.profileId = valueDes;
          break;
        case r'version_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.versionId = valueDes;
          break;
        case r'version':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.version = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.status = valueDes;
          break;
        case r'environment':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.environment = valueDes;
          break;
        case r'evidence_origin':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.evidenceOrigin = valueDes;
          break;
        case r'data':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
          ) as BuiltMap<String, JsonObject?>;
          result.data.replace(valueDes);
          break;
        case r'owner_attested_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.ownerAttestedAt = valueDes;
          break;
        case r'withholding_treatment':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.withholdingTreatment = valueDes;
          break;
        case r'history':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(VendorTaxVersionHistory)]),
          ) as BuiltList<VendorTaxVersionHistory>;
          result.history.replace(valueDes);
          break;
        case r'legal_effect':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(VendorTaxProfileLegalEffectEnum),
          ) as VendorTaxProfileLegalEffectEnum;
          result.legalEffect = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  VendorTaxProfile deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = VendorTaxProfileBuilder();
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


class VendorTaxProfileLegalEffectEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'TEST_DEMO_ONLY_NOT_REGULATORY_APPROVAL')
  static const VendorTaxProfileLegalEffectEnum TEST_DEMO_ONLY_NOT_REGULATORY_APPROVAL = _$vendorTaxProfileLegalEffectEnum_TEST_DEMO_ONLY_NOT_REGULATORY_APPROVAL;

  static Serializer<VendorTaxProfileLegalEffectEnum> get serializer => _$vendorTaxProfileLegalEffectEnumSerializer;

  const VendorTaxProfileLegalEffectEnum._(String name): super(name);

  static BuiltSet<VendorTaxProfileLegalEffectEnum> get values => _$vendorTaxProfileLegalEffectEnumValues;
  static VendorTaxProfileLegalEffectEnum valueOf(String name) => _$vendorTaxProfileLegalEffectEnumValueOf(name);
}

