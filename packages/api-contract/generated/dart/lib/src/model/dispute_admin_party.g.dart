// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dispute_admin_party.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$DisputeAdminParty extends DisputeAdminParty {
  @override
  final String displayName;
  @override
  final int priorCases;

  factory _$DisputeAdminParty(
          [void Function(DisputeAdminPartyBuilder)? updates]) =>
      (DisputeAdminPartyBuilder()..update(updates))._build();

  _$DisputeAdminParty._({required this.displayName, required this.priorCases})
      : super._();
  @override
  DisputeAdminParty rebuild(void Function(DisputeAdminPartyBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DisputeAdminPartyBuilder toBuilder() =>
      DisputeAdminPartyBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DisputeAdminParty &&
        displayName == other.displayName &&
        priorCases == other.priorCases;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, displayName.hashCode);
    _$hash = $jc(_$hash, priorCases.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'DisputeAdminParty')
          ..add('displayName', displayName)
          ..add('priorCases', priorCases))
        .toString();
  }
}

class DisputeAdminPartyBuilder
    implements Builder<DisputeAdminParty, DisputeAdminPartyBuilder> {
  _$DisputeAdminParty? _$v;

  String? _displayName;
  String? get displayName => _$this._displayName;
  set displayName(String? displayName) => _$this._displayName = displayName;

  int? _priorCases;
  int? get priorCases => _$this._priorCases;
  set priorCases(int? priorCases) => _$this._priorCases = priorCases;

  DisputeAdminPartyBuilder() {
    DisputeAdminParty._defaults(this);
  }

  DisputeAdminPartyBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _displayName = $v.displayName;
      _priorCases = $v.priorCases;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DisputeAdminParty other) {
    _$v = other as _$DisputeAdminParty;
  }

  @override
  void update(void Function(DisputeAdminPartyBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DisputeAdminParty build() => _build();

  _$DisputeAdminParty _build() {
    final _$result = _$v ??
        _$DisputeAdminParty._(
          displayName: BuiltValueNullFieldError.checkNotNull(
              displayName, r'DisputeAdminParty', 'displayName'),
          priorCases: BuiltValueNullFieldError.checkNotNull(
              priorCases, r'DisputeAdminParty', 'priorCases'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
