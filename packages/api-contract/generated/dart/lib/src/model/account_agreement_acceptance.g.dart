// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_agreement_acceptance.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AccountAgreementAcceptance extends AccountAgreementAcceptance {
  @override
  final BuiltList<String> versionIds;

  factory _$AccountAgreementAcceptance(
          [void Function(AccountAgreementAcceptanceBuilder)? updates]) =>
      (AccountAgreementAcceptanceBuilder()..update(updates))._build();

  _$AccountAgreementAcceptance._({required this.versionIds}) : super._();
  @override
  AccountAgreementAcceptance rebuild(
          void Function(AccountAgreementAcceptanceBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AccountAgreementAcceptanceBuilder toBuilder() =>
      AccountAgreementAcceptanceBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AccountAgreementAcceptance &&
        versionIds == other.versionIds;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, versionIds.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AccountAgreementAcceptance')
          ..add('versionIds', versionIds))
        .toString();
  }
}

class AccountAgreementAcceptanceBuilder
    implements
        Builder<AccountAgreementAcceptance, AccountAgreementAcceptanceBuilder> {
  _$AccountAgreementAcceptance? _$v;

  ListBuilder<String>? _versionIds;
  ListBuilder<String> get versionIds =>
      _$this._versionIds ??= ListBuilder<String>();
  set versionIds(ListBuilder<String>? versionIds) =>
      _$this._versionIds = versionIds;

  AccountAgreementAcceptanceBuilder() {
    AccountAgreementAcceptance._defaults(this);
  }

  AccountAgreementAcceptanceBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _versionIds = $v.versionIds.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AccountAgreementAcceptance other) {
    _$v = other as _$AccountAgreementAcceptance;
  }

  @override
  void update(void Function(AccountAgreementAcceptanceBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AccountAgreementAcceptance build() => _build();

  _$AccountAgreementAcceptance _build() {
    _$AccountAgreementAcceptance _$result;
    try {
      _$result = _$v ??
          _$AccountAgreementAcceptance._(
            versionIds: versionIds.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'versionIds';
        versionIds.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'AccountAgreementAcceptance', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
