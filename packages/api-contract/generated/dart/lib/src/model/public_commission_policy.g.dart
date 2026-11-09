// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'public_commission_policy.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PublicCommissionPolicy extends PublicCommissionPolicy {
  @override
  final CommissionPolicy? current;
  @override
  final CommissionPolicy? next;
  @override
  final CommissionPolicy? selected;

  factory _$PublicCommissionPolicy(
          [void Function(PublicCommissionPolicyBuilder)? updates]) =>
      (PublicCommissionPolicyBuilder()..update(updates))._build();

  _$PublicCommissionPolicy._({this.current, this.next, this.selected})
      : super._();
  @override
  PublicCommissionPolicy rebuild(
          void Function(PublicCommissionPolicyBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PublicCommissionPolicyBuilder toBuilder() =>
      PublicCommissionPolicyBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PublicCommissionPolicy &&
        current == other.current &&
        next == other.next &&
        selected == other.selected;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, current.hashCode);
    _$hash = $jc(_$hash, next.hashCode);
    _$hash = $jc(_$hash, selected.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PublicCommissionPolicy')
          ..add('current', current)
          ..add('next', next)
          ..add('selected', selected))
        .toString();
  }
}

class PublicCommissionPolicyBuilder
    implements Builder<PublicCommissionPolicy, PublicCommissionPolicyBuilder> {
  _$PublicCommissionPolicy? _$v;

  CommissionPolicyBuilder? _current;
  CommissionPolicyBuilder get current =>
      _$this._current ??= CommissionPolicyBuilder();
  set current(CommissionPolicyBuilder? current) => _$this._current = current;

  CommissionPolicyBuilder? _next;
  CommissionPolicyBuilder get next =>
      _$this._next ??= CommissionPolicyBuilder();
  set next(CommissionPolicyBuilder? next) => _$this._next = next;

  CommissionPolicyBuilder? _selected;
  CommissionPolicyBuilder get selected =>
      _$this._selected ??= CommissionPolicyBuilder();
  set selected(CommissionPolicyBuilder? selected) =>
      _$this._selected = selected;

  PublicCommissionPolicyBuilder() {
    PublicCommissionPolicy._defaults(this);
  }

  PublicCommissionPolicyBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _current = $v.current?.toBuilder();
      _next = $v.next?.toBuilder();
      _selected = $v.selected?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PublicCommissionPolicy other) {
    _$v = other as _$PublicCommissionPolicy;
  }

  @override
  void update(void Function(PublicCommissionPolicyBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PublicCommissionPolicy build() => _build();

  _$PublicCommissionPolicy _build() {
    _$PublicCommissionPolicy _$result;
    try {
      _$result = _$v ??
          _$PublicCommissionPolicy._(
            current: _current?.build(),
            next: _next?.build(),
            selected: _selected?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'current';
        _current?.build();
        _$failedField = 'next';
        _next?.build();
        _$failedField = 'selected';
        _selected?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'PublicCommissionPolicy', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
