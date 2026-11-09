//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/date.dart';
import 'package:built_collection/built_collection.dart';
import 'package:materyalph_api_client/src/model/dispute_file_link.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'invoice_draft.g.dart';

/// Private Vendor preparation. Only invoice-upload roles receive it. The uploaded file is ready for review; sending freezes a separate invoice record. Buyer and Admin record lists never include drafts.
///
/// Properties:
/// * [invoiceType]
/// * [issuerName] - Must equal the registered business name.
/// * [invoiceNumber]
/// * [issuedOn] - Invoice calendar date; must not be later than today in Asia/Manila.
/// * [amountCentavos]
/// * [vatCentavos]
/// * [vatExemptCentavos]
/// * [zeroRatedCentavos]
/// * [relatedLineIds]
/// * [sourceSystem]
/// * [invoicingMethod]
/// * [amendsInvoiceRecordId]
/// * [invoiceRequestId]
/// * [lockVersion]
/// * [id]
/// * [sentRecordId]
/// * [sentAt]
/// * [updatedAt]
/// * [fileName]
/// * [contentType]
/// * [fileSizeBytes]
/// * [download]
@BuiltValue()
abstract class InvoiceDraft implements Built<InvoiceDraft, InvoiceDraftBuilder> {
  @BuiltValueField(wireName: r'invoice_type')
  InvoiceDraftInvoiceTypeEnum get invoiceType;
  // enum invoiceTypeEnum {  VENDOR_GOODS_INVOICE,  VENDOR_ADJUSTMENT_DOCUMENT,  };

  /// Must equal the registered business name.
  @BuiltValueField(wireName: r'issuer_name')
  String get issuerName;

  @BuiltValueField(wireName: r'invoice_number')
  String get invoiceNumber;

  /// Invoice calendar date; must not be later than today in Asia/Manila.
  @BuiltValueField(wireName: r'issued_on')
  Date get issuedOn;

  @BuiltValueField(wireName: r'amount_centavos')
  int get amountCentavos;

  @BuiltValueField(wireName: r'vat_centavos')
  int? get vatCentavos;

  @BuiltValueField(wireName: r'vat_exempt_centavos')
  int? get vatExemptCentavos;

  @BuiltValueField(wireName: r'zero_rated_centavos')
  int? get zeroRatedCentavos;

  @BuiltValueField(wireName: r'related_line_ids')
  BuiltList<String>? get relatedLineIds;

  @BuiltValueField(wireName: r'source_system')
  InvoiceDraftSourceSystemEnum get sourceSystem;
  // enum sourceSystemEnum {  REGISTERED_CAS,  BIR_EIS,  LOOSE_LEAF_OR_PRINTED,  OTHER_REGISTERED,  };

  @BuiltValueField(wireName: r'invoicing_method')
  InvoiceDraftInvoicingMethodEnum get invoicingMethod;
  // enum invoicingMethodEnum {  ELECTRONIC,  COMPUTERIZED,  MANUAL,  };

  @BuiltValueField(wireName: r'amends_invoice_record_id')
  String? get amendsInvoiceRecordId;

  @BuiltValueField(wireName: r'invoice_request_id')
  String? get invoiceRequestId;

  @BuiltValueField(wireName: r'lock_version')
  int get lockVersion;

  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'sent_record_id')
  String? get sentRecordId;

  @BuiltValueField(wireName: r'sent_at')
  DateTime? get sentAt;

  @BuiltValueField(wireName: r'updated_at')
  DateTime? get updatedAt;

  @BuiltValueField(wireName: r'file_name')
  String? get fileName;

  @BuiltValueField(wireName: r'content_type')
  String? get contentType;

  @BuiltValueField(wireName: r'file_size_bytes')
  int? get fileSizeBytes;

  @BuiltValueField(wireName: r'download')
  DisputeFileLink get download;

  InvoiceDraft._();

  factory InvoiceDraft([void updates(InvoiceDraftBuilder b)]) = _$InvoiceDraft;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(InvoiceDraftBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<InvoiceDraft> get serializer => _$InvoiceDraftSerializer();
}

class _$InvoiceDraftSerializer implements PrimitiveSerializer<InvoiceDraft> {
  @override
  final Iterable<Type> types = const [InvoiceDraft, _$InvoiceDraft];

