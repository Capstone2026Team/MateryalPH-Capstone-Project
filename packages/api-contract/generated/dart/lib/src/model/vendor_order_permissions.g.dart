// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_order_permissions.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$VendorOrderPermissions extends VendorOrderPermissions {
  @override
  final bool canConfirm;
  @override
  final bool canRevise;
  @override
  final bool canSetNrpc;
  @override
  final bool canConfirmDelivery;
  @override
  final bool canDecline;
  @override
  final bool canViewInventory;

  factory _$VendorOrderPermissions(
          [void Function(VendorOrderPermissionsBuilder)? updates]) =>
      (VendorOrderPermissionsBuilder()..update(updates))._build();

  _$VendorOrderPermissions._(
      {required this.canConfirm,
      required this.canRevise,
      required this.canSetNrpc,
      required this.canConfirmDelivery,
      required this.canDecline,
      required this.canViewInventory})
      : super._();
  @override
  VendorOrderPermissions rebuild(
          void Function(VendorOrderPermissionsBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  VendorOrderPermissionsBuilder toBuilder() =>
      VendorOrderPermissionsBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is VendorOrderPermissions &&
        canConfirm == other.canConfirm &&
        canRevise == other.canRevise &&
        canSetNrpc == other.canSetNrpc &&
        canConfirmDelivery == other.canConfirmDelivery &&
        canDecline == other.canDecline &&
        canViewInventory == other.canViewInventory;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, canConfirm.hashCode);
    _$hash = $jc(_$hash, canRevise.hashCode);
    _$hash = $jc(_$hash, canSetNrpc.hashCode);
    _$hash = $jc(_$hash, canConfirmDelivery.hashCode);
    _$hash = $jc(_$hash, canDecline.hashCode);
    _$hash = $jc(_$hash, canViewInventory.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'VendorOrderPermissions')
          ..add('canConfirm', canConfirm)
          ..add('canRevise', canRevise)
          ..add('canSetNrpc', canSetNrpc)
          ..add('canConfirmDelivery', canConfirmDelivery)
          ..add('canDecline', canDecline)
          ..add('canViewInventory', canViewInventory))
        .toString();
  }
}

class VendorOrderPermissionsBuilder
    implements Builder<VendorOrderPermissions, VendorOrderPermissionsBuilder> {
  _$VendorOrderPermissions? _$v;

  bool? _canConfirm;
  bool? get canConfirm => _$this._canConfirm;
  set canConfirm(bool? canConfirm) => _$this._canConfirm = canConfirm;

  bool? _canRevise;
  bool? get canRevise => _$this._canRevise;
  set canRevise(bool? canRevise) => _$this._canRevise = canRevise;

  bool? _canSetNrpc;
  bool? get canSetNrpc => _$this._canSetNrpc;
  set canSetNrpc(bool? canSetNrpc) => _$this._canSetNrpc = canSetNrpc;

  bool? _canConfirmDelivery;
  bool? get canConfirmDelivery => _$this._canConfirmDelivery;
  set canConfirmDelivery(bool? canConfirmDelivery) =>
      _$this._canConfirmDelivery = canConfirmDelivery;

  bool? _canDecline;
  bool? get canDecline => _$this._canDecline;
  set canDecline(bool? canDecline) => _$this._canDecline = canDecline;

  bool? _canViewInventory;
  bool? get canViewInventory => _$this._canViewInventory;
  set canViewInventory(bool? canViewInventory) =>
      _$this._canViewInventory = canViewInventory;

  VendorOrderPermissionsBuilder() {
    VendorOrderPermissions._defaults(this);
  }

  VendorOrderPermissionsBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _canConfirm = $v.canConfirm;
      _canRevise = $v.canRevise;
      _canSetNrpc = $v.canSetNrpc;
      _canConfirmDelivery = $v.canConfirmDelivery;
      _canDecline = $v.canDecline;
      _canViewInventory = $v.canViewInventory;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(VendorOrderPermissions other) {
    _$v = other as _$VendorOrderPermissions;
  }

  @override
  void update(void Function(VendorOrderPermissionsBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  VendorOrderPermissions build() => _build();

  _$VendorOrderPermissions _build() {
    final _$result = _$v ??
        _$VendorOrderPermissions._(
          canConfirm: BuiltValueNullFieldError.checkNotNull(
              canConfirm, r'VendorOrderPermissions', 'canConfirm'),
          canRevise: BuiltValueNullFieldError.checkNotNull(
              canRevise, r'VendorOrderPermissions', 'canRevise'),
          canSetNrpc: BuiltValueNullFieldError.checkNotNull(
              canSetNrpc, r'VendorOrderPermissions', 'canSetNrpc'),
          canConfirmDelivery: BuiltValueNullFieldError.checkNotNull(
              canConfirmDelivery,
              r'VendorOrderPermissions',
              'canConfirmDelivery'),
          canDecline: BuiltValueNullFieldError.checkNotNull(
              canDecline, r'VendorOrderPermissions', 'canDecline'),
          canViewInventory: BuiltValueNullFieldError.checkNotNull(
              canViewInventory, r'VendorOrderPermissions', 'canViewInventory'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
