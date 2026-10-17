//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/invoice_order_line.dart';
import 'package:materyalph_api_client/src/model/invoice_request_view.dart';
import 'package:materyalph_api_client/src/model/invoice_record_view.dart';
import 'package:materyalph_api_client/src/model/platform_document_ref.dart';
import 'package:materyalph_api_client/src/model/vendor_invoice_billing_details.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'vendor_order_invoices.g.dart';

/// VendorOrderInvoices
///
/// Properties:
/// * [orderId]
/// * [orderReference]
/// * [status]
/// * [issuanceNotice]
/// * [records]
/// * [requests]
/// * [platformDocuments]
/// * [billingDetails]
/// * [canUpload]
/// * [canOpenFiles]
/// * [issuerName]
/// * [invoiceTypes]
/// * [sourceSystems]
/// * [invoicingMethods]
/// * [lines]
@BuiltValue()
abstract class VendorOrderInvoices implements Built<VendorOrderInvoices, VendorOrderInvoicesBuilder> {
  @BuiltValueField(wireName: r'order_id')
  String get orderId;

  @BuiltValueField(wireName: r'order_reference')
  String get orderReference;

  @BuiltValueField(wireName: r'status')
  VendorOrderInvoicesStatusEnum get status;
  // enum statusEnum {  ISSUED,  NOT_YET_UPLOADED,  NOT_DUE,  };

  @BuiltValueField(wireName: r'issuance_notice')
  String get issuanceNotice;

  @BuiltValueField(wireName: r'records')
  BuiltList<InvoiceRecordView> get records;

  @BuiltValueField(wireName: r'requests')
  BuiltList<InvoiceRequestView> get requests;

  @BuiltValueField(wireName: r'platform_documents')
  BuiltList<PlatformDocumentRef> get platformDocuments;

  @BuiltValueField(wireName: r'billing_details')
  VendorInvoiceBillingDetails? get billingDetails;

  @BuiltValueField(wireName: r'can_upload')
  bool get canUpload;

  @BuiltValueField(wireName: r'can_open_files')
  bool get canOpenFiles;

  @BuiltValueField(wireName: r'issuer_name')
  String get issuerName;

  @BuiltValueField(wireName: r'invoice_types')
  BuiltList<VendorOrderInvoicesInvoiceTypesEnum> get invoiceTypes;
  // enum invoiceTypesEnum {  VENDOR_GOODS_INVOICE,  VENDOR_ADJUSTMENT_DOCUMENT,  };

  @BuiltValueField(wireName: r'source_systems')
  BuiltList<VendorOrderInvoicesSourceSystemsEnum> get sourceSystems;
  // enum sourceSystemsEnum {  REGISTERED_CAS,  BIR_EIS,  LOOSE_LEAF_OR_PRINTED,  OTHER_REGISTERED,  };

  @BuiltValueField(wireName: r'invoicing_methods')
  BuiltList<VendorOrderInvoicesInvoicingMethodsEnum> get invoicingMethods;
  // enum invoicingMethodsEnum {  ELECTRONIC,  COMPUTERIZED,  MANUAL,  };

  @BuiltValueField(wireName: r'lines')
  BuiltList<InvoiceOrderLine> get lines;

  VendorOrderInvoices._();

  factory VendorOrderInvoices([void updates(VendorOrderInvoicesBuilder b)]) = _$VendorOrderInvoices;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(VendorOrderInvoicesBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<VendorOrderInvoices> get serializer => _$VendorOrderInvoicesSerializer();
}

class _$VendorOrderInvoicesSerializer implements PrimitiveSerializer<VendorOrderInvoices> {
  @override
  final Iterable<Type> types = const [VendorOrderInvoices, _$VendorOrderInvoices];

