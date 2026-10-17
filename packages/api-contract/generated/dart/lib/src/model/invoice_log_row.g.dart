// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'invoice_log_row.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$InvoiceLogRow extends InvoiceLogRow {
  @override
  final String? id;
  @override
  final String? orderId;
  @override
  final String? orderReference;
  @override
  final String? orderState;
  @override
  final String? paymentState;
  @override
  final DateTime? acceptedAt;
  @override
  final bool? openRequest;
  @override
  final String? note;
  @override
  final String? kind;
  @override
  final String? state;
  @override
  final String? details;
  @override
  final DateTime? serviceTargetAt;
  @override
  final String? serviceTargetLabel;
  @override
  final bool? overdue;
  @override
  final String? invoiceType;
  @override
  final String? issuer;
  @override
  final String? invoiceNumber;
  @override
  final String? issuedOn;
  @override
  final int? amountCentavos;
  @override
  final String? reconciliationState;
  @override
  final int? reconciliationDifferenceCentavos;
  @override
  final String? originLabel;
  @override
  final String? complianceNote;
  @override
  final String? vendorName;
  @override
  final int? downloads;
  @override
  final DateTime? lastDownloadAt;
  @override
  final DateTime? uploadedAt;
  @override
  final DisputeFileLink? download;

  factory _$InvoiceLogRow([void Function(InvoiceLogRowBuilder)? updates]) =>
      (InvoiceLogRowBuilder()..update(updates))._build();

  _$InvoiceLogRow._(
      {this.id,
      this.orderId,
      this.orderReference,
      this.orderState,
      this.paymentState,
      this.acceptedAt,
      this.openRequest,
      this.note,
      this.kind,
      this.state,
      this.details,
      this.serviceTargetAt,
      this.serviceTargetLabel,
      this.overdue,
      this.invoiceType,
      this.issuer,
      this.invoiceNumber,
      this.issuedOn,
      this.amountCentavos,
      this.reconciliationState,
      this.reconciliationDifferenceCentavos,
      this.originLabel,
      this.complianceNote,
      this.vendorName,
      this.downloads,
      this.lastDownloadAt,
      this.uploadedAt,
      this.download})
      : super._();
  @override
  InvoiceLogRow rebuild(void Function(InvoiceLogRowBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  InvoiceLogRowBuilder toBuilder() => InvoiceLogRowBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is InvoiceLogRow &&
        id == other.id &&
        orderId == other.orderId &&
        orderReference == other.orderReference &&
        orderState == other.orderState &&
        paymentState == other.paymentState &&
        acceptedAt == other.acceptedAt &&
        openRequest == other.openRequest &&
        note == other.note &&
        kind == other.kind &&
        state == other.state &&
        details == other.details &&
        serviceTargetAt == other.serviceTargetAt &&
        serviceTargetLabel == other.serviceTargetLabel &&
        overdue == other.overdue &&
        invoiceType == other.invoiceType &&
        issuer == other.issuer &&
        invoiceNumber == other.invoiceNumber &&
        issuedOn == other.issuedOn &&
        amountCentavos == other.amountCentavos &&
        reconciliationState == other.reconciliationState &&
        reconciliationDifferenceCentavos ==
            other.reconciliationDifferenceCentavos &&
        originLabel == other.originLabel &&
        complianceNote == other.complianceNote &&
        vendorName == other.vendorName &&
        downloads == other.downloads &&
        lastDownloadAt == other.lastDownloadAt &&
        uploadedAt == other.uploadedAt &&
        download == other.download;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, orderId.hashCode);
    _$hash = $jc(_$hash, orderReference.hashCode);
    _$hash = $jc(_$hash, orderState.hashCode);
    _$hash = $jc(_$hash, paymentState.hashCode);
    _$hash = $jc(_$hash, acceptedAt.hashCode);
    _$hash = $jc(_$hash, openRequest.hashCode);
    _$hash = $jc(_$hash, note.hashCode);
    _$hash = $jc(_$hash, kind.hashCode);
    _$hash = $jc(_$hash, state.hashCode);
    _$hash = $jc(_$hash, details.hashCode);
    _$hash = $jc(_$hash, serviceTargetAt.hashCode);
    _$hash = $jc(_$hash, serviceTargetLabel.hashCode);
    _$hash = $jc(_$hash, overdue.hashCode);
    _$hash = $jc(_$hash, invoiceType.hashCode);
    _$hash = $jc(_$hash, issuer.hashCode);
    _$hash = $jc(_$hash, invoiceNumber.hashCode);
    _$hash = $jc(_$hash, issuedOn.hashCode);
    _$hash = $jc(_$hash, amountCentavos.hashCode);
    _$hash = $jc(_$hash, reconciliationState.hashCode);
    _$hash = $jc(_$hash, reconciliationDifferenceCentavos.hashCode);
    _$hash = $jc(_$hash, originLabel.hashCode);
    _$hash = $jc(_$hash, complianceNote.hashCode);
    _$hash = $jc(_$hash, vendorName.hashCode);
    _$hash = $jc(_$hash, downloads.hashCode);
    _$hash = $jc(_$hash, lastDownloadAt.hashCode);
    _$hash = $jc(_$hash, uploadedAt.hashCode);
    _$hash = $jc(_$hash, download.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'InvoiceLogRow')
          ..add('id', id)
          ..add('orderId', orderId)
          ..add('orderReference', orderReference)
          ..add('orderState', orderState)
          ..add('paymentState', paymentState)
          ..add('acceptedAt', acceptedAt)
          ..add('openRequest', openRequest)
          ..add('note', note)
          ..add('kind', kind)
          ..add('state', state)
          ..add('details', details)
          ..add('serviceTargetAt', serviceTargetAt)
          ..add('serviceTargetLabel', serviceTargetLabel)
          ..add('overdue', overdue)
          ..add('invoiceType', invoiceType)
          ..add('issuer', issuer)
          ..add('invoiceNumber', invoiceNumber)
          ..add('issuedOn', issuedOn)
          ..add('amountCentavos', amountCentavos)
          ..add('reconciliationState', reconciliationState)
          ..add('reconciliationDifferenceCentavos',
              reconciliationDifferenceCentavos)
          ..add('originLabel', originLabel)
          ..add('complianceNote', complianceNote)
          ..add('vendorName', vendorName)
          ..add('downloads', downloads)
          ..add('lastDownloadAt', lastDownloadAt)
          ..add('uploadedAt', uploadedAt)
          ..add('download', download))
        .toString();
  }
}

