// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_team_performance_envelope.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$VendorTeamPerformanceEnvelope extends VendorTeamPerformanceEnvelope {
  @override
  final VendorTeamPerformance data;
  @override
  final BuiltMap<String, JsonObject?> meta;
  @override
  final BuiltList<BuiltMap<String, JsonObject?>> errors;

  factory _$VendorTeamPerformanceEnvelope(
          [void Function(VendorTeamPerformanceEnvelopeBuilder)? updates]) =>
      (VendorTeamPerformanceEnvelopeBuilder()..update(updates))._build();

  _$VendorTeamPerformanceEnvelope._(
      {required this.data, required this.meta, required this.errors})
      : super._();
  @override
  VendorTeamPerformanceEnvelope rebuild(
          void Function(VendorTeamPerformanceEnvelopeBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  VendorTeamPerformanceEnvelopeBuilder toBuilder() =>
      VendorTeamPerformanceEnvelopeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is VendorTeamPerformanceEnvelope &&
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
    return (newBuiltValueToStringHelper(r'VendorTeamPerformanceEnvelope')
          ..add('data', data)
          ..add('meta', meta)
          ..add('errors', errors))
        .toString();
  }
}

class VendorTeamPerformanceEnvelopeBuilder
    implements
        Builder<VendorTeamPerformanceEnvelope,
            VendorTeamPerformanceEnvelopeBuilder> {
  _$VendorTeamPerformanceEnvelope? _$v;

  VendorTeamPerformanceBuilder? _data;
  VendorTeamPerformanceBuilder get data =>
      _$this._data ??= VendorTeamPerformanceBuilder();
  set data(VendorTeamPerformanceBuilder? data) => _$this._data = data;

  MapBuilder<String, JsonObject?>? _meta;
  MapBuilder<String, JsonObject?> get meta =>
      _$this._meta ??= MapBuilder<String, JsonObject?>();
  set meta(MapBuilder<String, JsonObject?>? meta) => _$this._meta = meta;

  ListBuilder<BuiltMap<String, JsonObject?>>? _errors;
  ListBuilder<BuiltMap<String, JsonObject?>> get errors =>
      _$this._errors ??= ListBuilder<BuiltMap<String, JsonObject?>>();
  set errors(ListBuilder<BuiltMap<String, JsonObject?>>? errors) =>
      _$this._errors = errors;

  VendorTeamPerformanceEnvelopeBuilder() {
    VendorTeamPerformanceEnvelope._defaults(this);
  }

  VendorTeamPerformanceEnvelopeBuilder get _$this {
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
  void replace(VendorTeamPerformanceEnvelope other) {
    _$v = other as _$VendorTeamPerformanceEnvelope;
  }

  @override
  void update(void Function(VendorTeamPerformanceEnvelopeBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  VendorTeamPerformanceEnvelope build() => _build();

  _$VendorTeamPerformanceEnvelope _build() {
    _$VendorTeamPerformanceEnvelope _$result;
    try {
      _$result = _$v ??
          _$VendorTeamPerformanceEnvelope._(
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
            r'VendorTeamPerformanceEnvelope', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
