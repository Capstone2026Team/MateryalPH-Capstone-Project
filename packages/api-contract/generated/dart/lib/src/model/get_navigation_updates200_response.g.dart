// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_navigation_updates200_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$GetNavigationUpdates200Response
    extends GetNavigationUpdates200Response {
  @override
  final NavigationUpdates data;
  @override
  final BuiltMap<String, JsonObject?> meta;
  @override
  final BuiltList<ApiError> errors;

  factory _$GetNavigationUpdates200Response(
          [void Function(GetNavigationUpdates200ResponseBuilder)? updates]) =>
      (GetNavigationUpdates200ResponseBuilder()..update(updates))._build();

  _$GetNavigationUpdates200Response._(
      {required this.data, required this.meta, required this.errors})
      : super._();
  @override
  GetNavigationUpdates200Response rebuild(
          void Function(GetNavigationUpdates200ResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  GetNavigationUpdates200ResponseBuilder toBuilder() =>
      GetNavigationUpdates200ResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is GetNavigationUpdates200Response &&
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
    return (newBuiltValueToStringHelper(r'GetNavigationUpdates200Response')
          ..add('data', data)
          ..add('meta', meta)
          ..add('errors', errors))
        .toString();
  }
}

class GetNavigationUpdates200ResponseBuilder
    implements
        Builder<GetNavigationUpdates200Response,
            GetNavigationUpdates200ResponseBuilder> {
  _$GetNavigationUpdates200Response? _$v;

  NavigationUpdatesBuilder? _data;
  NavigationUpdatesBuilder get data =>
      _$this._data ??= NavigationUpdatesBuilder();
  set data(NavigationUpdatesBuilder? data) => _$this._data = data;

  MapBuilder<String, JsonObject?>? _meta;
  MapBuilder<String, JsonObject?> get meta =>
      _$this._meta ??= MapBuilder<String, JsonObject?>();
  set meta(MapBuilder<String, JsonObject?>? meta) => _$this._meta = meta;

  ListBuilder<ApiError>? _errors;
  ListBuilder<ApiError> get errors =>
      _$this._errors ??= ListBuilder<ApiError>();
  set errors(ListBuilder<ApiError>? errors) => _$this._errors = errors;

  GetNavigationUpdates200ResponseBuilder() {
    GetNavigationUpdates200Response._defaults(this);
  }

  GetNavigationUpdates200ResponseBuilder get _$this {
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
  void replace(GetNavigationUpdates200Response other) {
    _$v = other as _$GetNavigationUpdates200Response;
  }

  @override
  void update(void Function(GetNavigationUpdates200ResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  GetNavigationUpdates200Response build() => _build();

  _$GetNavigationUpdates200Response _build() {
    _$GetNavigationUpdates200Response _$result;
    try {
      _$result = _$v ??
          _$GetNavigationUpdates200Response._(
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
            r'GetNavigationUpdates200Response', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
