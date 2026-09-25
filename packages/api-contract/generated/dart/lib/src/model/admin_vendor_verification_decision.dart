//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/date.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_vendor_verification_decision.g.dart';

/// AdminVendorVerificationDecision
///
/// Properties:
/// * [authorityEvidenceVersionId]
/// * [authorityScopes]
/// * [decision]
/// * [lockVersion]
/// * [requirementVersions] - Current lock version of every applicable underlying requirement when deciding a grouped review item.
/// * [reason]
/// * [verifiedDocumentNumber]
/// * [verifiedIssueDate]
/// * [expirationKind]
/// * [verifiedExpirationDate]
/// * [evidenceSource]
/// * [verifiedVatCategory]
/// * [remarks]
@BuiltValue()
abstract class AdminVendorVerificationDecision implements Built<AdminVendorVerificationDecision, AdminVendorVerificationDecisionBuilder> {
  @BuiltValueField(wireName: r'authority_evidence_version_id')
  String? get authorityEvidenceVersionId;

  @BuiltValueField(wireName: r'authority_scopes')
  BuiltList<AdminVendorVerificationDecisionAuthorityScopesEnum>? get authorityScopes;
  // enum authorityScopesEnum {  TAX_DECLARATIONS,  COMMISSION_AGREEMENT,  PAYMENT_CONFIGURATION,  };

  @BuiltValueField(wireName: r'decision')
  AdminVendorVerificationDecisionDecisionEnum get decision;
  // enum decisionEnum {  APPROVED,  CHANGES_REQUIRED,  REJECTED,  };

  @BuiltValueField(wireName: r'lock_version')
  int? get lockVersion;

  /// Current lock version of every applicable underlying requirement when deciding a grouped review item.
  @BuiltValueField(wireName: r'requirement_versions')
  BuiltMap<String, int>? get requirementVersions;

  @BuiltValueField(wireName: r'reason')
  String? get reason;

  @BuiltValueField(wireName: r'verified_document_number')
  String? get verifiedDocumentNumber;

  @BuiltValueField(wireName: r'verified_issue_date')
  Date? get verifiedIssueDate;

  @BuiltValueField(wireName: r'expiration_kind')
  AdminVendorVerificationDecisionExpirationKindEnum? get expirationKind;
  // enum expirationKindEnum {  DATE,  NO_EXPIRATION,  UNVERIFIED,  };

  @BuiltValueField(wireName: r'verified_expiration_date')
  Date? get verifiedExpirationDate;

  @BuiltValueField(wireName: r'evidence_source')
  String? get evidenceSource;

  @BuiltValueField(wireName: r'verified_vat_category')
  AdminVendorVerificationDecisionVerifiedVatCategoryEnum? get verifiedVatCategory;
  // enum verifiedVatCategoryEnum {  VAT,  NON_VAT,  VAT_ZERO,  VAT_EXEMPT,  };

  @BuiltValueField(wireName: r'remarks')
  String? get remarks;

  AdminVendorVerificationDecision._();

  factory AdminVendorVerificationDecision([void updates(AdminVendorVerificationDecisionBuilder b)]) = _$AdminVendorVerificationDecision;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminVendorVerificationDecisionBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminVendorVerificationDecision> get serializer => _$AdminVendorVerificationDecisionSerializer();
}

class _$AdminVendorVerificationDecisionSerializer implements PrimitiveSerializer<AdminVendorVerificationDecision> {
  @override
  final Iterable<Type> types = const [AdminVendorVerificationDecision, _$AdminVendorVerificationDecision];

