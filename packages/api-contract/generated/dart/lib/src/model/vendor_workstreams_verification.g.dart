// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_workstreams_verification.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$VendorWorkstreamsVerification extends VendorWorkstreamsVerification {
  @override
  final String status;

  factory _$VendorWorkstreamsVerification(
          [void Function(VendorWorkstreamsVerificationBuilder)? updates]) =>
      (VendorWorkstreamsVerificationBuilder()..update(updates))._build();

  _$VendorWorkstreamsVerification._({required this.status}) : super._();
  @override
  VendorWorkstreamsVerification rebuild(
          void Function(VendorWorkstreamsVerificationBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  VendorWorkstreamsVerificationBuilder toBuilder() =>
      VendorWorkstreamsVerificationBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is VendorWorkstreamsVerification && status == other.status;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'VendorWorkstreamsVerification')
          ..add('status', status))
        .toString();
  }
}

class VendorWorkstreamsVerificationBuilder
    implements
        Builder<VendorWorkstreamsVerification,
            VendorWorkstreamsVerificationBuilder> {
  _$VendorWorkstreamsVerification? _$v;

  String? _status;
  String? get status => _$this._status;
  set status(String? status) => _$this._status = status;

  VendorWorkstreamsVerificationBuilder() {
    VendorWorkstreamsVerification._defaults(this);
  }

  VendorWorkstreamsVerificationBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _status = $v.status;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(VendorWorkstreamsVerification other) {
    _$v = other as _$VendorWorkstreamsVerification;
  }

  @override
  void update(void Function(VendorWorkstreamsVerificationBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  VendorWorkstreamsVerification build() => _build();

  _$VendorWorkstreamsVerification _build() {
    final _$result = _$v ??
        _$VendorWorkstreamsVerification._(
          status: BuiltValueNullFieldError.checkNotNull(
              status, r'VendorWorkstreamsVerification', 'status'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
