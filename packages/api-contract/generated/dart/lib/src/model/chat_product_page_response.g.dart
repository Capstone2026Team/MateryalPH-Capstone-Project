// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_product_page_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ChatProductPageResponse extends ChatProductPageResponse {
  @override
  final ChatProductPage data;
  @override
  final BuiltMap<String, JsonObject?> meta;
  @override
  final BuiltList<ApiError> errors;

  factory _$ChatProductPageResponse(
          [void Function(ChatProductPageResponseBuilder)? updates]) =>
      (ChatProductPageResponseBuilder()..update(updates))._build();

  _$ChatProductPageResponse._(
      {required this.data, required this.meta, required this.errors})
      : super._();
  @override
  ChatProductPageResponse rebuild(
          void Function(ChatProductPageResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ChatProductPageResponseBuilder toBuilder() =>
      ChatProductPageResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ChatProductPageResponse &&
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
    return (newBuiltValueToStringHelper(r'ChatProductPageResponse')
          ..add('data', data)
          ..add('meta', meta)
          ..add('errors', errors))
        .toString();
  }
}

class ChatProductPageResponseBuilder
    implements
        Builder<ChatProductPageResponse, ChatProductPageResponseBuilder> {
  _$ChatProductPageResponse? _$v;

  ChatProductPageBuilder? _data;
  ChatProductPageBuilder get data => _$this._data ??= ChatProductPageBuilder();
  set data(ChatProductPageBuilder? data) => _$this._data = data;

  MapBuilder<String, JsonObject?>? _meta;
  MapBuilder<String, JsonObject?> get meta =>
      _$this._meta ??= MapBuilder<String, JsonObject?>();
  set meta(MapBuilder<String, JsonObject?>? meta) => _$this._meta = meta;

  ListBuilder<ApiError>? _errors;
  ListBuilder<ApiError> get errors =>
      _$this._errors ??= ListBuilder<ApiError>();
  set errors(ListBuilder<ApiError>? errors) => _$this._errors = errors;

  ChatProductPageResponseBuilder() {
    ChatProductPageResponse._defaults(this);
  }

  ChatProductPageResponseBuilder get _$this {
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
  void replace(ChatProductPageResponse other) {
    _$v = other as _$ChatProductPageResponse;
  }

  @override
  void update(void Function(ChatProductPageResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ChatProductPageResponse build() => _build();

  _$ChatProductPageResponse _build() {
    _$ChatProductPageResponse _$result;
    try {
      _$result = _$v ??
          _$ChatProductPageResponse._(
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
            r'ChatProductPageResponse', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
