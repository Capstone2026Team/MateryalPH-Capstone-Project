// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_workstreams.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$VendorWorkstreams extends VendorWorkstreams {
  @override
  final VendorWorkstreamsVerification verification;
  @override
  final VendorWorkstreamsVerification setup;
  @override
  final VendorWorkstreamsProviderReadiness providerReadiness;
  @override
  final VendorWorkstreamsActivation activation;
  @override
  final VendorWorkstreamsDiscoverability discoverability;

  factory _$VendorWorkstreams(
          [void Function(VendorWorkstreamsBuilder)? updates]) =>
      (VendorWorkstreamsBuilder()..update(updates))._build();

  _$VendorWorkstreams._(
      {required this.verification,
      required this.setup,
      required this.providerReadiness,
      required this.activation,
      required this.discoverability})
      : super._();
  @override
  VendorWorkstreams rebuild(void Function(VendorWorkstreamsBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  VendorWorkstreamsBuilder toBuilder() =>
      VendorWorkstreamsBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is VendorWorkstreams &&
        verification == other.verification &&
        setup == other.setup &&
        providerReadiness == other.providerReadiness &&
        activation == other.activation &&
        discoverability == other.discoverability;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, verification.hashCode);
    _$hash = $jc(_$hash, setup.hashCode);
    _$hash = $jc(_$hash, providerReadiness.hashCode);
    _$hash = $jc(_$hash, activation.hashCode);
    _$hash = $jc(_$hash, discoverability.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'VendorWorkstreams')
          ..add('verification', verification)
          ..add('setup', setup)
          ..add('providerReadiness', providerReadiness)
          ..add('activation', activation)
          ..add('discoverability', discoverability))
        .toString();
  }
}

class VendorWorkstreamsBuilder
    implements Builder<VendorWorkstreams, VendorWorkstreamsBuilder> {
  _$VendorWorkstreams? _$v;

  VendorWorkstreamsVerificationBuilder? _verification;
  VendorWorkstreamsVerificationBuilder get verification =>
      _$this._verification ??= VendorWorkstreamsVerificationBuilder();
  set verification(VendorWorkstreamsVerificationBuilder? verification) =>
      _$this._verification = verification;

  VendorWorkstreamsVerificationBuilder? _setup;
  VendorWorkstreamsVerificationBuilder get setup =>
      _$this._setup ??= VendorWorkstreamsVerificationBuilder();
  set setup(VendorWorkstreamsVerificationBuilder? setup) =>
      _$this._setup = setup;

  VendorWorkstreamsProviderReadinessBuilder? _providerReadiness;
  VendorWorkstreamsProviderReadinessBuilder get providerReadiness =>
      _$this._providerReadiness ??= VendorWorkstreamsProviderReadinessBuilder();
  set providerReadiness(
          VendorWorkstreamsProviderReadinessBuilder? providerReadiness) =>
      _$this._providerReadiness = providerReadiness;

  VendorWorkstreamsActivationBuilder? _activation;
  VendorWorkstreamsActivationBuilder get activation =>
      _$this._activation ??= VendorWorkstreamsActivationBuilder();
  set activation(VendorWorkstreamsActivationBuilder? activation) =>
      _$this._activation = activation;

  VendorWorkstreamsDiscoverabilityBuilder? _discoverability;
  VendorWorkstreamsDiscoverabilityBuilder get discoverability =>
      _$this._discoverability ??= VendorWorkstreamsDiscoverabilityBuilder();
  set discoverability(
          VendorWorkstreamsDiscoverabilityBuilder? discoverability) =>
      _$this._discoverability = discoverability;

  VendorWorkstreamsBuilder() {
    VendorWorkstreams._defaults(this);
  }

  VendorWorkstreamsBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _verification = $v.verification.toBuilder();
      _setup = $v.setup.toBuilder();
      _providerReadiness = $v.providerReadiness.toBuilder();
      _activation = $v.activation.toBuilder();
      _discoverability = $v.discoverability.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(VendorWorkstreams other) {
    _$v = other as _$VendorWorkstreams;
  }

  @override
  void update(void Function(VendorWorkstreamsBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  VendorWorkstreams build() => _build();

  _$VendorWorkstreams _build() {
    _$VendorWorkstreams _$result;
    try {
      _$result = _$v ??
          _$VendorWorkstreams._(
            verification: verification.build(),
            setup: setup.build(),
            providerReadiness: providerReadiness.build(),
            activation: activation.build(),
            discoverability: discoverability.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'verification';
        verification.build();
        _$failedField = 'setup';
        setup.build();
        _$failedField = 'providerReadiness';
        providerReadiness.build();
        _$failedField = 'activation';
        activation.build();
        _$failedField = 'discoverability';
        discoverability.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'VendorWorkstreams', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
