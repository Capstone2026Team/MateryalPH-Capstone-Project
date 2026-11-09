// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'buyer_received_ratings_envelope.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$BuyerReceivedRatingsEnvelope extends BuyerReceivedRatingsEnvelope {
  @override
  final BuiltList<BuyerReceivedRating> data;
  @override
  final BuyerReceivedRatingsMeta meta;
  @override
  final BuiltList<ApiError> errors;

  factory _$BuyerReceivedRatingsEnvelope(
          [void Function(BuyerReceivedRatingsEnvelopeBuilder)? updates]) =>
      (BuyerReceivedRatingsEnvelopeBuilder()..update(updates))._build();

  _$BuyerReceivedRatingsEnvelope._(
      {required this.data, required this.meta, required this.errors})
      : super._();
  @override
  BuyerReceivedRatingsEnvelope rebuild(
          void Function(BuyerReceivedRatingsEnvelopeBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  BuyerReceivedRatingsEnvelopeBuilder toBuilder() =>
      BuyerReceivedRatingsEnvelopeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is BuyerReceivedRatingsEnvelope &&
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
    return (newBuiltValueToStringHelper(r'BuyerReceivedRatingsEnvelope')
          ..add('data', data)
          ..add('meta', meta)
          ..add('errors', errors))
        .toString();
  }
}

class BuyerReceivedRatingsEnvelopeBuilder
    implements
        Builder<BuyerReceivedRatingsEnvelope,
            BuyerReceivedRatingsEnvelopeBuilder> {
  _$BuyerReceivedRatingsEnvelope? _$v;

  ListBuilder<BuyerReceivedRating>? _data;
  ListBuilder<BuyerReceivedRating> get data =>
      _$this._data ??= ListBuilder<BuyerReceivedRating>();
  set data(ListBuilder<BuyerReceivedRating>? data) => _$this._data = data;

  BuyerReceivedRatingsMetaBuilder? _meta;
  BuyerReceivedRatingsMetaBuilder get meta =>
      _$this._meta ??= BuyerReceivedRatingsMetaBuilder();
  set meta(BuyerReceivedRatingsMetaBuilder? meta) => _$this._meta = meta;

  ListBuilder<ApiError>? _errors;
  ListBuilder<ApiError> get errors =>
      _$this._errors ??= ListBuilder<ApiError>();
  set errors(ListBuilder<ApiError>? errors) => _$this._errors = errors;

  BuyerReceivedRatingsEnvelopeBuilder() {
    BuyerReceivedRatingsEnvelope._defaults(this);
  }

  BuyerReceivedRatingsEnvelopeBuilder get _$this {
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
  void replace(BuyerReceivedRatingsEnvelope other) {
    _$v = other as _$BuyerReceivedRatingsEnvelope;
  }

  @override
  void update(void Function(BuyerReceivedRatingsEnvelopeBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  BuyerReceivedRatingsEnvelope build() => _build();

  _$BuyerReceivedRatingsEnvelope _build() {
    _$BuyerReceivedRatingsEnvelope _$result;
    try {
      _$result = _$v ??
          _$BuyerReceivedRatingsEnvelope._(
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
            r'BuyerReceivedRatingsEnvelope', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
