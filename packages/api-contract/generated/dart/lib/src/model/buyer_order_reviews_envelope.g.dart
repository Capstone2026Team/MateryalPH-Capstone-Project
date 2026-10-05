// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'buyer_order_reviews_envelope.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$BuyerOrderReviewsEnvelope extends BuyerOrderReviewsEnvelope {
  @override
  final BuyerOrderReviews data;
  @override
  final BuiltMap<String, JsonObject?> meta;
  @override
  final BuiltList<ApiError> errors;

  factory _$BuyerOrderReviewsEnvelope(
          [void Function(BuyerOrderReviewsEnvelopeBuilder)? updates]) =>
      (BuyerOrderReviewsEnvelopeBuilder()..update(updates))._build();

  _$BuyerOrderReviewsEnvelope._(
      {required this.data, required this.meta, required this.errors})
      : super._();
  @override
  BuyerOrderReviewsEnvelope rebuild(
          void Function(BuyerOrderReviewsEnvelopeBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  BuyerOrderReviewsEnvelopeBuilder toBuilder() =>
      BuyerOrderReviewsEnvelopeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is BuyerOrderReviewsEnvelope &&
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
    return (newBuiltValueToStringHelper(r'BuyerOrderReviewsEnvelope')
          ..add('data', data)
          ..add('meta', meta)
          ..add('errors', errors))
        .toString();
  }
}

class BuyerOrderReviewsEnvelopeBuilder
    implements
        Builder<BuyerOrderReviewsEnvelope, BuyerOrderReviewsEnvelopeBuilder> {
  _$BuyerOrderReviewsEnvelope? _$v;

  BuyerOrderReviewsBuilder? _data;
  BuyerOrderReviewsBuilder get data =>
      _$this._data ??= BuyerOrderReviewsBuilder();
  set data(BuyerOrderReviewsBuilder? data) => _$this._data = data;

  MapBuilder<String, JsonObject?>? _meta;
  MapBuilder<String, JsonObject?> get meta =>
      _$this._meta ??= MapBuilder<String, JsonObject?>();
  set meta(MapBuilder<String, JsonObject?>? meta) => _$this._meta = meta;

  ListBuilder<ApiError>? _errors;
  ListBuilder<ApiError> get errors =>
      _$this._errors ??= ListBuilder<ApiError>();
  set errors(ListBuilder<ApiError>? errors) => _$this._errors = errors;

  BuyerOrderReviewsEnvelopeBuilder() {
    BuyerOrderReviewsEnvelope._defaults(this);
  }

  BuyerOrderReviewsEnvelopeBuilder get _$this {
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
  void replace(BuyerOrderReviewsEnvelope other) {
    _$v = other as _$BuyerOrderReviewsEnvelope;
  }

  @override
  void update(void Function(BuyerOrderReviewsEnvelopeBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  BuyerOrderReviewsEnvelope build() => _build();

  _$BuyerOrderReviewsEnvelope _build() {
    _$BuyerOrderReviewsEnvelope _$result;
    try {
      _$result = _$v ??
          _$BuyerOrderReviewsEnvelope._(
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
            r'BuyerOrderReviewsEnvelope', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
