// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'catalog_media.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const CatalogMediaStatusEnum _$catalogMediaStatusEnum_READY =
    const CatalogMediaStatusEnum._('READY');
const CatalogMediaStatusEnum _$catalogMediaStatusEnum_REPLACED =
    const CatalogMediaStatusEnum._('REPLACED');
const CatalogMediaStatusEnum _$catalogMediaStatusEnum_REMOVED =
    const CatalogMediaStatusEnum._('REMOVED');

CatalogMediaStatusEnum _$catalogMediaStatusEnumValueOf(String name) {
  switch (name) {
    case 'READY':
      return _$catalogMediaStatusEnum_READY;
    case 'REPLACED':
      return _$catalogMediaStatusEnum_REPLACED;
    case 'REMOVED':
      return _$catalogMediaStatusEnum_REMOVED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<CatalogMediaStatusEnum> _$catalogMediaStatusEnumValues =
    BuiltSet<CatalogMediaStatusEnum>(const <CatalogMediaStatusEnum>[
  _$catalogMediaStatusEnum_READY,
  _$catalogMediaStatusEnum_REPLACED,
  _$catalogMediaStatusEnum_REMOVED,
]);

Serializer<CatalogMediaStatusEnum> _$catalogMediaStatusEnumSerializer =
    _$CatalogMediaStatusEnumSerializer();

class _$CatalogMediaStatusEnumSerializer
    implements PrimitiveSerializer<CatalogMediaStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'READY': 'READY',
    'REPLACED': 'REPLACED',
    'REMOVED': 'REMOVED',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'READY': 'READY',
    'REPLACED': 'REPLACED',
    'REMOVED': 'REMOVED',
  };

  @override
  final Iterable<Type> types = const <Type>[CatalogMediaStatusEnum];
  @override
  final String wireName = 'CatalogMediaStatusEnum';

  @override
  Object serialize(Serializers serializers, CatalogMediaStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  CatalogMediaStatusEnum deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      CatalogMediaStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$CatalogMedia extends CatalogMedia {
  @override
  final String id;
  @override
  final String fileId;
  @override
  final String? altText;
  @override
  final CatalogMediaStatusEnum status;
  @override
  final int version;
  @override
  final String? replacesMediaId;
  @override
  final String contentType;
  @override
  final int byteSize;
  @override
  final String scanState;
  @override
  final String? uploadedAt;

  factory _$CatalogMedia([void Function(CatalogMediaBuilder)? updates]) =>
      (CatalogMediaBuilder()..update(updates))._build();

  _$CatalogMedia._(
      {required this.id,
      required this.fileId,
      this.altText,
      required this.status,
      required this.version,
      this.replacesMediaId,
      required this.contentType,
      required this.byteSize,
      required this.scanState,
      this.uploadedAt})
      : super._();
  @override
  CatalogMedia rebuild(void Function(CatalogMediaBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CatalogMediaBuilder toBuilder() => CatalogMediaBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CatalogMedia &&
        id == other.id &&
        fileId == other.fileId &&
        altText == other.altText &&
        status == other.status &&
        version == other.version &&
        replacesMediaId == other.replacesMediaId &&
        contentType == other.contentType &&
        byteSize == other.byteSize &&
        scanState == other.scanState &&
        uploadedAt == other.uploadedAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, fileId.hashCode);
    _$hash = $jc(_$hash, altText.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, version.hashCode);
    _$hash = $jc(_$hash, replacesMediaId.hashCode);
    _$hash = $jc(_$hash, contentType.hashCode);
    _$hash = $jc(_$hash, byteSize.hashCode);
    _$hash = $jc(_$hash, scanState.hashCode);
    _$hash = $jc(_$hash, uploadedAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CatalogMedia')
          ..add('id', id)
          ..add('fileId', fileId)
          ..add('altText', altText)
          ..add('status', status)
          ..add('version', version)
          ..add('replacesMediaId', replacesMediaId)
          ..add('contentType', contentType)
          ..add('byteSize', byteSize)
          ..add('scanState', scanState)
          ..add('uploadedAt', uploadedAt))
        .toString();
  }
}

class CatalogMediaBuilder
    implements Builder<CatalogMedia, CatalogMediaBuilder> {
  _$CatalogMedia? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _fileId;
  String? get fileId => _$this._fileId;
  set fileId(String? fileId) => _$this._fileId = fileId;

  String? _altText;
  String? get altText => _$this._altText;
  set altText(String? altText) => _$this._altText = altText;

  CatalogMediaStatusEnum? _status;
  CatalogMediaStatusEnum? get status => _$this._status;
  set status(CatalogMediaStatusEnum? status) => _$this._status = status;

  int? _version;
  int? get version => _$this._version;
  set version(int? version) => _$this._version = version;

  String? _replacesMediaId;
  String? get replacesMediaId => _$this._replacesMediaId;
  set replacesMediaId(String? replacesMediaId) =>
      _$this._replacesMediaId = replacesMediaId;

  String? _contentType;
  String? get contentType => _$this._contentType;
  set contentType(String? contentType) => _$this._contentType = contentType;

  int? _byteSize;
  int? get byteSize => _$this._byteSize;
  set byteSize(int? byteSize) => _$this._byteSize = byteSize;

  String? _scanState;
  String? get scanState => _$this._scanState;
  set scanState(String? scanState) => _$this._scanState = scanState;

  String? _uploadedAt;
  String? get uploadedAt => _$this._uploadedAt;
  set uploadedAt(String? uploadedAt) => _$this._uploadedAt = uploadedAt;

  CatalogMediaBuilder() {
    CatalogMedia._defaults(this);
  }

  CatalogMediaBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _fileId = $v.fileId;
      _altText = $v.altText;
      _status = $v.status;
      _version = $v.version;
      _replacesMediaId = $v.replacesMediaId;
      _contentType = $v.contentType;
      _byteSize = $v.byteSize;
      _scanState = $v.scanState;
      _uploadedAt = $v.uploadedAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CatalogMedia other) {
    _$v = other as _$CatalogMedia;
  }

  @override
  void update(void Function(CatalogMediaBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CatalogMedia build() => _build();

  _$CatalogMedia _build() {
    final _$result = _$v ??
        _$CatalogMedia._(
          id: BuiltValueNullFieldError.checkNotNull(id, r'CatalogMedia', 'id'),
          fileId: BuiltValueNullFieldError.checkNotNull(
              fileId, r'CatalogMedia', 'fileId'),
          altText: altText,
          status: BuiltValueNullFieldError.checkNotNull(
              status, r'CatalogMedia', 'status'),
          version: BuiltValueNullFieldError.checkNotNull(
              version, r'CatalogMedia', 'version'),
          replacesMediaId: replacesMediaId,
          contentType: BuiltValueNullFieldError.checkNotNull(
              contentType, r'CatalogMedia', 'contentType'),
          byteSize: BuiltValueNullFieldError.checkNotNull(
              byteSize, r'CatalogMedia', 'byteSize'),
          scanState: BuiltValueNullFieldError.checkNotNull(
              scanState, r'CatalogMedia', 'scanState'),
          uploadedAt: uploadedAt,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
