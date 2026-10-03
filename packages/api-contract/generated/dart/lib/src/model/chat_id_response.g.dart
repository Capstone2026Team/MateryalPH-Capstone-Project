// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_id_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ChatIdResponse extends ChatIdResponse {
  @override
  final ChatId data;
  @override
  final BuiltMap<String, JsonObject?> meta;
  @override
  final BuiltList<ApiError> errors;

  factory _$ChatIdResponse([void Function(ChatIdResponseBuilder)? updates]) =>
      (ChatIdResponseBuilder()..update(updates))._build();

  _$ChatIdResponse._(
      {required this.data, required this.meta, required this.errors})
      : super._();
  @override
  ChatIdResponse rebuild(void Function(ChatIdResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ChatIdResponseBuilder toBuilder() => ChatIdResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ChatIdResponse &&
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
    return (newBuiltValueToStringHelper(r'ChatIdResponse')
          ..add('data', data)
          ..add('meta', meta)
          ..add('errors', errors))
        .toString();
  }
}

class ChatIdResponseBuilder
    implements Builder<ChatIdResponse, ChatIdResponseBuilder> {
  _$ChatIdResponse? _$v;

  ChatIdBuilder? _data;
  ChatIdBuilder get data => _$this._data ??= ChatIdBuilder();
  set data(ChatIdBuilder? data) => _$this._data = data;

  MapBuilder<String, JsonObject?>? _meta;
  MapBuilder<String, JsonObject?> get meta =>
      _$this._meta ??= MapBuilder<String, JsonObject?>();
  set meta(MapBuilder<String, JsonObject?>? meta) => _$this._meta = meta;

  ListBuilder<ApiError>? _errors;
  ListBuilder<ApiError> get errors =>
      _$this._errors ??= ListBuilder<ApiError>();
  set errors(ListBuilder<ApiError>? errors) => _$this._errors = errors;

  ChatIdResponseBuilder() {
    ChatIdResponse._defaults(this);
  }

  ChatIdResponseBuilder get _$this {
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
  void replace(ChatIdResponse other) {
    _$v = other as _$ChatIdResponse;
  }

  @override
  void update(void Function(ChatIdResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ChatIdResponse build() => _build();

  _$ChatIdResponse _build() {
    _$ChatIdResponse _$result;
    try {
      _$result = _$v ??
          _$ChatIdResponse._(
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
            r'ChatIdResponse', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
