// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'buyer_order_invoices_envelope.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$BuyerOrderInvoicesEnvelope extends BuyerOrderInvoicesEnvelope {
  @override
  final BuyerOrderInvoices data;
  @override
  final BuiltMap<String, JsonObject?> meta;
  @override
  final BuiltList<ApiError> errors;

  factory _$BuyerOrderInvoicesEnvelope(
          [void Function(BuyerOrderInvoicesEnvelopeBuilder)? updates]) =>
      (BuyerOrderInvoicesEnvelopeBuilder()..update(updates))._build();

  _$BuyerOrderInvoicesEnvelope._(
      {required this.data, required this.meta, required this.errors})
      : super._();
  @override
  BuyerOrderInvoicesEnvelope rebuild(
          void Function(BuyerOrderInvoicesEnvelopeBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  BuyerOrderInvoicesEnvelopeBuilder toBuilder() =>
      BuyerOrderInvoicesEnvelopeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is BuyerOrderInvoicesEnvelope &&
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
    return (newBuiltValueToStringHelper(r'BuyerOrderInvoicesEnvelope')
          ..add('data', data)
          ..add('meta', meta)
          ..add('errors', errors))
        .toString();
  }
}

class BuyerOrderInvoicesEnvelopeBuilder
    implements
        Builder<BuyerOrderInvoicesEnvelope, BuyerOrderInvoicesEnvelopeBuilder> {
  _$BuyerOrderInvoicesEnvelope? _$v;

  BuyerOrderInvoicesBuilder? _data;
  BuyerOrderInvoicesBuilder get data =>
      _$this._data ??= BuyerOrderInvoicesBuilder();
  set data(BuyerOrderInvoicesBuilder? data) => _$this._data = data;

  MapBuilder<String, JsonObject?>? _meta;
  MapBuilder<String, JsonObject?> get meta =>
      _$this._meta ??= MapBuilder<String, JsonObject?>();
  set meta(MapBuilder<String, JsonObject?>? meta) => _$this._meta = meta;

  ListBuilder<ApiError>? _errors;
  ListBuilder<ApiError> get errors =>
      _$this._errors ??= ListBuilder<ApiError>();
  set errors(ListBuilder<ApiError>? errors) => _$this._errors = errors;

  BuyerOrderInvoicesEnvelopeBuilder() {
    BuyerOrderInvoicesEnvelope._defaults(this);
  }

  BuyerOrderInvoicesEnvelopeBuilder get _$this {
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
  void replace(BuyerOrderInvoicesEnvelope other) {
    _$v = other as _$BuyerOrderInvoicesEnvelope;
  }

  @override
  void update(void Function(BuyerOrderInvoicesEnvelopeBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  BuyerOrderInvoicesEnvelope build() => _build();

  _$BuyerOrderInvoicesEnvelope _build() {
    _$BuyerOrderInvoicesEnvelope _$result;
    try {
      _$result = _$v ??
          _$BuyerOrderInvoicesEnvelope._(
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
            r'BuyerOrderInvoicesEnvelope', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
