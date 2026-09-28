// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'radius_expansion.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$RadiusExpansion extends RadiusExpansion {
  @override
  final int eligibleVerifiedCount;
  @override
  final int? suggestedRadiusKm;
  @override
  final bool atMaximum;
  @override
  final String? reason;
  @override
  final bool requiresConfirmation;

  factory _$RadiusExpansion([void Function(RadiusExpansionBuilder)? updates]) =>
      (RadiusExpansionBuilder()..update(updates))._build();

  _$RadiusExpansion._(
      {required this.eligibleVerifiedCount,
      this.suggestedRadiusKm,
      required this.atMaximum,
      this.reason,
      required this.requiresConfirmation})
      : super._();
  @override
  RadiusExpansion rebuild(void Function(RadiusExpansionBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  RadiusExpansionBuilder toBuilder() => RadiusExpansionBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is RadiusExpansion &&
        eligibleVerifiedCount == other.eligibleVerifiedCount &&
        suggestedRadiusKm == other.suggestedRadiusKm &&
        atMaximum == other.atMaximum &&
        reason == other.reason &&
        requiresConfirmation == other.requiresConfirmation;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, eligibleVerifiedCount.hashCode);
    _$hash = $jc(_$hash, suggestedRadiusKm.hashCode);
    _$hash = $jc(_$hash, atMaximum.hashCode);
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jc(_$hash, requiresConfirmation.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'RadiusExpansion')
          ..add('eligibleVerifiedCount', eligibleVerifiedCount)
          ..add('suggestedRadiusKm', suggestedRadiusKm)
          ..add('atMaximum', atMaximum)
          ..add('reason', reason)
          ..add('requiresConfirmation', requiresConfirmation))
        .toString();
  }
}

class RadiusExpansionBuilder
    implements Builder<RadiusExpansion, RadiusExpansionBuilder> {
  _$RadiusExpansion? _$v;

  int? _eligibleVerifiedCount;
  int? get eligibleVerifiedCount => _$this._eligibleVerifiedCount;
  set eligibleVerifiedCount(int? eligibleVerifiedCount) =>
      _$this._eligibleVerifiedCount = eligibleVerifiedCount;

  int? _suggestedRadiusKm;
  int? get suggestedRadiusKm => _$this._suggestedRadiusKm;
  set suggestedRadiusKm(int? suggestedRadiusKm) =>
      _$this._suggestedRadiusKm = suggestedRadiusKm;

  bool? _atMaximum;
  bool? get atMaximum => _$this._atMaximum;
  set atMaximum(bool? atMaximum) => _$this._atMaximum = atMaximum;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  bool? _requiresConfirmation;
  bool? get requiresConfirmation => _$this._requiresConfirmation;
  set requiresConfirmation(bool? requiresConfirmation) =>
      _$this._requiresConfirmation = requiresConfirmation;

  RadiusExpansionBuilder() {
    RadiusExpansion._defaults(this);
  }

  RadiusExpansionBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _eligibleVerifiedCount = $v.eligibleVerifiedCount;
      _suggestedRadiusKm = $v.suggestedRadiusKm;
      _atMaximum = $v.atMaximum;
      _reason = $v.reason;
      _requiresConfirmation = $v.requiresConfirmation;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(RadiusExpansion other) {
    _$v = other as _$RadiusExpansion;
  }

  @override
  void update(void Function(RadiusExpansionBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  RadiusExpansion build() => _build();

  _$RadiusExpansion _build() {
    final _$result = _$v ??
        _$RadiusExpansion._(
          eligibleVerifiedCount: BuiltValueNullFieldError.checkNotNull(
              eligibleVerifiedCount,
              r'RadiusExpansion',
              'eligibleVerifiedCount'),
          suggestedRadiusKm: suggestedRadiusKm,
          atMaximum: BuiltValueNullFieldError.checkNotNull(
              atMaximum, r'RadiusExpansion', 'atMaximum'),
          reason: reason,
          requiresConfirmation: BuiltValueNullFieldError.checkNotNull(
              requiresConfirmation, r'RadiusExpansion', 'requiresConfirmation'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
