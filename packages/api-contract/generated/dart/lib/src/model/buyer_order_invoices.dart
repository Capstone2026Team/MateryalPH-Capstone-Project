//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/buyer_invoice_billing_details.dart';
import 'package:materyalph_api_client/src/model/invoice_request_view.dart';
import 'package:materyalph_api_client/src/model/invoice_record_view.dart';
import 'package:materyalph_api_client/src/model/platform_document_ref.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'buyer_order_invoices.g.dart';

/// BuyerOrderInvoices
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
/// * [canEditBillingDetails]
/// * [canRequestCopy]
/// * [canRequestCorrection]
@BuiltValue()
abstract class BuyerOrderInvoices implements Built<BuyerOrderInvoices, BuyerOrderInvoicesBuilder> {
  @BuiltValueField(wireName: r'order_id')
  String get orderId;

  @BuiltValueField(wireName: r'order_reference')
  String get orderReference;

  @BuiltValueField(wireName: r'status')
  BuyerOrderInvoicesStatusEnum get status;
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
  BuyerInvoiceBillingDetails? get billingDetails;

  @BuiltValueField(wireName: r'can_edit_billing_details')
  bool get canEditBillingDetails;

  @BuiltValueField(wireName: r'can_request_copy')
  bool get canRequestCopy;

  @BuiltValueField(wireName: r'can_request_correction')
  bool get canRequestCorrection;

  BuyerOrderInvoices._();

  factory BuyerOrderInvoices([void updates(BuyerOrderInvoicesBuilder b)]) = _$BuyerOrderInvoices;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(BuyerOrderInvoicesBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<BuyerOrderInvoices> get serializer => _$BuyerOrderInvoicesSerializer();
}

class _$BuyerOrderInvoicesSerializer implements PrimitiveSerializer<BuyerOrderInvoices> {
  @override
  final Iterable<Type> types = const [BuyerOrderInvoices, _$BuyerOrderInvoices];

  @override
  final String wireName = r'BuyerOrderInvoices';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    BuyerOrderInvoices object, {
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
      specifiedType: const FullType(BuyerOrderInvoicesStatusEnum),
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
        specifiedType: const FullType.nullable(BuyerInvoiceBillingDetails),
      );
    }
    yield r'can_edit_billing_details';
    yield serializers.serialize(
      object.canEditBillingDetails,
      specifiedType: const FullType(bool),
    );
    yield r'can_request_copy';
    yield serializers.serialize(
      object.canRequestCopy,
      specifiedType: const FullType(bool),
    );
    yield r'can_request_correction';
    yield serializers.serialize(
      object.canRequestCorrection,
      specifiedType: const FullType(bool),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    BuyerOrderInvoices object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required BuyerOrderInvoicesBuilder result,
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
            specifiedType: const FullType(BuyerOrderInvoicesStatusEnum),
          ) as BuyerOrderInvoicesStatusEnum;
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
            specifiedType: const FullType.nullable(BuyerInvoiceBillingDetails),
          ) as BuyerInvoiceBillingDetails?;
          if (valueDes == null) continue;
          result.billingDetails.replace(valueDes);
          break;
        case r'can_edit_billing_details':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.canEditBillingDetails = valueDes;
          break;
        case r'can_request_copy':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.canRequestCopy = valueDes;
          break;
        case r'can_request_correction':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.canRequestCorrection = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  BuyerOrderInvoices deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = BuyerOrderInvoicesBuilder();
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


class BuyerOrderInvoicesStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'ISSUED')
  static const BuyerOrderInvoicesStatusEnum ISSUED = _$buyerOrderInvoicesStatusEnum_ISSUED;
  @BuiltValueEnumConst(wireName: r'NOT_YET_UPLOADED')
  static const BuyerOrderInvoicesStatusEnum NOT_YET_UPLOADED = _$buyerOrderInvoicesStatusEnum_NOT_YET_UPLOADED;
  @BuiltValueEnumConst(wireName: r'NOT_DUE')
  static const BuyerOrderInvoicesStatusEnum NOT_DUE = _$buyerOrderInvoicesStatusEnum_NOT_DUE;

  static Serializer<BuyerOrderInvoicesStatusEnum> get serializer => _$buyerOrderInvoicesStatusEnumSerializer;

  const BuyerOrderInvoicesStatusEnum._(String name): super(name);

  static BuiltSet<BuyerOrderInvoicesStatusEnum> get values => _$buyerOrderInvoicesStatusEnumValues;
  static BuyerOrderInvoicesStatusEnum valueOf(String name) => _$buyerOrderInvoicesStatusEnumValueOf(name);
}

