// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inventory_row.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$InventoryRow extends InventoryRow {
  @override
  final String listingVariantId;
  @override
  final String listingId;
  @override
  final String listingName;
  @override
  final ListingStatus listingStatus;
  @override
  final String? variantLabel;
  @override
  final String sku;
  @override
  final String unitCode;
  @override
  final int lockVersion;
  @override
  final InventoryBalance? inventory;
  @override
  final StockLabel publicLabel;
  @override
  final StockConfirmationSchedule stockConfirmation;
  @override
  final StockConfirmationSchedule listingConfirmation;
  @override
  final InventoryPrice? price;
  @override
  final InventoryComparability comparability;
  @override
  final AutoAcceptPolicy autoAccept;

  factory _$InventoryRow([void Function(InventoryRowBuilder)? updates]) =>
      (InventoryRowBuilder()..update(updates))._build();

  _$InventoryRow._(
      {required this.listingVariantId,
      required this.listingId,
      required this.listingName,
      required this.listingStatus,
      this.variantLabel,
      required this.sku,
      required this.unitCode,
      required this.lockVersion,
      this.inventory,
      required this.publicLabel,
      required this.stockConfirmation,
      required this.listingConfirmation,
      this.price,
      required this.comparability,
      required this.autoAccept})
      : super._();
  @override
  InventoryRow rebuild(void Function(InventoryRowBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  InventoryRowBuilder toBuilder() => InventoryRowBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is InventoryRow &&
        listingVariantId == other.listingVariantId &&
        listingId == other.listingId &&
        listingName == other.listingName &&
        listingStatus == other.listingStatus &&
        variantLabel == other.variantLabel &&
        sku == other.sku &&
        unitCode == other.unitCode &&
        lockVersion == other.lockVersion &&
        inventory == other.inventory &&
        publicLabel == other.publicLabel &&
        stockConfirmation == other.stockConfirmation &&
        listingConfirmation == other.listingConfirmation &&
        price == other.price &&
        comparability == other.comparability &&
        autoAccept == other.autoAccept;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, listingVariantId.hashCode);
    _$hash = $jc(_$hash, listingId.hashCode);
    _$hash = $jc(_$hash, listingName.hashCode);
    _$hash = $jc(_$hash, listingStatus.hashCode);
    _$hash = $jc(_$hash, variantLabel.hashCode);
    _$hash = $jc(_$hash, sku.hashCode);
    _$hash = $jc(_$hash, unitCode.hashCode);
    _$hash = $jc(_$hash, lockVersion.hashCode);
    _$hash = $jc(_$hash, inventory.hashCode);
    _$hash = $jc(_$hash, publicLabel.hashCode);
    _$hash = $jc(_$hash, stockConfirmation.hashCode);
    _$hash = $jc(_$hash, listingConfirmation.hashCode);
    _$hash = $jc(_$hash, price.hashCode);
    _$hash = $jc(_$hash, comparability.hashCode);
    _$hash = $jc(_$hash, autoAccept.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'InventoryRow')
          ..add('listingVariantId', listingVariantId)
          ..add('listingId', listingId)
          ..add('listingName', listingName)
          ..add('listingStatus', listingStatus)
          ..add('variantLabel', variantLabel)
          ..add('sku', sku)
          ..add('unitCode', unitCode)
          ..add('lockVersion', lockVersion)
          ..add('inventory', inventory)
          ..add('publicLabel', publicLabel)
          ..add('stockConfirmation', stockConfirmation)
          ..add('listingConfirmation', listingConfirmation)
          ..add('price', price)
          ..add('comparability', comparability)
          ..add('autoAccept', autoAccept))
        .toString();
  }
}

