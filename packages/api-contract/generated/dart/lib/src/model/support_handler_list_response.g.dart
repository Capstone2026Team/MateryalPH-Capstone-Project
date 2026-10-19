// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'support_handler_list_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$SupportHandlerListResponse extends SupportHandlerListResponse {
  @override
  final BuiltList<SupportHandler> data;
  @override
  final SupportPageMeta meta;
  @override
  final BuiltList<ApiError> errors;

  factory _$SupportHandlerListResponse(
          [void Function(SupportHandlerListResponseBuilder)? updates]) =>
      (SupportHandlerListResponseBuilder()..update(updates))._build();

  _$SupportHandlerListResponse._(
      {required this.data, required this.meta, required this.errors})
      : super._();
  @override
  SupportHandlerListResponse rebuild(
          void Function(SupportHandlerListResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SupportHandlerListResponseBuilder toBuilder() =>
      SupportHandlerListResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SupportHandlerListResponse &&
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
    return (newBuiltValueToStringHelper(r'SupportHandlerListResponse')
          ..add('data', data)
          ..add('meta', meta)
          ..add('errors', errors))
        .toString();
  }
}

class SupportHandlerListResponseBuilder
    implements
        Builder<SupportHandlerListResponse, SupportHandlerListResponseBuilder> {
  _$SupportHandlerListResponse? _$v;

  ListBuilder<SupportHandler>? _data;
  ListBuilder<SupportHandler> get data =>
      _$this._data ??= ListBuilder<SupportHandler>();
  set data(ListBuilder<SupportHandler>? data) => _$this._data = data;

  SupportPageMetaBuilder? _meta;
  SupportPageMetaBuilder get meta => _$this._meta ??= SupportPageMetaBuilder();
  set meta(SupportPageMetaBuilder? meta) => _$this._meta = meta;

  ListBuilder<ApiError>? _errors;
  ListBuilder<ApiError> get errors =>
      _$this._errors ??= ListBuilder<ApiError>();
  set errors(ListBuilder<ApiError>? errors) => _$this._errors = errors;

  SupportHandlerListResponseBuilder() {
    SupportHandlerListResponse._defaults(this);
  }

  SupportHandlerListResponseBuilder get _$this {
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
  void replace(SupportHandlerListResponse other) {
    _$v = other as _$SupportHandlerListResponse;
  }

  @override
  void update(void Function(SupportHandlerListResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SupportHandlerListResponse build() => _build();

  _$SupportHandlerListResponse _build() {
    _$SupportHandlerListResponse _$result;
    try {
      _$result = _$v ??
          _$SupportHandlerListResponse._(
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
            r'SupportHandlerListResponse', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
