// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_materials_analytics_list_envelope.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$VendorMaterialsAnalyticsListEnvelope
    extends VendorMaterialsAnalyticsListEnvelope {
  @override
  final VendorMaterialsAnalyticsList data;
  @override
  final BuiltMap<String, JsonObject?> meta;
  @override
  final BuiltList<ApiError> errors;

  factory _$VendorMaterialsAnalyticsListEnvelope(
          [void Function(VendorMaterialsAnalyticsListEnvelopeBuilder)?
              updates]) =>
      (VendorMaterialsAnalyticsListEnvelopeBuilder()..update(updates))._build();

  _$VendorMaterialsAnalyticsListEnvelope._(
      {required this.data, required this.meta, required this.errors})
      : super._();
  @override
  VendorMaterialsAnalyticsListEnvelope rebuild(
          void Function(VendorMaterialsAnalyticsListEnvelopeBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  VendorMaterialsAnalyticsListEnvelopeBuilder toBuilder() =>
      VendorMaterialsAnalyticsListEnvelopeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is VendorMaterialsAnalyticsListEnvelope &&
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
    return (newBuiltValueToStringHelper(r'VendorMaterialsAnalyticsListEnvelope')
          ..add('data', data)
          ..add('meta', meta)
          ..add('errors', errors))
        .toString();
  }
}

class VendorMaterialsAnalyticsListEnvelopeBuilder
    implements
        Builder<VendorMaterialsAnalyticsListEnvelope,
            VendorMaterialsAnalyticsListEnvelopeBuilder> {
  _$VendorMaterialsAnalyticsListEnvelope? _$v;

  VendorMaterialsAnalyticsListBuilder? _data;
  VendorMaterialsAnalyticsListBuilder get data =>
      _$this._data ??= VendorMaterialsAnalyticsListBuilder();
  set data(VendorMaterialsAnalyticsListBuilder? data) => _$this._data = data;

  MapBuilder<String, JsonObject?>? _meta;
  MapBuilder<String, JsonObject?> get meta =>
      _$this._meta ??= MapBuilder<String, JsonObject?>();
  set meta(MapBuilder<String, JsonObject?>? meta) => _$this._meta = meta;

  ListBuilder<ApiError>? _errors;
  ListBuilder<ApiError> get errors =>
      _$this._errors ??= ListBuilder<ApiError>();
  set errors(ListBuilder<ApiError>? errors) => _$this._errors = errors;

  VendorMaterialsAnalyticsListEnvelopeBuilder() {
    VendorMaterialsAnalyticsListEnvelope._defaults(this);
  }

  VendorMaterialsAnalyticsListEnvelopeBuilder get _$this {
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
  void replace(VendorMaterialsAnalyticsListEnvelope other) {
    _$v = other as _$VendorMaterialsAnalyticsListEnvelope;
  }

  @override
  void update(
      void Function(VendorMaterialsAnalyticsListEnvelopeBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  VendorMaterialsAnalyticsListEnvelope build() => _build();

  _$VendorMaterialsAnalyticsListEnvelope _build() {
    _$VendorMaterialsAnalyticsListEnvelope _$result;
    try {
      _$result = _$v ??
          _$VendorMaterialsAnalyticsListEnvelope._(
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
            r'VendorMaterialsAnalyticsListEnvelope',
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
