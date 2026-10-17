// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_product_analytics_detail_envelope.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$VendorProductAnalyticsDetailEnvelope
    extends VendorProductAnalyticsDetailEnvelope {
  @override
  final VendorProductAnalyticsDetail data;
  @override
  final BuiltMap<String, JsonObject?> meta;
  @override
  final BuiltList<BuiltMap<String, JsonObject?>> errors;

  factory _$VendorProductAnalyticsDetailEnvelope(
          [void Function(VendorProductAnalyticsDetailEnvelopeBuilder)?
              updates]) =>
      (VendorProductAnalyticsDetailEnvelopeBuilder()..update(updates))._build();

  _$VendorProductAnalyticsDetailEnvelope._(
      {required this.data, required this.meta, required this.errors})
      : super._();
  @override
  VendorProductAnalyticsDetailEnvelope rebuild(
          void Function(VendorProductAnalyticsDetailEnvelopeBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  VendorProductAnalyticsDetailEnvelopeBuilder toBuilder() =>
      VendorProductAnalyticsDetailEnvelopeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is VendorProductAnalyticsDetailEnvelope &&
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
    return (newBuiltValueToStringHelper(r'VendorProductAnalyticsDetailEnvelope')
          ..add('data', data)
          ..add('meta', meta)
          ..add('errors', errors))
        .toString();
  }
}

class VendorProductAnalyticsDetailEnvelopeBuilder
    implements
        Builder<VendorProductAnalyticsDetailEnvelope,
            VendorProductAnalyticsDetailEnvelopeBuilder> {
  _$VendorProductAnalyticsDetailEnvelope? _$v;

  VendorProductAnalyticsDetailBuilder? _data;
  VendorProductAnalyticsDetailBuilder get data =>
      _$this._data ??= VendorProductAnalyticsDetailBuilder();
  set data(VendorProductAnalyticsDetailBuilder? data) => _$this._data = data;

  MapBuilder<String, JsonObject?>? _meta;
  MapBuilder<String, JsonObject?> get meta =>
      _$this._meta ??= MapBuilder<String, JsonObject?>();
  set meta(MapBuilder<String, JsonObject?>? meta) => _$this._meta = meta;

  ListBuilder<BuiltMap<String, JsonObject?>>? _errors;
  ListBuilder<BuiltMap<String, JsonObject?>> get errors =>
      _$this._errors ??= ListBuilder<BuiltMap<String, JsonObject?>>();
  set errors(ListBuilder<BuiltMap<String, JsonObject?>>? errors) =>
      _$this._errors = errors;

  VendorProductAnalyticsDetailEnvelopeBuilder() {
    VendorProductAnalyticsDetailEnvelope._defaults(this);
  }

  VendorProductAnalyticsDetailEnvelopeBuilder get _$this {
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
  void replace(VendorProductAnalyticsDetailEnvelope other) {
    _$v = other as _$VendorProductAnalyticsDetailEnvelope;
  }

  @override
  void update(
      void Function(VendorProductAnalyticsDetailEnvelopeBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  VendorProductAnalyticsDetailEnvelope build() => _build();

  _$VendorProductAnalyticsDetailEnvelope _build() {
    _$VendorProductAnalyticsDetailEnvelope _$result;
    try {
      _$result = _$v ??
          _$VendorProductAnalyticsDetailEnvelope._(
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
            r'VendorProductAnalyticsDetailEnvelope',
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
