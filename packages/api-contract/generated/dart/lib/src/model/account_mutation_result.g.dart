// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_mutation_result.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AccountMutationResult extends AccountMutationResult {
  @override
  final bool? changed;
  @override
  final bool? verified;
  @override
  final bool? revoked;
  @override
  final bool? accepted;
  @override
  final bool? queued;
  @override
  final bool? signInRequired;
  @override
  final String? next;

  factory _$AccountMutationResult(
          [void Function(AccountMutationResultBuilder)? updates]) =>
      (AccountMutationResultBuilder()..update(updates))._build();

  _$AccountMutationResult._(
      {this.changed,
      this.verified,
      this.revoked,
      this.accepted,
      this.queued,
      this.signInRequired,
      this.next})
      : super._();
  @override
  AccountMutationResult rebuild(
          void Function(AccountMutationResultBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AccountMutationResultBuilder toBuilder() =>
      AccountMutationResultBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AccountMutationResult &&
        changed == other.changed &&
        verified == other.verified &&
        revoked == other.revoked &&
        accepted == other.accepted &&
        queued == other.queued &&
        signInRequired == other.signInRequired &&
        next == other.next;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, changed.hashCode);
    _$hash = $jc(_$hash, verified.hashCode);
    _$hash = $jc(_$hash, revoked.hashCode);
    _$hash = $jc(_$hash, accepted.hashCode);
    _$hash = $jc(_$hash, queued.hashCode);
    _$hash = $jc(_$hash, signInRequired.hashCode);
    _$hash = $jc(_$hash, next.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AccountMutationResult')
          ..add('changed', changed)
          ..add('verified', verified)
          ..add('revoked', revoked)
          ..add('accepted', accepted)
          ..add('queued', queued)
          ..add('signInRequired', signInRequired)
          ..add('next', next))
        .toString();
  }
}

class AccountMutationResultBuilder
    implements Builder<AccountMutationResult, AccountMutationResultBuilder> {
  _$AccountMutationResult? _$v;

  bool? _changed;
  bool? get changed => _$this._changed;
  set changed(bool? changed) => _$this._changed = changed;

  bool? _verified;
  bool? get verified => _$this._verified;
  set verified(bool? verified) => _$this._verified = verified;

  bool? _revoked;
  bool? get revoked => _$this._revoked;
  set revoked(bool? revoked) => _$this._revoked = revoked;

  bool? _accepted;
  bool? get accepted => _$this._accepted;
  set accepted(bool? accepted) => _$this._accepted = accepted;

  bool? _queued;
  bool? get queued => _$this._queued;
  set queued(bool? queued) => _$this._queued = queued;

  bool? _signInRequired;
  bool? get signInRequired => _$this._signInRequired;
  set signInRequired(bool? signInRequired) =>
      _$this._signInRequired = signInRequired;

  String? _next;
  String? get next => _$this._next;
  set next(String? next) => _$this._next = next;

  AccountMutationResultBuilder() {
    AccountMutationResult._defaults(this);
  }

  AccountMutationResultBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _changed = $v.changed;
      _verified = $v.verified;
      _revoked = $v.revoked;
      _accepted = $v.accepted;
      _queued = $v.queued;
      _signInRequired = $v.signInRequired;
      _next = $v.next;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AccountMutationResult other) {
    _$v = other as _$AccountMutationResult;
  }

  @override
  void update(void Function(AccountMutationResultBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AccountMutationResult build() => _build();

  _$AccountMutationResult _build() {
    final _$result = _$v ??
        _$AccountMutationResult._(
          changed: changed,
          verified: verified,
          revoked: revoked,
          accepted: accepted,
          queued: queued,
          signInRequired: signInRequired,
          next: next,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
