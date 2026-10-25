// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'buyer_analytics_product_list_envelope.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$BuyerAnalyticsProductListEnvelope
    extends BuyerAnalyticsProductListEnvelope {
  @override
  final BuyerAnalyticsProductList data;
  @override
  final BuiltMap<String, JsonObject?> meta;
  @override
  final BuiltList<ApiError> errors;

  factory _$BuyerAnalyticsProductListEnvelope(
          [void Function(BuyerAnalyticsProductListEnvelopeBuilder)? updates]) =>
      (BuyerAnalyticsProductListEnvelopeBuilder()..update(updates))._build();

  _$BuyerAnalyticsProductListEnvelope._(
      {required this.data, required this.meta, required this.errors})
      : super._();
  @override
  BuyerAnalyticsProductListEnvelope rebuild(
          void Function(BuyerAnalyticsProductListEnvelopeBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  BuyerAnalyticsProductListEnvelopeBuilder toBuilder() =>
      BuyerAnalyticsProductListEnvelopeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is BuyerAnalyticsProductListEnvelope &&
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
    return (newBuiltValueToStringHelper(r'BuyerAnalyticsProductListEnvelope')
          ..add('data', data)
          ..add('meta', meta)
          ..add('errors', errors))
        .toString();
  }
}

class BuyerAnalyticsProductListEnvelopeBuilder
    implements
        Builder<BuyerAnalyticsProductListEnvelope,
            BuyerAnalyticsProductListEnvelopeBuilder> {
  _$BuyerAnalyticsProductListEnvelope? _$v;

  BuyerAnalyticsProductListBuilder? _data;
  BuyerAnalyticsProductListBuilder get data =>
      _$this._data ??= BuyerAnalyticsProductListBuilder();
  set data(BuyerAnalyticsProductListBuilder? data) => _$this._data = data;

  MapBuilder<String, JsonObject?>? _meta;
  MapBuilder<String, JsonObject?> get meta =>
      _$this._meta ??= MapBuilder<String, JsonObject?>();
  set meta(MapBuilder<String, JsonObject?>? meta) => _$this._meta = meta;

  ListBuilder<ApiError>? _errors;
  ListBuilder<ApiError> get errors =>
      _$this._errors ??= ListBuilder<ApiError>();
  set errors(ListBuilder<ApiError>? errors) => _$this._errors = errors;

  BuyerAnalyticsProductListEnvelopeBuilder() {
    BuyerAnalyticsProductListEnvelope._defaults(this);
  }

  BuyerAnalyticsProductListEnvelopeBuilder get _$this {
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
  void replace(BuyerAnalyticsProductListEnvelope other) {
    _$v = other as _$BuyerAnalyticsProductListEnvelope;
  }

  @override
  void update(
      void Function(BuyerAnalyticsProductListEnvelopeBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  BuyerAnalyticsProductListEnvelope build() => _build();

  _$BuyerAnalyticsProductListEnvelope _build() {
    _$BuyerAnalyticsProductListEnvelope _$result;
    try {
      _$result = _$v ??
          _$BuyerAnalyticsProductListEnvelope._(
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
            r'BuyerAnalyticsProductListEnvelope', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
