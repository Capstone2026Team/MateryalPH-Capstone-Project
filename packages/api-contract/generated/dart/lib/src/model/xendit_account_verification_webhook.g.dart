// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'xendit_account_verification_webhook.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$XenditAccountVerificationWebhook
    extends XenditAccountVerificationWebhook {
  @override
  final String id;
  @override
  final String? forUserId;
  @override
  final String? accountId;
  @override
  final String? subaccountId;
  @override
  final String? status;
  @override
  final String? verificationStatus;

  factory _$XenditAccountVerificationWebhook(
          [void Function(XenditAccountVerificationWebhookBuilder)? updates]) =>
      (XenditAccountVerificationWebhookBuilder()..update(updates))._build();

  _$XenditAccountVerificationWebhook._(
      {required this.id,
      this.forUserId,
      this.accountId,
      this.subaccountId,
      this.status,
      this.verificationStatus})
      : super._();
  @override
  XenditAccountVerificationWebhook rebuild(
          void Function(XenditAccountVerificationWebhookBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  XenditAccountVerificationWebhookBuilder toBuilder() =>
      XenditAccountVerificationWebhookBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is XenditAccountVerificationWebhook &&
        id == other.id &&
        forUserId == other.forUserId &&
        accountId == other.accountId &&
        subaccountId == other.subaccountId &&
        status == other.status &&
        verificationStatus == other.verificationStatus;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, forUserId.hashCode);
    _$hash = $jc(_$hash, accountId.hashCode);
    _$hash = $jc(_$hash, subaccountId.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, verificationStatus.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'XenditAccountVerificationWebhook')
          ..add('id', id)
          ..add('forUserId', forUserId)
          ..add('accountId', accountId)
          ..add('subaccountId', subaccountId)
          ..add('status', status)
          ..add('verificationStatus', verificationStatus))
        .toString();
  }
}

class XenditAccountVerificationWebhookBuilder
    implements
        Builder<XenditAccountVerificationWebhook,
            XenditAccountVerificationWebhookBuilder> {
  _$XenditAccountVerificationWebhook? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _forUserId;
  String? get forUserId => _$this._forUserId;
  set forUserId(String? forUserId) => _$this._forUserId = forUserId;

  String? _accountId;
  String? get accountId => _$this._accountId;
  set accountId(String? accountId) => _$this._accountId = accountId;

  String? _subaccountId;
  String? get subaccountId => _$this._subaccountId;
  set subaccountId(String? subaccountId) => _$this._subaccountId = subaccountId;

  String? _status;
  String? get status => _$this._status;
  set status(String? status) => _$this._status = status;

  String? _verificationStatus;
  String? get verificationStatus => _$this._verificationStatus;
  set verificationStatus(String? verificationStatus) =>
      _$this._verificationStatus = verificationStatus;

  XenditAccountVerificationWebhookBuilder() {
    XenditAccountVerificationWebhook._defaults(this);
  }

  XenditAccountVerificationWebhookBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _forUserId = $v.forUserId;
      _accountId = $v.accountId;
      _subaccountId = $v.subaccountId;
      _status = $v.status;
      _verificationStatus = $v.verificationStatus;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(XenditAccountVerificationWebhook other) {
    _$v = other as _$XenditAccountVerificationWebhook;
  }

  @override
  void update(void Function(XenditAccountVerificationWebhookBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  XenditAccountVerificationWebhook build() => _build();

  _$XenditAccountVerificationWebhook _build() {
    final _$result = _$v ??
        _$XenditAccountVerificationWebhook._(
          id: BuiltValueNullFieldError.checkNotNull(
              id, r'XenditAccountVerificationWebhook', 'id'),
          forUserId: forUserId,
          accountId: accountId,
          subaccountId: subaccountId,
          status: status,
          verificationStatus: verificationStatus,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
