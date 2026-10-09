// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_finance_reviews_envelope.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$VendorFinanceReviewsEnvelope extends VendorFinanceReviewsEnvelope {
  @override
  final VendorFinanceReviews data;
  @override
  final BuiltMap<String, JsonObject?> meta;
  @override
  final BuiltList<ApiError> errors;

  factory _$VendorFinanceReviewsEnvelope(
          [void Function(VendorFinanceReviewsEnvelopeBuilder)? updates]) =>
      (VendorFinanceReviewsEnvelopeBuilder()..update(updates))._build();

  _$VendorFinanceReviewsEnvelope._(
      {required this.data, required this.meta, required this.errors})
      : super._();
  @override
  VendorFinanceReviewsEnvelope rebuild(
          void Function(VendorFinanceReviewsEnvelopeBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  VendorFinanceReviewsEnvelopeBuilder toBuilder() =>
      VendorFinanceReviewsEnvelopeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is VendorFinanceReviewsEnvelope &&
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
    return (newBuiltValueToStringHelper(r'VendorFinanceReviewsEnvelope')
          ..add('data', data)
          ..add('meta', meta)
          ..add('errors', errors))
        .toString();
  }
}

class VendorFinanceReviewsEnvelopeBuilder
    implements
        Builder<VendorFinanceReviewsEnvelope,
            VendorFinanceReviewsEnvelopeBuilder> {
  _$VendorFinanceReviewsEnvelope? _$v;

  VendorFinanceReviewsBuilder? _data;
  VendorFinanceReviewsBuilder get data =>
      _$this._data ??= VendorFinanceReviewsBuilder();
  set data(VendorFinanceReviewsBuilder? data) => _$this._data = data;

  MapBuilder<String, JsonObject?>? _meta;
  MapBuilder<String, JsonObject?> get meta =>
      _$this._meta ??= MapBuilder<String, JsonObject?>();
  set meta(MapBuilder<String, JsonObject?>? meta) => _$this._meta = meta;

  ListBuilder<ApiError>? _errors;
  ListBuilder<ApiError> get errors =>
      _$this._errors ??= ListBuilder<ApiError>();
  set errors(ListBuilder<ApiError>? errors) => _$this._errors = errors;

  VendorFinanceReviewsEnvelopeBuilder() {
    VendorFinanceReviewsEnvelope._defaults(this);
  }

  VendorFinanceReviewsEnvelopeBuilder get _$this {
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
  void replace(VendorFinanceReviewsEnvelope other) {
    _$v = other as _$VendorFinanceReviewsEnvelope;
  }

  @override
  void update(void Function(VendorFinanceReviewsEnvelopeBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  VendorFinanceReviewsEnvelope build() => _build();

  _$VendorFinanceReviewsEnvelope _build() {
    _$VendorFinanceReviewsEnvelope _$result;
    try {
      _$result = _$v ??
          _$VendorFinanceReviewsEnvelope._(
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
            r'VendorFinanceReviewsEnvelope', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
