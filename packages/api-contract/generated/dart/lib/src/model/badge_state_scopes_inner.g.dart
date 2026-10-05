// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'badge_state_scopes_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$BadgeStateScopesInner extends BadgeStateScopesInner {
  @override
  final String? scopeLabel;
  @override
  final DateTime? earnedAt;

  factory _$BadgeStateScopesInner(
          [void Function(BadgeStateScopesInnerBuilder)? updates]) =>
      (BadgeStateScopesInnerBuilder()..update(updates))._build();

  _$BadgeStateScopesInner._({this.scopeLabel, this.earnedAt}) : super._();
  @override
  BadgeStateScopesInner rebuild(
          void Function(BadgeStateScopesInnerBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  BadgeStateScopesInnerBuilder toBuilder() =>
      BadgeStateScopesInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is BadgeStateScopesInner &&
        scopeLabel == other.scopeLabel &&
        earnedAt == other.earnedAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, scopeLabel.hashCode);
    _$hash = $jc(_$hash, earnedAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'BadgeStateScopesInner')
          ..add('scopeLabel', scopeLabel)
          ..add('earnedAt', earnedAt))
        .toString();
  }
}

class BadgeStateScopesInnerBuilder
    implements Builder<BadgeStateScopesInner, BadgeStateScopesInnerBuilder> {
  _$BadgeStateScopesInner? _$v;

  String? _scopeLabel;
  String? get scopeLabel => _$this._scopeLabel;
  set scopeLabel(String? scopeLabel) => _$this._scopeLabel = scopeLabel;

  DateTime? _earnedAt;
  DateTime? get earnedAt => _$this._earnedAt;
  set earnedAt(DateTime? earnedAt) => _$this._earnedAt = earnedAt;

  BadgeStateScopesInnerBuilder() {
    BadgeStateScopesInner._defaults(this);
  }

  BadgeStateScopesInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _scopeLabel = $v.scopeLabel;
      _earnedAt = $v.earnedAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(BadgeStateScopesInner other) {
    _$v = other as _$BadgeStateScopesInner;
  }

  @override
  void update(void Function(BadgeStateScopesInnerBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  BadgeStateScopesInner build() => _build();

  _$BadgeStateScopesInner _build() {
    final _$result = _$v ??
        _$BadgeStateScopesInner._(
          scopeLabel: scopeLabel,
          earnedAt: earnedAt,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
