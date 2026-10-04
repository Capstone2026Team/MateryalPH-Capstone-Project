// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'invoice_request_view.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const InvoiceRequestViewKindEnum _$invoiceRequestViewKindEnum_COPY =
    const InvoiceRequestViewKindEnum._('COPY');
const InvoiceRequestViewKindEnum _$invoiceRequestViewKindEnum_CORRECTION =
    const InvoiceRequestViewKindEnum._('CORRECTION');

InvoiceRequestViewKindEnum _$invoiceRequestViewKindEnumValueOf(String name) {
  switch (name) {
    case 'COPY':
      return _$invoiceRequestViewKindEnum_COPY;
    case 'CORRECTION':
      return _$invoiceRequestViewKindEnum_CORRECTION;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<InvoiceRequestViewKindEnum> _$invoiceRequestViewKindEnumValues =
    BuiltSet<InvoiceRequestViewKindEnum>(const <InvoiceRequestViewKindEnum>[
  _$invoiceRequestViewKindEnum_COPY,
  _$invoiceRequestViewKindEnum_CORRECTION,
]);

const InvoiceRequestViewStateEnum _$invoiceRequestViewStateEnum_REQUESTED =
    const InvoiceRequestViewStateEnum._('REQUESTED');
const InvoiceRequestViewStateEnum _$invoiceRequestViewStateEnum_UPLOADED =
    const InvoiceRequestViewStateEnum._('UPLOADED');
const InvoiceRequestViewStateEnum _$invoiceRequestViewStateEnum_DOWNLOADED =
    const InvoiceRequestViewStateEnum._('DOWNLOADED');
const InvoiceRequestViewStateEnum
    _$invoiceRequestViewStateEnum_RETURNED_FOR_CORRECTION =
    const InvoiceRequestViewStateEnum._('RETURNED_FOR_CORRECTION');
const InvoiceRequestViewStateEnum _$invoiceRequestViewStateEnum_CLOSED =
    const InvoiceRequestViewStateEnum._('CLOSED');

InvoiceRequestViewStateEnum _$invoiceRequestViewStateEnumValueOf(String name) {
  switch (name) {
    case 'REQUESTED':
      return _$invoiceRequestViewStateEnum_REQUESTED;
    case 'UPLOADED':
      return _$invoiceRequestViewStateEnum_UPLOADED;
    case 'DOWNLOADED':
      return _$invoiceRequestViewStateEnum_DOWNLOADED;
    case 'RETURNED_FOR_CORRECTION':
      return _$invoiceRequestViewStateEnum_RETURNED_FOR_CORRECTION;
    case 'CLOSED':
      return _$invoiceRequestViewStateEnum_CLOSED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<InvoiceRequestViewStateEnum>
    _$invoiceRequestViewStateEnumValues =
    BuiltSet<InvoiceRequestViewStateEnum>(const <InvoiceRequestViewStateEnum>[
  _$invoiceRequestViewStateEnum_REQUESTED,
  _$invoiceRequestViewStateEnum_UPLOADED,
  _$invoiceRequestViewStateEnum_DOWNLOADED,
  _$invoiceRequestViewStateEnum_RETURNED_FOR_CORRECTION,
  _$invoiceRequestViewStateEnum_CLOSED,
]);

Serializer<InvoiceRequestViewKindEnum> _$invoiceRequestViewKindEnumSerializer =
    _$InvoiceRequestViewKindEnumSerializer();
Serializer<InvoiceRequestViewStateEnum>
    _$invoiceRequestViewStateEnumSerializer =
    _$InvoiceRequestViewStateEnumSerializer();

class _$InvoiceRequestViewKindEnumSerializer
    implements PrimitiveSerializer<InvoiceRequestViewKindEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'COPY': 'COPY',
    'CORRECTION': 'CORRECTION',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'COPY': 'COPY',
    'CORRECTION': 'CORRECTION',
  };

  @override
  final Iterable<Type> types = const <Type>[InvoiceRequestViewKindEnum];
  @override
  final String wireName = 'InvoiceRequestViewKindEnum';

  @override
  Object serialize(Serializers serializers, InvoiceRequestViewKindEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  InvoiceRequestViewKindEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      InvoiceRequestViewKindEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$InvoiceRequestViewStateEnumSerializer
    implements PrimitiveSerializer<InvoiceRequestViewStateEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'REQUESTED': 'REQUESTED',
    'UPLOADED': 'UPLOADED',
    'DOWNLOADED': 'DOWNLOADED',
    'RETURNED_FOR_CORRECTION': 'RETURNED_FOR_CORRECTION',
    'CLOSED': 'CLOSED',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'REQUESTED': 'REQUESTED',
    'UPLOADED': 'UPLOADED',
    'DOWNLOADED': 'DOWNLOADED',
    'RETURNED_FOR_CORRECTION': 'RETURNED_FOR_CORRECTION',
    'CLOSED': 'CLOSED',
  };

  @override
  final Iterable<Type> types = const <Type>[InvoiceRequestViewStateEnum];
  @override
  final String wireName = 'InvoiceRequestViewStateEnum';

  @override
  Object serialize(Serializers serializers, InvoiceRequestViewStateEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  InvoiceRequestViewStateEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      InvoiceRequestViewStateEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$InvoiceRequestView extends InvoiceRequestView {
  @override
  final String id;
  @override
  final InvoiceRequestViewKindEnum kind;
  @override
  final InvoiceRequestViewStateEnum state;
  @override
  final String? details;
  @override
  final String? invoiceRecordId;
  @override
  final String? fulfilledInvoiceRecordId;
  @override
  final DateTime? requestedAt;
  @override
  final DateTime serviceTargetAt;
  @override
  final String serviceTargetLabel;
  @override
  final bool overdue;
  @override
  final DateTime? uploadedAt;
  @override
  final DateTime? downloadedAt;
  @override
  final DateTime? closedAt;
  @override
  final bool canReturn;
  @override
  final bool canClose;
  @override
  final String? orderReference;
  @override
  final String? vendorName;

  factory _$InvoiceRequestView(
          [void Function(InvoiceRequestViewBuilder)? updates]) =>
      (InvoiceRequestViewBuilder()..update(updates))._build();

  _$InvoiceRequestView._(
      {required this.id,
      required this.kind,
      required this.state,
      this.details,
      this.invoiceRecordId,
      this.fulfilledInvoiceRecordId,
      this.requestedAt,
      required this.serviceTargetAt,
      required this.serviceTargetLabel,
      required this.overdue,
      this.uploadedAt,
      this.downloadedAt,
      this.closedAt,
      required this.canReturn,
      required this.canClose,
      this.orderReference,
      this.vendorName})
      : super._();
  @override
  InvoiceRequestView rebuild(
          void Function(InvoiceRequestViewBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  InvoiceRequestViewBuilder toBuilder() =>
      InvoiceRequestViewBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is InvoiceRequestView &&
        id == other.id &&
        kind == other.kind &&
        state == other.state &&
        details == other.details &&
        invoiceRecordId == other.invoiceRecordId &&
        fulfilledInvoiceRecordId == other.fulfilledInvoiceRecordId &&
        requestedAt == other.requestedAt &&
        serviceTargetAt == other.serviceTargetAt &&
        serviceTargetLabel == other.serviceTargetLabel &&
        overdue == other.overdue &&
        uploadedAt == other.uploadedAt &&
        downloadedAt == other.downloadedAt &&
        closedAt == other.closedAt &&
        canReturn == other.canReturn &&
        canClose == other.canClose &&
        orderReference == other.orderReference &&
        vendorName == other.vendorName;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, kind.hashCode);
    _$hash = $jc(_$hash, state.hashCode);
    _$hash = $jc(_$hash, details.hashCode);
    _$hash = $jc(_$hash, invoiceRecordId.hashCode);
    _$hash = $jc(_$hash, fulfilledInvoiceRecordId.hashCode);
    _$hash = $jc(_$hash, requestedAt.hashCode);
    _$hash = $jc(_$hash, serviceTargetAt.hashCode);
    _$hash = $jc(_$hash, serviceTargetLabel.hashCode);
    _$hash = $jc(_$hash, overdue.hashCode);
    _$hash = $jc(_$hash, uploadedAt.hashCode);
    _$hash = $jc(_$hash, downloadedAt.hashCode);
    _$hash = $jc(_$hash, closedAt.hashCode);
    _$hash = $jc(_$hash, canReturn.hashCode);
    _$hash = $jc(_$hash, canClose.hashCode);
    _$hash = $jc(_$hash, orderReference.hashCode);
    _$hash = $jc(_$hash, vendorName.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'InvoiceRequestView')
          ..add('id', id)
          ..add('kind', kind)
          ..add('state', state)
          ..add('details', details)
          ..add('invoiceRecordId', invoiceRecordId)
          ..add('fulfilledInvoiceRecordId', fulfilledInvoiceRecordId)
          ..add('requestedAt', requestedAt)
          ..add('serviceTargetAt', serviceTargetAt)
          ..add('serviceTargetLabel', serviceTargetLabel)
          ..add('overdue', overdue)
          ..add('uploadedAt', uploadedAt)
          ..add('downloadedAt', downloadedAt)
          ..add('closedAt', closedAt)
          ..add('canReturn', canReturn)
          ..add('canClose', canClose)
          ..add('orderReference', orderReference)
          ..add('vendorName', vendorName))
        .toString();
  }
}

class InvoiceRequestViewBuilder
    implements Builder<InvoiceRequestView, InvoiceRequestViewBuilder> {
  _$InvoiceRequestView? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  InvoiceRequestViewKindEnum? _kind;
  InvoiceRequestViewKindEnum? get kind => _$this._kind;
  set kind(InvoiceRequestViewKindEnum? kind) => _$this._kind = kind;

  InvoiceRequestViewStateEnum? _state;
  InvoiceRequestViewStateEnum? get state => _$this._state;
  set state(InvoiceRequestViewStateEnum? state) => _$this._state = state;

  String? _details;
  String? get details => _$this._details;
  set details(String? details) => _$this._details = details;

  String? _invoiceRecordId;
  String? get invoiceRecordId => _$this._invoiceRecordId;
  set invoiceRecordId(String? invoiceRecordId) =>
      _$this._invoiceRecordId = invoiceRecordId;

  String? _fulfilledInvoiceRecordId;
  String? get fulfilledInvoiceRecordId => _$this._fulfilledInvoiceRecordId;
  set fulfilledInvoiceRecordId(String? fulfilledInvoiceRecordId) =>
      _$this._fulfilledInvoiceRecordId = fulfilledInvoiceRecordId;

  DateTime? _requestedAt;
  DateTime? get requestedAt => _$this._requestedAt;
  set requestedAt(DateTime? requestedAt) => _$this._requestedAt = requestedAt;

  DateTime? _serviceTargetAt;
  DateTime? get serviceTargetAt => _$this._serviceTargetAt;
  set serviceTargetAt(DateTime? serviceTargetAt) =>
      _$this._serviceTargetAt = serviceTargetAt;

  String? _serviceTargetLabel;
  String? get serviceTargetLabel => _$this._serviceTargetLabel;
  set serviceTargetLabel(String? serviceTargetLabel) =>
      _$this._serviceTargetLabel = serviceTargetLabel;

  bool? _overdue;
  bool? get overdue => _$this._overdue;
  set overdue(bool? overdue) => _$this._overdue = overdue;

  DateTime? _uploadedAt;
  DateTime? get uploadedAt => _$this._uploadedAt;
  set uploadedAt(DateTime? uploadedAt) => _$this._uploadedAt = uploadedAt;

  DateTime? _downloadedAt;
  DateTime? get downloadedAt => _$this._downloadedAt;
  set downloadedAt(DateTime? downloadedAt) =>
      _$this._downloadedAt = downloadedAt;

  DateTime? _closedAt;
  DateTime? get closedAt => _$this._closedAt;
  set closedAt(DateTime? closedAt) => _$this._closedAt = closedAt;

  bool? _canReturn;
  bool? get canReturn => _$this._canReturn;
  set canReturn(bool? canReturn) => _$this._canReturn = canReturn;

  bool? _canClose;
  bool? get canClose => _$this._canClose;
  set canClose(bool? canClose) => _$this._canClose = canClose;

  String? _orderReference;
  String? get orderReference => _$this._orderReference;
  set orderReference(String? orderReference) =>
      _$this._orderReference = orderReference;

  String? _vendorName;
  String? get vendorName => _$this._vendorName;
  set vendorName(String? vendorName) => _$this._vendorName = vendorName;

  InvoiceRequestViewBuilder() {
    InvoiceRequestView._defaults(this);
  }

  InvoiceRequestViewBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _kind = $v.kind;
      _state = $v.state;
      _details = $v.details;
      _invoiceRecordId = $v.invoiceRecordId;
      _fulfilledInvoiceRecordId = $v.fulfilledInvoiceRecordId;
      _requestedAt = $v.requestedAt;
      _serviceTargetAt = $v.serviceTargetAt;
      _serviceTargetLabel = $v.serviceTargetLabel;
      _overdue = $v.overdue;
      _uploadedAt = $v.uploadedAt;
      _downloadedAt = $v.downloadedAt;
      _closedAt = $v.closedAt;
      _canReturn = $v.canReturn;
      _canClose = $v.canClose;
      _orderReference = $v.orderReference;
      _vendorName = $v.vendorName;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(InvoiceRequestView other) {
    _$v = other as _$InvoiceRequestView;
  }

  @override
  void update(void Function(InvoiceRequestViewBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  InvoiceRequestView build() => _build();

  _$InvoiceRequestView _build() {
    final _$result = _$v ??
        _$InvoiceRequestView._(
          id: BuiltValueNullFieldError.checkNotNull(
              id, r'InvoiceRequestView', 'id'),
          kind: BuiltValueNullFieldError.checkNotNull(
              kind, r'InvoiceRequestView', 'kind'),
          state: BuiltValueNullFieldError.checkNotNull(
              state, r'InvoiceRequestView', 'state'),
          details: details,
          invoiceRecordId: invoiceRecordId,
          fulfilledInvoiceRecordId: fulfilledInvoiceRecordId,
          requestedAt: requestedAt,
          serviceTargetAt: BuiltValueNullFieldError.checkNotNull(
              serviceTargetAt, r'InvoiceRequestView', 'serviceTargetAt'),
          serviceTargetLabel: BuiltValueNullFieldError.checkNotNull(
              serviceTargetLabel, r'InvoiceRequestView', 'serviceTargetLabel'),
          overdue: BuiltValueNullFieldError.checkNotNull(
              overdue, r'InvoiceRequestView', 'overdue'),
          uploadedAt: uploadedAt,
          downloadedAt: downloadedAt,
          closedAt: closedAt,
          canReturn: BuiltValueNullFieldError.checkNotNull(
              canReturn, r'InvoiceRequestView', 'canReturn'),
          canClose: BuiltValueNullFieldError.checkNotNull(
              canClose, r'InvoiceRequestView', 'canClose'),
          orderReference: orderReference,
          vendorName: vendorName,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
