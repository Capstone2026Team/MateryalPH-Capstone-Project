// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_document_upload.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$VendorDocumentUpload extends VendorDocumentUpload {
  @override
  final String id;
  @override
  final String documentId;
  @override
  final int version;
  @override
  final String scanState;
  @override
  final String environment;

  factory _$VendorDocumentUpload(
          [void Function(VendorDocumentUploadBuilder)? updates]) =>
      (VendorDocumentUploadBuilder()..update(updates))._build();

  _$VendorDocumentUpload._(
      {required this.id,
      required this.documentId,
      required this.version,
      required this.scanState,
      required this.environment})
      : super._();
  @override
  VendorDocumentUpload rebuild(
          void Function(VendorDocumentUploadBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  VendorDocumentUploadBuilder toBuilder() =>
      VendorDocumentUploadBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is VendorDocumentUpload &&
        id == other.id &&
        documentId == other.documentId &&
        version == other.version &&
        scanState == other.scanState &&
        environment == other.environment;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, documentId.hashCode);
    _$hash = $jc(_$hash, version.hashCode);
    _$hash = $jc(_$hash, scanState.hashCode);
    _$hash = $jc(_$hash, environment.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'VendorDocumentUpload')
          ..add('id', id)
          ..add('documentId', documentId)
          ..add('version', version)
          ..add('scanState', scanState)
          ..add('environment', environment))
        .toString();
  }
}

class VendorDocumentUploadBuilder
    implements Builder<VendorDocumentUpload, VendorDocumentUploadBuilder> {
  _$VendorDocumentUpload? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _documentId;
  String? get documentId => _$this._documentId;
  set documentId(String? documentId) => _$this._documentId = documentId;

  int? _version;
  int? get version => _$this._version;
  set version(int? version) => _$this._version = version;

  String? _scanState;
  String? get scanState => _$this._scanState;
  set scanState(String? scanState) => _$this._scanState = scanState;

  String? _environment;
  String? get environment => _$this._environment;
  set environment(String? environment) => _$this._environment = environment;

  VendorDocumentUploadBuilder() {
    VendorDocumentUpload._defaults(this);
  }

  VendorDocumentUploadBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _documentId = $v.documentId;
      _version = $v.version;
      _scanState = $v.scanState;
      _environment = $v.environment;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(VendorDocumentUpload other) {
    _$v = other as _$VendorDocumentUpload;
  }

  @override
  void update(void Function(VendorDocumentUploadBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  VendorDocumentUpload build() => _build();

  _$VendorDocumentUpload _build() {
    final _$result = _$v ??
        _$VendorDocumentUpload._(
          id: BuiltValueNullFieldError.checkNotNull(
              id, r'VendorDocumentUpload', 'id'),
          documentId: BuiltValueNullFieldError.checkNotNull(
              documentId, r'VendorDocumentUpload', 'documentId'),
          version: BuiltValueNullFieldError.checkNotNull(
              version, r'VendorDocumentUpload', 'version'),
          scanState: BuiltValueNullFieldError.checkNotNull(
              scanState, r'VendorDocumentUpload', 'scanState'),
          environment: BuiltValueNullFieldError.checkNotNull(
              environment, r'VendorDocumentUpload', 'environment'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
