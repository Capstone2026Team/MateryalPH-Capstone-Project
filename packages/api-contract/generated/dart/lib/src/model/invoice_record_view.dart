//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:materyalph_api_client/src/model/dispute_file_link.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'invoice_record_view.g.dart';

/// A protected copy of an externally issued Vendor document. An uploaded PDF is not proof of BIR or structured e-invoicing compliance; a reconciliation difference never changes the accepted Buyer total.
///
/// Properties:
/// * [id]
/// * [invoiceType]
/// * [issuer]
/// * [invoiceNumber]
/// * [issuedOn]
/// * [amountCentavos]
/// * [vatCentavos]
/// * [documentOrigin]
/// * [originLabel]
/// * [verificationState]
/// * [eInvoicingCoverage]
/// * [complianceNote]
/// * [reconciliationState]
/// * [reconciliationDifferenceCentavos]
/// * [expectedTotalCentavos]
/// * [reconciliationNote]
/// * [amendsInvoiceRecordId]
/// * [uploadedAt]
/// * [uploadedRole]
/// * [sourceSystem]
/// * [invoicingMethod]
/// * [download]
/// * [canExplain]
/// * [buyerTotalUnchanged]
/// * [orderReference]
/// * [vendorName]
/// * [downloads]
/// * [lastDownloadAt]
@BuiltValue()
abstract class InvoiceRecordView implements Built<InvoiceRecordView, InvoiceRecordViewBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'invoice_type')
  InvoiceRecordViewInvoiceTypeEnum get invoiceType;
  // enum invoiceTypeEnum {  VENDOR_GOODS_INVOICE,  VENDOR_ADJUSTMENT_DOCUMENT,  PLATFORM_SERVICE_INVOICE,  PROCESSOR_INVOICE,  };

  @BuiltValueField(wireName: r'issuer')
  String get issuer;

  @BuiltValueField(wireName: r'invoice_number')
  String get invoiceNumber;

  @BuiltValueField(wireName: r'issued_on')
  String get issuedOn;

  @BuiltValueField(wireName: r'amount_centavos')
  int get amountCentavos;

  @BuiltValueField(wireName: r'vat_centavos')
  int? get vatCentavos;

  @BuiltValueField(wireName: r'document_origin')
  InvoiceRecordViewDocumentOriginEnum get documentOrigin;
  // enum documentOriginEnum {  DEMO_SAMPLE,  VENDOR_REGISTERED_PROCESS,  PLATFORM_SAMPLE,  };

  @BuiltValueField(wireName: r'origin_label')
  String get originLabel;

  @BuiltValueField(wireName: r'verification_state')
  InvoiceRecordViewVerificationStateEnum get verificationState;
  // enum verificationStateEnum {  UNVERIFIED,  VERIFIED,  REJECTED,  };

  @BuiltValueField(wireName: r'e_invoicing_coverage')
  InvoiceRecordViewEInvoicingCoverageEnum get eInvoicingCoverage;
  // enum eInvoicingCoverageEnum {  REVIEW_REQUIRED,  COVERED,  NOT_COVERED,  EXEMPT_MICRO,  };

  @BuiltValueField(wireName: r'compliance_note')
  String get complianceNote;

  @BuiltValueField(wireName: r'reconciliation_state')
  InvoiceRecordViewReconciliationStateEnum get reconciliationState;
  // enum reconciliationStateEnum {  NOT_APPLICABLE,  MATCHED,  INVOICE_RECONCILIATION_REQUIRED,  EXPLAINED,  CORRECTED,  };

  @BuiltValueField(wireName: r'reconciliation_difference_centavos')
  int get reconciliationDifferenceCentavos;

  @BuiltValueField(wireName: r'expected_total_centavos')
  int? get expectedTotalCentavos;

  @BuiltValueField(wireName: r'reconciliation_note')
  String? get reconciliationNote;

  @BuiltValueField(wireName: r'amends_invoice_record_id')
  String? get amendsInvoiceRecordId;

  @BuiltValueField(wireName: r'uploaded_at')
  DateTime? get uploadedAt;

  @BuiltValueField(wireName: r'uploaded_role')
  String? get uploadedRole;

  @BuiltValueField(wireName: r'source_system')
  String? get sourceSystem;

  @BuiltValueField(wireName: r'invoicing_method')
  String? get invoicingMethod;

  @BuiltValueField(wireName: r'download')
  DisputeFileLink? get download;

  @BuiltValueField(wireName: r'can_explain')
  bool get canExplain;

  @BuiltValueField(wireName: r'buyer_total_unchanged')
  bool get buyerTotalUnchanged;

  @BuiltValueField(wireName: r'order_reference')
  String? get orderReference;

  @BuiltValueField(wireName: r'vendor_name')
  String? get vendorName;

  @BuiltValueField(wireName: r'downloads')
  int? get downloads;

  @BuiltValueField(wireName: r'last_download_at')
  DateTime? get lastDownloadAt;

  InvoiceRecordView._();

  factory InvoiceRecordView([void updates(InvoiceRecordViewBuilder b)]) = _$InvoiceRecordView;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(InvoiceRecordViewBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<InvoiceRecordView> get serializer => _$InvoiceRecordViewSerializer();
}

