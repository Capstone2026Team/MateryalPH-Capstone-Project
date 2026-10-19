// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'support_command_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$SupportCommandResponse extends SupportCommandResponse {
  @override
  final SupportCommandResult data;
  @override
  final BuiltMap<String, JsonObject?> meta;
  @override
  final BuiltList<ApiError> errors;

  factory _$SupportCommandResponse(
          [void Function(SupportCommandResponseBuilder)? updates]) =>
      (SupportCommandResponseBuilder()..update(updates))._build();

  _$SupportCommandResponse._(
      {required this.data, required this.meta, required this.errors})
      : super._();
  @override
  SupportCommandResponse rebuild(
          void Function(SupportCommandResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SupportCommandResponseBuilder toBuilder() =>
      SupportCommandResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SupportCommandResponse &&
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
    return (newBuiltValueToStringHelper(r'SupportCommandResponse')
          ..add('data', data)
          ..add('meta', meta)
          ..add('errors', errors))
        .toString();
  }
}

class SupportCommandResponseBuilder
    implements Builder<SupportCommandResponse, SupportCommandResponseBuilder> {
  _$SupportCommandResponse? _$v;

  SupportCommandResultBuilder? _data;
  SupportCommandResultBuilder get data =>
      _$this._data ??= SupportCommandResultBuilder();
  set data(SupportCommandResultBuilder? data) => _$this._data = data;

  MapBuilder<String, JsonObject?>? _meta;
  MapBuilder<String, JsonObject?> get meta =>
      _$this._meta ??= MapBuilder<String, JsonObject?>();
  set meta(MapBuilder<String, JsonObject?>? meta) => _$this._meta = meta;

  ListBuilder<ApiError>? _errors;
  ListBuilder<ApiError> get errors =>
      _$this._errors ??= ListBuilder<ApiError>();
  set errors(ListBuilder<ApiError>? errors) => _$this._errors = errors;

  SupportCommandResponseBuilder() {
    SupportCommandResponse._defaults(this);
  }

  SupportCommandResponseBuilder get _$this {
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
  void replace(SupportCommandResponse other) {
    _$v = other as _$SupportCommandResponse;
  }

  @override
  void update(void Function(SupportCommandResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SupportCommandResponse build() => _build();

  _$SupportCommandResponse _build() {
    _$SupportCommandResponse _$result;
    try {
      _$result = _$v ??
          _$SupportCommandResponse._(
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
            r'SupportCommandResponse', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
