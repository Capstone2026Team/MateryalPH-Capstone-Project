// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_document.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$VendorDocument extends VendorDocument {
  @override
  final String? reviewReason;
  @override
  final String? verifiedReference;
  @override
  final String? verifiedIssuedOn;
  @override
  final String? verifiedExpiresOn;
  @override
  final bool verifiedExpiryNotApplicable;
  @override
  final String id;
  @override
  final String documentType;
  @override
  final String status;
  @override
  final int version;
  @override
  final String environment;
  @override
  final String evidenceOrigin;
  @override
  final String scanState;
  @override
  final String createdAt;

  factory _$VendorDocument([void Function(VendorDocumentBuilder)? updates]) =>
      (VendorDocumentBuilder()..update(updates))._build();

  _$VendorDocument._(
      {this.reviewReason,
      this.verifiedReference,
      this.verifiedIssuedOn,
      this.verifiedExpiresOn,
      required this.verifiedExpiryNotApplicable,
      required this.id,
      required this.documentType,
      required this.status,
      required this.version,
      required this.environment,
      required this.evidenceOrigin,
      required this.scanState,
      required this.createdAt})
      : super._();
  @override
  VendorDocument rebuild(void Function(VendorDocumentBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  VendorDocumentBuilder toBuilder() => VendorDocumentBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is VendorDocument &&
        reviewReason == other.reviewReason &&
        verifiedReference == other.verifiedReference &&
        verifiedIssuedOn == other.verifiedIssuedOn &&
        verifiedExpiresOn == other.verifiedExpiresOn &&
        verifiedExpiryNotApplicable == other.verifiedExpiryNotApplicable &&
        id == other.id &&
        documentType == other.documentType &&
        status == other.status &&
        version == other.version &&
        environment == other.environment &&
        evidenceOrigin == other.evidenceOrigin &&
        scanState == other.scanState &&
        createdAt == other.createdAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, reviewReason.hashCode);
    _$hash = $jc(_$hash, verifiedReference.hashCode);
    _$hash = $jc(_$hash, verifiedIssuedOn.hashCode);
    _$hash = $jc(_$hash, verifiedExpiresOn.hashCode);
    _$hash = $jc(_$hash, verifiedExpiryNotApplicable.hashCode);
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, documentType.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, version.hashCode);
    _$hash = $jc(_$hash, environment.hashCode);
    _$hash = $jc(_$hash, evidenceOrigin.hashCode);
    _$hash = $jc(_$hash, scanState.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'VendorDocument')
          ..add('reviewReason', reviewReason)
          ..add('verifiedReference', verifiedReference)
          ..add('verifiedIssuedOn', verifiedIssuedOn)
          ..add('verifiedExpiresOn', verifiedExpiresOn)
          ..add('verifiedExpiryNotApplicable', verifiedExpiryNotApplicable)
          ..add('id', id)
          ..add('documentType', documentType)
          ..add('status', status)
          ..add('version', version)
          ..add('environment', environment)
          ..add('evidenceOrigin', evidenceOrigin)
          ..add('scanState', scanState)
          ..add('createdAt', createdAt))
        .toString();
  }
}

