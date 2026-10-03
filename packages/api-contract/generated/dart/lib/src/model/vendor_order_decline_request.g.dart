// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_order_decline_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$VendorOrderDeclineRequest extends VendorOrderDeclineRequest {
  @override
  final int lockVersion;
  @override
  final VendorOrderDeclineReason reasonCode;
  @override
  final String reason;

  factory _$VendorOrderDeclineRequest(
          [void Function(VendorOrderDeclineRequestBuilder)? updates]) =>
      (VendorOrderDeclineRequestBuilder()..update(updates))._build();

  _$VendorOrderDeclineRequest._(
      {required this.lockVersion,
      required this.reasonCode,
      required this.reason})
      : super._();
  @override
  VendorOrderDeclineRequest rebuild(
          void Function(VendorOrderDeclineRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  VendorOrderDeclineRequestBuilder toBuilder() =>
      VendorOrderDeclineRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is VendorOrderDeclineRequest &&
        lockVersion == other.lockVersion &&
        reasonCode == other.reasonCode &&
        reason == other.reason;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, lockVersion.hashCode);
    _$hash = $jc(_$hash, reasonCode.hashCode);
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'VendorOrderDeclineRequest')
          ..add('lockVersion', lockVersion)
          ..add('reasonCode', reasonCode)
          ..add('reason', reason))
        .toString();
  }
}

class VendorOrderDeclineRequestBuilder
    implements
        Builder<VendorOrderDeclineRequest, VendorOrderDeclineRequestBuilder> {
  _$VendorOrderDeclineRequest? _$v;

  int? _lockVersion;
  int? get lockVersion => _$this._lockVersion;
  set lockVersion(int? lockVersion) => _$this._lockVersion = lockVersion;

  VendorOrderDeclineReason? _reasonCode;
  VendorOrderDeclineReason? get reasonCode => _$this._reasonCode;
  set reasonCode(VendorOrderDeclineReason? reasonCode) =>
      _$this._reasonCode = reasonCode;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  VendorOrderDeclineRequestBuilder() {
    VendorOrderDeclineRequest._defaults(this);
  }

  VendorOrderDeclineRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _lockVersion = $v.lockVersion;
      _reasonCode = $v.reasonCode;
      _reason = $v.reason;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(VendorOrderDeclineRequest other) {
    _$v = other as _$VendorOrderDeclineRequest;
  }

  @override
  void update(void Function(VendorOrderDeclineRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  VendorOrderDeclineRequest build() => _build();

  _$VendorOrderDeclineRequest _build() {
    final _$result = _$v ??
        _$VendorOrderDeclineRequest._(
          lockVersion: BuiltValueNullFieldError.checkNotNull(
              lockVersion, r'VendorOrderDeclineRequest', 'lockVersion'),
          reasonCode: BuiltValueNullFieldError.checkNotNull(
              reasonCode, r'VendorOrderDeclineRequest', 'reasonCode'),
          reason: BuiltValueNullFieldError.checkNotNull(
              reason, r'VendorOrderDeclineRequest', 'reason'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
