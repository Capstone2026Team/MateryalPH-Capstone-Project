// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'accept_vendor_commission.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AcceptVendorCommission extends AcceptVendorCommission {
  @override
  final String versionId;

  factory _$AcceptVendorCommission(
          [void Function(AcceptVendorCommissionBuilder)? updates]) =>
      (AcceptVendorCommissionBuilder()..update(updates))._build();

  _$AcceptVendorCommission._({required this.versionId}) : super._();
  @override
  AcceptVendorCommission rebuild(
          void Function(AcceptVendorCommissionBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AcceptVendorCommissionBuilder toBuilder() =>
      AcceptVendorCommissionBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AcceptVendorCommission && versionId == other.versionId;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, versionId.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AcceptVendorCommission')
          ..add('versionId', versionId))
        .toString();
  }
}

class AcceptVendorCommissionBuilder
    implements Builder<AcceptVendorCommission, AcceptVendorCommissionBuilder> {
  _$AcceptVendorCommission? _$v;

  String? _versionId;
  String? get versionId => _$this._versionId;
  set versionId(String? versionId) => _$this._versionId = versionId;

  AcceptVendorCommissionBuilder() {
    AcceptVendorCommission._defaults(this);
  }

  AcceptVendorCommissionBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _versionId = $v.versionId;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AcceptVendorCommission other) {
    _$v = other as _$AcceptVendorCommission;
  }

  @override
  void update(void Function(AcceptVendorCommissionBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AcceptVendorCommission build() => _build();

  _$AcceptVendorCommission _build() {
    final _$result = _$v ??
        _$AcceptVendorCommission._(
          versionId: BuiltValueNullFieldError.checkNotNull(
              versionId, r'AcceptVendorCommission', 'versionId'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