class VendorDocumentBuilder
    implements Builder<VendorDocument, VendorDocumentBuilder> {
  _$VendorDocument? _$v;

  String? _reviewReason;
  String? get reviewReason => _$this._reviewReason;
  set reviewReason(String? reviewReason) => _$this._reviewReason = reviewReason;

  String? _verifiedReference;
  String? get verifiedReference => _$this._verifiedReference;
  set verifiedReference(String? verifiedReference) =>
      _$this._verifiedReference = verifiedReference;

  String? _verifiedIssuedOn;
  String? get verifiedIssuedOn => _$this._verifiedIssuedOn;
  set verifiedIssuedOn(String? verifiedIssuedOn) =>
      _$this._verifiedIssuedOn = verifiedIssuedOn;

  String? _verifiedExpiresOn;
  String? get verifiedExpiresOn => _$this._verifiedExpiresOn;
  set verifiedExpiresOn(String? verifiedExpiresOn) =>
      _$this._verifiedExpiresOn = verifiedExpiresOn;

  bool? _verifiedExpiryNotApplicable;
  bool? get verifiedExpiryNotApplicable => _$this._verifiedExpiryNotApplicable;
  set verifiedExpiryNotApplicable(bool? verifiedExpiryNotApplicable) =>
      _$this._verifiedExpiryNotApplicable = verifiedExpiryNotApplicable;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _documentType;
  String? get documentType => _$this._documentType;
  set documentType(String? documentType) => _$this._documentType = documentType;

  String? _status;
  String? get status => _$this._status;
  set status(String? status) => _$this._status = status;

  int? _version;
  int? get version => _$this._version;
  set version(int? version) => _$this._version = version;

  String? _environment;
  String? get environment => _$this._environment;
  set environment(String? environment) => _$this._environment = environment;

  String? _evidenceOrigin;
  String? get evidenceOrigin => _$this._evidenceOrigin;
  set evidenceOrigin(String? evidenceOrigin) =>
      _$this._evidenceOrigin = evidenceOrigin;

  String? _scanState;
  String? get scanState => _$this._scanState;
  set scanState(String? scanState) => _$this._scanState = scanState;

  String? _createdAt;
  String? get createdAt => _$this._createdAt;
  set createdAt(String? createdAt) => _$this._createdAt = createdAt;

  VendorDocumentBuilder() {
    VendorDocument._defaults(this);
  }

  VendorDocumentBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _reviewReason = $v.reviewReason;
      _verifiedReference = $v.verifiedReference;
      _verifiedIssuedOn = $v.verifiedIssuedOn;
      _verifiedExpiresOn = $v.verifiedExpiresOn;
      _verifiedExpiryNotApplicable = $v.verifiedExpiryNotApplicable;
      _id = $v.id;
      _documentType = $v.documentType;
      _status = $v.status;
      _version = $v.version;
      _environment = $v.environment;
      _evidenceOrigin = $v.evidenceOrigin;
      _scanState = $v.scanState;
      _createdAt = $v.createdAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(VendorDocument other) {
    _$v = other as _$VendorDocument;
  }

  @override
  void update(void Function(VendorDocumentBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  VendorDocument build() => _build();

  _$VendorDocument _build() {
    final _$result = _$v ??
        _$VendorDocument._(
          reviewReason: reviewReason,
          verifiedReference: verifiedReference,
          verifiedIssuedOn: verifiedIssuedOn,
          verifiedExpiresOn: verifiedExpiresOn,
          verifiedExpiryNotApplicable: BuiltValueNullFieldError.checkNotNull(
              verifiedExpiryNotApplicable,
              r'VendorDocument',
              'verifiedExpiryNotApplicable'),
          id: BuiltValueNullFieldError.checkNotNull(
              id, r'VendorDocument', 'id'),
          documentType: BuiltValueNullFieldError.checkNotNull(
              documentType, r'VendorDocument', 'documentType'),
          status: BuiltValueNullFieldError.checkNotNull(
              status, r'VendorDocument', 'status'),
          version: BuiltValueNullFieldError.checkNotNull(
              version, r'VendorDocument', 'version'),
          environment: BuiltValueNullFieldError.checkNotNull(
              environment, r'VendorDocument', 'environment'),
          evidenceOrigin: BuiltValueNullFieldError.checkNotNull(
              evidenceOrigin, r'VendorDocument', 'evidenceOrigin'),
          scanState: BuiltValueNullFieldError.checkNotNull(
              scanState, r'VendorDocument', 'scanState'),
          createdAt: BuiltValueNullFieldError.checkNotNull(
              createdAt, r'VendorDocument', 'createdAt'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
