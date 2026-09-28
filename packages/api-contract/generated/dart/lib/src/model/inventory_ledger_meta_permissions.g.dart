// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inventory_ledger_meta_permissions.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$InventoryLedgerMetaPermissions extends InventoryLedgerMetaPermissions {
  @override
  final bool canAdjust;
  @override
  final bool canChangePrice;
  @override
  final bool canConfigureAutoAccept;
  @override
  final bool canUpdateAllotment;
  @override
  final bool canViewAutoAccept;
  @override
  final bool canEditSettings;

  factory _$InventoryLedgerMetaPermissions(
          [void Function(InventoryLedgerMetaPermissionsBuilder)? updates]) =>
      (InventoryLedgerMetaPermissionsBuilder()..update(updates))._build();

  _$InventoryLedgerMetaPermissions._(
      {required this.canAdjust,
      required this.canChangePrice,
      required this.canConfigureAutoAccept,
      required this.canUpdateAllotment,
      required this.canViewAutoAccept,
      required this.canEditSettings})
      : super._();
  @override
  InventoryLedgerMetaPermissions rebuild(
          void Function(InventoryLedgerMetaPermissionsBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  InventoryLedgerMetaPermissionsBuilder toBuilder() =>
      InventoryLedgerMetaPermissionsBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is InventoryLedgerMetaPermissions &&
        canAdjust == other.canAdjust &&
        canChangePrice == other.canChangePrice &&
        canConfigureAutoAccept == other.canConfigureAutoAccept &&
        canUpdateAllotment == other.canUpdateAllotment &&
        canViewAutoAccept == other.canViewAutoAccept &&
        canEditSettings == other.canEditSettings;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, canAdjust.hashCode);
    _$hash = $jc(_$hash, canChangePrice.hashCode);
    _$hash = $jc(_$hash, canConfigureAutoAccept.hashCode);
    _$hash = $jc(_$hash, canUpdateAllotment.hashCode);
    _$hash = $jc(_$hash, canViewAutoAccept.hashCode);
    _$hash = $jc(_$hash, canEditSettings.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'InventoryLedgerMetaPermissions')
          ..add('canAdjust', canAdjust)
          ..add('canChangePrice', canChangePrice)
          ..add('canConfigureAutoAccept', canConfigureAutoAccept)
          ..add('canUpdateAllotment', canUpdateAllotment)
          ..add('canViewAutoAccept', canViewAutoAccept)
          ..add('canEditSettings', canEditSettings))
        .toString();
  }
}

class InventoryLedgerMetaPermissionsBuilder
    implements
        Builder<InventoryLedgerMetaPermissions,
            InventoryLedgerMetaPermissionsBuilder> {
  _$InventoryLedgerMetaPermissions? _$v;

  bool? _canAdjust;
  bool? get canAdjust => _$this._canAdjust;
  set canAdjust(bool? canAdjust) => _$this._canAdjust = canAdjust;

  bool? _canChangePrice;
  bool? get canChangePrice => _$this._canChangePrice;
  set canChangePrice(bool? canChangePrice) =>
      _$this._canChangePrice = canChangePrice;

  bool? _canConfigureAutoAccept;
  bool? get canConfigureAutoAccept => _$this._canConfigureAutoAccept;
  set canConfigureAutoAccept(bool? canConfigureAutoAccept) =>
      _$this._canConfigureAutoAccept = canConfigureAutoAccept;

  bool? _canUpdateAllotment;
  bool? get canUpdateAllotment => _$this._canUpdateAllotment;
  set canUpdateAllotment(bool? canUpdateAllotment) =>
      _$this._canUpdateAllotment = canUpdateAllotment;

  bool? _canViewAutoAccept;
  bool? get canViewAutoAccept => _$this._canViewAutoAccept;
  set canViewAutoAccept(bool? canViewAutoAccept) =>
      _$this._canViewAutoAccept = canViewAutoAccept;

  bool? _canEditSettings;
  bool? get canEditSettings => _$this._canEditSettings;
  set canEditSettings(bool? canEditSettings) =>
      _$this._canEditSettings = canEditSettings;

  InventoryLedgerMetaPermissionsBuilder() {
    InventoryLedgerMetaPermissions._defaults(this);
  }

  InventoryLedgerMetaPermissionsBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _canAdjust = $v.canAdjust;
      _canChangePrice = $v.canChangePrice;
      _canConfigureAutoAccept = $v.canConfigureAutoAccept;
      _canUpdateAllotment = $v.canUpdateAllotment;
      _canViewAutoAccept = $v.canViewAutoAccept;
      _canEditSettings = $v.canEditSettings;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(InventoryLedgerMetaPermissions other) {
    _$v = other as _$InventoryLedgerMetaPermissions;
  }

  @override
  void update(void Function(InventoryLedgerMetaPermissionsBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  InventoryLedgerMetaPermissions build() => _build();

  _$InventoryLedgerMetaPermissions _build() {
    final _$result = _$v ??
        _$InventoryLedgerMetaPermissions._(
          canAdjust: BuiltValueNullFieldError.checkNotNull(
              canAdjust, r'InventoryLedgerMetaPermissions', 'canAdjust'),
          canChangePrice: BuiltValueNullFieldError.checkNotNull(canChangePrice,
              r'InventoryLedgerMetaPermissions', 'canChangePrice'),
          canConfigureAutoAccept: BuiltValueNullFieldError.checkNotNull(
              canConfigureAutoAccept,
              r'InventoryLedgerMetaPermissions',
              'canConfigureAutoAccept'),
          canUpdateAllotment: BuiltValueNullFieldError.checkNotNull(
              canUpdateAllotment,
              r'InventoryLedgerMetaPermissions',
              'canUpdateAllotment'),
          canViewAutoAccept: BuiltValueNullFieldError.checkNotNull(
              canViewAutoAccept,
              r'InventoryLedgerMetaPermissions',
              'canViewAutoAccept'),
          canEditSettings: BuiltValueNullFieldError.checkNotNull(
              canEditSettings,
              r'InventoryLedgerMetaPermissions',
              'canEditSettings'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
