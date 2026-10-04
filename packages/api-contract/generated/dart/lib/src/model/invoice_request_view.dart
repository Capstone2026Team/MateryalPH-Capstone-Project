//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'invoice_request_view.g.dart';

/// InvoiceRequestView
///
/// Properties:
/// * [id]
/// * [kind]
/// * [state]
/// * [details]
/// * [invoiceRecordId]
/// * [fulfilledInvoiceRecordId]
/// * [requestedAt]
/// * [serviceTargetAt]
/// * [serviceTargetLabel]
/// * [overdue]
/// * [uploadedAt]
/// * [downloadedAt]
/// * [closedAt]
/// * [canReturn]
/// * [canClose]
/// * [orderReference]
/// * [vendorName]
@BuiltValue()
abstract class InvoiceRequestView implements Built<InvoiceRequestView, InvoiceRequestViewBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'kind')
  InvoiceRequestViewKindEnum get kind;
  // enum kindEnum {  COPY,  CORRECTION,  };

  @BuiltValueField(wireName: r'state')
  InvoiceRequestViewStateEnum get state;
  // enum stateEnum {  REQUESTED,  UPLOADED,  DOWNLOADED,  RETURNED_FOR_CORRECTION,  CLOSED,  };

  @BuiltValueField(wireName: r'details')
  String? get details;

  @BuiltValueField(wireName: r'invoice_record_id')
  String? get invoiceRecordId;

  @BuiltValueField(wireName: r'fulfilled_invoice_record_id')
  String? get fulfilledInvoiceRecordId;

  @BuiltValueField(wireName: r'requested_at')
  DateTime? get requestedAt;

  @BuiltValueField(wireName: r'service_target_at')
  DateTime get serviceTargetAt;

  @BuiltValueField(wireName: r'service_target_label')
  String get serviceTargetLabel;

  @BuiltValueField(wireName: r'overdue')
  bool get overdue;

  @BuiltValueField(wireName: r'uploaded_at')
  DateTime? get uploadedAt;

  @BuiltValueField(wireName: r'downloaded_at')
  DateTime? get downloadedAt;

  @BuiltValueField(wireName: r'closed_at')
  DateTime? get closedAt;

  @BuiltValueField(wireName: r'can_return')
  bool get canReturn;

  @BuiltValueField(wireName: r'can_close')
  bool get canClose;

  @BuiltValueField(wireName: r'order_reference')
  String? get orderReference;

  @BuiltValueField(wireName: r'vendor_name')
  String? get vendorName;

  InvoiceRequestView._();

  factory InvoiceRequestView([void updates(InvoiceRequestViewBuilder b)]) = _$InvoiceRequestView;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(InvoiceRequestViewBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<InvoiceRequestView> get serializer => _$InvoiceRequestViewSerializer();
}

class _$InvoiceRequestViewSerializer implements PrimitiveSerializer<InvoiceRequestView> {
  @override
  final Iterable<Type> types = const [InvoiceRequestView, _$InvoiceRequestView];

