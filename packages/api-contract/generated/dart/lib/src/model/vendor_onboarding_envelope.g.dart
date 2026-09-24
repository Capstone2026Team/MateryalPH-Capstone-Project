// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_onboarding_envelope.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$VendorOnboardingEnvelope extends VendorOnboardingEnvelope {
  @override
  final VendorOnboardingSnapshot data;
  @override
  final BuiltMap<String, JsonObject?> meta;
  @override
  final BuiltList<BuiltMap<String, JsonObject?>> errors;

  factory _$VendorOnboardingEnvelope(
          [void Function(VendorOnboardingEnvelopeBuilder)? updates]) =>
      (VendorOnboardingEnvelopeBuilder()..update(updates))._build();

  _$VendorOnboardingEnvelope._(
      {required this.data, required this.meta, required this.errors})
      : super._();
  @override
  VendorOnboardingEnvelope rebuild(
          void Function(VendorOnboardingEnvelopeBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  VendorOnboardingEnvelopeBuilder toBuilder() =>
      VendorOnboardingEnvelopeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is VendorOnboardingEnvelope &&
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
    return (newBuiltValueToStringHelper(r'VendorOnboardingEnvelope')
          ..add('data', data)
          ..add('meta', meta)
          ..add('errors', errors))
        .toString();
  }
}

class VendorOnboardingEnvelopeBuilder
    implements
        Builder<VendorOnboardingEnvelope, VendorOnboardingEnvelopeBuilder> {
  _$VendorOnboardingEnvelope? _$v;

  VendorOnboardingSnapshotBuilder? _data;
  VendorOnboardingSnapshotBuilder get data =>
      _$this._data ??= VendorOnboardingSnapshotBuilder();
  set data(VendorOnboardingSnapshotBuilder? data) => _$this._data = data;

  MapBuilder<String, JsonObject?>? _meta;
  MapBuilder<String, JsonObject?> get meta =>
      _$this._meta ??= MapBuilder<String, JsonObject?>();
  set meta(MapBuilder<String, JsonObject?>? meta) => _$this._meta = meta;

  ListBuilder<BuiltMap<String, JsonObject?>>? _errors;
  ListBuilder<BuiltMap<String, JsonObject?>> get errors =>
      _$this._errors ??= ListBuilder<BuiltMap<String, JsonObject?>>();
  set errors(ListBuilder<BuiltMap<String, JsonObject?>>? errors) =>
      _$this._errors = errors;

  VendorOnboardingEnvelopeBuilder() {
    VendorOnboardingEnvelope._defaults(this);
  }

  VendorOnboardingEnvelopeBuilder get _$this {
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
  void replace(VendorOnboardingEnvelope other) {
    _$v = other as _$VendorOnboardingEnvelope;
  }

  @override
  void update(void Function(VendorOnboardingEnvelopeBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  VendorOnboardingEnvelope build() => _build();

  _$VendorOnboardingEnvelope _build() {
    _$VendorOnboardingEnvelope _$result;
    try {
      _$result = _$v ??
          _$VendorOnboardingEnvelope._(
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
            r'VendorOnboardingEnvelope', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
