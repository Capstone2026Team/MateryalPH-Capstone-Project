// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_profile_update.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AccountProfileUpdateBuyerTypeEnum
    _$accountProfileUpdateBuyerTypeEnum_INDIVIDUAL =
    const AccountProfileUpdateBuyerTypeEnum._('INDIVIDUAL');
const AccountProfileUpdateBuyerTypeEnum
    _$accountProfileUpdateBuyerTypeEnum_BUSINESS =
    const AccountProfileUpdateBuyerTypeEnum._('BUSINESS');

AccountProfileUpdateBuyerTypeEnum _$accountProfileUpdateBuyerTypeEnumValueOf(
    String name) {
  switch (name) {
    case 'INDIVIDUAL':
      return _$accountProfileUpdateBuyerTypeEnum_INDIVIDUAL;
    case 'BUSINESS':
      return _$accountProfileUpdateBuyerTypeEnum_BUSINESS;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AccountProfileUpdateBuyerTypeEnum>
    _$accountProfileUpdateBuyerTypeEnumValues = BuiltSet<
        AccountProfileUpdateBuyerTypeEnum>(const <AccountProfileUpdateBuyerTypeEnum>[
  _$accountProfileUpdateBuyerTypeEnum_INDIVIDUAL,
  _$accountProfileUpdateBuyerTypeEnum_BUSINESS,
]);

Serializer<AccountProfileUpdateBuyerTypeEnum>
    _$accountProfileUpdateBuyerTypeEnumSerializer =
    _$AccountProfileUpdateBuyerTypeEnumSerializer();

class _$AccountProfileUpdateBuyerTypeEnumSerializer
    implements PrimitiveSerializer<AccountProfileUpdateBuyerTypeEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'INDIVIDUAL': 'INDIVIDUAL',
    'BUSINESS': 'BUSINESS',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'INDIVIDUAL': 'INDIVIDUAL',
    'BUSINESS': 'BUSINESS',
  };

  @override
  final Iterable<Type> types = const <Type>[AccountProfileUpdateBuyerTypeEnum];
  @override
  final String wireName = 'AccountProfileUpdateBuyerTypeEnum';

  @override
  Object serialize(
          Serializers serializers, AccountProfileUpdateBuyerTypeEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  AccountProfileUpdateBuyerTypeEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      AccountProfileUpdateBuyerTypeEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$AccountProfileUpdate extends AccountProfileUpdate {
  @override
  final String fullName;
  @override
  final int lockVersion;
  @override
  final AccountProfileUpdateBuyerTypeEnum? buyerType;
  @override
  final String? companyName;

  factory _$AccountProfileUpdate(
          [void Function(AccountProfileUpdateBuilder)? updates]) =>
      (AccountProfileUpdateBuilder()..update(updates))._build();

  _$AccountProfileUpdate._(
      {required this.fullName,
      required this.lockVersion,
      this.buyerType,
      this.companyName})
      : super._();
  @override
  AccountProfileUpdate rebuild(
          void Function(AccountProfileUpdateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AccountProfileUpdateBuilder toBuilder() =>
      AccountProfileUpdateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AccountProfileUpdate &&
        fullName == other.fullName &&
        lockVersion == other.lockVersion &&
        buyerType == other.buyerType &&
        companyName == other.companyName;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, fullName.hashCode);
    _$hash = $jc(_$hash, lockVersion.hashCode);
    _$hash = $jc(_$hash, buyerType.hashCode);
    _$hash = $jc(_$hash, companyName.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AccountProfileUpdate')
          ..add('fullName', fullName)
          ..add('lockVersion', lockVersion)
          ..add('buyerType', buyerType)
          ..add('companyName', companyName))
        .toString();
  }
}

class AccountProfileUpdateBuilder
    implements Builder<AccountProfileUpdate, AccountProfileUpdateBuilder> {
  _$AccountProfileUpdate? _$v;

  String? _fullName;
  String? get fullName => _$this._fullName;
  set fullName(String? fullName) => _$this._fullName = fullName;

  int? _lockVersion;
  int? get lockVersion => _$this._lockVersion;
  set lockVersion(int? lockVersion) => _$this._lockVersion = lockVersion;

  AccountProfileUpdateBuyerTypeEnum? _buyerType;
  AccountProfileUpdateBuyerTypeEnum? get buyerType => _$this._buyerType;
  set buyerType(AccountProfileUpdateBuyerTypeEnum? buyerType) =>
      _$this._buyerType = buyerType;

  String? _companyName;
  String? get companyName => _$this._companyName;
  set companyName(String? companyName) => _$this._companyName = companyName;

  AccountProfileUpdateBuilder() {
    AccountProfileUpdate._defaults(this);
  }

  AccountProfileUpdateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _fullName = $v.fullName;
      _lockVersion = $v.lockVersion;
      _buyerType = $v.buyerType;
      _companyName = $v.companyName;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AccountProfileUpdate other) {
    _$v = other as _$AccountProfileUpdate;
  }

  @override
  void update(void Function(AccountProfileUpdateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AccountProfileUpdate build() => _build();

  _$AccountProfileUpdate _build() {
    final _$result = _$v ??
        _$AccountProfileUpdate._(
          fullName: BuiltValueNullFieldError.checkNotNull(
              fullName, r'AccountProfileUpdate', 'fullName'),
          lockVersion: BuiltValueNullFieldError.checkNotNull(
              lockVersion, r'AccountProfileUpdate', 'lockVersion'),
          buyerType: buyerType,
          companyName: companyName,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