class _$InvoiceRecordViewSerializer implements PrimitiveSerializer<InvoiceRecordView> {
  @override
  final Iterable<Type> types = const [InvoiceRecordView, _$InvoiceRecordView];

  @override
  final String wireName = r'InvoiceRecordView';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    InvoiceRecordView object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'invoice_type';
    yield serializers.serialize(
      object.invoiceType,
      specifiedType: const FullType(InvoiceRecordViewInvoiceTypeEnum),
    );
    yield r'issuer';
    yield serializers.serialize(
      object.issuer,
      specifiedType: const FullType(String),
    );
    yield r'invoice_number';
    yield serializers.serialize(
      object.invoiceNumber,
      specifiedType: const FullType(String),
    );
    yield r'issued_on';
    yield serializers.serialize(
      object.issuedOn,
      specifiedType: const FullType(String),
    );
    yield r'amount_centavos';
    yield serializers.serialize(
      object.amountCentavos,
      specifiedType: const FullType(int),
    );
    if (object.vatCentavos != null) {
      yield r'vat_centavos';
      yield serializers.serialize(
        object.vatCentavos,
        specifiedType: const FullType(int),
      );
    }
    yield r'document_origin';
    yield serializers.serialize(
      object.documentOrigin,
      specifiedType: const FullType(InvoiceRecordViewDocumentOriginEnum),
    );
    yield r'origin_label';
    yield serializers.serialize(
      object.originLabel,
      specifiedType: const FullType(String),
    );
    yield r'verification_state';
    yield serializers.serialize(
      object.verificationState,
      specifiedType: const FullType(InvoiceRecordViewVerificationStateEnum),
    );
    yield r'e_invoicing_coverage';
    yield serializers.serialize(
      object.eInvoicingCoverage,
      specifiedType: const FullType(InvoiceRecordViewEInvoicingCoverageEnum),
    );
    yield r'compliance_note';
    yield serializers.serialize(
      object.complianceNote,
      specifiedType: const FullType(String),
    );
    yield r'reconciliation_state';
    yield serializers.serialize(
      object.reconciliationState,
      specifiedType: const FullType(InvoiceRecordViewReconciliationStateEnum),
    );
    yield r'reconciliation_difference_centavos';
    yield serializers.serialize(
      object.reconciliationDifferenceCentavos,
      specifiedType: const FullType(int),
    );
    if (object.expectedTotalCentavos != null) {
      yield r'expected_total_centavos';
      yield serializers.serialize(
        object.expectedTotalCentavos,
        specifiedType: const FullType(int),
      );
    }
    if (object.reconciliationNote != null) {
      yield r'reconciliation_note';
      yield serializers.serialize(
        object.reconciliationNote,
        specifiedType: const FullType(String),
      );
    }
    if (object.amendsInvoiceRecordId != null) {
      yield r'amends_invoice_record_id';
      yield serializers.serialize(
        object.amendsInvoiceRecordId,
        specifiedType: const FullType(String),
      );
    }
    if (object.uploadedAt != null) {
      yield r'uploaded_at';
      yield serializers.serialize(
        object.uploadedAt,
        specifiedType: const FullType(DateTime),
      );
    }
    if (object.uploadedRole != null) {
      yield r'uploaded_role';
      yield serializers.serialize(
        object.uploadedRole,
        specifiedType: const FullType(String),
      );
    }
    if (object.sourceSystem != null) {
      yield r'source_system';
      yield serializers.serialize(
        object.sourceSystem,
        specifiedType: const FullType(String),
      );
    }
    if (object.invoicingMethod != null) {
      yield r'invoicing_method';
      yield serializers.serialize(
        object.invoicingMethod,
        specifiedType: const FullType(String),
      );
    }
    if (object.download != null) {
      yield r'download';
      yield serializers.serialize(
        object.download,
        specifiedType: const FullType.nullable(DisputeFileLink),
      );
    }
    yield r'can_explain';
    yield serializers.serialize(
      object.canExplain,
      specifiedType: const FullType(bool),
    );
    yield r'buyer_total_unchanged';
    yield serializers.serialize(
      object.buyerTotalUnchanged,
      specifiedType: const FullType(bool),
    );
    if (object.orderReference != null) {
      yield r'order_reference';
      yield serializers.serialize(
        object.orderReference,
        specifiedType: const FullType(String),
      );
    }
    if (object.vendorName != null) {
      yield r'vendor_name';
      yield serializers.serialize(
        object.vendorName,
        specifiedType: const FullType(String),
      );
    }
    if (object.downloads != null) {
      yield r'downloads';
      yield serializers.serialize(
        object.downloads,
        specifiedType: const FullType(int),
      );
    }
    if (object.lastDownloadAt != null) {
      yield r'last_download_at';
      yield serializers.serialize(
        object.lastDownloadAt,
        specifiedType: const FullType(DateTime),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    InvoiceRecordView object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required InvoiceRecordViewBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.id = valueDes;
          break;
        case r'invoice_type':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(InvoiceRecordViewInvoiceTypeEnum),
          ) as InvoiceRecordViewInvoiceTypeEnum;
          result.invoiceType = valueDes;
          break;
        case r'issuer':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.issuer = valueDes;
          break;
        case r'invoice_number':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.invoiceNumber = valueDes;
          break;
        case r'issued_on':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.issuedOn = valueDes;
          break;
        case r'amount_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.amountCentavos = valueDes;
          break;
        case r'vat_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.vatCentavos = valueDes;
          break;
        case r'document_origin':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(InvoiceRecordViewDocumentOriginEnum),
          ) as InvoiceRecordViewDocumentOriginEnum;
          result.documentOrigin = valueDes;
          break;
        case r'origin_label':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.originLabel = valueDes;
          break;
        case r'verification_state':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(InvoiceRecordViewVerificationStateEnum),
          ) as InvoiceRecordViewVerificationStateEnum;
          result.verificationState = valueDes;
          break;
        case r'e_invoicing_coverage':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(InvoiceRecordViewEInvoicingCoverageEnum),
          ) as InvoiceRecordViewEInvoicingCoverageEnum;
          result.eInvoicingCoverage = valueDes;
          break;
        case r'compliance_note':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.complianceNote = valueDes;
          break;
        case r'reconciliation_state':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(InvoiceRecordViewReconciliationStateEnum),
          ) as InvoiceRecordViewReconciliationStateEnum;
          result.reconciliationState = valueDes;
          break;
        case r'reconciliation_difference_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.reconciliationDifferenceCentavos = valueDes;
          break;
        case r'expected_total_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.expectedTotalCentavos = valueDes;
          break;
        case r'reconciliation_note':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.reconciliationNote = valueDes;
          break;
        case r'amends_invoice_record_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.amendsInvoiceRecordId = valueDes;
          break;
        case r'uploaded_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.uploadedAt = valueDes;
          break;
        case r'uploaded_role':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.uploadedRole = valueDes;
          break;
        case r'source_system':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.sourceSystem = valueDes;
          break;
        case r'invoicing_method':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.invoicingMethod = valueDes;
          break;
        case r'download':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DisputeFileLink),
          ) as DisputeFileLink?;
          if (valueDes == null) continue;
          result.download.replace(valueDes);
          break;
        case r'can_explain':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.canExplain = valueDes;
          break;
        case r'buyer_total_unchanged':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.buyerTotalUnchanged = valueDes;
          break;
        case r'order_reference':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.orderReference = valueDes;
          break;
        case r'vendor_name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.vendorName = valueDes;
          break;
        case r'downloads':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.downloads = valueDes;
          break;
        case r'last_download_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.lastDownloadAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  InvoiceRecordView deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = InvoiceRecordViewBuilder();
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


class InvoiceRecordViewInvoiceTypeEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'VENDOR_GOODS_INVOICE')
  static const InvoiceRecordViewInvoiceTypeEnum VENDOR_GOODS_INVOICE = _$invoiceRecordViewInvoiceTypeEnum_VENDOR_GOODS_INVOICE;
  @BuiltValueEnumConst(wireName: r'VENDOR_ADJUSTMENT_DOCUMENT')
  static const InvoiceRecordViewInvoiceTypeEnum VENDOR_ADJUSTMENT_DOCUMENT = _$invoiceRecordViewInvoiceTypeEnum_VENDOR_ADJUSTMENT_DOCUMENT;
  @BuiltValueEnumConst(wireName: r'PLATFORM_SERVICE_INVOICE')
  static const InvoiceRecordViewInvoiceTypeEnum PLATFORM_SERVICE_INVOICE = _$invoiceRecordViewInvoiceTypeEnum_PLATFORM_SERVICE_INVOICE;
  @BuiltValueEnumConst(wireName: r'PROCESSOR_INVOICE')
  static const InvoiceRecordViewInvoiceTypeEnum PROCESSOR_INVOICE = _$invoiceRecordViewInvoiceTypeEnum_PROCESSOR_INVOICE;

  static Serializer<InvoiceRecordViewInvoiceTypeEnum> get serializer => _$invoiceRecordViewInvoiceTypeEnumSerializer;

  const InvoiceRecordViewInvoiceTypeEnum._(String name): super(name);

  static BuiltSet<InvoiceRecordViewInvoiceTypeEnum> get values => _$invoiceRecordViewInvoiceTypeEnumValues;
  static InvoiceRecordViewInvoiceTypeEnum valueOf(String name) => _$invoiceRecordViewInvoiceTypeEnumValueOf(name);
}

class InvoiceRecordViewDocumentOriginEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'DEMO_SAMPLE')
  static const InvoiceRecordViewDocumentOriginEnum DEMO_SAMPLE = _$invoiceRecordViewDocumentOriginEnum_DEMO_SAMPLE;
  @BuiltValueEnumConst(wireName: r'VENDOR_REGISTERED_PROCESS')
  static const InvoiceRecordViewDocumentOriginEnum VENDOR_REGISTERED_PROCESS = _$invoiceRecordViewDocumentOriginEnum_VENDOR_REGISTERED_PROCESS;
  @BuiltValueEnumConst(wireName: r'PLATFORM_SAMPLE')
  static const InvoiceRecordViewDocumentOriginEnum PLATFORM_SAMPLE = _$invoiceRecordViewDocumentOriginEnum_PLATFORM_SAMPLE;

  static Serializer<InvoiceRecordViewDocumentOriginEnum> get serializer => _$invoiceRecordViewDocumentOriginEnumSerializer;

  const InvoiceRecordViewDocumentOriginEnum._(String name): super(name);

  static BuiltSet<InvoiceRecordViewDocumentOriginEnum> get values => _$invoiceRecordViewDocumentOriginEnumValues;
  static InvoiceRecordViewDocumentOriginEnum valueOf(String name) => _$invoiceRecordViewDocumentOriginEnumValueOf(name);
}

class InvoiceRecordViewVerificationStateEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'UNVERIFIED')
  static const InvoiceRecordViewVerificationStateEnum UNVERIFIED = _$invoiceRecordViewVerificationStateEnum_UNVERIFIED;
  @BuiltValueEnumConst(wireName: r'VERIFIED')
  static const InvoiceRecordViewVerificationStateEnum VERIFIED = _$invoiceRecordViewVerificationStateEnum_VERIFIED;
  @BuiltValueEnumConst(wireName: r'REJECTED')
  static const InvoiceRecordViewVerificationStateEnum REJECTED = _$invoiceRecordViewVerificationStateEnum_REJECTED;

  static Serializer<InvoiceRecordViewVerificationStateEnum> get serializer => _$invoiceRecordViewVerificationStateEnumSerializer;

  const InvoiceRecordViewVerificationStateEnum._(String name): super(name);

  static BuiltSet<InvoiceRecordViewVerificationStateEnum> get values => _$invoiceRecordViewVerificationStateEnumValues;
  static InvoiceRecordViewVerificationStateEnum valueOf(String name) => _$invoiceRecordViewVerificationStateEnumValueOf(name);
}

class InvoiceRecordViewEInvoicingCoverageEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'REVIEW_REQUIRED')
  static const InvoiceRecordViewEInvoicingCoverageEnum REVIEW_REQUIRED = _$invoiceRecordViewEInvoicingCoverageEnum_REVIEW_REQUIRED;
  @BuiltValueEnumConst(wireName: r'COVERED')
  static const InvoiceRecordViewEInvoicingCoverageEnum COVERED = _$invoiceRecordViewEInvoicingCoverageEnum_COVERED;
  @BuiltValueEnumConst(wireName: r'NOT_COVERED')
  static const InvoiceRecordViewEInvoicingCoverageEnum NOT_COVERED = _$invoiceRecordViewEInvoicingCoverageEnum_NOT_COVERED;
  @BuiltValueEnumConst(wireName: r'EXEMPT_MICRO')
  static const InvoiceRecordViewEInvoicingCoverageEnum EXEMPT_MICRO = _$invoiceRecordViewEInvoicingCoverageEnum_EXEMPT_MICRO;

  static Serializer<InvoiceRecordViewEInvoicingCoverageEnum> get serializer => _$invoiceRecordViewEInvoicingCoverageEnumSerializer;

  const InvoiceRecordViewEInvoicingCoverageEnum._(String name): super(name);

  static BuiltSet<InvoiceRecordViewEInvoicingCoverageEnum> get values => _$invoiceRecordViewEInvoicingCoverageEnumValues;
  static InvoiceRecordViewEInvoicingCoverageEnum valueOf(String name) => _$invoiceRecordViewEInvoicingCoverageEnumValueOf(name);
}

class InvoiceRecordViewReconciliationStateEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'NOT_APPLICABLE')
  static const InvoiceRecordViewReconciliationStateEnum NOT_APPLICABLE = _$invoiceRecordViewReconciliationStateEnum_NOT_APPLICABLE;
  @BuiltValueEnumConst(wireName: r'MATCHED')
  static const InvoiceRecordViewReconciliationStateEnum MATCHED = _$invoiceRecordViewReconciliationStateEnum_MATCHED;
  @BuiltValueEnumConst(wireName: r'INVOICE_RECONCILIATION_REQUIRED')
  static const InvoiceRecordViewReconciliationStateEnum INVOICE_RECONCILIATION_REQUIRED = _$invoiceRecordViewReconciliationStateEnum_INVOICE_RECONCILIATION_REQUIRED;
  @BuiltValueEnumConst(wireName: r'EXPLAINED')
  static const InvoiceRecordViewReconciliationStateEnum EXPLAINED = _$invoiceRecordViewReconciliationStateEnum_EXPLAINED;
  @BuiltValueEnumConst(wireName: r'CORRECTED')
  static const InvoiceRecordViewReconciliationStateEnum CORRECTED = _$invoiceRecordViewReconciliationStateEnum_CORRECTED;

  static Serializer<InvoiceRecordViewReconciliationStateEnum> get serializer => _$invoiceRecordViewReconciliationStateEnumSerializer;

  const InvoiceRecordViewReconciliationStateEnum._(String name): super(name);

  static BuiltSet<InvoiceRecordViewReconciliationStateEnum> get values => _$invoiceRecordViewReconciliationStateEnumValues;
  static InvoiceRecordViewReconciliationStateEnum valueOf(String name) => _$invoiceRecordViewReconciliationStateEnumValueOf(name);
}

