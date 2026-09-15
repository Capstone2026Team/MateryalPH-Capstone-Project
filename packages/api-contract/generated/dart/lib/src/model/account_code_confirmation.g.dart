// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_code_confirmation.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AccountCodeConfirmation extends AccountCodeConfirmation {
  @override
  final String id;
  @override
  final String code;

  factory _$AccountCodeConfirmation(
          [void Function(AccountCodeConfirmationBuilder)? updates]) =>
      (AccountCodeConfirmationBuilder()..update(updates))._build();

  _$AccountCodeConfirmation._({required this.id, required this.code})
      : super._();
  @override
  AccountCodeConfirmation rebuild(
          void Function(AccountCodeConfirmationBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AccountCodeConfirmationBuilder toBuilder() =>
      AccountCodeConfirmationBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AccountCodeConfirmation &&
        id == other.id &&
        code == other.code;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, code.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AccountCodeConfirmation')
          ..add('id', id)
          ..add('code', code))
        .toString();
  }
}

class AccountCodeConfirmationBuilder
    implements
        Builder<AccountCodeConfirmation, AccountCodeConfirmationBuilder> {
  _$AccountCodeConfirmation? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _code;
  String? get code => _$this._code;
  set code(String? code) => _$this._code = code;

  AccountCodeConfirmationBuilder() {
    AccountCodeConfirmation._defaults(this);
  }

  AccountCodeConfirmationBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _code = $v.code;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AccountCodeConfirmation other) {
    _$v = other as _$AccountCodeConfirmation;
  }

  @override
  void update(void Function(AccountCodeConfirmationBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AccountCodeConfirmation build() => _build();

  _$AccountCodeConfirmation _build() {
    final _$result = _$v ??
        _$AccountCodeConfirmation._(
          id: BuiltValueNullFieldError.checkNotNull(
              id, r'AccountCodeConfirmation', 'id'),
          code: BuiltValueNullFieldError.checkNotNull(
              code, r'AccountCodeConfirmation', 'code'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
