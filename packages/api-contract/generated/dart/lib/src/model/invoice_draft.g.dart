// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'invoice_draft.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const InvoiceDraftInvoiceTypeEnum
    _$invoiceDraftInvoiceTypeEnum_VENDOR_GOODS_INVOICE =
    const InvoiceDraftInvoiceTypeEnum._('VENDOR_GOODS_INVOICE');
const InvoiceDraftInvoiceTypeEnum
    _$invoiceDraftInvoiceTypeEnum_VENDOR_ADJUSTMENT_DOCUMENT =
    const InvoiceDraftInvoiceTypeEnum._('VENDOR_ADJUSTMENT_DOCUMENT');

InvoiceDraftInvoiceTypeEnum _$invoiceDraftInvoiceTypeEnumValueOf(String name) {
  switch (name) {
    case 'VENDOR_GOODS_INVOICE':
      return _$invoiceDraftInvoiceTypeEnum_VENDOR_GOODS_INVOICE;
    case 'VENDOR_ADJUSTMENT_DOCUMENT':
      return _$invoiceDraftInvoiceTypeEnum_VENDOR_ADJUSTMENT_DOCUMENT;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<InvoiceDraftInvoiceTypeEnum>
    _$invoiceDraftInvoiceTypeEnumValues =
    BuiltSet<InvoiceDraftInvoiceTypeEnum>(const <InvoiceDraftInvoiceTypeEnum>[
  _$invoiceDraftInvoiceTypeEnum_VENDOR_GOODS_INVOICE,
  _$invoiceDraftInvoiceTypeEnum_VENDOR_ADJUSTMENT_DOCUMENT,
]);

const InvoiceDraftSourceSystemEnum
    _$invoiceDraftSourceSystemEnum_REGISTERED_CAS =
    const InvoiceDraftSourceSystemEnum._('REGISTERED_CAS');
const InvoiceDraftSourceSystemEnum _$invoiceDraftSourceSystemEnum_BIR_EIS =
    const InvoiceDraftSourceSystemEnum._('BIR_EIS');
const InvoiceDraftSourceSystemEnum
    _$invoiceDraftSourceSystemEnum_LOOSE_LEAF_OR_PRINTED =
    const InvoiceDraftSourceSystemEnum._('LOOSE_LEAF_OR_PRINTED');
const InvoiceDraftSourceSystemEnum
    _$invoiceDraftSourceSystemEnum_OTHER_REGISTERED =
    const InvoiceDraftSourceSystemEnum._('OTHER_REGISTERED');

InvoiceDraftSourceSystemEnum _$invoiceDraftSourceSystemEnumValueOf(
    String name) {
  switch (name) {
    case 'REGISTERED_CAS':
      return _$invoiceDraftSourceSystemEnum_REGISTERED_CAS;
    case 'BIR_EIS':
      return _$invoiceDraftSourceSystemEnum_BIR_EIS;
    case 'LOOSE_LEAF_OR_PRINTED':
      return _$invoiceDraftSourceSystemEnum_LOOSE_LEAF_OR_PRINTED;
    case 'OTHER_REGISTERED':
      return _$invoiceDraftSourceSystemEnum_OTHER_REGISTERED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<InvoiceDraftSourceSystemEnum>
    _$invoiceDraftSourceSystemEnumValues =
    BuiltSet<InvoiceDraftSourceSystemEnum>(const <InvoiceDraftSourceSystemEnum>[
  _$invoiceDraftSourceSystemEnum_REGISTERED_CAS,
  _$invoiceDraftSourceSystemEnum_BIR_EIS,
  _$invoiceDraftSourceSystemEnum_LOOSE_LEAF_OR_PRINTED,
  _$invoiceDraftSourceSystemEnum_OTHER_REGISTERED,
]);

const InvoiceDraftInvoicingMethodEnum
    _$invoiceDraftInvoicingMethodEnum_ELECTRONIC =
    const InvoiceDraftInvoicingMethodEnum._('ELECTRONIC');
const InvoiceDraftInvoicingMethodEnum
    _$invoiceDraftInvoicingMethodEnum_COMPUTERIZED =
    const InvoiceDraftInvoicingMethodEnum._('COMPUTERIZED');
const InvoiceDraftInvoicingMethodEnum _$invoiceDraftInvoicingMethodEnum_MANUAL =
    const InvoiceDraftInvoicingMethodEnum._('MANUAL');

InvoiceDraftInvoicingMethodEnum _$invoiceDraftInvoicingMethodEnumValueOf(
    String name) {
  switch (name) {
    case 'ELECTRONIC':
      return _$invoiceDraftInvoicingMethodEnum_ELECTRONIC;
    case 'COMPUTERIZED':
      return _$invoiceDraftInvoicingMethodEnum_COMPUTERIZED;
    case 'MANUAL':
      return _$invoiceDraftInvoicingMethodEnum_MANUAL;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<InvoiceDraftInvoicingMethodEnum>
    _$invoiceDraftInvoicingMethodEnumValues = BuiltSet<
        InvoiceDraftInvoicingMethodEnum>(const <InvoiceDraftInvoicingMethodEnum>[
  _$invoiceDraftInvoicingMethodEnum_ELECTRONIC,
  _$invoiceDraftInvoicingMethodEnum_COMPUTERIZED,
  _$invoiceDraftInvoicingMethodEnum_MANUAL,
]);

Serializer<InvoiceDraftInvoiceTypeEnum>
    _$invoiceDraftInvoiceTypeEnumSerializer =
    _$InvoiceDraftInvoiceTypeEnumSerializer();
Serializer<InvoiceDraftSourceSystemEnum>
    _$invoiceDraftSourceSystemEnumSerializer =
    _$InvoiceDraftSourceSystemEnumSerializer();
Serializer<InvoiceDraftInvoicingMethodEnum>
    _$invoiceDraftInvoicingMethodEnumSerializer =
    _$InvoiceDraftInvoicingMethodEnumSerializer();

class _$InvoiceDraftInvoiceTypeEnumSerializer
    implements PrimitiveSerializer<InvoiceDraftInvoiceTypeEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'VENDOR_GOODS_INVOICE': 'VENDOR_GOODS_INVOICE',
    'VENDOR_ADJUSTMENT_DOCUMENT': 'VENDOR_ADJUSTMENT_DOCUMENT',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'VENDOR_GOODS_INVOICE': 'VENDOR_GOODS_INVOICE',
    'VENDOR_ADJUSTMENT_DOCUMENT': 'VENDOR_ADJUSTMENT_DOCUMENT',
  };

  @override
  final Iterable<Type> types = const <Type>[InvoiceDraftInvoiceTypeEnum];
  @override
  final String wireName = 'InvoiceDraftInvoiceTypeEnum';

  @override
  Object serialize(Serializers serializers, InvoiceDraftInvoiceTypeEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  InvoiceDraftInvoiceTypeEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      InvoiceDraftInvoiceTypeEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$InvoiceDraftSourceSystemEnumSerializer
    implements PrimitiveSerializer<InvoiceDraftSourceSystemEnum> {
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
  final Iterable<Type> types = const <Type>[InvoiceDraftSourceSystemEnum];
  @override
  final String wireName = 'InvoiceDraftSourceSystemEnum';

  @override
  Object serialize(Serializers serializers, InvoiceDraftSourceSystemEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  InvoiceDraftSourceSystemEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      InvoiceDraftSourceSystemEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$InvoiceDraftInvoicingMethodEnumSerializer
    implements PrimitiveSerializer<InvoiceDraftInvoicingMethodEnum> {
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
  final Iterable<Type> types = const <Type>[InvoiceDraftInvoicingMethodEnum];
  @override
  final String wireName = 'InvoiceDraftInvoicingMethodEnum';

  @override
  Object serialize(
          Serializers serializers, InvoiceDraftInvoicingMethodEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  InvoiceDraftInvoicingMethodEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      InvoiceDraftInvoicingMethodEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$InvoiceDraft extends InvoiceDraft {
  @override
  final InvoiceDraftInvoiceTypeEnum invoiceType;
  @override
  final String issuerName;
  @override
  final String invoiceNumber;
  @override
  final Date issuedOn;
  @override
  final int amountCentavos;
  @override
  final int? vatCentavos;
  @override
  final int? vatExemptCentavos;
  @override
  final int? zeroRatedCentavos;
  @override
  final BuiltList<String>? relatedLineIds;
  @override
  final InvoiceDraftSourceSystemEnum sourceSystem;
  @override
  final InvoiceDraftInvoicingMethodEnum invoicingMethod;
  @override
  final String? amendsInvoiceRecordId;
  @override
  final String? invoiceRequestId;
  @override
  final int lockVersion;
  @override
  final String id;
  @override
  final String? sentRecordId;
  @override
  final DateTime? sentAt;
  @override
  final DateTime? updatedAt;
  @override
  final String? fileName;
  @override
  final String? contentType;
  @override
  final int? fileSizeBytes;
  @override
  final DisputeFileLink download;

  factory _$InvoiceDraft([void Function(InvoiceDraftBuilder)? updates]) =>
      (InvoiceDraftBuilder()..update(updates))._build();

  _$InvoiceDraft._(
      {required this.invoiceType,
      required this.issuerName,
      required this.invoiceNumber,
      required this.issuedOn,
      required this.amountCentavos,
      this.vatCentavos,
      this.vatExemptCentavos,
      this.zeroRatedCentavos,
      this.relatedLineIds,
      required this.sourceSystem,
      required this.invoicingMethod,
      this.amendsInvoiceRecordId,
      this.invoiceRequestId,
      required this.lockVersion,
      required this.id,
      this.sentRecordId,
      this.sentAt,
      this.updatedAt,
      this.fileName,
      this.contentType,
      this.fileSizeBytes,
      required this.download})
      : super._();
  @override
  InvoiceDraft rebuild(void Function(InvoiceDraftBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  InvoiceDraftBuilder toBuilder() => InvoiceDraftBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is InvoiceDraft &&
        invoiceType == other.invoiceType &&
        issuerName == other.issuerName &&
        invoiceNumber == other.invoiceNumber &&
        issuedOn == other.issuedOn &&
        amountCentavos == other.amountCentavos &&
        vatCentavos == other.vatCentavos &&
        vatExemptCentavos == other.vatExemptCentavos &&
        zeroRatedCentavos == other.zeroRatedCentavos &&
        relatedLineIds == other.relatedLineIds &&
        sourceSystem == other.sourceSystem &&
        invoicingMethod == other.invoicingMethod &&
        amendsInvoiceRecordId == other.amendsInvoiceRecordId &&
        invoiceRequestId == other.invoiceRequestId &&
        lockVersion == other.lockVersion &&
        id == other.id &&
        sentRecordId == other.sentRecordId &&
        sentAt == other.sentAt &&
        updatedAt == other.updatedAt &&
        fileName == other.fileName &&
        contentType == other.contentType &&
        fileSizeBytes == other.fileSizeBytes &&
        download == other.download;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, invoiceType.hashCode);
    _$hash = $jc(_$hash, issuerName.hashCode);
    _$hash = $jc(_$hash, invoiceNumber.hashCode);
    _$hash = $jc(_$hash, issuedOn.hashCode);
    _$hash = $jc(_$hash, amountCentavos.hashCode);
    _$hash = $jc(_$hash, vatCentavos.hashCode);
    _$hash = $jc(_$hash, vatExemptCentavos.hashCode);
    _$hash = $jc(_$hash, zeroRatedCentavos.hashCode);
    _$hash = $jc(_$hash, relatedLineIds.hashCode);
    _$hash = $jc(_$hash, sourceSystem.hashCode);
    _$hash = $jc(_$hash, invoicingMethod.hashCode);
    _$hash = $jc(_$hash, amendsInvoiceRecordId.hashCode);
    _$hash = $jc(_$hash, invoiceRequestId.hashCode);
    _$hash = $jc(_$hash, lockVersion.hashCode);
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, sentRecordId.hashCode);
    _$hash = $jc(_$hash, sentAt.hashCode);
    _$hash = $jc(_$hash, updatedAt.hashCode);
    _$hash = $jc(_$hash, fileName.hashCode);
    _$hash = $jc(_$hash, contentType.hashCode);
    _$hash = $jc(_$hash, fileSizeBytes.hashCode);
    _$hash = $jc(_$hash, download.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'InvoiceDraft')
          ..add('invoiceType', invoiceType)
          ..add('issuerName', issuerName)
          ..add('invoiceNumber', invoiceNumber)
          ..add('issuedOn', issuedOn)
          ..add('amountCentavos', amountCentavos)
          ..add('vatCentavos', vatCentavos)
          ..add('vatExemptCentavos', vatExemptCentavos)
          ..add('zeroRatedCentavos', zeroRatedCentavos)
          ..add('relatedLineIds', relatedLineIds)
          ..add('sourceSystem', sourceSystem)
          ..add('invoicingMethod', invoicingMethod)
          ..add('amendsInvoiceRecordId', amendsInvoiceRecordId)
          ..add('invoiceRequestId', invoiceRequestId)
          ..add('lockVersion', lockVersion)
          ..add('id', id)
          ..add('sentRecordId', sentRecordId)
          ..add('sentAt', sentAt)
          ..add('updatedAt', updatedAt)
          ..add('fileName', fileName)
          ..add('contentType', contentType)
          ..add('fileSizeBytes', fileSizeBytes)
          ..add('download', download))
        .toString();
  }
}

class InvoiceDraftBuilder
    implements Builder<InvoiceDraft, InvoiceDraftBuilder> {
  _$InvoiceDraft? _$v;

  InvoiceDraftInvoiceTypeEnum? _invoiceType;
  InvoiceDraftInvoiceTypeEnum? get invoiceType => _$this._invoiceType;
  set invoiceType(InvoiceDraftInvoiceTypeEnum? invoiceType) =>
      _$this._invoiceType = invoiceType;

  String? _issuerName;
  String? get issuerName => _$this._issuerName;
  set issuerName(String? issuerName) => _$this._issuerName = issuerName;

  String? _invoiceNumber;
  String? get invoiceNumber => _$this._invoiceNumber;
  set invoiceNumber(String? invoiceNumber) =>
      _$this._invoiceNumber = invoiceNumber;

  Date? _issuedOn;
  Date? get issuedOn => _$this._issuedOn;
  set issuedOn(Date? issuedOn) => _$this._issuedOn = issuedOn;

  int? _amountCentavos;
  int? get amountCentavos => _$this._amountCentavos;
  set amountCentavos(int? amountCentavos) =>
      _$this._amountCentavos = amountCentavos;

  int? _vatCentavos;
  int? get vatCentavos => _$this._vatCentavos;
  set vatCentavos(int? vatCentavos) => _$this._vatCentavos = vatCentavos;

  int? _vatExemptCentavos;
  int? get vatExemptCentavos => _$this._vatExemptCentavos;
  set vatExemptCentavos(int? vatExemptCentavos) =>
      _$this._vatExemptCentavos = vatExemptCentavos;

  int? _zeroRatedCentavos;
  int? get zeroRatedCentavos => _$this._zeroRatedCentavos;
  set zeroRatedCentavos(int? zeroRatedCentavos) =>
      _$this._zeroRatedCentavos = zeroRatedCentavos;

  ListBuilder<String>? _relatedLineIds;
  ListBuilder<String> get relatedLineIds =>
      _$this._relatedLineIds ??= ListBuilder<String>();
  set relatedLineIds(ListBuilder<String>? relatedLineIds) =>
      _$this._relatedLineIds = relatedLineIds;

  InvoiceDraftSourceSystemEnum? _sourceSystem;
  InvoiceDraftSourceSystemEnum? get sourceSystem => _$this._sourceSystem;
  set sourceSystem(InvoiceDraftSourceSystemEnum? sourceSystem) =>
      _$this._sourceSystem = sourceSystem;

  InvoiceDraftInvoicingMethodEnum? _invoicingMethod;
  InvoiceDraftInvoicingMethodEnum? get invoicingMethod =>
      _$this._invoicingMethod;
  set invoicingMethod(InvoiceDraftInvoicingMethodEnum? invoicingMethod) =>
      _$this._invoicingMethod = invoicingMethod;

  String? _amendsInvoiceRecordId;
  String? get amendsInvoiceRecordId => _$this._amendsInvoiceRecordId;
  set amendsInvoiceRecordId(String? amendsInvoiceRecordId) =>
      _$this._amendsInvoiceRecordId = amendsInvoiceRecordId;

  String? _invoiceRequestId;
  String? get invoiceRequestId => _$this._invoiceRequestId;
  set invoiceRequestId(String? invoiceRequestId) =>
      _$this._invoiceRequestId = invoiceRequestId;

  int? _lockVersion;
  int? get lockVersion => _$this._lockVersion;
  set lockVersion(int? lockVersion) => _$this._lockVersion = lockVersion;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _sentRecordId;
  String? get sentRecordId => _$this._sentRecordId;
  set sentRecordId(String? sentRecordId) => _$this._sentRecordId = sentRecordId;

  DateTime? _sentAt;
  DateTime? get sentAt => _$this._sentAt;
  set sentAt(DateTime? sentAt) => _$this._sentAt = sentAt;

  DateTime? _updatedAt;
  DateTime? get updatedAt => _$this._updatedAt;
  set updatedAt(DateTime? updatedAt) => _$this._updatedAt = updatedAt;

  String? _fileName;
  String? get fileName => _$this._fileName;
  set fileName(String? fileName) => _$this._fileName = fileName;

  String? _contentType;
  String? get contentType => _$this._contentType;
  set contentType(String? contentType) => _$this._contentType = contentType;

  int? _fileSizeBytes;
  int? get fileSizeBytes => _$this._fileSizeBytes;
  set fileSizeBytes(int? fileSizeBytes) =>
      _$this._fileSizeBytes = fileSizeBytes;

  DisputeFileLinkBuilder? _download;
  DisputeFileLinkBuilder get download =>
      _$this._download ??= DisputeFileLinkBuilder();
  set download(DisputeFileLinkBuilder? download) => _$this._download = download;

  InvoiceDraftBuilder() {
    InvoiceDraft._defaults(this);
  }

  InvoiceDraftBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _invoiceType = $v.invoiceType;
      _issuerName = $v.issuerName;
      _invoiceNumber = $v.invoiceNumber;
      _issuedOn = $v.issuedOn;
      _amountCentavos = $v.amountCentavos;
      _vatCentavos = $v.vatCentavos;
      _vatExemptCentavos = $v.vatExemptCentavos;
      _zeroRatedCentavos = $v.zeroRatedCentavos;
      _relatedLineIds = $v.relatedLineIds?.toBuilder();
      _sourceSystem = $v.sourceSystem;
      _invoicingMethod = $v.invoicingMethod;
      _amendsInvoiceRecordId = $v.amendsInvoiceRecordId;
      _invoiceRequestId = $v.invoiceRequestId;
      _lockVersion = $v.lockVersion;
      _id = $v.id;
      _sentRecordId = $v.sentRecordId;
      _sentAt = $v.sentAt;
      _updatedAt = $v.updatedAt;
      _fileName = $v.fileName;
      _contentType = $v.contentType;
      _fileSizeBytes = $v.fileSizeBytes;
      _download = $v.download.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(InvoiceDraft other) {
    _$v = other as _$InvoiceDraft;
  }

  @override
  void update(void Function(InvoiceDraftBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  InvoiceDraft build() => _build();

  _$InvoiceDraft _build() {
    _$InvoiceDraft _$result;
    try {
      _$result = _$v ??
          _$InvoiceDraft._(
            invoiceType: BuiltValueNullFieldError.checkNotNull(
                invoiceType, r'InvoiceDraft', 'invoiceType'),
            issuerName: BuiltValueNullFieldError.checkNotNull(
                issuerName, r'InvoiceDraft', 'issuerName'),
            invoiceNumber: BuiltValueNullFieldError.checkNotNull(
                invoiceNumber, r'InvoiceDraft', 'invoiceNumber'),
            issuedOn: BuiltValueNullFieldError.checkNotNull(
                issuedOn, r'InvoiceDraft', 'issuedOn'),
            amountCentavos: BuiltValueNullFieldError.checkNotNull(
                amountCentavos, r'InvoiceDraft', 'amountCentavos'),
            vatCentavos: vatCentavos,
            vatExemptCentavos: vatExemptCentavos,
            zeroRatedCentavos: zeroRatedCentavos,
            relatedLineIds: _relatedLineIds?.build(),
            sourceSystem: BuiltValueNullFieldError.checkNotNull(
                sourceSystem, r'InvoiceDraft', 'sourceSystem'),
            invoicingMethod: BuiltValueNullFieldError.checkNotNull(
                invoicingMethod, r'InvoiceDraft', 'invoicingMethod'),
            amendsInvoiceRecordId: amendsInvoiceRecordId,
            invoiceRequestId: invoiceRequestId,
            lockVersion: BuiltValueNullFieldError.checkNotNull(
                lockVersion, r'InvoiceDraft', 'lockVersion'),
            id: BuiltValueNullFieldError.checkNotNull(
                id, r'InvoiceDraft', 'id'),
            sentRecordId: sentRecordId,
            sentAt: sentAt,
            updatedAt: updatedAt,
            fileName: fileName,
            contentType: contentType,
            fileSizeBytes: fileSizeBytes,
            download: download.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'relatedLineIds';
        _relatedLineIds?.build();

        _$failedField = 'download';
        download.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'InvoiceDraft', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