  @override
  final String wireName = r'InvoiceDraft';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    InvoiceDraft object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'invoice_type';
    yield serializers.serialize(
      object.invoiceType,
      specifiedType: const FullType(InvoiceDraftInvoiceTypeEnum),
    );
    yield r'issuer_name';
    yield serializers.serialize(
      object.issuerName,
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
      specifiedType: const FullType(Date),
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
    if (object.vatExemptCentavos != null) {
      yield r'vat_exempt_centavos';
      yield serializers.serialize(
        object.vatExemptCentavos,
        specifiedType: const FullType(int),
      );
    }
    if (object.zeroRatedCentavos != null) {
      yield r'zero_rated_centavos';
      yield serializers.serialize(
        object.zeroRatedCentavos,
        specifiedType: const FullType(int),
      );
    }
    if (object.relatedLineIds != null) {
      yield r'related_line_ids';
      yield serializers.serialize(
        object.relatedLineIds,
        specifiedType: const FullType(BuiltList, [FullType(String)]),
      );
    }
    yield r'source_system';
    yield serializers.serialize(
      object.sourceSystem,
      specifiedType: const FullType(InvoiceDraftSourceSystemEnum),
    );
    yield r'invoicing_method';
    yield serializers.serialize(
      object.invoicingMethod,
      specifiedType: const FullType(InvoiceDraftInvoicingMethodEnum),
    );
    if (object.amendsInvoiceRecordId != null) {
      yield r'amends_invoice_record_id';
      yield serializers.serialize(
        object.amendsInvoiceRecordId,
        specifiedType: const FullType(String),
      );
    }
    if (object.invoiceRequestId != null) {
      yield r'invoice_request_id';
      yield serializers.serialize(
        object.invoiceRequestId,
        specifiedType: const FullType(String),
      );
    }
    yield r'lock_version';
    yield serializers.serialize(
      object.lockVersion,
      specifiedType: const FullType(int),
    );
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    if (object.sentRecordId != null) {
      yield r'sent_record_id';
      yield serializers.serialize(
        object.sentRecordId,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.sentAt != null) {
      yield r'sent_at';
      yield serializers.serialize(
        object.sentAt,
        specifiedType: const FullType.nullable(DateTime),
      );
    }
    if (object.updatedAt != null) {
      yield r'updated_at';
      yield serializers.serialize(
        object.updatedAt,
        specifiedType: const FullType.nullable(DateTime),
      );
    }
    if (object.fileName != null) {
      yield r'file_name';
      yield serializers.serialize(
        object.fileName,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.contentType != null) {
      yield r'content_type';
      yield serializers.serialize(
        object.contentType,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.fileSizeBytes != null) {
      yield r'file_size_bytes';
      yield serializers.serialize(
        object.fileSizeBytes,
        specifiedType: const FullType.nullable(int),
      );
    }
    yield r'download';
    yield serializers.serialize(
      object.download,
      specifiedType: const FullType(DisputeFileLink),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    InvoiceDraft object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required InvoiceDraftBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'invoice_type':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(InvoiceDraftInvoiceTypeEnum),
          ) as InvoiceDraftInvoiceTypeEnum;
          result.invoiceType = valueDes;
          break;
        case r'issuer_name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.issuerName = valueDes;
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
            specifiedType: const FullType(Date),
          ) as Date;
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
        case r'vat_exempt_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.vatExemptCentavos = valueDes;
          break;
        case r'zero_rated_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.zeroRatedCentavos = valueDes;
          break;
        case r'related_line_ids':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BuiltList, [FullType(String)]),
          ) as BuiltList<String>?;
          if (valueDes == null) continue;
          result.relatedLineIds.replace(valueDes);
          break;
        case r'source_system':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(InvoiceDraftSourceSystemEnum),
          ) as InvoiceDraftSourceSystemEnum;
          result.sourceSystem = valueDes;
          break;
        case r'invoicing_method':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(InvoiceDraftInvoicingMethodEnum),
          ) as InvoiceDraftInvoicingMethodEnum;
          result.invoicingMethod = valueDes;
          break;
        case r'amends_invoice_record_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.amendsInvoiceRecordId = valueDes;
          break;
        case r'invoice_request_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.invoiceRequestId = valueDes;
          break;
        case r'lock_version':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.lockVersion = valueDes;
          break;
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.id = valueDes;
          break;
        case r'sent_record_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.sentRecordId = valueDes;
          break;
        case r'sent_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.sentAt = valueDes;
          break;
        case r'updated_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.updatedAt = valueDes;
          break;
        case r'file_name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.fileName = valueDes;
          break;
        case r'content_type':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.contentType = valueDes;
          break;
        case r'file_size_bytes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.fileSizeBytes = valueDes;
          break;
        case r'download':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DisputeFileLink),
          ) as DisputeFileLink;
          result.download.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  InvoiceDraft deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = InvoiceDraftBuilder();
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


class InvoiceDraftInvoiceTypeEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'VENDOR_GOODS_INVOICE')
  static const InvoiceDraftInvoiceTypeEnum VENDOR_GOODS_INVOICE = _$invoiceDraftInvoiceTypeEnum_VENDOR_GOODS_INVOICE;
  @BuiltValueEnumConst(wireName: r'VENDOR_ADJUSTMENT_DOCUMENT')
  static const InvoiceDraftInvoiceTypeEnum VENDOR_ADJUSTMENT_DOCUMENT = _$invoiceDraftInvoiceTypeEnum_VENDOR_ADJUSTMENT_DOCUMENT;

  static Serializer<InvoiceDraftInvoiceTypeEnum> get serializer => _$invoiceDraftInvoiceTypeEnumSerializer;

  const InvoiceDraftInvoiceTypeEnum._(String name): super(name);

  static BuiltSet<InvoiceDraftInvoiceTypeEnum> get values => _$invoiceDraftInvoiceTypeEnumValues;
  static InvoiceDraftInvoiceTypeEnum valueOf(String name) => _$invoiceDraftInvoiceTypeEnumValueOf(name);
}

class InvoiceDraftSourceSystemEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'REGISTERED_CAS')
  static const InvoiceDraftSourceSystemEnum REGISTERED_CAS = _$invoiceDraftSourceSystemEnum_REGISTERED_CAS;
  @BuiltValueEnumConst(wireName: r'BIR_EIS')
  static const InvoiceDraftSourceSystemEnum BIR_EIS = _$invoiceDraftSourceSystemEnum_BIR_EIS;
  @BuiltValueEnumConst(wireName: r'LOOSE_LEAF_OR_PRINTED')
  static const InvoiceDraftSourceSystemEnum LOOSE_LEAF_OR_PRINTED = _$invoiceDraftSourceSystemEnum_LOOSE_LEAF_OR_PRINTED;
  @BuiltValueEnumConst(wireName: r'OTHER_REGISTERED')
  static const InvoiceDraftSourceSystemEnum OTHER_REGISTERED = _$invoiceDraftSourceSystemEnum_OTHER_REGISTERED;

  static Serializer<InvoiceDraftSourceSystemEnum> get serializer => _$invoiceDraftSourceSystemEnumSerializer;

  const InvoiceDraftSourceSystemEnum._(String name): super(name);

  static BuiltSet<InvoiceDraftSourceSystemEnum> get values => _$invoiceDraftSourceSystemEnumValues;
  static InvoiceDraftSourceSystemEnum valueOf(String name) => _$invoiceDraftSourceSystemEnumValueOf(name);
}

class InvoiceDraftInvoicingMethodEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'ELECTRONIC')
  static const InvoiceDraftInvoicingMethodEnum ELECTRONIC = _$invoiceDraftInvoicingMethodEnum_ELECTRONIC;
  @BuiltValueEnumConst(wireName: r'COMPUTERIZED')
  static const InvoiceDraftInvoicingMethodEnum COMPUTERIZED = _$invoiceDraftInvoicingMethodEnum_COMPUTERIZED;
  @BuiltValueEnumConst(wireName: r'MANUAL')
  static const InvoiceDraftInvoicingMethodEnum MANUAL = _$invoiceDraftInvoicingMethodEnum_MANUAL;

  static Serializer<InvoiceDraftInvoicingMethodEnum> get serializer => _$invoiceDraftInvoicingMethodEnumSerializer;

  const InvoiceDraftInvoicingMethodEnum._(String name): super(name);

  static BuiltSet<InvoiceDraftInvoicingMethodEnum> get values => _$invoiceDraftInvoicingMethodEnumValues;
  static InvoiceDraftInvoicingMethodEnum valueOf(String name) => _$invoiceDraftInvoicingMethodEnumValueOf(name);
}

