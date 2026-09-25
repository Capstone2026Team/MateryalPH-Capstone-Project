// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'xendit_account_verification_webhook_data_account_info.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$XenditAccountVerificationWebhookDataAccountInfo
    extends XenditAccountVerificationWebhookDataAccountInfo {
  @override
  final bool? paymentsEnabled;

  factory _$XenditAccountVerificationWebhookDataAccountInfo(
          [void Function(
                  XenditAccountVerificationWebhookDataAccountInfoBuilder)?
              updates]) =>
      (XenditAccountVerificationWebhookDataAccountInfoBuilder()
            ..update(updates))
          ._build();

  _$XenditAccountVerificationWebhookDataAccountInfo._({this.paymentsEnabled})
      : super._();
  @override
  XenditAccountVerificationWebhookDataAccountInfo rebuild(
          void Function(XenditAccountVerificationWebhookDataAccountInfoBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  XenditAccountVerificationWebhookDataAccountInfoBuilder toBuilder() =>
      XenditAccountVerificationWebhookDataAccountInfoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is XenditAccountVerificationWebhookDataAccountInfo &&
        paymentsEnabled == other.paymentsEnabled;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, paymentsEnabled.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'XenditAccountVerificationWebhookDataAccountInfo')
          ..add('paymentsEnabled', paymentsEnabled))
        .toString();
  }
}

class XenditAccountVerificationWebhookDataAccountInfoBuilder
    implements
        Builder<XenditAccountVerificationWebhookDataAccountInfo,
            XenditAccountVerificationWebhookDataAccountInfoBuilder> {
  _$XenditAccountVerificationWebhookDataAccountInfo? _$v;

  bool? _paymentsEnabled;
  bool? get paymentsEnabled => _$this._paymentsEnabled;
  set paymentsEnabled(bool? paymentsEnabled) =>
      _$this._paymentsEnabled = paymentsEnabled;

  XenditAccountVerificationWebhookDataAccountInfoBuilder() {
    XenditAccountVerificationWebhookDataAccountInfo._defaults(this);
  }

  XenditAccountVerificationWebhookDataAccountInfoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _paymentsEnabled = $v.paymentsEnabled;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(XenditAccountVerificationWebhookDataAccountInfo other) {
    _$v = other as _$XenditAccountVerificationWebhookDataAccountInfo;
  }

  @override
  void update(
      void Function(XenditAccountVerificationWebhookDataAccountInfoBuilder)?
          updates) {
    if (updates != null) updates(this);
  }

  @override
  XenditAccountVerificationWebhookDataAccountInfo build() => _build();

  _$XenditAccountVerificationWebhookDataAccountInfo _build() {
    final _$result = _$v ??
        _$XenditAccountVerificationWebhookDataAccountInfo._(
          paymentsEnabled: paymentsEnabled,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
