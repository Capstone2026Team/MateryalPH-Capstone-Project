// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_materials_analytics_detail_envelope.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$VendorMaterialsAnalyticsDetailEnvelope
    extends VendorMaterialsAnalyticsDetailEnvelope {
  @override
  final VendorMaterialsAnalyticsDetail data;
  @override
  final BuiltMap<String, JsonObject?> meta;
  @override
  final BuiltList<ApiError> errors;

  factory _$VendorMaterialsAnalyticsDetailEnvelope(
          [void Function(VendorMaterialsAnalyticsDetailEnvelopeBuilder)?
              updates]) =>
      (VendorMaterialsAnalyticsDetailEnvelopeBuilder()..update(updates))
          ._build();

  _$VendorMaterialsAnalyticsDetailEnvelope._(
      {required this.data, required this.meta, required this.errors})
      : super._();
  @override
  VendorMaterialsAnalyticsDetailEnvelope rebuild(
          void Function(VendorMaterialsAnalyticsDetailEnvelopeBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  VendorMaterialsAnalyticsDetailEnvelopeBuilder toBuilder() =>
      VendorMaterialsAnalyticsDetailEnvelopeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is VendorMaterialsAnalyticsDetailEnvelope &&
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
            r'VendorMaterialsAnalyticsDetailEnvelope')
          ..add('data', data)
          ..add('meta', meta)
          ..add('errors', errors))
        .toString();
  }
}

class VendorMaterialsAnalyticsDetailEnvelopeBuilder
    implements
        Builder<VendorMaterialsAnalyticsDetailEnvelope,
            VendorMaterialsAnalyticsDetailEnvelopeBuilder> {
  _$VendorMaterialsAnalyticsDetailEnvelope? _$v;

  VendorMaterialsAnalyticsDetailBuilder? _data;
  VendorMaterialsAnalyticsDetailBuilder get data =>
      _$this._data ??= VendorMaterialsAnalyticsDetailBuilder();
  set data(VendorMaterialsAnalyticsDetailBuilder? data) => _$this._data = data;

  MapBuilder<String, JsonObject?>? _meta;
  MapBuilder<String, JsonObject?> get meta =>
      _$this._meta ??= MapBuilder<String, JsonObject?>();
  set meta(MapBuilder<String, JsonObject?>? meta) => _$this._meta = meta;

  ListBuilder<ApiError>? _errors;
  ListBuilder<ApiError> get errors =>
      _$this._errors ??= ListBuilder<ApiError>();
  set errors(ListBuilder<ApiError>? errors) => _$this._errors = errors;

  VendorMaterialsAnalyticsDetailEnvelopeBuilder() {
    VendorMaterialsAnalyticsDetailEnvelope._defaults(this);
  }

  VendorMaterialsAnalyticsDetailEnvelopeBuilder get _$this {
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
  void replace(VendorMaterialsAnalyticsDetailEnvelope other) {
    _$v = other as _$VendorMaterialsAnalyticsDetailEnvelope;
  }

  @override
  void update(
      void Function(VendorMaterialsAnalyticsDetailEnvelopeBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  VendorMaterialsAnalyticsDetailEnvelope build() => _build();

  _$VendorMaterialsAnalyticsDetailEnvelope _build() {
    _$VendorMaterialsAnalyticsDetailEnvelope _$result;
    try {
      _$result = _$v ??
          _$VendorMaterialsAnalyticsDetailEnvelope._(
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
            r'VendorMaterialsAnalyticsDetailEnvelope',
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
