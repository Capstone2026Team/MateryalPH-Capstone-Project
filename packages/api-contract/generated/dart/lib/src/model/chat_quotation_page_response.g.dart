// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_quotation_page_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ChatQuotationPageResponse extends ChatQuotationPageResponse {
  @override
  final ChatQuotationPage data;
  @override
  final BuiltMap<String, JsonObject?> meta;
  @override
  final BuiltList<ApiError> errors;

  factory _$ChatQuotationPageResponse(
          [void Function(ChatQuotationPageResponseBuilder)? updates]) =>
      (ChatQuotationPageResponseBuilder()..update(updates))._build();

  _$ChatQuotationPageResponse._(
      {required this.data, required this.meta, required this.errors})
      : super._();
  @override
  ChatQuotationPageResponse rebuild(
          void Function(ChatQuotationPageResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ChatQuotationPageResponseBuilder toBuilder() =>
      ChatQuotationPageResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ChatQuotationPageResponse &&
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
    return (newBuiltValueToStringHelper(r'ChatQuotationPageResponse')
          ..add('data', data)
          ..add('meta', meta)
          ..add('errors', errors))
        .toString();
  }
}

class ChatQuotationPageResponseBuilder
    implements
        Builder<ChatQuotationPageResponse, ChatQuotationPageResponseBuilder> {
  _$ChatQuotationPageResponse? _$v;

  ChatQuotationPageBuilder? _data;
  ChatQuotationPageBuilder get data =>
      _$this._data ??= ChatQuotationPageBuilder();
  set data(ChatQuotationPageBuilder? data) => _$this._data = data;

  MapBuilder<String, JsonObject?>? _meta;
  MapBuilder<String, JsonObject?> get meta =>
      _$this._meta ??= MapBuilder<String, JsonObject?>();
  set meta(MapBuilder<String, JsonObject?>? meta) => _$this._meta = meta;

  ListBuilder<ApiError>? _errors;
  ListBuilder<ApiError> get errors =>
      _$this._errors ??= ListBuilder<ApiError>();
  set errors(ListBuilder<ApiError>? errors) => _$this._errors = errors;

  ChatQuotationPageResponseBuilder() {
    ChatQuotationPageResponse._defaults(this);
  }

  ChatQuotationPageResponseBuilder get _$this {
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
  void replace(ChatQuotationPageResponse other) {
    _$v = other as _$ChatQuotationPageResponse;
  }

  @override
  void update(void Function(ChatQuotationPageResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ChatQuotationPageResponse build() => _build();

  _$ChatQuotationPageResponse _build() {
    _$ChatQuotationPageResponse _$result;
    try {
      _$result = _$v ??
          _$ChatQuotationPageResponse._(
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
            r'ChatQuotationPageResponse', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
