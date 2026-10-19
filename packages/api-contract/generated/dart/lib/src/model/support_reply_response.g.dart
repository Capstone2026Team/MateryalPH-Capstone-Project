// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'support_reply_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$SupportReplyResponse extends SupportReplyResponse {
  @override
  final SupportCommandResult data;
  @override
  final BuiltMap<String, JsonObject?> meta;
  @override
  final BuiltList<ApiError> errors;

  factory _$SupportReplyResponse(
          [void Function(SupportReplyResponseBuilder)? updates]) =>
      (SupportReplyResponseBuilder()..update(updates))._build();

  _$SupportReplyResponse._(
      {required this.data, required this.meta, required this.errors})
      : super._();
  @override
  SupportReplyResponse rebuild(
          void Function(SupportReplyResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SupportReplyResponseBuilder toBuilder() =>
      SupportReplyResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SupportReplyResponse &&
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
    return (newBuiltValueToStringHelper(r'SupportReplyResponse')
          ..add('data', data)
          ..add('meta', meta)
          ..add('errors', errors))
        .toString();
  }
}

class SupportReplyResponseBuilder
    implements Builder<SupportReplyResponse, SupportReplyResponseBuilder> {
  _$SupportReplyResponse? _$v;

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

  SupportReplyResponseBuilder() {
    SupportReplyResponse._defaults(this);
  }

  SupportReplyResponseBuilder get _$this {
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
  void replace(SupportReplyResponse other) {
    _$v = other as _$SupportReplyResponse;
  }

  @override
  void update(void Function(SupportReplyResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SupportReplyResponse build() => _build();

  _$SupportReplyResponse _build() {
    _$SupportReplyResponse _$result;
    try {
      _$result = _$v ??
          _$SupportReplyResponse._(
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
            r'SupportReplyResponse', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