  @override
  final String wireName = r'InvoiceRequestView';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    InvoiceRequestView object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'kind';
    yield serializers.serialize(
      object.kind,
      specifiedType: const FullType(InvoiceRequestViewKindEnum),
    );
    yield r'state';
    yield serializers.serialize(
      object.state,
      specifiedType: const FullType(InvoiceRequestViewStateEnum),
    );
    if (object.details != null) {
      yield r'details';
      yield serializers.serialize(
        object.details,
        specifiedType: const FullType(String),
      );
    }
    if (object.invoiceRecordId != null) {
      yield r'invoice_record_id';
      yield serializers.serialize(
        object.invoiceRecordId,
        specifiedType: const FullType(String),
      );
    }
    if (object.fulfilledInvoiceRecordId != null) {
      yield r'fulfilled_invoice_record_id';
      yield serializers.serialize(
        object.fulfilledInvoiceRecordId,
        specifiedType: const FullType(String),
      );
    }
    if (object.requestedAt != null) {
      yield r'requested_at';
      yield serializers.serialize(
        object.requestedAt,
        specifiedType: const FullType(DateTime),
      );
    }
    yield r'service_target_at';
    yield serializers.serialize(
      object.serviceTargetAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'service_target_label';
    yield serializers.serialize(
      object.serviceTargetLabel,
      specifiedType: const FullType(String),
    );
    yield r'overdue';
    yield serializers.serialize(
      object.overdue,
      specifiedType: const FullType(bool),
    );
    if (object.uploadedAt != null) {
      yield r'uploaded_at';
      yield serializers.serialize(
        object.uploadedAt,
        specifiedType: const FullType(DateTime),
      );
    }
    if (object.downloadedAt != null) {
      yield r'downloaded_at';
      yield serializers.serialize(
        object.downloadedAt,
        specifiedType: const FullType(DateTime),
      );
    }
    if (object.closedAt != null) {
      yield r'closed_at';
      yield serializers.serialize(
        object.closedAt,
        specifiedType: const FullType(DateTime),
      );
    }
    yield r'can_return';
    yield serializers.serialize(
      object.canReturn,
      specifiedType: const FullType(bool),
    );
    yield r'can_close';
    yield serializers.serialize(
      object.canClose,
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
  }

  @override
  Object serialize(
    Serializers serializers,
    InvoiceRequestView object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required InvoiceRequestViewBuilder result,
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
        case r'kind':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(InvoiceRequestViewKindEnum),
          ) as InvoiceRequestViewKindEnum;
          result.kind = valueDes;
          break;
        case r'state':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(InvoiceRequestViewStateEnum),
          ) as InvoiceRequestViewStateEnum;
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
        case r'invoice_record_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.invoiceRecordId = valueDes;
          break;
        case r'fulfilled_invoice_record_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.fulfilledInvoiceRecordId = valueDes;
          break;
        case r'requested_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.requestedAt = valueDes;
          break;
        case r'service_target_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.serviceTargetAt = valueDes;
          break;
        case r'service_target_label':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.serviceTargetLabel = valueDes;
          break;
        case r'overdue':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.overdue = valueDes;
          break;
        case r'uploaded_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.uploadedAt = valueDes;
          break;
        case r'downloaded_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.downloadedAt = valueDes;
          break;
        case r'closed_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.closedAt = valueDes;
          break;
        case r'can_return':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.canReturn = valueDes;
          break;
        case r'can_close':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.canClose = valueDes;
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
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  InvoiceRequestView deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = InvoiceRequestViewBuilder();
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


class InvoiceRequestViewKindEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'COPY')
  static const InvoiceRequestViewKindEnum COPY = _$invoiceRequestViewKindEnum_COPY;
  @BuiltValueEnumConst(wireName: r'CORRECTION')
  static const InvoiceRequestViewKindEnum CORRECTION = _$invoiceRequestViewKindEnum_CORRECTION;

  static Serializer<InvoiceRequestViewKindEnum> get serializer => _$invoiceRequestViewKindEnumSerializer;

  const InvoiceRequestViewKindEnum._(String name): super(name);

  static BuiltSet<InvoiceRequestViewKindEnum> get values => _$invoiceRequestViewKindEnumValues;
  static InvoiceRequestViewKindEnum valueOf(String name) => _$invoiceRequestViewKindEnumValueOf(name);
}

class InvoiceRequestViewStateEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'REQUESTED')
  static const InvoiceRequestViewStateEnum REQUESTED = _$invoiceRequestViewStateEnum_REQUESTED;
  @BuiltValueEnumConst(wireName: r'UPLOADED')
  static const InvoiceRequestViewStateEnum UPLOADED = _$invoiceRequestViewStateEnum_UPLOADED;
  @BuiltValueEnumConst(wireName: r'DOWNLOADED')
  static const InvoiceRequestViewStateEnum DOWNLOADED = _$invoiceRequestViewStateEnum_DOWNLOADED;
  @BuiltValueEnumConst(wireName: r'RETURNED_FOR_CORRECTION')
  static const InvoiceRequestViewStateEnum RETURNED_FOR_CORRECTION = _$invoiceRequestViewStateEnum_RETURNED_FOR_CORRECTION;
  @BuiltValueEnumConst(wireName: r'CLOSED')
  static const InvoiceRequestViewStateEnum CLOSED = _$invoiceRequestViewStateEnum_CLOSED;

  static Serializer<InvoiceRequestViewStateEnum> get serializer => _$invoiceRequestViewStateEnumSerializer;

  const InvoiceRequestViewStateEnum._(String name): super(name);

  static BuiltSet<InvoiceRequestViewStateEnum> get values => _$invoiceRequestViewStateEnumValues;
  static InvoiceRequestViewStateEnum valueOf(String name) => _$invoiceRequestViewStateEnumValueOf(name);
}