  @override
  final String wireName = r'VendorOrderInvoices';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    VendorOrderInvoices object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'order_id';
    yield serializers.serialize(
      object.orderId,
      specifiedType: const FullType(String),
    );
    yield r'order_reference';
    yield serializers.serialize(
      object.orderReference,
      specifiedType: const FullType(String),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(VendorOrderInvoicesStatusEnum),
    );
    yield r'issuance_notice';
    yield serializers.serialize(
      object.issuanceNotice,
      specifiedType: const FullType(String),
    );
    yield r'records';
    yield serializers.serialize(
      object.records,
      specifiedType: const FullType(BuiltList, [FullType(InvoiceRecordView)]),
    );
    yield r'requests';
    yield serializers.serialize(
      object.requests,
      specifiedType: const FullType(BuiltList, [FullType(InvoiceRequestView)]),
    );
    yield r'platform_documents';
    yield serializers.serialize(
      object.platformDocuments,
      specifiedType: const FullType(BuiltList, [FullType(PlatformDocumentRef)]),
    );
    if (object.billingDetails != null) {
      yield r'billing_details';
      yield serializers.serialize(
        object.billingDetails,
        specifiedType: const FullType.nullable(VendorInvoiceBillingDetails),
      );
    }
    yield r'can_upload';
    yield serializers.serialize(
      object.canUpload,
      specifiedType: const FullType(bool),
    );
    yield r'can_open_files';
    yield serializers.serialize(
      object.canOpenFiles,
      specifiedType: const FullType(bool),
    );
    yield r'issuer_name';
    yield serializers.serialize(
      object.issuerName,
      specifiedType: const FullType(String),
    );
    yield r'invoice_types';
    yield serializers.serialize(
      object.invoiceTypes,
      specifiedType: const FullType(BuiltList, [FullType(VendorOrderInvoicesInvoiceTypesEnum)]),
    );
    yield r'source_systems';
    yield serializers.serialize(
      object.sourceSystems,
      specifiedType: const FullType(BuiltList, [FullType(VendorOrderInvoicesSourceSystemsEnum)]),
    );
    yield r'invoicing_methods';
    yield serializers.serialize(
      object.invoicingMethods,
      specifiedType: const FullType(BuiltList, [FullType(VendorOrderInvoicesInvoicingMethodsEnum)]),
    );
    yield r'lines';
    yield serializers.serialize(
      object.lines,
      specifiedType: const FullType(BuiltList, [FullType(InvoiceOrderLine)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    VendorOrderInvoices object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required VendorOrderInvoicesBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'order_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.orderId = valueDes;
          break;
        case r'order_reference':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.orderReference = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(VendorOrderInvoicesStatusEnum),
          ) as VendorOrderInvoicesStatusEnum;
          result.status = valueDes;
          break;
        case r'issuance_notice':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.issuanceNotice = valueDes;
          break;
        case r'records':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(InvoiceRecordView)]),
          ) as BuiltList<InvoiceRecordView>;
          result.records.replace(valueDes);
          break;
        case r'requests':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(InvoiceRequestView)]),
          ) as BuiltList<InvoiceRequestView>;
          result.requests.replace(valueDes);
          break;
        case r'platform_documents':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(PlatformDocumentRef)]),
          ) as BuiltList<PlatformDocumentRef>;
          result.platformDocuments.replace(valueDes);
          break;
        case r'billing_details':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(VendorInvoiceBillingDetails),
          ) as VendorInvoiceBillingDetails?;
          if (valueDes == null) continue;
          result.billingDetails.replace(valueDes);
          break;
        case r'can_upload':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.canUpload = valueDes;
          break;
        case r'can_open_files':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.canOpenFiles = valueDes;
          break;
        case r'issuer_name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.issuerName = valueDes;
          break;
        case r'invoice_types':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(VendorOrderInvoicesInvoiceTypesEnum)]),
          ) as BuiltList<VendorOrderInvoicesInvoiceTypesEnum>;
          result.invoiceTypes.replace(valueDes);
          break;
        case r'source_systems':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(VendorOrderInvoicesSourceSystemsEnum)]),
          ) as BuiltList<VendorOrderInvoicesSourceSystemsEnum>;
          result.sourceSystems.replace(valueDes);
          break;
        case r'invoicing_methods':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(VendorOrderInvoicesInvoicingMethodsEnum)]),
          ) as BuiltList<VendorOrderInvoicesInvoicingMethodsEnum>;
          result.invoicingMethods.replace(valueDes);
          break;
        case r'lines':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(InvoiceOrderLine)]),
          ) as BuiltList<InvoiceOrderLine>;
          result.lines.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  VendorOrderInvoices deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = VendorOrderInvoicesBuilder();
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


class VendorOrderInvoicesStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'ISSUED')
  static const VendorOrderInvoicesStatusEnum ISSUED = _$vendorOrderInvoicesStatusEnum_ISSUED;
  @BuiltValueEnumConst(wireName: r'NOT_YET_UPLOADED')
  static const VendorOrderInvoicesStatusEnum NOT_YET_UPLOADED = _$vendorOrderInvoicesStatusEnum_NOT_YET_UPLOADED;
  @BuiltValueEnumConst(wireName: r'NOT_DUE')
  static const VendorOrderInvoicesStatusEnum NOT_DUE = _$vendorOrderInvoicesStatusEnum_NOT_DUE;

  static Serializer<VendorOrderInvoicesStatusEnum> get serializer => _$vendorOrderInvoicesStatusEnumSerializer;

  const VendorOrderInvoicesStatusEnum._(String name): super(name);

  static BuiltSet<VendorOrderInvoicesStatusEnum> get values => _$vendorOrderInvoicesStatusEnumValues;
  static VendorOrderInvoicesStatusEnum valueOf(String name) => _$vendorOrderInvoicesStatusEnumValueOf(name);
}

class VendorOrderInvoicesInvoiceTypesEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'VENDOR_GOODS_INVOICE')
  static const VendorOrderInvoicesInvoiceTypesEnum VENDOR_GOODS_INVOICE = _$vendorOrderInvoicesInvoiceTypesEnum_VENDOR_GOODS_INVOICE;
  @BuiltValueEnumConst(wireName: r'VENDOR_ADJUSTMENT_DOCUMENT')
  static const VendorOrderInvoicesInvoiceTypesEnum VENDOR_ADJUSTMENT_DOCUMENT = _$vendorOrderInvoicesInvoiceTypesEnum_VENDOR_ADJUSTMENT_DOCUMENT;

  static Serializer<VendorOrderInvoicesInvoiceTypesEnum> get serializer => _$vendorOrderInvoicesInvoiceTypesEnumSerializer;

  const VendorOrderInvoicesInvoiceTypesEnum._(String name): super(name);

  static BuiltSet<VendorOrderInvoicesInvoiceTypesEnum> get values => _$vendorOrderInvoicesInvoiceTypesEnumValues;
  static VendorOrderInvoicesInvoiceTypesEnum valueOf(String name) => _$vendorOrderInvoicesInvoiceTypesEnumValueOf(name);
}

class VendorOrderInvoicesSourceSystemsEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'REGISTERED_CAS')
  static const VendorOrderInvoicesSourceSystemsEnum REGISTERED_CAS = _$vendorOrderInvoicesSourceSystemsEnum_REGISTERED_CAS;
  @BuiltValueEnumConst(wireName: r'BIR_EIS')
  static const VendorOrderInvoicesSourceSystemsEnum BIR_EIS = _$vendorOrderInvoicesSourceSystemsEnum_BIR_EIS;
  @BuiltValueEnumConst(wireName: r'LOOSE_LEAF_OR_PRINTED')
  static const VendorOrderInvoicesSourceSystemsEnum LOOSE_LEAF_OR_PRINTED = _$vendorOrderInvoicesSourceSystemsEnum_LOOSE_LEAF_OR_PRINTED;
  @BuiltValueEnumConst(wireName: r'OTHER_REGISTERED')
  static const VendorOrderInvoicesSourceSystemsEnum OTHER_REGISTERED = _$vendorOrderInvoicesSourceSystemsEnum_OTHER_REGISTERED;

  static Serializer<VendorOrderInvoicesSourceSystemsEnum> get serializer => _$vendorOrderInvoicesSourceSystemsEnumSerializer;

  const VendorOrderInvoicesSourceSystemsEnum._(String name): super(name);

  static BuiltSet<VendorOrderInvoicesSourceSystemsEnum> get values => _$vendorOrderInvoicesSourceSystemsEnumValues;
  static VendorOrderInvoicesSourceSystemsEnum valueOf(String name) => _$vendorOrderInvoicesSourceSystemsEnumValueOf(name);
}

class VendorOrderInvoicesInvoicingMethodsEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'ELECTRONIC')
  static const VendorOrderInvoicesInvoicingMethodsEnum ELECTRONIC = _$vendorOrderInvoicesInvoicingMethodsEnum_ELECTRONIC;
  @BuiltValueEnumConst(wireName: r'COMPUTERIZED')
  static const VendorOrderInvoicesInvoicingMethodsEnum COMPUTERIZED = _$vendorOrderInvoicesInvoicingMethodsEnum_COMPUTERIZED;
  @BuiltValueEnumConst(wireName: r'MANUAL')
  static const VendorOrderInvoicesInvoicingMethodsEnum MANUAL = _$vendorOrderInvoicesInvoicingMethodsEnum_MANUAL;

  static Serializer<VendorOrderInvoicesInvoicingMethodsEnum> get serializer => _$vendorOrderInvoicesInvoicingMethodsEnumSerializer;

  const VendorOrderInvoicesInvoicingMethodsEnum._(String name): super(name);

  static BuiltSet<VendorOrderInvoicesInvoicingMethodsEnum> get values => _$vendorOrderInvoicesInvoicingMethodsEnumValues;
  static VendorOrderInvoicesInvoicingMethodsEnum valueOf(String name) => _$vendorOrderInvoicesInvoicingMethodsEnumValueOf(name);
}

