// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'public_scores.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PublicScores extends PublicScores {
  @override
  final String label;
  @override
  final bool newVendor;
  @override
  final String? vps;
  @override
  final String? vcs;
  @override
  final String? mqs;
  @override
  final String? ohs;
  @override
  final Date? asOf;
  @override
  final BuiltList<PublicBadge> badges;

  factory _$PublicScores([void Function(PublicScoresBuilder)? updates]) =>
      (PublicScoresBuilder()..update(updates))._build();

  _$PublicScores._(
      {required this.label,
      required this.newVendor,
      this.vps,
      this.vcs,
      this.mqs,
      this.ohs,
      this.asOf,
      required this.badges})
      : super._();
  @override
  PublicScores rebuild(void Function(PublicScoresBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PublicScoresBuilder toBuilder() => PublicScoresBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PublicScores &&
        label == other.label &&
        newVendor == other.newVendor &&
        vps == other.vps &&
        vcs == other.vcs &&
        mqs == other.mqs &&
        ohs == other.ohs &&
        asOf == other.asOf &&
        badges == other.badges;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, label.hashCode);
    _$hash = $jc(_$hash, newVendor.hashCode);
    _$hash = $jc(_$hash, vps.hashCode);
    _$hash = $jc(_$hash, vcs.hashCode);
    _$hash = $jc(_$hash, mqs.hashCode);
    _$hash = $jc(_$hash, ohs.hashCode);
    _$hash = $jc(_$hash, asOf.hashCode);
    _$hash = $jc(_$hash, badges.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PublicScores')
          ..add('label', label)
          ..add('newVendor', newVendor)
          ..add('vps', vps)
          ..add('vcs', vcs)
          ..add('mqs', mqs)
          ..add('ohs', ohs)
          ..add('asOf', asOf)
          ..add('badges', badges))
        .toString();
  }
}

class PublicScoresBuilder
    implements Builder<PublicScores, PublicScoresBuilder> {
  _$PublicScores? _$v;

  String? _label;
  String? get label => _$this._label;
  set label(String? label) => _$this._label = label;

  bool? _newVendor;
  bool? get newVendor => _$this._newVendor;
  set newVendor(bool? newVendor) => _$this._newVendor = newVendor;

  String? _vps;
  String? get vps => _$this._vps;
  set vps(String? vps) => _$this._vps = vps;

  String? _vcs;
  String? get vcs => _$this._vcs;
  set vcs(String? vcs) => _$this._vcs = vcs;

  String? _mqs;
  String? get mqs => _$this._mqs;
  set mqs(String? mqs) => _$this._mqs = mqs;

  String? _ohs;
  String? get ohs => _$this._ohs;
  set ohs(String? ohs) => _$this._ohs = ohs;

  Date? _asOf;
  Date? get asOf => _$this._asOf;
  set asOf(Date? asOf) => _$this._asOf = asOf;

  ListBuilder<PublicBadge>? _badges;
  ListBuilder<PublicBadge> get badges =>
      _$this._badges ??= ListBuilder<PublicBadge>();
  set badges(ListBuilder<PublicBadge>? badges) => _$this._badges = badges;

  PublicScoresBuilder() {
    PublicScores._defaults(this);
  }

  PublicScoresBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _label = $v.label;
      _newVendor = $v.newVendor;
      _vps = $v.vps;
      _vcs = $v.vcs;
      _mqs = $v.mqs;
      _ohs = $v.ohs;
      _asOf = $v.asOf;
      _badges = $v.badges.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PublicScores other) {
    _$v = other as _$PublicScores;
  }

  @override
  void update(void Function(PublicScoresBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PublicScores build() => _build();

  _$PublicScores _build() {
    _$PublicScores _$result;
    try {
      _$result = _$v ??
          _$PublicScores._(
            label: BuiltValueNullFieldError.checkNotNull(
                label, r'PublicScores', 'label'),
            newVendor: BuiltValueNullFieldError.checkNotNull(
                newVendor, r'PublicScores', 'newVendor'),
            vps: vps,
            vcs: vcs,
            mqs: mqs,
            ohs: ohs,
            asOf: asOf,
            badges: badges.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'badges';
        badges.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'PublicScores', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
