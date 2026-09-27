// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'catalog_import_job.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const CatalogImportJobStatusEnum _$catalogImportJobStatusEnum_VALIDATED =
    const CatalogImportJobStatusEnum._('VALIDATED');
const CatalogImportJobStatusEnum _$catalogImportJobStatusEnum_HAS_ERRORS =
    const CatalogImportJobStatusEnum._('HAS_ERRORS');
const CatalogImportJobStatusEnum _$catalogImportJobStatusEnum_APPLIED =
    const CatalogImportJobStatusEnum._('APPLIED');
const CatalogImportJobStatusEnum
    _$catalogImportJobStatusEnum_APPLIED_WITH_REJECTIONS =
    const CatalogImportJobStatusEnum._('APPLIED_WITH_REJECTIONS');
const CatalogImportJobStatusEnum _$catalogImportJobStatusEnum_FAILED =
    const CatalogImportJobStatusEnum._('FAILED');

CatalogImportJobStatusEnum _$catalogImportJobStatusEnumValueOf(String name) {
  switch (name) {
    case 'VALIDATED':
      return _$catalogImportJobStatusEnum_VALIDATED;
    case 'HAS_ERRORS':
      return _$catalogImportJobStatusEnum_HAS_ERRORS;
    case 'APPLIED':
      return _$catalogImportJobStatusEnum_APPLIED;
    case 'APPLIED_WITH_REJECTIONS':
      return _$catalogImportJobStatusEnum_APPLIED_WITH_REJECTIONS;
    case 'FAILED':
      return _$catalogImportJobStatusEnum_FAILED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<CatalogImportJobStatusEnum> _$catalogImportJobStatusEnumValues =
    BuiltSet<CatalogImportJobStatusEnum>(const <CatalogImportJobStatusEnum>[
  _$catalogImportJobStatusEnum_VALIDATED,
  _$catalogImportJobStatusEnum_HAS_ERRORS,
  _$catalogImportJobStatusEnum_APPLIED,
  _$catalogImportJobStatusEnum_APPLIED_WITH_REJECTIONS,
  _$catalogImportJobStatusEnum_FAILED,
]);

Serializer<CatalogImportJobStatusEnum> _$catalogImportJobStatusEnumSerializer =
    _$CatalogImportJobStatusEnumSerializer();

class _$CatalogImportJobStatusEnumSerializer
    implements PrimitiveSerializer<CatalogImportJobStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'VALIDATED': 'VALIDATED',
    'HAS_ERRORS': 'HAS_ERRORS',
    'APPLIED': 'APPLIED',
    'APPLIED_WITH_REJECTIONS': 'APPLIED_WITH_REJECTIONS',
    'FAILED': 'FAILED',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'VALIDATED': 'VALIDATED',
    'HAS_ERRORS': 'HAS_ERRORS',
    'APPLIED': 'APPLIED',
    'APPLIED_WITH_REJECTIONS': 'APPLIED_WITH_REJECTIONS',
    'FAILED': 'FAILED',
  };

  @override
  final Iterable<Type> types = const <Type>[CatalogImportJobStatusEnum];
  @override
  final String wireName = 'CatalogImportJobStatusEnum';

  @override
  Object serialize(Serializers serializers, CatalogImportJobStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  CatalogImportJobStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      CatalogImportJobStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$CatalogImportJob extends CatalogImportJob {
  @override
  final String id;
  @override
  final CatalogImportJobStatusEnum status;
  @override
  final String templateVersion;
  @override
  final int totalRows;
  @override
  final int validRows;
  @override
  final int errorRows;
  @override
  final int appliedRows;
  @override
  final String? appliedAt;
  @override
  final String? createdAt;
  @override
  final BuiltList<CatalogImportRowError> rowErrors;
  @override
  final BuiltMap<String, JsonObject?> rowErrorsMeta;

  factory _$CatalogImportJob(
          [void Function(CatalogImportJobBuilder)? updates]) =>
      (CatalogImportJobBuilder()..update(updates))._build();

  _$CatalogImportJob._(
      {required this.id,
      required this.status,
      required this.templateVersion,
      required this.totalRows,
      required this.validRows,
      required this.errorRows,
      required this.appliedRows,
      this.appliedAt,
      this.createdAt,
      required this.rowErrors,
      required this.rowErrorsMeta})
      : super._();
  @override
  CatalogImportJob rebuild(void Function(CatalogImportJobBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CatalogImportJobBuilder toBuilder() =>
      CatalogImportJobBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CatalogImportJob &&
        id == other.id &&
        status == other.status &&
        templateVersion == other.templateVersion &&
        totalRows == other.totalRows &&
        validRows == other.validRows &&
        errorRows == other.errorRows &&
        appliedRows == other.appliedRows &&
        appliedAt == other.appliedAt &&
        createdAt == other.createdAt &&
        rowErrors == other.rowErrors &&
        rowErrorsMeta == other.rowErrorsMeta;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, templateVersion.hashCode);
    _$hash = $jc(_$hash, totalRows.hashCode);
    _$hash = $jc(_$hash, validRows.hashCode);
    _$hash = $jc(_$hash, errorRows.hashCode);
    _$hash = $jc(_$hash, appliedRows.hashCode);
    _$hash = $jc(_$hash, appliedAt.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, rowErrors.hashCode);
    _$hash = $jc(_$hash, rowErrorsMeta.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CatalogImportJob')
          ..add('id', id)
          ..add('status', status)
          ..add('templateVersion', templateVersion)
          ..add('totalRows', totalRows)
          ..add('validRows', validRows)
          ..add('errorRows', errorRows)
          ..add('appliedRows', appliedRows)
          ..add('appliedAt', appliedAt)
          ..add('createdAt', createdAt)
          ..add('rowErrors', rowErrors)
          ..add('rowErrorsMeta', rowErrorsMeta))
        .toString();
  }
}

class CatalogImportJobBuilder
    implements Builder<CatalogImportJob, CatalogImportJobBuilder> {
  _$CatalogImportJob? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  CatalogImportJobStatusEnum? _status;
  CatalogImportJobStatusEnum? get status => _$this._status;
  set status(CatalogImportJobStatusEnum? status) => _$this._status = status;

  String? _templateVersion;
  String? get templateVersion => _$this._templateVersion;
  set templateVersion(String? templateVersion) =>
      _$this._templateVersion = templateVersion;

  int? _totalRows;
  int? get totalRows => _$this._totalRows;
  set totalRows(int? totalRows) => _$this._totalRows = totalRows;

  int? _validRows;
  int? get validRows => _$this._validRows;
  set validRows(int? validRows) => _$this._validRows = validRows;

  int? _errorRows;
  int? get errorRows => _$this._errorRows;
  set errorRows(int? errorRows) => _$this._errorRows = errorRows;

  int? _appliedRows;
  int? get appliedRows => _$this._appliedRows;
  set appliedRows(int? appliedRows) => _$this._appliedRows = appliedRows;

  String? _appliedAt;
  String? get appliedAt => _$this._appliedAt;
  set appliedAt(String? appliedAt) => _$this._appliedAt = appliedAt;

  String? _createdAt;
  String? get createdAt => _$this._createdAt;
  set createdAt(String? createdAt) => _$this._createdAt = createdAt;

  ListBuilder<CatalogImportRowError>? _rowErrors;
  ListBuilder<CatalogImportRowError> get rowErrors =>
      _$this._rowErrors ??= ListBuilder<CatalogImportRowError>();
  set rowErrors(ListBuilder<CatalogImportRowError>? rowErrors) =>
      _$this._rowErrors = rowErrors;

  MapBuilder<String, JsonObject?>? _rowErrorsMeta;
  MapBuilder<String, JsonObject?> get rowErrorsMeta =>
      _$this._rowErrorsMeta ??= MapBuilder<String, JsonObject?>();
  set rowErrorsMeta(MapBuilder<String, JsonObject?>? rowErrorsMeta) =>
      _$this._rowErrorsMeta = rowErrorsMeta;

  CatalogImportJobBuilder() {
    CatalogImportJob._defaults(this);
  }

  CatalogImportJobBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _status = $v.status;
      _templateVersion = $v.templateVersion;
      _totalRows = $v.totalRows;
      _validRows = $v.validRows;
      _errorRows = $v.errorRows;
      _appliedRows = $v.appliedRows;
      _appliedAt = $v.appliedAt;
      _createdAt = $v.createdAt;
      _rowErrors = $v.rowErrors.toBuilder();
      _rowErrorsMeta = $v.rowErrorsMeta.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CatalogImportJob other) {
    _$v = other as _$CatalogImportJob;
  }

  @override
  void update(void Function(CatalogImportJobBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CatalogImportJob build() => _build();

  _$CatalogImportJob _build() {
    _$CatalogImportJob _$result;
    try {
      _$result = _$v ??
          _$CatalogImportJob._(
            id: BuiltValueNullFieldError.checkNotNull(
                id, r'CatalogImportJob', 'id'),
            status: BuiltValueNullFieldError.checkNotNull(
                status, r'CatalogImportJob', 'status'),
            templateVersion: BuiltValueNullFieldError.checkNotNull(
                templateVersion, r'CatalogImportJob', 'templateVersion'),
            totalRows: BuiltValueNullFieldError.checkNotNull(
                totalRows, r'CatalogImportJob', 'totalRows'),
            validRows: BuiltValueNullFieldError.checkNotNull(
                validRows, r'CatalogImportJob', 'validRows'),
            errorRows: BuiltValueNullFieldError.checkNotNull(
                errorRows, r'CatalogImportJob', 'errorRows'),
            appliedRows: BuiltValueNullFieldError.checkNotNull(
                appliedRows, r'CatalogImportJob', 'appliedRows'),
            appliedAt: appliedAt,
            createdAt: createdAt,
            rowErrors: rowErrors.build(),
            rowErrorsMeta: rowErrorsMeta.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'rowErrors';
        rowErrors.build();
        _$failedField = 'rowErrorsMeta';
        rowErrorsMeta.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'CatalogImportJob', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
