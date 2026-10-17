// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'buyer_materials_analytics_detail_envelope.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$BuyerMaterialsAnalyticsDetailEnvelope
    extends BuyerMaterialsAnalyticsDetailEnvelope {
  @override
  final BuyerMaterialsAnalyticsDetail data;
  @override
  final BuiltMap<String, JsonObject?> meta;
  @override
  final BuiltList<ApiError> errors;

  factory _$BuyerMaterialsAnalyticsDetailEnvelope(
          [void Function(BuyerMaterialsAnalyticsDetailEnvelopeBuilder)?
              updates]) =>
      (BuyerMaterialsAnalyticsDetailEnvelopeBuilder()..update(updates))
          ._build();

  _$BuyerMaterialsAnalyticsDetailEnvelope._(
      {required this.data, required this.meta, required this.errors})
      : super._();
  @override
  BuyerMaterialsAnalyticsDetailEnvelope rebuild(
          void Function(BuyerMaterialsAnalyticsDetailEnvelopeBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  BuyerMaterialsAnalyticsDetailEnvelopeBuilder toBuilder() =>
      BuyerMaterialsAnalyticsDetailEnvelopeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is BuyerMaterialsAnalyticsDetailEnvelope &&
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
    return (newBuiltValueToStringHelper(
            r'BuyerMaterialsAnalyticsDetailEnvelope')
          ..add('data', data)
          ..add('meta', meta)
          ..add('errors', errors))
        .toString();
  }
}

class BuyerMaterialsAnalyticsDetailEnvelopeBuilder
    implements
        Builder<BuyerMaterialsAnalyticsDetailEnvelope,
            BuyerMaterialsAnalyticsDetailEnvelopeBuilder> {
  _$BuyerMaterialsAnalyticsDetailEnvelope? _$v;

  BuyerMaterialsAnalyticsDetailBuilder? _data;
  BuyerMaterialsAnalyticsDetailBuilder get data =>
      _$this._data ??= BuyerMaterialsAnalyticsDetailBuilder();
  set data(BuyerMaterialsAnalyticsDetailBuilder? data) => _$this._data = data;

  MapBuilder<String, JsonObject?>? _meta;
  MapBuilder<String, JsonObject?> get meta =>
      _$this._meta ??= MapBuilder<String, JsonObject?>();
  set meta(MapBuilder<String, JsonObject?>? meta) => _$this._meta = meta;

  ListBuilder<ApiError>? _errors;
  ListBuilder<ApiError> get errors =>
      _$this._errors ??= ListBuilder<ApiError>();
  set errors(ListBuilder<ApiError>? errors) => _$this._errors = errors;

  BuyerMaterialsAnalyticsDetailEnvelopeBuilder() {
    BuyerMaterialsAnalyticsDetailEnvelope._defaults(this);
  }

  BuyerMaterialsAnalyticsDetailEnvelopeBuilder get _$this {
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
  void replace(BuyerMaterialsAnalyticsDetailEnvelope other) {
    _$v = other as _$BuyerMaterialsAnalyticsDetailEnvelope;
  }

  @override
  void update(
      void Function(BuyerMaterialsAnalyticsDetailEnvelopeBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  BuyerMaterialsAnalyticsDetailEnvelope build() => _build();

  _$BuyerMaterialsAnalyticsDetailEnvelope _build() {
    _$BuyerMaterialsAnalyticsDetailEnvelope _$result;
    try {
      _$result = _$v ??
          _$BuyerMaterialsAnalyticsDetailEnvelope._(
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
            r'BuyerMaterialsAnalyticsDetailEnvelope',
            _$failedField,
            e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
