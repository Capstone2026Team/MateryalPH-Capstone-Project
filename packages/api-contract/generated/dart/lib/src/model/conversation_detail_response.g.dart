// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'conversation_detail_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ConversationDetailResponse extends ConversationDetailResponse {
  @override
  final ConversationDetail data;
  @override
  final BuiltMap<String, JsonObject?> meta;
  @override
  final BuiltList<ApiError> errors;

  factory _$ConversationDetailResponse(
          [void Function(ConversationDetailResponseBuilder)? updates]) =>
      (ConversationDetailResponseBuilder()..update(updates))._build();

  _$ConversationDetailResponse._(
      {required this.data, required this.meta, required this.errors})
      : super._();
  @override
  ConversationDetailResponse rebuild(
          void Function(ConversationDetailResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ConversationDetailResponseBuilder toBuilder() =>
      ConversationDetailResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ConversationDetailResponse &&
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
    return (newBuiltValueToStringHelper(r'ConversationDetailResponse')
          ..add('data', data)
          ..add('meta', meta)
          ..add('errors', errors))
        .toString();
  }
}

class ConversationDetailResponseBuilder
    implements
        Builder<ConversationDetailResponse, ConversationDetailResponseBuilder> {
  _$ConversationDetailResponse? _$v;

  ConversationDetailBuilder? _data;
  ConversationDetailBuilder get data =>
      _$this._data ??= ConversationDetailBuilder();
  set data(ConversationDetailBuilder? data) => _$this._data = data;

  MapBuilder<String, JsonObject?>? _meta;
  MapBuilder<String, JsonObject?> get meta =>
      _$this._meta ??= MapBuilder<String, JsonObject?>();
  set meta(MapBuilder<String, JsonObject?>? meta) => _$this._meta = meta;

  ListBuilder<ApiError>? _errors;
  ListBuilder<ApiError> get errors =>
      _$this._errors ??= ListBuilder<ApiError>();
  set errors(ListBuilder<ApiError>? errors) => _$this._errors = errors;

  ConversationDetailResponseBuilder() {
    ConversationDetailResponse._defaults(this);
  }

  ConversationDetailResponseBuilder get _$this {
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
  void replace(ConversationDetailResponse other) {
    _$v = other as _$ConversationDetailResponse;
  }

  @override
  void update(void Function(ConversationDetailResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ConversationDetailResponse build() => _build();

  _$ConversationDetailResponse _build() {
    _$ConversationDetailResponse _$result;
    try {
      _$result = _$v ??
          _$ConversationDetailResponse._(
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
            r'ConversationDetailResponse', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
