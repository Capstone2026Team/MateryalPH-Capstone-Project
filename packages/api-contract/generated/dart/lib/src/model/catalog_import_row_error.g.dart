// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'catalog_import_row_error.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CatalogImportRowError extends CatalogImportRowError {
  @override
  final int rowNumber;
  @override
  final String? vendorSku;
  @override
  final String? variantSku;
  @override
  final BuiltMap<String, BuiltList<String>> errors;

  factory _$CatalogImportRowError(
          [void Function(CatalogImportRowErrorBuilder)? updates]) =>
      (CatalogImportRowErrorBuilder()..update(updates))._build();

  _$CatalogImportRowError._(
      {required this.rowNumber,
      this.vendorSku,
      this.variantSku,
      required this.errors})
      : super._();
  @override
  CatalogImportRowError rebuild(
          void Function(CatalogImportRowErrorBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CatalogImportRowErrorBuilder toBuilder() =>
      CatalogImportRowErrorBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CatalogImportRowError &&
        rowNumber == other.rowNumber &&
        vendorSku == other.vendorSku &&
        variantSku == other.variantSku &&
        errors == other.errors;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, rowNumber.hashCode);
    _$hash = $jc(_$hash, vendorSku.hashCode);
    _$hash = $jc(_$hash, variantSku.hashCode);
    _$hash = $jc(_$hash, errors.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CatalogImportRowError')
          ..add('rowNumber', rowNumber)
          ..add('vendorSku', vendorSku)
          ..add('variantSku', variantSku)
          ..add('errors', errors))
        .toString();
  }
}

class CatalogImportRowErrorBuilder
    implements Builder<CatalogImportRowError, CatalogImportRowErrorBuilder> {
  _$CatalogImportRowError? _$v;

  int? _rowNumber;
  int? get rowNumber => _$this._rowNumber;
  set rowNumber(int? rowNumber) => _$this._rowNumber = rowNumber;

  String? _vendorSku;
  String? get vendorSku => _$this._vendorSku;
  set vendorSku(String? vendorSku) => _$this._vendorSku = vendorSku;

  String? _variantSku;
  String? get variantSku => _$this._variantSku;
  set variantSku(String? variantSku) => _$this._variantSku = variantSku;

  MapBuilder<String, BuiltList<String>>? _errors;
  MapBuilder<String, BuiltList<String>> get errors =>
      _$this._errors ??= MapBuilder<String, BuiltList<String>>();
  set errors(MapBuilder<String, BuiltList<String>>? errors) =>
      _$this._errors = errors;

  CatalogImportRowErrorBuilder() {
    CatalogImportRowError._defaults(this);
  }

  CatalogImportRowErrorBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _rowNumber = $v.rowNumber;
      _vendorSku = $v.vendorSku;
      _variantSku = $v.variantSku;
      _errors = $v.errors.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CatalogImportRowError other) {
    _$v = other as _$CatalogImportRowError;
  }

  @override
  void update(void Function(CatalogImportRowErrorBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CatalogImportRowError build() => _build();

  _$CatalogImportRowError _build() {
    _$CatalogImportRowError _$result;
    try {
      _$result = _$v ??
          _$CatalogImportRowError._(
            rowNumber: BuiltValueNullFieldError.checkNotNull(
                rowNumber, r'CatalogImportRowError', 'rowNumber'),
            vendorSku: vendorSku,
            variantSku: variantSku,
            errors: errors.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'errors';
        errors.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'CatalogImportRowError', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
