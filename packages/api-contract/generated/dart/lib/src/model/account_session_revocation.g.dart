// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_session_revocation.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AccountSessionRevocationScopeEnum
    _$accountSessionRevocationScopeEnum_OTHERS =
    const AccountSessionRevocationScopeEnum._('OTHERS');
const AccountSessionRevocationScopeEnum
    _$accountSessionRevocationScopeEnum_ALL =
    const AccountSessionRevocationScopeEnum._('ALL');

AccountSessionRevocationScopeEnum _$accountSessionRevocationScopeEnumValueOf(
    String name) {
  switch (name) {
    case 'OTHERS':
      return _$accountSessionRevocationScopeEnum_OTHERS;
    case 'ALL':
      return _$accountSessionRevocationScopeEnum_ALL;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AccountSessionRevocationScopeEnum>
    _$accountSessionRevocationScopeEnumValues = BuiltSet<
        AccountSessionRevocationScopeEnum>(const <AccountSessionRevocationScopeEnum>[
  _$accountSessionRevocationScopeEnum_OTHERS,
  _$accountSessionRevocationScopeEnum_ALL,
]);

Serializer<AccountSessionRevocationScopeEnum>
    _$accountSessionRevocationScopeEnumSerializer =
    _$AccountSessionRevocationScopeEnumSerializer();

class _$AccountSessionRevocationScopeEnumSerializer
    implements PrimitiveSerializer<AccountSessionRevocationScopeEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'OTHERS': 'OTHERS',
    'ALL': 'ALL',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'OTHERS': 'OTHERS',
    'ALL': 'ALL',
  };

  @override
  final Iterable<Type> types = const <Type>[AccountSessionRevocationScopeEnum];
  @override
  final String wireName = 'AccountSessionRevocationScopeEnum';

  @override
  Object serialize(
          Serializers serializers, AccountSessionRevocationScopeEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  AccountSessionRevocationScopeEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      AccountSessionRevocationScopeEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$AccountSessionRevocation extends AccountSessionRevocation {
  @override
  final AccountSessionRevocationScopeEnum scope;

  factory _$AccountSessionRevocation(
          [void Function(AccountSessionRevocationBuilder)? updates]) =>
      (AccountSessionRevocationBuilder()..update(updates))._build();

  _$AccountSessionRevocation._({required this.scope}) : super._();
  @override
  AccountSessionRevocation rebuild(
          void Function(AccountSessionRevocationBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AccountSessionRevocationBuilder toBuilder() =>
      AccountSessionRevocationBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AccountSessionRevocation && scope == other.scope;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, scope.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AccountSessionRevocation')
          ..add('scope', scope))
        .toString();
  }
}

class AccountSessionRevocationBuilder
    implements
        Builder<AccountSessionRevocation, AccountSessionRevocationBuilder> {
  _$AccountSessionRevocation? _$v;

  AccountSessionRevocationScopeEnum? _scope;
  AccountSessionRevocationScopeEnum? get scope => _$this._scope;
  set scope(AccountSessionRevocationScopeEnum? scope) => _$this._scope = scope;

  AccountSessionRevocationBuilder() {
    AccountSessionRevocation._defaults(this);
  }

  AccountSessionRevocationBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _scope = $v.scope;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AccountSessionRevocation other) {
    _$v = other as _$AccountSessionRevocation;
  }

  @override
  void update(void Function(AccountSessionRevocationBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AccountSessionRevocation build() => _build();

  _$AccountSessionRevocation _build() {
    final _$result = _$v ??
        _$AccountSessionRevocation._(
          scope: BuiltValueNullFieldError.checkNotNull(
              scope, r'AccountSessionRevocation', 'scope'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
