// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dispute_vendor_permissions.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$DisputeVendorPermissions extends DisputeVendorPermissions {
  @override
  final bool canRespond;
  @override
  final bool canOfferRefund;

  factory _$DisputeVendorPermissions(
          [void Function(DisputeVendorPermissionsBuilder)? updates]) =>
      (DisputeVendorPermissionsBuilder()..update(updates))._build();

  _$DisputeVendorPermissions._(
      {required this.canRespond, required this.canOfferRefund})
      : super._();
  @override
  DisputeVendorPermissions rebuild(
          void Function(DisputeVendorPermissionsBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DisputeVendorPermissionsBuilder toBuilder() =>
      DisputeVendorPermissionsBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DisputeVendorPermissions &&
        canRespond == other.canRespond &&
        canOfferRefund == other.canOfferRefund;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, canRespond.hashCode);
    _$hash = $jc(_$hash, canOfferRefund.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'DisputeVendorPermissions')
          ..add('canRespond', canRespond)
          ..add('canOfferRefund', canOfferRefund))
        .toString();
  }
}

class DisputeVendorPermissionsBuilder
    implements
        Builder<DisputeVendorPermissions, DisputeVendorPermissionsBuilder> {
  _$DisputeVendorPermissions? _$v;

  bool? _canRespond;
  bool? get canRespond => _$this._canRespond;
  set canRespond(bool? canRespond) => _$this._canRespond = canRespond;

  bool? _canOfferRefund;
  bool? get canOfferRefund => _$this._canOfferRefund;
  set canOfferRefund(bool? canOfferRefund) =>
      _$this._canOfferRefund = canOfferRefund;

  DisputeVendorPermissionsBuilder() {
    DisputeVendorPermissions._defaults(this);
  }

  DisputeVendorPermissionsBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _canRespond = $v.canRespond;
      _canOfferRefund = $v.canOfferRefund;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DisputeVendorPermissions other) {
    _$v = other as _$DisputeVendorPermissions;
  }

  @override
  void update(void Function(DisputeVendorPermissionsBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DisputeVendorPermissions build() => _build();

  _$DisputeVendorPermissions _build() {
    final _$result = _$v ??
        _$DisputeVendorPermissions._(
          canRespond: BuiltValueNullFieldError.checkNotNull(
              canRespond, r'DisputeVendorPermissions', 'canRespond'),
          canOfferRefund: BuiltValueNullFieldError.checkNotNull(
              canOfferRefund, r'DisputeVendorPermissions', 'canOfferRefund'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
