// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_product_analytics_summaries_envelope.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$VendorProductAnalyticsSummariesEnvelope
    extends VendorProductAnalyticsSummariesEnvelope {
  @override
  final VendorProductAnalyticsSummaries data;
  @override
  final BuiltMap<String, JsonObject?> meta;
  @override
  final BuiltList<BuiltMap<String, JsonObject?>> errors;

  factory _$VendorProductAnalyticsSummariesEnvelope(
          [void Function(VendorProductAnalyticsSummariesEnvelopeBuilder)?
              updates]) =>
      (VendorProductAnalyticsSummariesEnvelopeBuilder()..update(updates))
          ._build();

  _$VendorProductAnalyticsSummariesEnvelope._(
      {required this.data, required this.meta, required this.errors})
      : super._();
  @override
  VendorProductAnalyticsSummariesEnvelope rebuild(
          void Function(VendorProductAnalyticsSummariesEnvelopeBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  VendorProductAnalyticsSummariesEnvelopeBuilder toBuilder() =>
      VendorProductAnalyticsSummariesEnvelopeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is VendorProductAnalyticsSummariesEnvelope &&
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
            r'VendorProductAnalyticsSummariesEnvelope')
          ..add('data', data)
          ..add('meta', meta)
          ..add('errors', errors))
        .toString();
  }
}

class VendorProductAnalyticsSummariesEnvelopeBuilder
    implements
        Builder<VendorProductAnalyticsSummariesEnvelope,
            VendorProductAnalyticsSummariesEnvelopeBuilder> {
  _$VendorProductAnalyticsSummariesEnvelope? _$v;

  VendorProductAnalyticsSummariesBuilder? _data;
  VendorProductAnalyticsSummariesBuilder get data =>
      _$this._data ??= VendorProductAnalyticsSummariesBuilder();
  set data(VendorProductAnalyticsSummariesBuilder? data) => _$this._data = data;

  MapBuilder<String, JsonObject?>? _meta;
  MapBuilder<String, JsonObject?> get meta =>
      _$this._meta ??= MapBuilder<String, JsonObject?>();
  set meta(MapBuilder<String, JsonObject?>? meta) => _$this._meta = meta;

  ListBuilder<BuiltMap<String, JsonObject?>>? _errors;
  ListBuilder<BuiltMap<String, JsonObject?>> get errors =>
      _$this._errors ??= ListBuilder<BuiltMap<String, JsonObject?>>();
  set errors(ListBuilder<BuiltMap<String, JsonObject?>>? errors) =>
      _$this._errors = errors;

  VendorProductAnalyticsSummariesEnvelopeBuilder() {
    VendorProductAnalyticsSummariesEnvelope._defaults(this);
  }

  VendorProductAnalyticsSummariesEnvelopeBuilder get _$this {
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
  void replace(VendorProductAnalyticsSummariesEnvelope other) {
    _$v = other as _$VendorProductAnalyticsSummariesEnvelope;
  }

  @override
  void update(
      void Function(VendorProductAnalyticsSummariesEnvelopeBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  VendorProductAnalyticsSummariesEnvelope build() => _build();

  _$VendorProductAnalyticsSummariesEnvelope _build() {
    _$VendorProductAnalyticsSummariesEnvelope _$result;
    try {
      _$result = _$v ??
          _$VendorProductAnalyticsSummariesEnvelope._(
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
            r'VendorProductAnalyticsSummariesEnvelope',
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
