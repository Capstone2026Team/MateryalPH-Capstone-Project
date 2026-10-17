// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'document_export.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$DocumentExport extends DocumentExport {
  @override
  final String id;
  @override
  final String? resourceId;
  @override
  final String type;
  @override
  final String format;
  @override
  final String state;
  @override
  final String purpose;
  @override
  final BuiltMap<String, JsonObject?> filters;
  @override
  final String? sourceHash;
  @override
  final BuiltMap<String, JsonObject?> sourceVersions;
  @override
  final String? checksum;
  @override
  final String createdAt;
  @override
  final String? expiresAt;
  @override
  final String? failureCode;
  @override
  final BuiltList<ExportAccessRecord> accessRecord;

  factory _$DocumentExport([void Function(DocumentExportBuilder)? updates]) =>
      (DocumentExportBuilder()..update(updates))._build();

  _$DocumentExport._(
      {required this.id,
      this.resourceId,
      required this.type,
      required this.format,
      required this.state,
      required this.purpose,
      required this.filters,
      this.sourceHash,
      required this.sourceVersions,
      this.checksum,
      required this.createdAt,
      this.expiresAt,
      this.failureCode,
      required this.accessRecord})
      : super._();
  @override
  DocumentExport rebuild(void Function(DocumentExportBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DocumentExportBuilder toBuilder() => DocumentExportBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DocumentExport &&
        id == other.id &&
        resourceId == other.resourceId &&
        type == other.type &&
        format == other.format &&
        state == other.state &&
        purpose == other.purpose &&
        filters == other.filters &&
        sourceHash == other.sourceHash &&
        sourceVersions == other.sourceVersions &&
        checksum == other.checksum &&
        createdAt == other.createdAt &&
        expiresAt == other.expiresAt &&
        failureCode == other.failureCode &&
        accessRecord == other.accessRecord;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, resourceId.hashCode);
    _$hash = $jc(_$hash, type.hashCode);
    _$hash = $jc(_$hash, format.hashCode);
    _$hash = $jc(_$hash, state.hashCode);
    _$hash = $jc(_$hash, purpose.hashCode);
    _$hash = $jc(_$hash, filters.hashCode);
    _$hash = $jc(_$hash, sourceHash.hashCode);
    _$hash = $jc(_$hash, sourceVersions.hashCode);
    _$hash = $jc(_$hash, checksum.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, expiresAt.hashCode);
    _$hash = $jc(_$hash, failureCode.hashCode);
    _$hash = $jc(_$hash, accessRecord.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'DocumentExport')
          ..add('id', id)
          ..add('resourceId', resourceId)
          ..add('type', type)
          ..add('format', format)
          ..add('state', state)
          ..add('purpose', purpose)
          ..add('filters', filters)
          ..add('sourceHash', sourceHash)
          ..add('sourceVersions', sourceVersions)
          ..add('checksum', checksum)
          ..add('createdAt', createdAt)
          ..add('expiresAt', expiresAt)
          ..add('failureCode', failureCode)
          ..add('accessRecord', accessRecord))
        .toString();
  }
}

class DocumentExportBuilder
    implements Builder<DocumentExport, DocumentExportBuilder> {
  _$DocumentExport? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _resourceId;
  String? get resourceId => _$this._resourceId;
  set resourceId(String? resourceId) => _$this._resourceId = resourceId;

  String? _type;
  String? get type => _$this._type;
  set type(String? type) => _$this._type = type;

  String? _format;
  String? get format => _$this._format;
  set format(String? format) => _$this._format = format;

  String? _state;
  String? get state => _$this._state;
  set state(String? state) => _$this._state = state;

  String? _purpose;
  String? get purpose => _$this._purpose;
  set purpose(String? purpose) => _$this._purpose = purpose;

  MapBuilder<String, JsonObject?>? _filters;
  MapBuilder<String, JsonObject?> get filters =>
      _$this._filters ??= MapBuilder<String, JsonObject?>();
  set filters(MapBuilder<String, JsonObject?>? filters) =>
      _$this._filters = filters;

  String? _sourceHash;
  String? get sourceHash => _$this._sourceHash;
  set sourceHash(String? sourceHash) => _$this._sourceHash = sourceHash;

  MapBuilder<String, JsonObject?>? _sourceVersions;
  MapBuilder<String, JsonObject?> get sourceVersions =>
      _$this._sourceVersions ??= MapBuilder<String, JsonObject?>();
  set sourceVersions(MapBuilder<String, JsonObject?>? sourceVersions) =>
      _$this._sourceVersions = sourceVersions;

  String? _checksum;
  String? get checksum => _$this._checksum;
  set checksum(String? checksum) => _$this._checksum = checksum;

  String? _createdAt;
  String? get createdAt => _$this._createdAt;
  set createdAt(String? createdAt) => _$this._createdAt = createdAt;

  String? _expiresAt;
  String? get expiresAt => _$this._expiresAt;
  set expiresAt(String? expiresAt) => _$this._expiresAt = expiresAt;

  String? _failureCode;
  String? get failureCode => _$this._failureCode;
  set failureCode(String? failureCode) => _$this._failureCode = failureCode;

  ListBuilder<ExportAccessRecord>? _accessRecord;
  ListBuilder<ExportAccessRecord> get accessRecord =>
      _$this._accessRecord ??= ListBuilder<ExportAccessRecord>();
  set accessRecord(ListBuilder<ExportAccessRecord>? accessRecord) =>
      _$this._accessRecord = accessRecord;

  DocumentExportBuilder() {
    DocumentExport._defaults(this);
  }

  DocumentExportBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _resourceId = $v.resourceId;
      _type = $v.type;
      _format = $v.format;
      _state = $v.state;
      _purpose = $v.purpose;
      _filters = $v.filters.toBuilder();
      _sourceHash = $v.sourceHash;
      _sourceVersions = $v.sourceVersions.toBuilder();
      _checksum = $v.checksum;
      _createdAt = $v.createdAt;
      _expiresAt = $v.expiresAt;
      _failureCode = $v.failureCode;
      _accessRecord = $v.accessRecord.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DocumentExport other) {
    _$v = other as _$DocumentExport;
  }

  @override
  void update(void Function(DocumentExportBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DocumentExport build() => _build();

  _$DocumentExport _build() {
    _$DocumentExport _$result;
    try {
      _$result = _$v ??
          _$DocumentExport._(
            id: BuiltValueNullFieldError.checkNotNull(
                id, r'DocumentExport', 'id'),
            resourceId: resourceId,
            type: BuiltValueNullFieldError.checkNotNull(
                type, r'DocumentExport', 'type'),
            format: BuiltValueNullFieldError.checkNotNull(
                format, r'DocumentExport', 'format'),
            state: BuiltValueNullFieldError.checkNotNull(
                state, r'DocumentExport', 'state'),
            purpose: BuiltValueNullFieldError.checkNotNull(
                purpose, r'DocumentExport', 'purpose'),
            filters: filters.build(),
            sourceHash: sourceHash,
            sourceVersions: sourceVersions.build(),
            checksum: checksum,
            createdAt: BuiltValueNullFieldError.checkNotNull(
                createdAt, r'DocumentExport', 'createdAt'),
            expiresAt: expiresAt,
            failureCode: failureCode,
            accessRecord: accessRecord.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'filters';
        filters.build();

        _$failedField = 'sourceVersions';
        sourceVersions.build();

        _$failedField = 'accessRecord';
        accessRecord.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'DocumentExport', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
