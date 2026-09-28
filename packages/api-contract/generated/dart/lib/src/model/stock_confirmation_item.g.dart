// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stock_confirmation_item.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$StockConfirmationItem extends StockConfirmationItem {
  @override
  final String listingVariantId;
  @override
  final int lockVersion;

  factory _$StockConfirmationItem(
          [void Function(StockConfirmationItemBuilder)? updates]) =>
      (StockConfirmationItemBuilder()..update(updates))._build();

  _$StockConfirmationItem._(
      {required this.listingVariantId, required this.lockVersion})
      : super._();
  @override
  StockConfirmationItem rebuild(
          void Function(StockConfirmationItemBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  StockConfirmationItemBuilder toBuilder() =>
      StockConfirmationItemBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is StockConfirmationItem &&
        listingVariantId == other.listingVariantId &&
        lockVersion == other.lockVersion;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, listingVariantId.hashCode);
    _$hash = $jc(_$hash, lockVersion.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'StockConfirmationItem')
          ..add('listingVariantId', listingVariantId)
          ..add('lockVersion', lockVersion))
        .toString();
  }
}

class StockConfirmationItemBuilder
    implements Builder<StockConfirmationItem, StockConfirmationItemBuilder> {
  _$StockConfirmationItem? _$v;

  String? _listingVariantId;
  String? get listingVariantId => _$this._listingVariantId;
  set listingVariantId(String? listingVariantId) =>
      _$this._listingVariantId = listingVariantId;

  int? _lockVersion;
  int? get lockVersion => _$this._lockVersion;
  set lockVersion(int? lockVersion) => _$this._lockVersion = lockVersion;

  StockConfirmationItemBuilder() {
    StockConfirmationItem._defaults(this);
  }

  StockConfirmationItemBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _listingVariantId = $v.listingVariantId;
      _lockVersion = $v.lockVersion;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(StockConfirmationItem other) {
    _$v = other as _$StockConfirmationItem;
  }

  @override
  void update(void Function(StockConfirmationItemBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  StockConfirmationItem build() => _build();

  _$StockConfirmationItem _build() {
    final _$result = _$v ??
        _$StockConfirmationItem._(
          listingVariantId: BuiltValueNullFieldError.checkNotNull(
              listingVariantId, r'StockConfirmationItem', 'listingVariantId'),
          lockVersion: BuiltValueNullFieldError.checkNotNull(
              lockVersion, r'StockConfirmationItem', 'lockVersion'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
