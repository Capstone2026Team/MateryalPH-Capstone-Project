// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_commission_terms.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$VendorCommissionTerms extends VendorCommissionTerms {
  @override
  final BuiltMap<String, JsonObject?>? agreement;
  @override
  final int commissionBasisPoints;
  @override
  final String basis;
  @override
  final String cadence;
  @override
  final String environment;
  @override
  final bool contentAvailable;

  factory _$VendorCommissionTerms(
          [void Function(VendorCommissionTermsBuilder)? updates]) =>
      (VendorCommissionTermsBuilder()..update(updates))._build();

  _$VendorCommissionTerms._(
      {this.agreement,
      required this.commissionBasisPoints,
      required this.basis,
      required this.cadence,
      required this.environment,
      required this.contentAvailable})
      : super._();
  @override
  VendorCommissionTerms rebuild(
          void Function(VendorCommissionTermsBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  VendorCommissionTermsBuilder toBuilder() =>
      VendorCommissionTermsBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is VendorCommissionTerms &&
        agreement == other.agreement &&
        commissionBasisPoints == other.commissionBasisPoints &&
        basis == other.basis &&
        cadence == other.cadence &&
        environment == other.environment &&
        contentAvailable == other.contentAvailable;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, agreement.hashCode);
    _$hash = $jc(_$hash, commissionBasisPoints.hashCode);
    _$hash = $jc(_$hash, basis.hashCode);
    _$hash = $jc(_$hash, cadence.hashCode);
    _$hash = $jc(_$hash, environment.hashCode);
    _$hash = $jc(_$hash, contentAvailable.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'VendorCommissionTerms')
          ..add('agreement', agreement)
          ..add('commissionBasisPoints', commissionBasisPoints)
          ..add('basis', basis)
          ..add('cadence', cadence)
          ..add('environment', environment)
          ..add('contentAvailable', contentAvailable))
        .toString();
  }
}

class VendorCommissionTermsBuilder
    implements Builder<VendorCommissionTerms, VendorCommissionTermsBuilder> {
  _$VendorCommissionTerms? _$v;

  MapBuilder<String, JsonObject?>? _agreement;
  MapBuilder<String, JsonObject?> get agreement =>
      _$this._agreement ??= MapBuilder<String, JsonObject?>();
  set agreement(MapBuilder<String, JsonObject?>? agreement) =>
      _$this._agreement = agreement;

  int? _commissionBasisPoints;
  int? get commissionBasisPoints => _$this._commissionBasisPoints;
  set commissionBasisPoints(int? commissionBasisPoints) =>
      _$this._commissionBasisPoints = commissionBasisPoints;

  String? _basis;
  String? get basis => _$this._basis;
  set basis(String? basis) => _$this._basis = basis;

  String? _cadence;
  String? get cadence => _$this._cadence;
  set cadence(String? cadence) => _$this._cadence = cadence;

  String? _environment;
  String? get environment => _$this._environment;
  set environment(String? environment) => _$this._environment = environment;

  bool? _contentAvailable;
  bool? get contentAvailable => _$this._contentAvailable;
  set contentAvailable(bool? contentAvailable) =>
      _$this._contentAvailable = contentAvailable;

  VendorCommissionTermsBuilder() {
    VendorCommissionTerms._defaults(this);
  }

  VendorCommissionTermsBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _agreement = $v.agreement?.toBuilder();
      _commissionBasisPoints = $v.commissionBasisPoints;
      _basis = $v.basis;
      _cadence = $v.cadence;
      _environment = $v.environment;
      _contentAvailable = $v.contentAvailable;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(VendorCommissionTerms other) {
    _$v = other as _$VendorCommissionTerms;
  }

  @override
  void update(void Function(VendorCommissionTermsBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  VendorCommissionTerms build() => _build();

  _$VendorCommissionTerms _build() {
    _$VendorCommissionTerms _$result;
    try {
      _$result = _$v ??
          _$VendorCommissionTerms._(
            agreement: _agreement?.build(),
            commissionBasisPoints: BuiltValueNullFieldError.checkNotNull(
                commissionBasisPoints,
                r'VendorCommissionTerms',
                'commissionBasisPoints'),
            basis: BuiltValueNullFieldError.checkNotNull(
                basis, r'VendorCommissionTerms', 'basis'),
            cadence: BuiltValueNullFieldError.checkNotNull(
                cadence, r'VendorCommissionTerms', 'cadence'),
            environment: BuiltValueNullFieldError.checkNotNull(
                environment, r'VendorCommissionTerms', 'environment'),
            contentAvailable: BuiltValueNullFieldError.checkNotNull(
                contentAvailable, r'VendorCommissionTerms', 'contentAvailable'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'agreement';
        _agreement?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'VendorCommissionTerms', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
