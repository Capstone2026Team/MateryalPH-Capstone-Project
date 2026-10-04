//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/dispute_file_link.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'invoice_log_row.g.dart';

/// One row of the selected view: an open request, an order without an invoice copy yet, an uploaded record or a reconciliation item.
///
/// Properties:
/// * [id]
/// * [orderId]
/// * [orderReference]
/// * [orderState]
/// * [paymentState]
/// * [acceptedAt]
/// * [openRequest]
/// * [note]
/// * [kind]
/// * [state]
/// * [details]
/// * [serviceTargetAt]
/// * [serviceTargetLabel]
/// * [overdue]
/// * [invoiceType]
/// * [issuer]
/// * [invoiceNumber]
/// * [issuedOn]
/// * [amountCentavos]
/// * [reconciliationState]
/// * [reconciliationDifferenceCentavos]
/// * [originLabel]
/// * [complianceNote]
/// * [vendorName]
/// * [downloads]
/// * [lastDownloadAt]
/// * [uploadedAt]
/// * [download]
@BuiltValue()
abstract class InvoiceLogRow implements Built<InvoiceLogRow, InvoiceLogRowBuilder> {
  @BuiltValueField(wireName: r'id')
  String? get id;

  @BuiltValueField(wireName: r'order_id')
  String? get orderId;

  @BuiltValueField(wireName: r'order_reference')
  String? get orderReference;

  @BuiltValueField(wireName: r'order_state')
  String? get orderState;

  @BuiltValueField(wireName: r'payment_state')
  String? get paymentState;

  @BuiltValueField(wireName: r'accepted_at')
  DateTime? get acceptedAt;

  @BuiltValueField(wireName: r'open_request')
  bool? get openRequest;

  @BuiltValueField(wireName: r'note')
  String? get note;

  @BuiltValueField(wireName: r'kind')
  String? get kind;

  @BuiltValueField(wireName: r'state')
  String? get state;

  @BuiltValueField(wireName: r'details')
  String? get details;

  @BuiltValueField(wireName: r'service_target_at')
  DateTime? get serviceTargetAt;

  @BuiltValueField(wireName: r'service_target_label')
  String? get serviceTargetLabel;

  @BuiltValueField(wireName: r'overdue')
  bool? get overdue;

  @BuiltValueField(wireName: r'invoice_type')
  String? get invoiceType;

  @BuiltValueField(wireName: r'issuer')
  String? get issuer;

  @BuiltValueField(wireName: r'invoice_number')
  String? get invoiceNumber;

  @BuiltValueField(wireName: r'issued_on')
  String? get issuedOn;

  @BuiltValueField(wireName: r'amount_centavos')
  int? get amountCentavos;

  @BuiltValueField(wireName: r'reconciliation_state')
  String? get reconciliationState;

  @BuiltValueField(wireName: r'reconciliation_difference_centavos')
  int? get reconciliationDifferenceCentavos;

  @BuiltValueField(wireName: r'origin_label')
  String? get originLabel;

  @BuiltValueField(wireName: r'compliance_note')
  String? get complianceNote;

  @BuiltValueField(wireName: r'vendor_name')
  String? get vendorName;

  @BuiltValueField(wireName: r'downloads')
  int? get downloads;

  @BuiltValueField(wireName: r'last_download_at')
  DateTime? get lastDownloadAt;

  @BuiltValueField(wireName: r'uploaded_at')
  DateTime? get uploadedAt;

  @BuiltValueField(wireName: r'download')
  DisputeFileLink? get download;

  InvoiceLogRow._();

  factory InvoiceLogRow([void updates(InvoiceLogRowBuilder b)]) = _$InvoiceLogRow;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(InvoiceLogRowBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<InvoiceLogRow> get serializer => _$InvoiceLogRowSerializer();
}

class _$InvoiceLogRowSerializer implements PrimitiveSerializer<InvoiceLogRow> {
  @override
  final Iterable<Type> types = const [InvoiceLogRow, _$InvoiceLogRow];

