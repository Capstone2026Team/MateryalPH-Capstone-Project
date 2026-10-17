// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'list_tax_packages200_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ListTaxPackages200Response extends ListTaxPackages200Response {
  @override
  final BuiltList<TaxPackage> data;
  @override
  final BuiltMap<String, JsonObject?> meta;
  @override
  final BuiltList<BuiltMap<String, JsonObject?>> errors;

  factory _$ListTaxPackages200Response(
          [void Function(ListTaxPackages200ResponseBuilder)? updates]) =>
      (ListTaxPackages200ResponseBuilder()..update(updates))._build();

  _$ListTaxPackages200Response._(
      {required this.data, required this.meta, required this.errors})
      : super._();
  @override
  ListTaxPackages200Response rebuild(
          void Function(ListTaxPackages200ResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ListTaxPackages200ResponseBuilder toBuilder() =>
      ListTaxPackages200ResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ListTaxPackages200Response &&
        data == other.data &&
        meta == other.meta &&
        errors == other.errors;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, data.hashCode);
    _$hash = $jc(_$hash, meta.hashCode);
    _$hash = $jc(_$hash, errors.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ListTaxPackages200Response')
          ..add('data', data)
          ..add('meta', meta)
          ..add('errors', errors))
        .toString();
  }
}

class ListTaxPackages200ResponseBuilder
    implements
        Builder<ListTaxPackages200Response, ListTaxPackages200ResponseBuilder> {
  _$ListTaxPackages200Response? _$v;

  ListBuilder<TaxPackage>? _data;
  ListBuilder<TaxPackage> get data =>
      _$this._data ??= ListBuilder<TaxPackage>();
  set data(ListBuilder<TaxPackage>? data) => _$this._data = data;

  MapBuilder<String, JsonObject?>? _meta;
  MapBuilder<String, JsonObject?> get meta =>
      _$this._meta ??= MapBuilder<String, JsonObject?>();
  set meta(MapBuilder<String, JsonObject?>? meta) => _$this._meta = meta;

  ListBuilder<BuiltMap<String, JsonObject?>>? _errors;
  ListBuilder<BuiltMap<String, JsonObject?>> get errors =>
      _$this._errors ??= ListBuilder<BuiltMap<String, JsonObject?>>();
  set errors(ListBuilder<BuiltMap<String, JsonObject?>>? errors) =>
      _$this._errors = errors;

  ListTaxPackages200ResponseBuilder() {
    ListTaxPackages200Response._defaults(this);
  }

  ListTaxPackages200ResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _data = $v.data.toBuilder();
      _meta = $v.meta.toBuilder();
      _errors = $v.errors.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ListTaxPackages200Response other) {
    _$v = other as _$ListTaxPackages200Response;
  }

  @override
  void update(void Function(ListTaxPackages200ResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ListTaxPackages200Response build() => _build();

  _$ListTaxPackages200Response _build() {
    _$ListTaxPackages200Response _$result;
    try {
      _$result = _$v ??
          _$ListTaxPackages200Response._(
            data: data.build(),
            meta: meta.build(),
            errors: errors.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'data';
        data.build();
        _$failedField = 'meta';
        meta.build();
        _$failedField = 'errors';
        errors.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'ListTaxPackages200Response', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
