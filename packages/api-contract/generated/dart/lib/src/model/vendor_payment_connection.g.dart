// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_payment_connection.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$VendorPaymentConnection extends VendorPaymentConnection {
  @override
  final String invitationUrl;
  @override
  final String providerAccountId;

  factory _$VendorPaymentConnection(
          [void Function(VendorPaymentConnectionBuilder)? updates]) =>
      (VendorPaymentConnectionBuilder()..update(updates))._build();

  _$VendorPaymentConnection._(
      {required this.invitationUrl, required this.providerAccountId})
      : super._();
  @override
  VendorPaymentConnection rebuild(
          void Function(VendorPaymentConnectionBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  VendorPaymentConnectionBuilder toBuilder() =>
      VendorPaymentConnectionBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is VendorPaymentConnection &&
        invitationUrl == other.invitationUrl &&
        providerAccountId == other.providerAccountId;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, invitationUrl.hashCode);
    _$hash = $jc(_$hash, providerAccountId.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'VendorPaymentConnection')
          ..add('invitationUrl', invitationUrl)
          ..add('providerAccountId', providerAccountId))
        .toString();
  }
}

class VendorPaymentConnectionBuilder
    implements
        Builder<VendorPaymentConnection, VendorPaymentConnectionBuilder> {
  _$VendorPaymentConnection? _$v;

  String? _invitationUrl;
  String? get invitationUrl => _$this._invitationUrl;
  set invitationUrl(String? invitationUrl) =>
      _$this._invitationUrl = invitationUrl;

  String? _providerAccountId;
  String? get providerAccountId => _$this._providerAccountId;
  set providerAccountId(String? providerAccountId) =>
      _$this._providerAccountId = providerAccountId;

  VendorPaymentConnectionBuilder() {
    VendorPaymentConnection._defaults(this);
  }

  VendorPaymentConnectionBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _invitationUrl = $v.invitationUrl;
      _providerAccountId = $v.providerAccountId;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(VendorPaymentConnection other) {
    _$v = other as _$VendorPaymentConnection;
  }

  @override
  void update(void Function(VendorPaymentConnectionBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  VendorPaymentConnection build() => _build();

  _$VendorPaymentConnection _build() {
    final _$result = _$v ??
        _$VendorPaymentConnection._(
          invitationUrl: BuiltValueNullFieldError.checkNotNull(
              invitationUrl, r'VendorPaymentConnection', 'invitationUrl'),
          providerAccountId: BuiltValueNullFieldError.checkNotNull(
              providerAccountId,
              r'VendorPaymentConnection',
              'providerAccountId'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
