// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'catalog_import_template.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CatalogImportTemplate extends CatalogImportTemplate {
  @override
  final String templateVersion;
  @override
  final BuiltList<String> columns;
  @override
  final BuiltList<String> requiredColumns;
  @override
  final int maxRows;

  factory _$CatalogImportTemplate(
          [void Function(CatalogImportTemplateBuilder)? updates]) =>
      (CatalogImportTemplateBuilder()..update(updates))._build();

  _$CatalogImportTemplate._(
      {required this.templateVersion,
      required this.columns,
      required this.requiredColumns,
      required this.maxRows})
      : super._();
  @override
  CatalogImportTemplate rebuild(
          void Function(CatalogImportTemplateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CatalogImportTemplateBuilder toBuilder() =>
      CatalogImportTemplateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CatalogImportTemplate &&
        templateVersion == other.templateVersion &&
        columns == other.columns &&
        requiredColumns == other.requiredColumns &&
        maxRows == other.maxRows;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, templateVersion.hashCode);
    _$hash = $jc(_$hash, columns.hashCode);
    _$hash = $jc(_$hash, requiredColumns.hashCode);
    _$hash = $jc(_$hash, maxRows.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CatalogImportTemplate')
          ..add('templateVersion', templateVersion)
          ..add('columns', columns)
          ..add('requiredColumns', requiredColumns)
          ..add('maxRows', maxRows))
        .toString();
  }
}

class CatalogImportTemplateBuilder
    implements Builder<CatalogImportTemplate, CatalogImportTemplateBuilder> {
  _$CatalogImportTemplate? _$v;

  String? _templateVersion;
  String? get templateVersion => _$this._templateVersion;
  set templateVersion(String? templateVersion) =>
      _$this._templateVersion = templateVersion;

  ListBuilder<String>? _columns;
  ListBuilder<String> get columns => _$this._columns ??= ListBuilder<String>();
  set columns(ListBuilder<String>? columns) => _$this._columns = columns;

  ListBuilder<String>? _requiredColumns;
  ListBuilder<String> get requiredColumns =>
      _$this._requiredColumns ??= ListBuilder<String>();
  set requiredColumns(ListBuilder<String>? requiredColumns) =>
      _$this._requiredColumns = requiredColumns;

  int? _maxRows;
  int? get maxRows => _$this._maxRows;
  set maxRows(int? maxRows) => _$this._maxRows = maxRows;

  CatalogImportTemplateBuilder() {
    CatalogImportTemplate._defaults(this);
  }

  CatalogImportTemplateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _templateVersion = $v.templateVersion;
      _columns = $v.columns.toBuilder();
      _requiredColumns = $v.requiredColumns.toBuilder();
      _maxRows = $v.maxRows;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CatalogImportTemplate other) {
    _$v = other as _$CatalogImportTemplate;
  }

  @override
  void update(void Function(CatalogImportTemplateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CatalogImportTemplate build() => _build();

  _$CatalogImportTemplate _build() {
    _$CatalogImportTemplate _$result;
    try {
      _$result = _$v ??
          _$CatalogImportTemplate._(
            templateVersion: BuiltValueNullFieldError.checkNotNull(
                templateVersion, r'CatalogImportTemplate', 'templateVersion'),
            columns: columns.build(),
            requiredColumns: requiredColumns.build(),
            maxRows: BuiltValueNullFieldError.checkNotNull(
                maxRows, r'CatalogImportTemplate', 'maxRows'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'columns';
        columns.build();
        _$failedField = 'requiredColumns';
        requiredColumns.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'CatalogImportTemplate', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
