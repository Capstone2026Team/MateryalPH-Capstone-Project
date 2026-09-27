// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'xendit_account_verification_webhook_data.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$XenditAccountVerificationWebhookData
    extends XenditAccountVerificationWebhookData {
  @override
  final String userId;
  @override
  final XenditAccountVerificationWebhookDataAccountInfo? accountInfo;

  factory _$XenditAccountVerificationWebhookData(
          [void Function(XenditAccountVerificationWebhookDataBuilder)?
              updates]) =>
      (XenditAccountVerificationWebhookDataBuilder()..update(updates))._build();

  _$XenditAccountVerificationWebhookData._(
      {required this.userId, this.accountInfo})
      : super._();
  @override
  XenditAccountVerificationWebhookData rebuild(
          void Function(XenditAccountVerificationWebhookDataBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  XenditAccountVerificationWebhookDataBuilder toBuilder() =>
      XenditAccountVerificationWebhookDataBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is XenditAccountVerificationWebhookData &&
        userId == other.userId &&
        accountInfo == other.accountInfo;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, userId.hashCode);
    _$hash = $jc(_$hash, accountInfo.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'XenditAccountVerificationWebhookData')
          ..add('userId', userId)
          ..add('accountInfo', accountInfo))
        .toString();
  }
}

class XenditAccountVerificationWebhookDataBuilder
    implements
        Builder<XenditAccountVerificationWebhookData,
            XenditAccountVerificationWebhookDataBuilder> {
  _$XenditAccountVerificationWebhookData? _$v;

  String? _userId;
  String? get userId => _$this._userId;
  set userId(String? userId) => _$this._userId = userId;

  XenditAccountVerificationWebhookDataAccountInfoBuilder? _accountInfo;
  XenditAccountVerificationWebhookDataAccountInfoBuilder get accountInfo =>
      _$this._accountInfo ??=
          XenditAccountVerificationWebhookDataAccountInfoBuilder();
  set accountInfo(
          XenditAccountVerificationWebhookDataAccountInfoBuilder?
              accountInfo) =>
      _$this._accountInfo = accountInfo;

  XenditAccountVerificationWebhookDataBuilder() {
    XenditAccountVerificationWebhookData._defaults(this);
  }

  XenditAccountVerificationWebhookDataBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _userId = $v.userId;
      _accountInfo = $v.accountInfo?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(XenditAccountVerificationWebhookData other) {
    _$v = other as _$XenditAccountVerificationWebhookData;
  }

  @override
  void update(
      void Function(XenditAccountVerificationWebhookDataBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  XenditAccountVerificationWebhookData build() => _build();

  _$XenditAccountVerificationWebhookData _build() {
    _$XenditAccountVerificationWebhookData _$result;
    try {
      _$result = _$v ??
          _$XenditAccountVerificationWebhookData._(
            userId: BuiltValueNullFieldError.checkNotNull(
                userId, r'XenditAccountVerificationWebhookData', 'userId'),
            accountInfo: _accountInfo?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'accountInfo';
        _accountInfo?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'XenditAccountVerificationWebhookData',
            _$failedField,
            e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
