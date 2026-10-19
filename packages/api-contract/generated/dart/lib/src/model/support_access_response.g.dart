// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'support_access_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$SupportAccessResponse extends SupportAccessResponse {
  @override
  final SupportAccessResult data;
  @override
  final BuiltMap<String, JsonObject?> meta;
  @override
  final BuiltList<ApiError> errors;

  factory _$SupportAccessResponse(
          [void Function(SupportAccessResponseBuilder)? updates]) =>
      (SupportAccessResponseBuilder()..update(updates))._build();

  _$SupportAccessResponse._(
      {required this.data, required this.meta, required this.errors})
      : super._();
  @override
  SupportAccessResponse rebuild(
          void Function(SupportAccessResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SupportAccessResponseBuilder toBuilder() =>
      SupportAccessResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SupportAccessResponse &&
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
    return (newBuiltValueToStringHelper(r'SupportAccessResponse')
          ..add('data', data)
          ..add('meta', meta)
          ..add('errors', errors))
        .toString();
  }
}

class SupportAccessResponseBuilder
    implements Builder<SupportAccessResponse, SupportAccessResponseBuilder> {
  _$SupportAccessResponse? _$v;

  SupportAccessResultBuilder? _data;
  SupportAccessResultBuilder get data =>
      _$this._data ??= SupportAccessResultBuilder();
  set data(SupportAccessResultBuilder? data) => _$this._data = data;

  MapBuilder<String, JsonObject?>? _meta;
  MapBuilder<String, JsonObject?> get meta =>
      _$this._meta ??= MapBuilder<String, JsonObject?>();
  set meta(MapBuilder<String, JsonObject?>? meta) => _$this._meta = meta;

  ListBuilder<ApiError>? _errors;
  ListBuilder<ApiError> get errors =>
      _$this._errors ??= ListBuilder<ApiError>();
  set errors(ListBuilder<ApiError>? errors) => _$this._errors = errors;

  SupportAccessResponseBuilder() {
    SupportAccessResponse._defaults(this);
  }

  SupportAccessResponseBuilder get _$this {
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
  void replace(SupportAccessResponse other) {
    _$v = other as _$SupportAccessResponse;
  }

  @override
  void update(void Function(SupportAccessResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SupportAccessResponse build() => _build();

  _$SupportAccessResponse _build() {
    _$SupportAccessResponse _$result;
    try {
      _$result = _$v ??
          _$SupportAccessResponse._(
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
            r'SupportAccessResponse', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