class InventoryRowBuilder
    implements Builder<InventoryRow, InventoryRowBuilder> {
  _$InventoryRow? _$v;

  String? _listingVariantId;
  String? get listingVariantId => _$this._listingVariantId;
  set listingVariantId(String? listingVariantId) =>
      _$this._listingVariantId = listingVariantId;

  String? _listingId;
  String? get listingId => _$this._listingId;
  set listingId(String? listingId) => _$this._listingId = listingId;

  String? _listingName;
  String? get listingName => _$this._listingName;
  set listingName(String? listingName) => _$this._listingName = listingName;

  ListingStatus? _listingStatus;
  ListingStatus? get listingStatus => _$this._listingStatus;
  set listingStatus(ListingStatus? listingStatus) =>
      _$this._listingStatus = listingStatus;

  String? _variantLabel;
  String? get variantLabel => _$this._variantLabel;
  set variantLabel(String? variantLabel) => _$this._variantLabel = variantLabel;

  String? _sku;
  String? get sku => _$this._sku;
  set sku(String? sku) => _$this._sku = sku;

  String? _unitCode;
  String? get unitCode => _$this._unitCode;
  set unitCode(String? unitCode) => _$this._unitCode = unitCode;

  int? _lockVersion;
  int? get lockVersion => _$this._lockVersion;
  set lockVersion(int? lockVersion) => _$this._lockVersion = lockVersion;

  InventoryBalanceBuilder? _inventory;
  InventoryBalanceBuilder get inventory =>
      _$this._inventory ??= InventoryBalanceBuilder();
  set inventory(InventoryBalanceBuilder? inventory) =>
      _$this._inventory = inventory;

  StockLabel? _publicLabel;
  StockLabel? get publicLabel => _$this._publicLabel;
  set publicLabel(StockLabel? publicLabel) => _$this._publicLabel = publicLabel;

  StockConfirmationScheduleBuilder? _stockConfirmation;
  StockConfirmationScheduleBuilder get stockConfirmation =>
      _$this._stockConfirmation ??= StockConfirmationScheduleBuilder();
  set stockConfirmation(StockConfirmationScheduleBuilder? stockConfirmation) =>
      _$this._stockConfirmation = stockConfirmation;

  StockConfirmationScheduleBuilder? _listingConfirmation;
  StockConfirmationScheduleBuilder get listingConfirmation =>
      _$this._listingConfirmation ??= StockConfirmationScheduleBuilder();
  set listingConfirmation(
          StockConfirmationScheduleBuilder? listingConfirmation) =>
      _$this._listingConfirmation = listingConfirmation;

  InventoryPriceBuilder? _price;
  InventoryPriceBuilder get price => _$this._price ??= InventoryPriceBuilder();
  set price(InventoryPriceBuilder? price) => _$this._price = price;

  InventoryComparabilityBuilder? _comparability;
  InventoryComparabilityBuilder get comparability =>
      _$this._comparability ??= InventoryComparabilityBuilder();
  set comparability(InventoryComparabilityBuilder? comparability) =>
      _$this._comparability = comparability;

  AutoAcceptPolicyBuilder? _autoAccept;
  AutoAcceptPolicyBuilder get autoAccept =>
      _$this._autoAccept ??= AutoAcceptPolicyBuilder();
  set autoAccept(AutoAcceptPolicyBuilder? autoAccept) =>
      _$this._autoAccept = autoAccept;

  InventoryRowBuilder() {
    InventoryRow._defaults(this);
  }

  InventoryRowBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _listingVariantId = $v.listingVariantId;
      _listingId = $v.listingId;
      _listingName = $v.listingName;
      _listingStatus = $v.listingStatus;
      _variantLabel = $v.variantLabel;
      _sku = $v.sku;
      _unitCode = $v.unitCode;
      _lockVersion = $v.lockVersion;
      _inventory = $v.inventory?.toBuilder();
      _publicLabel = $v.publicLabel;
      _stockConfirmation = $v.stockConfirmation.toBuilder();
      _listingConfirmation = $v.listingConfirmation.toBuilder();
      _price = $v.price?.toBuilder();
      _comparability = $v.comparability.toBuilder();
      _autoAccept = $v.autoAccept.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(InventoryRow other) {
    _$v = other as _$InventoryRow;
  }

  @override
  void update(void Function(InventoryRowBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  InventoryRow build() => _build();

  _$InventoryRow _build() {
    _$InventoryRow _$result;
    try {
      _$result = _$v ??
          _$InventoryRow._(
            listingVariantId: BuiltValueNullFieldError.checkNotNull(
                listingVariantId, r'InventoryRow', 'listingVariantId'),
            listingId: BuiltValueNullFieldError.checkNotNull(
                listingId, r'InventoryRow', 'listingId'),
            listingName: BuiltValueNullFieldError.checkNotNull(
                listingName, r'InventoryRow', 'listingName'),
            listingStatus: BuiltValueNullFieldError.checkNotNull(
                listingStatus, r'InventoryRow', 'listingStatus'),
            variantLabel: variantLabel,
            sku: BuiltValueNullFieldError.checkNotNull(
                sku, r'InventoryRow', 'sku'),
            unitCode: BuiltValueNullFieldError.checkNotNull(
                unitCode, r'InventoryRow', 'unitCode'),
            lockVersion: BuiltValueNullFieldError.checkNotNull(
                lockVersion, r'InventoryRow', 'lockVersion'),
            inventory: _inventory?.build(),
            publicLabel: BuiltValueNullFieldError.checkNotNull(
                publicLabel, r'InventoryRow', 'publicLabel'),
            stockConfirmation: stockConfirmation.build(),
            listingConfirmation: listingConfirmation.build(),
            price: _price?.build(),
            comparability: comparability.build(),
            autoAccept: autoAccept.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'inventory';
        _inventory?.build();

        _$failedField = 'stockConfirmation';
        stockConfirmation.build();
        _$failedField = 'listingConfirmation';
        listingConfirmation.build();
        _$failedField = 'price';
        _price?.build();
        _$failedField = 'comparability';
        comparability.build();
        _$failedField = 'autoAccept';
        autoAccept.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'InventoryRow', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
