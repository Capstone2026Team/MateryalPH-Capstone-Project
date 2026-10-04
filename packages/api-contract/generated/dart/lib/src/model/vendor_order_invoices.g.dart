// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_order_invoices.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const VendorOrderInvoicesStatusEnum _$vendorOrderInvoicesStatusEnum_ISSUED =
    const VendorOrderInvoicesStatusEnum._('ISSUED');
const VendorOrderInvoicesStatusEnum
    _$vendorOrderInvoicesStatusEnum_NOT_YET_UPLOADED =
    const VendorOrderInvoicesStatusEnum._('NOT_YET_UPLOADED');
const VendorOrderInvoicesStatusEnum _$vendorOrderInvoicesStatusEnum_NOT_DUE =
    const VendorOrderInvoicesStatusEnum._('NOT_DUE');

VendorOrderInvoicesStatusEnum _$vendorOrderInvoicesStatusEnumValueOf(
    String name) {
  switch (name) {
    case 'ISSUED':
      return _$vendorOrderInvoicesStatusEnum_ISSUED;
    case 'NOT_YET_UPLOADED':
      return _$vendorOrderInvoicesStatusEnum_NOT_YET_UPLOADED;
    case 'NOT_DUE':
      return _$vendorOrderInvoicesStatusEnum_NOT_DUE;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<VendorOrderInvoicesStatusEnum>
    _$vendorOrderInvoicesStatusEnumValues = BuiltSet<
        VendorOrderInvoicesStatusEnum>(const <VendorOrderInvoicesStatusEnum>[
  _$vendorOrderInvoicesStatusEnum_ISSUED,
  _$vendorOrderInvoicesStatusEnum_NOT_YET_UPLOADED,
  _$vendorOrderInvoicesStatusEnum_NOT_DUE,
]);

const VendorOrderInvoicesInvoiceTypesEnum
    _$vendorOrderInvoicesInvoiceTypesEnum_VENDOR_GOODS_INVOICE =
    const VendorOrderInvoicesInvoiceTypesEnum._('VENDOR_GOODS_INVOICE');
const VendorOrderInvoicesInvoiceTypesEnum
    _$vendorOrderInvoicesInvoiceTypesEnum_VENDOR_ADJUSTMENT_DOCUMENT =
    const VendorOrderInvoicesInvoiceTypesEnum._('VENDOR_ADJUSTMENT_DOCUMENT');

VendorOrderInvoicesInvoiceTypesEnum
    _$vendorOrderInvoicesInvoiceTypesEnumValueOf(String name) {
  switch (name) {
    case 'VENDOR_GOODS_INVOICE':
      return _$vendorOrderInvoicesInvoiceTypesEnum_VENDOR_GOODS_INVOICE;
    case 'VENDOR_ADJUSTMENT_DOCUMENT':
      return _$vendorOrderInvoicesInvoiceTypesEnum_VENDOR_ADJUSTMENT_DOCUMENT;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<VendorOrderInvoicesInvoiceTypesEnum>
    _$vendorOrderInvoicesInvoiceTypesEnumValues = BuiltSet<
        VendorOrderInvoicesInvoiceTypesEnum>(const <VendorOrderInvoicesInvoiceTypesEnum>[
  _$vendorOrderInvoicesInvoiceTypesEnum_VENDOR_GOODS_INVOICE,
  _$vendorOrderInvoicesInvoiceTypesEnum_VENDOR_ADJUSTMENT_DOCUMENT,
]);

const VendorOrderInvoicesSourceSystemsEnum
    _$vendorOrderInvoicesSourceSystemsEnum_REGISTERED_CAS =
    const VendorOrderInvoicesSourceSystemsEnum._('REGISTERED_CAS');
const VendorOrderInvoicesSourceSystemsEnum
    _$vendorOrderInvoicesSourceSystemsEnum_BIR_EIS =
    const VendorOrderInvoicesSourceSystemsEnum._('BIR_EIS');
const VendorOrderInvoicesSourceSystemsEnum
    _$vendorOrderInvoicesSourceSystemsEnum_LOOSE_LEAF_OR_PRINTED =
    const VendorOrderInvoicesSourceSystemsEnum._('LOOSE_LEAF_OR_PRINTED');
const VendorOrderInvoicesSourceSystemsEnum
    _$vendorOrderInvoicesSourceSystemsEnum_OTHER_REGISTERED =
    const VendorOrderInvoicesSourceSystemsEnum._('OTHER_REGISTERED');

VendorOrderInvoicesSourceSystemsEnum
    _$vendorOrderInvoicesSourceSystemsEnumValueOf(String name) {
  switch (name) {
    case 'REGISTERED_CAS':
      return _$vendorOrderInvoicesSourceSystemsEnum_REGISTERED_CAS;
    case 'BIR_EIS':
      return _$vendorOrderInvoicesSourceSystemsEnum_BIR_EIS;
    case 'LOOSE_LEAF_OR_PRINTED':
      return _$vendorOrderInvoicesSourceSystemsEnum_LOOSE_LEAF_OR_PRINTED;
    case 'OTHER_REGISTERED':
      return _$vendorOrderInvoicesSourceSystemsEnum_OTHER_REGISTERED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<VendorOrderInvoicesSourceSystemsEnum>
    _$vendorOrderInvoicesSourceSystemsEnumValues = BuiltSet<
        VendorOrderInvoicesSourceSystemsEnum>(const <VendorOrderInvoicesSourceSystemsEnum>[
  _$vendorOrderInvoicesSourceSystemsEnum_REGISTERED_CAS,
  _$vendorOrderInvoicesSourceSystemsEnum_BIR_EIS,
  _$vendorOrderInvoicesSourceSystemsEnum_LOOSE_LEAF_OR_PRINTED,
  _$vendorOrderInvoicesSourceSystemsEnum_OTHER_REGISTERED,
]);

const VendorOrderInvoicesInvoicingMethodsEnum
    _$vendorOrderInvoicesInvoicingMethodsEnum_ELECTRONIC =
    const VendorOrderInvoicesInvoicingMethodsEnum._('ELECTRONIC');
const VendorOrderInvoicesInvoicingMethodsEnum
    _$vendorOrderInvoicesInvoicingMethodsEnum_COMPUTERIZED =
    const VendorOrderInvoicesInvoicingMethodsEnum._('COMPUTERIZED');
const VendorOrderInvoicesInvoicingMethodsEnum
    _$vendorOrderInvoicesInvoicingMethodsEnum_MANUAL =
    const VendorOrderInvoicesInvoicingMethodsEnum._('MANUAL');

VendorOrderInvoicesInvoicingMethodsEnum
    _$vendorOrderInvoicesInvoicingMethodsEnumValueOf(String name) {
  switch (name) {
    case 'ELECTRONIC':
      return _$vendorOrderInvoicesInvoicingMethodsEnum_ELECTRONIC;
    case 'COMPUTERIZED':
      return _$vendorOrderInvoicesInvoicingMethodsEnum_COMPUTERIZED;
    case 'MANUAL':
      return _$vendorOrderInvoicesInvoicingMethodsEnum_MANUAL;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<VendorOrderInvoicesInvoicingMethodsEnum>
    _$vendorOrderInvoicesInvoicingMethodsEnumValues = BuiltSet<
        VendorOrderInvoicesInvoicingMethodsEnum>(const <VendorOrderInvoicesInvoicingMethodsEnum>[
  _$vendorOrderInvoicesInvoicingMethodsEnum_ELECTRONIC,
  _$vendorOrderInvoicesInvoicingMethodsEnum_COMPUTERIZED,
  _$vendorOrderInvoicesInvoicingMethodsEnum_MANUAL,
]);

Serializer<VendorOrderInvoicesStatusEnum>
    _$vendorOrderInvoicesStatusEnumSerializer =
    _$VendorOrderInvoicesStatusEnumSerializer();
Serializer<VendorOrderInvoicesInvoiceTypesEnum>
    _$vendorOrderInvoicesInvoiceTypesEnumSerializer =
    _$VendorOrderInvoicesInvoiceTypesEnumSerializer();
Serializer<VendorOrderInvoicesSourceSystemsEnum>
    _$vendorOrderInvoicesSourceSystemsEnumSerializer =
    _$VendorOrderInvoicesSourceSystemsEnumSerializer();
Serializer<VendorOrderInvoicesInvoicingMethodsEnum>
    _$vendorOrderInvoicesInvoicingMethodsEnumSerializer =
    _$VendorOrderInvoicesInvoicingMethodsEnumSerializer();

class _$VendorOrderInvoicesStatusEnumSerializer
    implements PrimitiveSerializer<VendorOrderInvoicesStatusEnum> {
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
  final Iterable<Type> types = const <Type>[VendorOrderInvoicesStatusEnum];
  @override
  final String wireName = 'VendorOrderInvoicesStatusEnum';

  @override
  Object serialize(
          Serializers serializers, VendorOrderInvoicesStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  VendorOrderInvoicesStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      VendorOrderInvoicesStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$VendorOrderInvoicesInvoiceTypesEnumSerializer
    implements PrimitiveSerializer<VendorOrderInvoicesInvoiceTypesEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'VENDOR_GOODS_INVOICE': 'VENDOR_GOODS_INVOICE',
    'VENDOR_ADJUSTMENT_DOCUMENT': 'VENDOR_ADJUSTMENT_DOCUMENT',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'VENDOR_GOODS_INVOICE': 'VENDOR_GOODS_INVOICE',
    'VENDOR_ADJUSTMENT_DOCUMENT': 'VENDOR_ADJUSTMENT_DOCUMENT',
  };

  @override
  final Iterable<Type> types = const <Type>[
    VendorOrderInvoicesInvoiceTypesEnum
  ];
  @override
  final String wireName = 'VendorOrderInvoicesInvoiceTypesEnum';

  @override
  Object serialize(
          Serializers serializers, VendorOrderInvoicesInvoiceTypesEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  VendorOrderInvoicesInvoiceTypesEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      VendorOrderInvoicesInvoiceTypesEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$VendorOrderInvoicesSourceSystemsEnumSerializer
    implements PrimitiveSerializer<VendorOrderInvoicesSourceSystemsEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'REGISTERED_CAS': 'REGISTERED_CAS',
    'BIR_EIS': 'BIR_EIS',
    'LOOSE_LEAF_OR_PRINTED': 'LOOSE_LEAF_OR_PRINTED',
    'OTHER_REGISTERED': 'OTHER_REGISTERED',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'REGISTERED_CAS': 'REGISTERED_CAS',
    'BIR_EIS': 'BIR_EIS',
    'LOOSE_LEAF_OR_PRINTED': 'LOOSE_LEAF_OR_PRINTED',
    'OTHER_REGISTERED': 'OTHER_REGISTERED',
  };

  @override
  final Iterable<Type> types = const <Type>[
    VendorOrderInvoicesSourceSystemsEnum
  ];
  @override
  final String wireName = 'VendorOrderInvoicesSourceSystemsEnum';

  @override
  Object serialize(
          Serializers serializers, VendorOrderInvoicesSourceSystemsEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  VendorOrderInvoicesSourceSystemsEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      VendorOrderInvoicesSourceSystemsEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$VendorOrderInvoicesInvoicingMethodsEnumSerializer
    implements PrimitiveSerializer<VendorOrderInvoicesInvoicingMethodsEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'ELECTRONIC': 'ELECTRONIC',
    'COMPUTERIZED': 'COMPUTERIZED',
    'MANUAL': 'MANUAL',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'ELECTRONIC': 'ELECTRONIC',
    'COMPUTERIZED': 'COMPUTERIZED',
    'MANUAL': 'MANUAL',
  };

  @override
  final Iterable<Type> types = const <Type>[
    VendorOrderInvoicesInvoicingMethodsEnum
  ];
  @override
  final String wireName = 'VendorOrderInvoicesInvoicingMethodsEnum';

  @override
  Object serialize(Serializers serializers,
          VendorOrderInvoicesInvoicingMethodsEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  VendorOrderInvoicesInvoicingMethodsEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      VendorOrderInvoicesInvoicingMethodsEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$VendorOrderInvoices extends VendorOrderInvoices {
  @override
  final String orderId;
  @override
  final String orderReference;
  @override
  final VendorOrderInvoicesStatusEnum status;
  @override
  final String issuanceNotice;
  @override
  final BuiltList<InvoiceRecordView> records;
  @override
  final BuiltList<InvoiceRequestView> requests;
  @override
  final BuiltList<PlatformDocumentRef> platformDocuments;
  @override
  final VendorInvoiceBillingDetails? billingDetails;
  @override
  final bool canUpload;
  @override
  final bool canOpenFiles;
  @override
  final String issuerName;
  @override
  final BuiltList<VendorOrderInvoicesInvoiceTypesEnum> invoiceTypes;
  @override
  final BuiltList<VendorOrderInvoicesSourceSystemsEnum> sourceSystems;
  @override
  final BuiltList<VendorOrderInvoicesInvoicingMethodsEnum> invoicingMethods;
  @override
  final BuiltList<InvoiceOrderLine> lines;

  factory _$VendorOrderInvoices(
          [void Function(VendorOrderInvoicesBuilder)? updates]) =>
      (VendorOrderInvoicesBuilder()..update(updates))._build();

  _$VendorOrderInvoices._(
      {required this.orderId,
      required this.orderReference,
      required this.status,
      required this.issuanceNotice,
      required this.records,
      required this.requests,
      required this.platformDocuments,
      this.billingDetails,
      required this.canUpload,
      required this.canOpenFiles,
      required this.issuerName,
      required this.invoiceTypes,
      required this.sourceSystems,
      required this.invoicingMethods,
      required this.lines})
      : super._();
  @override
  VendorOrderInvoices rebuild(
          void Function(VendorOrderInvoicesBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  VendorOrderInvoicesBuilder toBuilder() =>
      VendorOrderInvoicesBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is VendorOrderInvoices &&
        orderId == other.orderId &&
        orderReference == other.orderReference &&
        status == other.status &&
        issuanceNotice == other.issuanceNotice &&
        records == other.records &&
        requests == other.requests &&
        platformDocuments == other.platformDocuments &&
        billingDetails == other.billingDetails &&
        canUpload == other.canUpload &&
        canOpenFiles == other.canOpenFiles &&
        issuerName == other.issuerName &&
        invoiceTypes == other.invoiceTypes &&
        sourceSystems == other.sourceSystems &&
        invoicingMethods == other.invoicingMethods &&
        lines == other.lines;
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
    _$hash = $jc(_$hash, canUpload.hashCode);
    _$hash = $jc(_$hash, canOpenFiles.hashCode);
    _$hash = $jc(_$hash, issuerName.hashCode);
    _$hash = $jc(_$hash, invoiceTypes.hashCode);
    _$hash = $jc(_$hash, sourceSystems.hashCode);
    _$hash = $jc(_$hash, invoicingMethods.hashCode);
    _$hash = $jc(_$hash, lines.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'VendorOrderInvoices')
          ..add('orderId', orderId)
          ..add('orderReference', orderReference)
          ..add('status', status)
          ..add('issuanceNotice', issuanceNotice)
          ..add('records', records)
          ..add('requests', requests)
          ..add('platformDocuments', platformDocuments)
          ..add('billingDetails', billingDetails)
          ..add('canUpload', canUpload)
          ..add('canOpenFiles', canOpenFiles)
          ..add('issuerName', issuerName)
          ..add('invoiceTypes', invoiceTypes)
          ..add('sourceSystems', sourceSystems)
          ..add('invoicingMethods', invoicingMethods)
          ..add('lines', lines))
        .toString();
  }
}

class VendorOrderInvoicesBuilder
    implements Builder<VendorOrderInvoices, VendorOrderInvoicesBuilder> {
  _$VendorOrderInvoices? _$v;

  String? _orderId;
  String? get orderId => _$this._orderId;
  set orderId(String? orderId) => _$this._orderId = orderId;

  String? _orderReference;
  String? get orderReference => _$this._orderReference;
  set orderReference(String? orderReference) =>
      _$this._orderReference = orderReference;

  VendorOrderInvoicesStatusEnum? _status;
  VendorOrderInvoicesStatusEnum? get status => _$this._status;
  set status(VendorOrderInvoicesStatusEnum? status) => _$this._status = status;

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

  VendorInvoiceBillingDetailsBuilder? _billingDetails;
  VendorInvoiceBillingDetailsBuilder get billingDetails =>
      _$this._billingDetails ??= VendorInvoiceBillingDetailsBuilder();
  set billingDetails(VendorInvoiceBillingDetailsBuilder? billingDetails) =>
      _$this._billingDetails = billingDetails;

  bool? _canUpload;
  bool? get canUpload => _$this._canUpload;
  set canUpload(bool? canUpload) => _$this._canUpload = canUpload;

  bool? _canOpenFiles;
  bool? get canOpenFiles => _$this._canOpenFiles;
  set canOpenFiles(bool? canOpenFiles) => _$this._canOpenFiles = canOpenFiles;

  String? _issuerName;
  String? get issuerName => _$this._issuerName;
  set issuerName(String? issuerName) => _$this._issuerName = issuerName;

  ListBuilder<VendorOrderInvoicesInvoiceTypesEnum>? _invoiceTypes;
  ListBuilder<VendorOrderInvoicesInvoiceTypesEnum> get invoiceTypes =>
      _$this._invoiceTypes ??=
          ListBuilder<VendorOrderInvoicesInvoiceTypesEnum>();
  set invoiceTypes(
          ListBuilder<VendorOrderInvoicesInvoiceTypesEnum>? invoiceTypes) =>
      _$this._invoiceTypes = invoiceTypes;

  ListBuilder<VendorOrderInvoicesSourceSystemsEnum>? _sourceSystems;
  ListBuilder<VendorOrderInvoicesSourceSystemsEnum> get sourceSystems =>
      _$this._sourceSystems ??=
          ListBuilder<VendorOrderInvoicesSourceSystemsEnum>();
  set sourceSystems(
          ListBuilder<VendorOrderInvoicesSourceSystemsEnum>? sourceSystems) =>
      _$this._sourceSystems = sourceSystems;

  ListBuilder<VendorOrderInvoicesInvoicingMethodsEnum>? _invoicingMethods;
  ListBuilder<VendorOrderInvoicesInvoicingMethodsEnum> get invoicingMethods =>
      _$this._invoicingMethods ??=
          ListBuilder<VendorOrderInvoicesInvoicingMethodsEnum>();
  set invoicingMethods(
          ListBuilder<VendorOrderInvoicesInvoicingMethodsEnum>?
              invoicingMethods) =>
      _$this._invoicingMethods = invoicingMethods;

  ListBuilder<InvoiceOrderLine>? _lines;
  ListBuilder<InvoiceOrderLine> get lines =>
      _$this._lines ??= ListBuilder<InvoiceOrderLine>();
  set lines(ListBuilder<InvoiceOrderLine>? lines) => _$this._lines = lines;

  VendorOrderInvoicesBuilder() {
    VendorOrderInvoices._defaults(this);
  }

  VendorOrderInvoicesBuilder get _$this {
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
      _canUpload = $v.canUpload;
      _canOpenFiles = $v.canOpenFiles;
      _issuerName = $v.issuerName;
      _invoiceTypes = $v.invoiceTypes.toBuilder();
      _sourceSystems = $v.sourceSystems.toBuilder();
      _invoicingMethods = $v.invoicingMethods.toBuilder();
      _lines = $v.lines.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(VendorOrderInvoices other) {
    _$v = other as _$VendorOrderInvoices;
  }

  @override
  void update(void Function(VendorOrderInvoicesBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  VendorOrderInvoices build() => _build();

  _$VendorOrderInvoices _build() {
    _$VendorOrderInvoices _$result;
    try {
      _$result = _$v ??
          _$VendorOrderInvoices._(
            orderId: BuiltValueNullFieldError.checkNotNull(
                orderId, r'VendorOrderInvoices', 'orderId'),
            orderReference: BuiltValueNullFieldError.checkNotNull(
                orderReference, r'VendorOrderInvoices', 'orderReference'),
            status: BuiltValueNullFieldError.checkNotNull(
                status, r'VendorOrderInvoices', 'status'),
            issuanceNotice: BuiltValueNullFieldError.checkNotNull(
                issuanceNotice, r'VendorOrderInvoices', 'issuanceNotice'),
            records: records.build(),
            requests: requests.build(),
            platformDocuments: platformDocuments.build(),
            billingDetails: _billingDetails?.build(),
            canUpload: BuiltValueNullFieldError.checkNotNull(
                canUpload, r'VendorOrderInvoices', 'canUpload'),
            canOpenFiles: BuiltValueNullFieldError.checkNotNull(
                canOpenFiles, r'VendorOrderInvoices', 'canOpenFiles'),
            issuerName: BuiltValueNullFieldError.checkNotNull(
                issuerName, r'VendorOrderInvoices', 'issuerName'),
            invoiceTypes: invoiceTypes.build(),
            sourceSystems: sourceSystems.build(),
            invoicingMethods: invoicingMethods.build(),
            lines: lines.build(),
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

        _$failedField = 'invoiceTypes';
        invoiceTypes.build();
        _$failedField = 'sourceSystems';
        sourceSystems.build();
        _$failedField = 'invoicingMethods';
        invoicingMethods.build();
        _$failedField = 'lines';
        lines.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'VendorOrderInvoices', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
