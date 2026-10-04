// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'buyer_order_invoices.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const BuyerOrderInvoicesStatusEnum _$buyerOrderInvoicesStatusEnum_ISSUED =
    const BuyerOrderInvoicesStatusEnum._('ISSUED');
const BuyerOrderInvoicesStatusEnum
    _$buyerOrderInvoicesStatusEnum_NOT_YET_UPLOADED =
    const BuyerOrderInvoicesStatusEnum._('NOT_YET_UPLOADED');
const BuyerOrderInvoicesStatusEnum _$buyerOrderInvoicesStatusEnum_NOT_DUE =
    const BuyerOrderInvoicesStatusEnum._('NOT_DUE');

BuyerOrderInvoicesStatusEnum _$buyerOrderInvoicesStatusEnumValueOf(
    String name) {
  switch (name) {
    case 'ISSUED':
      return _$buyerOrderInvoicesStatusEnum_ISSUED;
    case 'NOT_YET_UPLOADED':
      return _$buyerOrderInvoicesStatusEnum_NOT_YET_UPLOADED;
    case 'NOT_DUE':
      return _$buyerOrderInvoicesStatusEnum_NOT_DUE;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<BuyerOrderInvoicesStatusEnum>
    _$buyerOrderInvoicesStatusEnumValues =
    BuiltSet<BuyerOrderInvoicesStatusEnum>(const <BuyerOrderInvoicesStatusEnum>[
  _$buyerOrderInvoicesStatusEnum_ISSUED,
  _$buyerOrderInvoicesStatusEnum_NOT_YET_UPLOADED,
  _$buyerOrderInvoicesStatusEnum_NOT_DUE,
]);

Serializer<BuyerOrderInvoicesStatusEnum>
    _$buyerOrderInvoicesStatusEnumSerializer =
    _$BuyerOrderInvoicesStatusEnumSerializer();

class _$BuyerOrderInvoicesStatusEnumSerializer
    implements PrimitiveSerializer<BuyerOrderInvoicesStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'ISSUED': 'ISSUED',
    'NOT_YET_UPLOADED': 'NOT_YET_UPLOADED',
    'NOT_DUE': 'NOT_DUE',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'ISSUED': 'ISSUED',
    'NOT_YET_UPLOADED': 'NOT_YET_UPLOADED',
    'NOT_DUE': 'NOT_DUE',
  };

  @override
  final Iterable<Type> types = const <Type>[BuyerOrderInvoicesStatusEnum];
  @override
  final String wireName = 'BuyerOrderInvoicesStatusEnum';

  @override
  Object serialize(Serializers serializers, BuyerOrderInvoicesStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  BuyerOrderInvoicesStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      BuyerOrderInvoicesStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$BuyerOrderInvoices extends BuyerOrderInvoices {
  @override
  final String orderId;
  @override
  final String orderReference;
  @override
  final BuyerOrderInvoicesStatusEnum status;
  @override
  final String issuanceNotice;
  @override
  final BuiltList<InvoiceRecordView> records;
  @override
  final BuiltList<InvoiceRequestView> requests;
  @override
  final BuiltList<PlatformDocumentRef> platformDocuments;
  @override
  final BuyerInvoiceBillingDetails? billingDetails;
  @override
  final bool canEditBillingDetails;
  @override
  final bool canRequestCopy;
  @override
  final bool canRequestCorrection;

  factory _$BuyerOrderInvoices(
          [void Function(BuyerOrderInvoicesBuilder)? updates]) =>
      (BuyerOrderInvoicesBuilder()..update(updates))._build();

  _$BuyerOrderInvoices._(
      {required this.orderId,
      required this.orderReference,
      required this.status,
      required this.issuanceNotice,
      required this.records,
      required this.requests,
      required this.platformDocuments,
      this.billingDetails,
      required this.canEditBillingDetails,
      required this.canRequestCopy,
      required this.canRequestCorrection})
      : super._();
  @override
  BuyerOrderInvoices rebuild(
          void Function(BuyerOrderInvoicesBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  BuyerOrderInvoicesBuilder toBuilder() =>
      BuyerOrderInvoicesBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is BuyerOrderInvoices &&
        orderId == other.orderId &&
        orderReference == other.orderReference &&
        status == other.status &&
        issuanceNotice == other.issuanceNotice &&
        records == other.records &&
        requests == other.requests &&
        platformDocuments == other.platformDocuments &&
        billingDetails == other.billingDetails &&
        canEditBillingDetails == other.canEditBillingDetails &&
        canRequestCopy == other.canRequestCopy &&
        canRequestCorrection == other.canRequestCorrection;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, orderId.hashCode);
    _$hash = $jc(_$hash, orderReference.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, issuanceNotice.hashCode);
    _$hash = $jc(_$hash, records.hashCode);
    _$hash = $jc(_$hash, requests.hashCode);
    _$hash = $jc(_$hash, platformDocuments.hashCode);
    _$hash = $jc(_$hash, billingDetails.hashCode);
    _$hash = $jc(_$hash, canEditBillingDetails.hashCode);
    _$hash = $jc(_$hash, canRequestCopy.hashCode);
    _$hash = $jc(_$hash, canRequestCorrection.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'BuyerOrderInvoices')
          ..add('orderId', orderId)
          ..add('orderReference', orderReference)
          ..add('status', status)
          ..add('issuanceNotice', issuanceNotice)
          ..add('records', records)
          ..add('requests', requests)
          ..add('platformDocuments', platformDocuments)
          ..add('billingDetails', billingDetails)
          ..add('canEditBillingDetails', canEditBillingDetails)
          ..add('canRequestCopy', canRequestCopy)
          ..add('canRequestCorrection', canRequestCorrection))
        .toString();
  }
}

class BuyerOrderInvoicesBuilder
    implements Builder<BuyerOrderInvoices, BuyerOrderInvoicesBuilder> {
  _$BuyerOrderInvoices? _$v;

  String? _orderId;
  String? get orderId => _$this._orderId;
  set orderId(String? orderId) => _$this._orderId = orderId;

  String? _orderReference;
  String? get orderReference => _$this._orderReference;
  set orderReference(String? orderReference) =>
      _$this._orderReference = orderReference;

  BuyerOrderInvoicesStatusEnum? _status;
  BuyerOrderInvoicesStatusEnum? get status => _$this._status;
  set status(BuyerOrderInvoicesStatusEnum? status) => _$this._status = status;

  String? _issuanceNotice;
  String? get issuanceNotice => _$this._issuanceNotice;
  set issuanceNotice(String? issuanceNotice) =>
      _$this._issuanceNotice = issuanceNotice;

  ListBuilder<InvoiceRecordView>? _records;
  ListBuilder<InvoiceRecordView> get records =>
      _$this._records ??= ListBuilder<InvoiceRecordView>();
  set records(ListBuilder<InvoiceRecordView>? records) =>
      _$this._records = records;

  ListBuilder<InvoiceRequestView>? _requests;
  ListBuilder<InvoiceRequestView> get requests =>
      _$this._requests ??= ListBuilder<InvoiceRequestView>();
  set requests(ListBuilder<InvoiceRequestView>? requests) =>
      _$this._requests = requests;

  ListBuilder<PlatformDocumentRef>? _platformDocuments;
  ListBuilder<PlatformDocumentRef> get platformDocuments =>
      _$this._platformDocuments ??= ListBuilder<PlatformDocumentRef>();
  set platformDocuments(ListBuilder<PlatformDocumentRef>? platformDocuments) =>
      _$this._platformDocuments = platformDocuments;

  BuyerInvoiceBillingDetailsBuilder? _billingDetails;
  BuyerInvoiceBillingDetailsBuilder get billingDetails =>
      _$this._billingDetails ??= BuyerInvoiceBillingDetailsBuilder();
  set billingDetails(BuyerInvoiceBillingDetailsBuilder? billingDetails) =>
      _$this._billingDetails = billingDetails;

  bool? _canEditBillingDetails;
  bool? get canEditBillingDetails => _$this._canEditBillingDetails;
  set canEditBillingDetails(bool? canEditBillingDetails) =>
      _$this._canEditBillingDetails = canEditBillingDetails;

  bool? _canRequestCopy;
  bool? get canRequestCopy => _$this._canRequestCopy;
  set canRequestCopy(bool? canRequestCopy) =>
      _$this._canRequestCopy = canRequestCopy;

  bool? _canRequestCorrection;
  bool? get canRequestCorrection => _$this._canRequestCorrection;
  set canRequestCorrection(bool? canRequestCorrection) =>
      _$this._canRequestCorrection = canRequestCorrection;

  BuyerOrderInvoicesBuilder() {
    BuyerOrderInvoices._defaults(this);
  }

  BuyerOrderInvoicesBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _orderId = $v.orderId;
      _orderReference = $v.orderReference;
      _status = $v.status;
      _issuanceNotice = $v.issuanceNotice;
      _records = $v.records.toBuilder();
      _requests = $v.requests.toBuilder();
      _platformDocuments = $v.platformDocuments.toBuilder();
      _billingDetails = $v.billingDetails?.toBuilder();
      _canEditBillingDetails = $v.canEditBillingDetails;
      _canRequestCopy = $v.canRequestCopy;
      _canRequestCorrection = $v.canRequestCorrection;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(BuyerOrderInvoices other) {
    _$v = other as _$BuyerOrderInvoices;
  }

  @override
  void update(void Function(BuyerOrderInvoicesBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  BuyerOrderInvoices build() => _build();

  _$BuyerOrderInvoices _build() {
    _$BuyerOrderInvoices _$result;
    try {
      _$result = _$v ??
          _$BuyerOrderInvoices._(
            orderId: BuiltValueNullFieldError.checkNotNull(
                orderId, r'BuyerOrderInvoices', 'orderId'),
            orderReference: BuiltValueNullFieldError.checkNotNull(
                orderReference, r'BuyerOrderInvoices', 'orderReference'),
            status: BuiltValueNullFieldError.checkNotNull(
                status, r'BuyerOrderInvoices', 'status'),
            issuanceNotice: BuiltValueNullFieldError.checkNotNull(
                issuanceNotice, r'BuyerOrderInvoices', 'issuanceNotice'),
            records: records.build(),
            requests: requests.build(),
            platformDocuments: platformDocuments.build(),
            billingDetails: _billingDetails?.build(),
            canEditBillingDetails: BuiltValueNullFieldError.checkNotNull(
                canEditBillingDetails,
                r'BuyerOrderInvoices',
                'canEditBillingDetails'),
            canRequestCopy: BuiltValueNullFieldError.checkNotNull(
                canRequestCopy, r'BuyerOrderInvoices', 'canRequestCopy'),
            canRequestCorrection: BuiltValueNullFieldError.checkNotNull(
                canRequestCorrection,
                r'BuyerOrderInvoices',
                'canRequestCorrection'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'records';
        records.build();
        _$failedField = 'requests';
        requests.build();
        _$failedField = 'platformDocuments';
        platformDocuments.build();
        _$failedField = 'billingDetails';
        _billingDetails?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'BuyerOrderInvoices', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
