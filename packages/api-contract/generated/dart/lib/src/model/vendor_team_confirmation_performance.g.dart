// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_team_confirmation_performance.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$VendorTeamConfirmationPerformance
    extends VendorTeamConfirmationPerformance {
  @override
  final int confirmed;
  @override
  final int revised;
  @override
  final int declined;

  factory _$VendorTeamConfirmationPerformance(
          [void Function(VendorTeamConfirmationPerformanceBuilder)? updates]) =>
      (VendorTeamConfirmationPerformanceBuilder()..update(updates))._build();

  _$VendorTeamConfirmationPerformance._(
      {required this.confirmed, required this.revised, required this.declined})
      : super._();
  @override
  VendorTeamConfirmationPerformance rebuild(
          void Function(VendorTeamConfirmationPerformanceBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  VendorTeamConfirmationPerformanceBuilder toBuilder() =>
      VendorTeamConfirmationPerformanceBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is VendorTeamConfirmationPerformance &&
        confirmed == other.confirmed &&
        revised == other.revised &&
        declined == other.declined;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, confirmed.hashCode);
    _$hash = $jc(_$hash, revised.hashCode);
    _$hash = $jc(_$hash, declined.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'VendorTeamConfirmationPerformance')
          ..add('confirmed', confirmed)
          ..add('revised', revised)
          ..add('declined', declined))
        .toString();
  }
}

class VendorTeamConfirmationPerformanceBuilder
    implements
        Builder<VendorTeamConfirmationPerformance,
            VendorTeamConfirmationPerformanceBuilder> {
  _$VendorTeamConfirmationPerformance? _$v;

  int? _confirmed;
  int? get confirmed => _$this._confirmed;
  set confirmed(int? confirmed) => _$this._confirmed = confirmed;

  int? _revised;
  int? get revised => _$this._revised;
  set revised(int? revised) => _$this._revised = revised;

  int? _declined;
  int? get declined => _$this._declined;
  set declined(int? declined) => _$this._declined = declined;

  VendorTeamConfirmationPerformanceBuilder() {
    VendorTeamConfirmationPerformance._defaults(this);
  }

  VendorTeamConfirmationPerformanceBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _confirmed = $v.confirmed;
      _revised = $v.revised;
      _declined = $v.declined;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(VendorTeamConfirmationPerformance other) {
    _$v = other as _$VendorTeamConfirmationPerformance;
  }

  @override
  void update(
      void Function(VendorTeamConfirmationPerformanceBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  VendorTeamConfirmationPerformance build() => _build();

  _$VendorTeamConfirmationPerformance _build() {
    final _$result = _$v ??
        _$VendorTeamConfirmationPerformance._(
          confirmed: BuiltValueNullFieldError.checkNotNull(
              confirmed, r'VendorTeamConfirmationPerformance', 'confirmed'),
          revised: BuiltValueNullFieldError.checkNotNull(
              revised, r'VendorTeamConfirmationPerformance', 'revised'),
          declined: BuiltValueNullFieldError.checkNotNull(
              declined, r'VendorTeamConfirmationPerformance', 'declined'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