class InvoiceLogRowBuilder
    implements Builder<InvoiceLogRow, InvoiceLogRowBuilder> {
  _$InvoiceLogRow? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _orderId;
  String? get orderId => _$this._orderId;
  set orderId(String? orderId) => _$this._orderId = orderId;

  String? _orderReference;
  String? get orderReference => _$this._orderReference;
  set orderReference(String? orderReference) =>
      _$this._orderReference = orderReference;

  String? _orderState;
  String? get orderState => _$this._orderState;
  set orderState(String? orderState) => _$this._orderState = orderState;

  String? _paymentState;
  String? get paymentState => _$this._paymentState;
  set paymentState(String? paymentState) => _$this._paymentState = paymentState;

  DateTime? _acceptedAt;
  DateTime? get acceptedAt => _$this._acceptedAt;
  set acceptedAt(DateTime? acceptedAt) => _$this._acceptedAt = acceptedAt;

  bool? _openRequest;
  bool? get openRequest => _$this._openRequest;
  set openRequest(bool? openRequest) => _$this._openRequest = openRequest;

  String? _note;
  String? get note => _$this._note;
  set note(String? note) => _$this._note = note;

  String? _kind;
  String? get kind => _$this._kind;
  set kind(String? kind) => _$this._kind = kind;

  String? _state;
  String? get state => _$this._state;
  set state(String? state) => _$this._state = state;

  String? _details;
  String? get details => _$this._details;
  set details(String? details) => _$this._details = details;

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

  String? _invoiceType;
  String? get invoiceType => _$this._invoiceType;
  set invoiceType(String? invoiceType) => _$this._invoiceType = invoiceType;

  String? _issuer;
  String? get issuer => _$this._issuer;
  set issuer(String? issuer) => _$this._issuer = issuer;

  String? _invoiceNumber;
  String? get invoiceNumber => _$this._invoiceNumber;
  set invoiceNumber(String? invoiceNumber) =>
      _$this._invoiceNumber = invoiceNumber;

  String? _issuedOn;
  String? get issuedOn => _$this._issuedOn;
  set issuedOn(String? issuedOn) => _$this._issuedOn = issuedOn;

  int? _amountCentavos;
  int? get amountCentavos => _$this._amountCentavos;
  set amountCentavos(int? amountCentavos) =>
      _$this._amountCentavos = amountCentavos;

  String? _reconciliationState;
  String? get reconciliationState => _$this._reconciliationState;
  set reconciliationState(String? reconciliationState) =>
      _$this._reconciliationState = reconciliationState;

  int? _reconciliationDifferenceCentavos;
  int? get reconciliationDifferenceCentavos =>
      _$this._reconciliationDifferenceCentavos;
  set reconciliationDifferenceCentavos(int? reconciliationDifferenceCentavos) =>
      _$this._reconciliationDifferenceCentavos =
          reconciliationDifferenceCentavos;

  String? _originLabel;
  String? get originLabel => _$this._originLabel;
  set originLabel(String? originLabel) => _$this._originLabel = originLabel;

  String? _complianceNote;
  String? get complianceNote => _$this._complianceNote;
  set complianceNote(String? complianceNote) =>
      _$this._complianceNote = complianceNote;

  String? _vendorName;
  String? get vendorName => _$this._vendorName;
  set vendorName(String? vendorName) => _$this._vendorName = vendorName;

  int? _downloads;
  int? get downloads => _$this._downloads;
  set downloads(int? downloads) => _$this._downloads = downloads;

  DateTime? _lastDownloadAt;
  DateTime? get lastDownloadAt => _$this._lastDownloadAt;
  set lastDownloadAt(DateTime? lastDownloadAt) =>
      _$this._lastDownloadAt = lastDownloadAt;

  DateTime? _uploadedAt;
  DateTime? get uploadedAt => _$this._uploadedAt;
  set uploadedAt(DateTime? uploadedAt) => _$this._uploadedAt = uploadedAt;

  DisputeFileLinkBuilder? _download;
  DisputeFileLinkBuilder get download =>
      _$this._download ??= DisputeFileLinkBuilder();
  set download(DisputeFileLinkBuilder? download) => _$this._download = download;

  InvoiceLogRowBuilder() {
    InvoiceLogRow._defaults(this);
  }

  InvoiceLogRowBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _orderId = $v.orderId;
      _orderReference = $v.orderReference;
      _orderState = $v.orderState;
      _paymentState = $v.paymentState;
      _acceptedAt = $v.acceptedAt;
      _openRequest = $v.openRequest;
      _note = $v.note;
      _kind = $v.kind;
      _state = $v.state;
      _details = $v.details;
      _serviceTargetAt = $v.serviceTargetAt;
      _serviceTargetLabel = $v.serviceTargetLabel;
      _overdue = $v.overdue;
      _invoiceType = $v.invoiceType;
      _issuer = $v.issuer;
      _invoiceNumber = $v.invoiceNumber;
      _issuedOn = $v.issuedOn;
      _amountCentavos = $v.amountCentavos;
      _reconciliationState = $v.reconciliationState;
      _reconciliationDifferenceCentavos = $v.reconciliationDifferenceCentavos;
      _originLabel = $v.originLabel;
      _complianceNote = $v.complianceNote;
      _vendorName = $v.vendorName;
      _downloads = $v.downloads;
      _lastDownloadAt = $v.lastDownloadAt;
      _uploadedAt = $v.uploadedAt;
      _download = $v.download?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(InvoiceLogRow other) {
    _$v = other as _$InvoiceLogRow;
  }

  @override
  void update(void Function(InvoiceLogRowBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  InvoiceLogRow build() => _build();

  _$InvoiceLogRow _build() {
    _$InvoiceLogRow _$result;
    try {
      _$result = _$v ??
          _$InvoiceLogRow._(
            id: id,
            orderId: orderId,
            orderReference: orderReference,
            orderState: orderState,
            paymentState: paymentState,
            acceptedAt: acceptedAt,
            openRequest: openRequest,
            note: note,
            kind: kind,
            state: state,
            details: details,
            serviceTargetAt: serviceTargetAt,
            serviceTargetLabel: serviceTargetLabel,
            overdue: overdue,
            invoiceType: invoiceType,
            issuer: issuer,
            invoiceNumber: invoiceNumber,
            issuedOn: issuedOn,
            amountCentavos: amountCentavos,
            reconciliationState: reconciliationState,
            reconciliationDifferenceCentavos: reconciliationDifferenceCentavos,
            originLabel: originLabel,
            complianceNote: complianceNote,
            vendorName: vendorName,
            downloads: downloads,
            lastDownloadAt: lastDownloadAt,
            uploadedAt: uploadedAt,
            download: _download?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'download';
        _download?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'InvoiceLogRow', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
