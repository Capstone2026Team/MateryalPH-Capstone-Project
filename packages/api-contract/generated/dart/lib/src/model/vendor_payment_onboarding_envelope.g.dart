// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_payment_onboarding_envelope.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$VendorPaymentOnboardingEnvelope
    extends VendorPaymentOnboardingEnvelope {
  @override
  final VendorPaymentOnboarding data;
  @override
  final BuiltMap<String, JsonObject?> meta;
  @override
  final BuiltList<BuiltMap<String, JsonObject?>> errors;

  factory _$VendorPaymentOnboardingEnvelope(
          [void Function(VendorPaymentOnboardingEnvelopeBuilder)? updates]) =>
      (VendorPaymentOnboardingEnvelopeBuilder()..update(updates))._build();

  _$VendorPaymentOnboardingEnvelope._(
      {required this.data, required this.meta, required this.errors})
      : super._();
  @override
  VendorPaymentOnboardingEnvelope rebuild(
          void Function(VendorPaymentOnboardingEnvelopeBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  VendorPaymentOnboardingEnvelopeBuilder toBuilder() =>
      VendorPaymentOnboardingEnvelopeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is VendorPaymentOnboardingEnvelope &&
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
    return (newBuiltValueToStringHelper(r'VendorPaymentOnboardingEnvelope')
          ..add('data', data)
          ..add('meta', meta)
          ..add('errors', errors))
        .toString();
  }
}

class VendorPaymentOnboardingEnvelopeBuilder
    implements
        Builder<VendorPaymentOnboardingEnvelope,
            VendorPaymentOnboardingEnvelopeBuilder> {
  _$VendorPaymentOnboardingEnvelope? _$v;

  VendorPaymentOnboardingBuilder? _data;
  VendorPaymentOnboardingBuilder get data =>
      _$this._data ??= VendorPaymentOnboardingBuilder();
  set data(VendorPaymentOnboardingBuilder? data) => _$this._data = data;

  MapBuilder<String, JsonObject?>? _meta;
  MapBuilder<String, JsonObject?> get meta =>
      _$this._meta ??= MapBuilder<String, JsonObject?>();
  set meta(MapBuilder<String, JsonObject?>? meta) => _$this._meta = meta;

  ListBuilder<BuiltMap<String, JsonObject?>>? _errors;
  ListBuilder<BuiltMap<String, JsonObject?>> get errors =>
      _$this._errors ??= ListBuilder<BuiltMap<String, JsonObject?>>();
  set errors(ListBuilder<BuiltMap<String, JsonObject?>>? errors) =>
      _$this._errors = errors;

  VendorPaymentOnboardingEnvelopeBuilder() {
    VendorPaymentOnboardingEnvelope._defaults(this);
  }

  VendorPaymentOnboardingEnvelopeBuilder get _$this {
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
  void replace(VendorPaymentOnboardingEnvelope other) {
    _$v = other as _$VendorPaymentOnboardingEnvelope;
  }

  @override
  void update(void Function(VendorPaymentOnboardingEnvelopeBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  VendorPaymentOnboardingEnvelope build() => _build();

  _$VendorPaymentOnboardingEnvelope _build() {
    _$VendorPaymentOnboardingEnvelope _$result;
    try {
      _$result = _$v ??
          _$VendorPaymentOnboardingEnvelope._(
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
            r'VendorPaymentOnboardingEnvelope', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