  @override
  final String wireName = r'AdminVendorVerificationDecision';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminVendorVerificationDecision object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.authorityEvidenceVersionId != null) {
      yield r'authority_evidence_version_id';
      yield serializers.serialize(
        object.authorityEvidenceVersionId,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.authorityScopes != null) {
      yield r'authority_scopes';
      yield serializers.serialize(
        object.authorityScopes,
        specifiedType: const FullType(BuiltList, [FullType(AdminVendorVerificationDecisionAuthorityScopesEnum)]),
      );
    }
    yield r'decision';
    yield serializers.serialize(
      object.decision,
      specifiedType: const FullType(AdminVendorVerificationDecisionDecisionEnum),
    );
    if (object.lockVersion != null) {
      yield r'lock_version';
      yield serializers.serialize(
        object.lockVersion,
        specifiedType: const FullType(int),
      );
    }
    if (object.requirementVersions != null) {
      yield r'requirement_versions';
      yield serializers.serialize(
        object.requirementVersions,
        specifiedType: const FullType(BuiltMap, [FullType(String), FullType(int)]),
      );
    }
    if (object.reason != null) {
      yield r'reason';
      yield serializers.serialize(
        object.reason,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.verifiedDocumentNumber != null) {
      yield r'verified_document_number';
      yield serializers.serialize(
        object.verifiedDocumentNumber,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.verifiedIssueDate != null) {
      yield r'verified_issue_date';
      yield serializers.serialize(
        object.verifiedIssueDate,
        specifiedType: const FullType.nullable(Date),
      );
    }
    if (object.expirationKind != null) {
      yield r'expiration_kind';
      yield serializers.serialize(
        object.expirationKind,
        specifiedType: const FullType(AdminVendorVerificationDecisionExpirationKindEnum),
      );
    }
    if (object.verifiedExpirationDate != null) {
      yield r'verified_expiration_date';
      yield serializers.serialize(
        object.verifiedExpirationDate,
        specifiedType: const FullType.nullable(Date),
      );
    }
    if (object.evidenceSource != null) {
      yield r'evidence_source';
      yield serializers.serialize(
        object.evidenceSource,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.verifiedVatCategory != null) {
      yield r'verified_vat_category';
      yield serializers.serialize(
        object.verifiedVatCategory,
        specifiedType: const FullType.nullable(AdminVendorVerificationDecisionVerifiedVatCategoryEnum),
      );
    }
    if (object.remarks != null) {
      yield r'remarks';
      yield serializers.serialize(
        object.remarks,
        specifiedType: const FullType.nullable(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminVendorVerificationDecision object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminVendorVerificationDecisionBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'authority_evidence_version_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.authorityEvidenceVersionId = valueDes;
          break;
        case r'authority_scopes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BuiltList, [FullType(AdminVendorVerificationDecisionAuthorityScopesEnum)]),
          ) as BuiltList<AdminVendorVerificationDecisionAuthorityScopesEnum>?;
          if (valueDes == null) continue;
          result.authorityScopes.replace(valueDes);
          break;
        case r'decision':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AdminVendorVerificationDecisionDecisionEnum),
          ) as AdminVendorVerificationDecisionDecisionEnum;
          result.decision = valueDes;
          break;
        case r'lock_version':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.lockVersion = valueDes;
          break;
        case r'requirement_versions':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BuiltMap, [FullType(String), FullType(int)]),
          ) as BuiltMap<String, int>?;
          if (valueDes == null) continue;
          result.requirementVersions.replace(valueDes);
          break;
        case r'reason':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.reason = valueDes;
          break;
        case r'verified_document_number':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.verifiedDocumentNumber = valueDes;
          break;
        case r'verified_issue_date':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(Date),
          ) as Date?;
          if (valueDes == null) continue;
          result.verifiedIssueDate = valueDes;
          break;
        case r'expiration_kind':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(AdminVendorVerificationDecisionExpirationKindEnum),
          ) as AdminVendorVerificationDecisionExpirationKindEnum?;
          if (valueDes == null) continue;
          result.expirationKind = valueDes;
          break;
        case r'verified_expiration_date':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(Date),
          ) as Date?;
          if (valueDes == null) continue;
          result.verifiedExpirationDate = valueDes;
          break;
        case r'evidence_source':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.evidenceSource = valueDes;
          break;
        case r'verified_vat_category':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(AdminVendorVerificationDecisionVerifiedVatCategoryEnum),
          ) as AdminVendorVerificationDecisionVerifiedVatCategoryEnum?;
          if (valueDes == null) continue;
          result.verifiedVatCategory = valueDes;
          break;
        case r'remarks':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.remarks = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminVendorVerificationDecision deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminVendorVerificationDecisionBuilder();
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


class AdminVendorVerificationDecisionAuthorityScopesEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'TAX_DECLARATIONS')
  static const AdminVendorVerificationDecisionAuthorityScopesEnum TAX_DECLARATIONS = _$adminVendorVerificationDecisionAuthorityScopesEnum_TAX_DECLARATIONS;
  @BuiltValueEnumConst(wireName: r'COMMISSION_AGREEMENT')
  static const AdminVendorVerificationDecisionAuthorityScopesEnum COMMISSION_AGREEMENT = _$adminVendorVerificationDecisionAuthorityScopesEnum_COMMISSION_AGREEMENT;
  @BuiltValueEnumConst(wireName: r'PAYMENT_CONFIGURATION')
  static const AdminVendorVerificationDecisionAuthorityScopesEnum PAYMENT_CONFIGURATION = _$adminVendorVerificationDecisionAuthorityScopesEnum_PAYMENT_CONFIGURATION;

  static Serializer<AdminVendorVerificationDecisionAuthorityScopesEnum> get serializer => _$adminVendorVerificationDecisionAuthorityScopesEnumSerializer;

  const AdminVendorVerificationDecisionAuthorityScopesEnum._(String name): super(name);

  static BuiltSet<AdminVendorVerificationDecisionAuthorityScopesEnum> get values => _$adminVendorVerificationDecisionAuthorityScopesEnumValues;
  static AdminVendorVerificationDecisionAuthorityScopesEnum valueOf(String name) => _$adminVendorVerificationDecisionAuthorityScopesEnumValueOf(name);
}

class AdminVendorVerificationDecisionDecisionEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'APPROVED')
  static const AdminVendorVerificationDecisionDecisionEnum APPROVED = _$adminVendorVerificationDecisionDecisionEnum_APPROVED;
  @BuiltValueEnumConst(wireName: r'CHANGES_REQUIRED')
  static const AdminVendorVerificationDecisionDecisionEnum CHANGES_REQUIRED = _$adminVendorVerificationDecisionDecisionEnum_CHANGES_REQUIRED;
  @BuiltValueEnumConst(wireName: r'REJECTED')
  static const AdminVendorVerificationDecisionDecisionEnum REJECTED = _$adminVendorVerificationDecisionDecisionEnum_REJECTED;

  static Serializer<AdminVendorVerificationDecisionDecisionEnum> get serializer => _$adminVendorVerificationDecisionDecisionEnumSerializer;

  const AdminVendorVerificationDecisionDecisionEnum._(String name): super(name);

  static BuiltSet<AdminVendorVerificationDecisionDecisionEnum> get values => _$adminVendorVerificationDecisionDecisionEnumValues;
  static AdminVendorVerificationDecisionDecisionEnum valueOf(String name) => _$adminVendorVerificationDecisionDecisionEnumValueOf(name);
}

class AdminVendorVerificationDecisionExpirationKindEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'DATE')
  static const AdminVendorVerificationDecisionExpirationKindEnum DATE = _$adminVendorVerificationDecisionExpirationKindEnum_DATE;
  @BuiltValueEnumConst(wireName: r'NO_EXPIRATION')
  static const AdminVendorVerificationDecisionExpirationKindEnum NO_EXPIRATION = _$adminVendorVerificationDecisionExpirationKindEnum_NO_EXPIRATION;
  @BuiltValueEnumConst(wireName: r'UNVERIFIED')
  static const AdminVendorVerificationDecisionExpirationKindEnum UNVERIFIED = _$adminVendorVerificationDecisionExpirationKindEnum_UNVERIFIED;

  static Serializer<AdminVendorVerificationDecisionExpirationKindEnum> get serializer => _$adminVendorVerificationDecisionExpirationKindEnumSerializer;

  const AdminVendorVerificationDecisionExpirationKindEnum._(String name): super(name);

  static BuiltSet<AdminVendorVerificationDecisionExpirationKindEnum> get values => _$adminVendorVerificationDecisionExpirationKindEnumValues;
  static AdminVendorVerificationDecisionExpirationKindEnum valueOf(String name) => _$adminVendorVerificationDecisionExpirationKindEnumValueOf(name);
}

class AdminVendorVerificationDecisionVerifiedVatCategoryEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'VAT')
  static const AdminVendorVerificationDecisionVerifiedVatCategoryEnum VAT = _$adminVendorVerificationDecisionVerifiedVatCategoryEnum_VAT;
  @BuiltValueEnumConst(wireName: r'NON_VAT')
  static const AdminVendorVerificationDecisionVerifiedVatCategoryEnum NON_VAT = _$adminVendorVerificationDecisionVerifiedVatCategoryEnum_NON_VAT;
  @BuiltValueEnumConst(wireName: r'VAT_ZERO')
  static const AdminVendorVerificationDecisionVerifiedVatCategoryEnum VAT_ZERO = _$adminVendorVerificationDecisionVerifiedVatCategoryEnum_VAT_ZERO;
  @BuiltValueEnumConst(wireName: r'VAT_EXEMPT')
  static const AdminVendorVerificationDecisionVerifiedVatCategoryEnum VAT_EXEMPT = _$adminVendorVerificationDecisionVerifiedVatCategoryEnum_VAT_EXEMPT;

  static Serializer<AdminVendorVerificationDecisionVerifiedVatCategoryEnum> get serializer => _$adminVendorVerificationDecisionVerifiedVatCategoryEnumSerializer;

  const AdminVendorVerificationDecisionVerifiedVatCategoryEnum._(String name): super(name);

  static BuiltSet<AdminVendorVerificationDecisionVerifiedVatCategoryEnum> get values => _$adminVendorVerificationDecisionVerifiedVatCategoryEnumValues;
  static AdminVendorVerificationDecisionVerifiedVatCategoryEnum valueOf(String name) => _$adminVendorVerificationDecisionVerifiedVatCategoryEnumValueOf(name);
}

