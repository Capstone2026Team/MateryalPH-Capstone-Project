// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'support_receipt_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$SupportReceiptResponse extends SupportReceiptResponse {
  @override
  final SupportReceipt data;
  @override
  final BuiltMap<String, JsonObject?> meta;
  @override
  final BuiltList<ApiError> errors;

  factory _$SupportReceiptResponse(
          [void Function(SupportReceiptResponseBuilder)? updates]) =>
      (SupportReceiptResponseBuilder()..update(updates))._build();

  _$SupportReceiptResponse._(
      {required this.data, required this.meta, required this.errors})
      : super._();
  @override
  SupportReceiptResponse rebuild(
          void Function(SupportReceiptResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SupportReceiptResponseBuilder toBuilder() =>
      SupportReceiptResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SupportReceiptResponse &&
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
    return (newBuiltValueToStringHelper(r'SupportReceiptResponse')
          ..add('data', data)
          ..add('meta', meta)
          ..add('errors', errors))
        .toString();
  }
}

class SupportReceiptResponseBuilder
    implements Builder<SupportReceiptResponse, SupportReceiptResponseBuilder> {
  _$SupportReceiptResponse? _$v;

  SupportReceiptBuilder? _data;
  SupportReceiptBuilder get data => _$this._data ??= SupportReceiptBuilder();
  set data(SupportReceiptBuilder? data) => _$this._data = data;

  MapBuilder<String, JsonObject?>? _meta;
  MapBuilder<String, JsonObject?> get meta =>
      _$this._meta ??= MapBuilder<String, JsonObject?>();
  set meta(MapBuilder<String, JsonObject?>? meta) => _$this._meta = meta;

  ListBuilder<ApiError>? _errors;
  ListBuilder<ApiError> get errors =>
      _$this._errors ??= ListBuilder<ApiError>();
  set errors(ListBuilder<ApiError>? errors) => _$this._errors = errors;

  SupportReceiptResponseBuilder() {
    SupportReceiptResponse._defaults(this);
  }

  SupportReceiptResponseBuilder get _$this {
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
  void replace(SupportReceiptResponse other) {
    _$v = other as _$SupportReceiptResponse;
  }

  @override
  void update(void Function(SupportReceiptResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SupportReceiptResponse build() => _build();

  _$SupportReceiptResponse _build() {
    _$SupportReceiptResponse _$result;
    try {
      _$result = _$v ??
          _$SupportReceiptResponse._(
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
            r'SupportReceiptResponse', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
