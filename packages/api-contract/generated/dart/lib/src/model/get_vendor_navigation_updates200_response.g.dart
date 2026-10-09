// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_vendor_navigation_updates200_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$GetVendorNavigationUpdates200Response
    extends GetVendorNavigationUpdates200Response {
  @override
  final VendorNavigationUpdates data;
  @override
  final BuiltMap<String, JsonObject?> meta;
  @override
  final BuiltList<ApiError> errors;

  factory _$GetVendorNavigationUpdates200Response(
          [void Function(GetVendorNavigationUpdates200ResponseBuilder)?
              updates]) =>
      (GetVendorNavigationUpdates200ResponseBuilder()..update(updates))
          ._build();

  _$GetVendorNavigationUpdates200Response._(
      {required this.data, required this.meta, required this.errors})
      : super._();
  @override
  GetVendorNavigationUpdates200Response rebuild(
          void Function(GetVendorNavigationUpdates200ResponseBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  GetVendorNavigationUpdates200ResponseBuilder toBuilder() =>
      GetVendorNavigationUpdates200ResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is GetVendorNavigationUpdates200Response &&
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
    return (newBuiltValueToStringHelper(
            r'GetVendorNavigationUpdates200Response')
          ..add('data', data)
          ..add('meta', meta)
          ..add('errors', errors))
        .toString();
  }
}

class GetVendorNavigationUpdates200ResponseBuilder
    implements
        Builder<GetVendorNavigationUpdates200Response,
            GetVendorNavigationUpdates200ResponseBuilder> {
  _$GetVendorNavigationUpdates200Response? _$v;

  VendorNavigationUpdatesBuilder? _data;
  VendorNavigationUpdatesBuilder get data =>
      _$this._data ??= VendorNavigationUpdatesBuilder();
  set data(VendorNavigationUpdatesBuilder? data) => _$this._data = data;

  MapBuilder<String, JsonObject?>? _meta;
  MapBuilder<String, JsonObject?> get meta =>
      _$this._meta ??= MapBuilder<String, JsonObject?>();
  set meta(MapBuilder<String, JsonObject?>? meta) => _$this._meta = meta;

  ListBuilder<ApiError>? _errors;
  ListBuilder<ApiError> get errors =>
      _$this._errors ??= ListBuilder<ApiError>();
  set errors(ListBuilder<ApiError>? errors) => _$this._errors = errors;

  GetVendorNavigationUpdates200ResponseBuilder() {
    GetVendorNavigationUpdates200Response._defaults(this);
  }

  GetVendorNavigationUpdates200ResponseBuilder get _$this {
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
  void replace(GetVendorNavigationUpdates200Response other) {
    _$v = other as _$GetVendorNavigationUpdates200Response;
  }

  @override
  void update(
      void Function(GetVendorNavigationUpdates200ResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  GetVendorNavigationUpdates200Response build() => _build();

  _$GetVendorNavigationUpdates200Response _build() {
    _$GetVendorNavigationUpdates200Response _$result;
    try {
      _$result = _$v ??
          _$GetVendorNavigationUpdates200Response._(
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
            r'GetVendorNavigationUpdates200Response',
            _$failedField,
            e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
