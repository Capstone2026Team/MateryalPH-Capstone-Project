// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_empty_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ChatEmptyResponse extends ChatEmptyResponse {
  @override
  final JsonObject? data;
  @override
  final BuiltMap<String, JsonObject?> meta;
  @override
  final BuiltList<ApiError> errors;

  factory _$ChatEmptyResponse(
          [void Function(ChatEmptyResponseBuilder)? updates]) =>
      (ChatEmptyResponseBuilder()..update(updates))._build();

  _$ChatEmptyResponse._({this.data, required this.meta, required this.errors})
      : super._();
  @override
  ChatEmptyResponse rebuild(void Function(ChatEmptyResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ChatEmptyResponseBuilder toBuilder() =>
      ChatEmptyResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ChatEmptyResponse &&
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
    return (newBuiltValueToStringHelper(r'ChatEmptyResponse')
          ..add('data', data)
          ..add('meta', meta)
          ..add('errors', errors))
        .toString();
  }
}

class ChatEmptyResponseBuilder
    implements Builder<ChatEmptyResponse, ChatEmptyResponseBuilder> {
  _$ChatEmptyResponse? _$v;

  JsonObject? _data;
  JsonObject? get data => _$this._data;
  set data(JsonObject? data) => _$this._data = data;

  MapBuilder<String, JsonObject?>? _meta;
  MapBuilder<String, JsonObject?> get meta =>
      _$this._meta ??= MapBuilder<String, JsonObject?>();
  set meta(MapBuilder<String, JsonObject?>? meta) => _$this._meta = meta;

  ListBuilder<ApiError>? _errors;
  ListBuilder<ApiError> get errors =>
      _$this._errors ??= ListBuilder<ApiError>();
  set errors(ListBuilder<ApiError>? errors) => _$this._errors = errors;

  ChatEmptyResponseBuilder() {
    ChatEmptyResponse._defaults(this);
  }

  ChatEmptyResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _data = $v.data;
      _meta = $v.meta.toBuilder();
      _errors = $v.errors.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ChatEmptyResponse other) {
    _$v = other as _$ChatEmptyResponse;
  }

  @override
  void update(void Function(ChatEmptyResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ChatEmptyResponse build() => _build();

  _$ChatEmptyResponse _build() {
    _$ChatEmptyResponse _$result;
    try {
      _$result = _$v ??
          _$ChatEmptyResponse._(
            data: data,
            meta: meta.build(),
            errors: errors.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'meta';
        meta.build();
        _$failedField = 'errors';
        errors.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'ChatEmptyResponse', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