  @override
  final String wireName = r'InvoiceLogRow';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    InvoiceLogRow object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.id != null) {
      yield r'id';
      yield serializers.serialize(
        object.id,
        specifiedType: const FullType(String),
      );
    }
    if (object.orderId != null) {
      yield r'order_id';
      yield serializers.serialize(
        object.orderId,
        specifiedType: const FullType(String),
      );
    }
    if (object.orderReference != null) {
      yield r'order_reference';
      yield serializers.serialize(
        object.orderReference,
        specifiedType: const FullType(String),
      );
    }
    if (object.orderState != null) {
      yield r'order_state';
      yield serializers.serialize(
        object.orderState,
        specifiedType: const FullType(String),
      );
    }
    if (object.paymentState != null) {
      yield r'payment_state';
      yield serializers.serialize(
        object.paymentState,
        specifiedType: const FullType(String),
      );
    }
    if (object.acceptedAt != null) {
      yield r'accepted_at';
      yield serializers.serialize(
        object.acceptedAt,
        specifiedType: const FullType(DateTime),
      );
    }
    if (object.openRequest != null) {
      yield r'open_request';
      yield serializers.serialize(
        object.openRequest,
        specifiedType: const FullType(bool),
      );
    }
    if (object.note != null) {
      yield r'note';
      yield serializers.serialize(
        object.note,
        specifiedType: const FullType(String),
      );
    }
    if (object.kind != null) {
      yield r'kind';
      yield serializers.serialize(
        object.kind,
        specifiedType: const FullType(String),
      );
    }
    if (object.state != null) {
      yield r'state';
      yield serializers.serialize(
        object.state,
        specifiedType: const FullType(String),
      );
    }
    if (object.details != null) {
      yield r'details';
      yield serializers.serialize(
        object.details,
        specifiedType: const FullType(String),
      );
    }
    if (object.serviceTargetAt != null) {
      yield r'service_target_at';
      yield serializers.serialize(
        object.serviceTargetAt,
        specifiedType: const FullType(DateTime),
      );
    }
    if (object.serviceTargetLabel != null) {
      yield r'service_target_label';
      yield serializers.serialize(
        object.serviceTargetLabel,
        specifiedType: const FullType(String),
      );
    }
    if (object.overdue != null) {
      yield r'overdue';
      yield serializers.serialize(
        object.overdue,
        specifiedType: const FullType(bool),
      );
    }
    if (object.invoiceType != null) {
      yield r'invoice_type';
      yield serializers.serialize(
        object.invoiceType,
        specifiedType: const FullType(String),
      );
    }
    if (object.issuer != null) {
      yield r'issuer';
      yield serializers.serialize(
        object.issuer,
        specifiedType: const FullType(String),
      );
    }
    if (object.invoiceNumber != null) {
      yield r'invoice_number';
      yield serializers.serialize(
        object.invoiceNumber,
        specifiedType: const FullType(String),
      );
    }
    if (object.issuedOn != null) {
      yield r'issued_on';
      yield serializers.serialize(
        object.issuedOn,
        specifiedType: const FullType(String),
      );
    }
    if (object.amountCentavos != null) {
      yield r'amount_centavos';
      yield serializers.serialize(
        object.amountCentavos,
        specifiedType: const FullType(int),
      );
    }
    if (object.reconciliationState != null) {
      yield r'reconciliation_state';
      yield serializers.serialize(
        object.reconciliationState,
        specifiedType: const FullType(String),
      );
    }
    if (object.reconciliationDifferenceCentavos != null) {
      yield r'reconciliation_difference_centavos';
      yield serializers.serialize(
        object.reconciliationDifferenceCentavos,
        specifiedType: const FullType(int),
      );
    }
    if (object.originLabel != null) {
      yield r'origin_label';
      yield serializers.serialize(
        object.originLabel,
        specifiedType: const FullType(String),
      );
    }
    if (object.complianceNote != null) {
      yield r'compliance_note';
      yield serializers.serialize(
        object.complianceNote,
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
    if (object.uploadedAt != null) {
      yield r'uploaded_at';
      yield serializers.serialize(
        object.uploadedAt,
        specifiedType: const FullType(DateTime),
      );
    }
    if (object.download != null) {
      yield r'download';
      yield serializers.serialize(
        object.download,
        specifiedType: const FullType.nullable(DisputeFileLink),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    InvoiceLogRow object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required InvoiceLogRowBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.id = valueDes;
          break;
        case r'order_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.orderId = valueDes;
          break;
        case r'order_reference':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.orderReference = valueDes;
          break;
        case r'order_state':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.orderState = valueDes;
          break;
        case r'payment_state':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.paymentState = valueDes;
          break;
        case r'accepted_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.acceptedAt = valueDes;
          break;
        case r'open_request':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.openRequest = valueDes;
          break;
        case r'note':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.note = valueDes;
          break;
        case r'kind':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.kind = valueDes;
          break;
        case r'state':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.state = valueDes;
          break;
        case r'details':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.details = valueDes;
          break;
        case r'service_target_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.serviceTargetAt = valueDes;
          break;
        case r'service_target_label':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.serviceTargetLabel = valueDes;
          break;
        case r'overdue':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.overdue = valueDes;
          break;
        case r'invoice_type':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.invoiceType = valueDes;
          break;
        case r'issuer':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.issuer = valueDes;
          break;
        case r'invoice_number':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.invoiceNumber = valueDes;
          break;
        case r'issued_on':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.issuedOn = valueDes;
          break;
        case r'amount_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.amountCentavos = valueDes;
          break;
        case r'reconciliation_state':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.reconciliationState = valueDes;
          break;
        case r'reconciliation_difference_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.reconciliationDifferenceCentavos = valueDes;
          break;
        case r'origin_label':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.originLabel = valueDes;
          break;
        case r'compliance_note':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.complianceNote = valueDes;
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
        case r'uploaded_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.uploadedAt = valueDes;
          break;
        case r'download':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DisputeFileLink),
          ) as DisputeFileLink?;
          if (valueDes == null) continue;
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
  InvoiceLogRow deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = InvoiceLogRowBuilder();
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


