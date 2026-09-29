// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'listing_detail_vendor.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ListingDetailVendor extends ListingDetailVendor {
  @override
  final String id;
  @override
  final String name;
  @override
  final String? logoUrl;
  @override
  final ScoreLabel scoreLabel;
  @override
  final PublicAddressSummary address;
  @override
  final SupplierOpenStatus openStatus;
  @override
  final bool vacationMode;
  @override
  final String? supplierType;

  factory _$ListingDetailVendor(
          [void Function(ListingDetailVendorBuilder)? updates]) =>
      (ListingDetailVendorBuilder()..update(updates))._build();

  _$ListingDetailVendor._(
      {required this.id,
      required this.name,
      this.logoUrl,
      required this.scoreLabel,
      required this.address,
      required this.openStatus,
      required this.vacationMode,
      this.supplierType})
      : super._();
  @override
  ListingDetailVendor rebuild(
          void Function(ListingDetailVendorBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ListingDetailVendorBuilder toBuilder() =>
      ListingDetailVendorBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ListingDetailVendor &&
        id == other.id &&
        name == other.name &&
        logoUrl == other.logoUrl &&
        scoreLabel == other.scoreLabel &&
        address == other.address &&
        openStatus == other.openStatus &&
        vacationMode == other.vacationMode &&
        supplierType == other.supplierType;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, logoUrl.hashCode);
    _$hash = $jc(_$hash, scoreLabel.hashCode);
    _$hash = $jc(_$hash, address.hashCode);
    _$hash = $jc(_$hash, openStatus.hashCode);
    _$hash = $jc(_$hash, vacationMode.hashCode);
    _$hash = $jc(_$hash, supplierType.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ListingDetailVendor')
          ..add('id', id)
          ..add('name', name)
          ..add('logoUrl', logoUrl)
          ..add('scoreLabel', scoreLabel)
          ..add('address', address)
          ..add('openStatus', openStatus)
          ..add('vacationMode', vacationMode)
          ..add('supplierType', supplierType))
        .toString();
  }
}

class ListingDetailVendorBuilder
    implements Builder<ListingDetailVendor, ListingDetailVendorBuilder> {
  _$ListingDetailVendor? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _logoUrl;
  String? get logoUrl => _$this._logoUrl;
  set logoUrl(String? logoUrl) => _$this._logoUrl = logoUrl;

  ScoreLabelBuilder? _scoreLabel;
  ScoreLabelBuilder get scoreLabel =>
      _$this._scoreLabel ??= ScoreLabelBuilder();
  set scoreLabel(ScoreLabelBuilder? scoreLabel) =>
      _$this._scoreLabel = scoreLabel;

  PublicAddressSummaryBuilder? _address;
  PublicAddressSummaryBuilder get address =>
      _$this._address ??= PublicAddressSummaryBuilder();
  set address(PublicAddressSummaryBuilder? address) =>
      _$this._address = address;

  SupplierOpenStatusBuilder? _openStatus;
  SupplierOpenStatusBuilder get openStatus =>
      _$this._openStatus ??= SupplierOpenStatusBuilder();
  set openStatus(SupplierOpenStatusBuilder? openStatus) =>
      _$this._openStatus = openStatus;

  bool? _vacationMode;
  bool? get vacationMode => _$this._vacationMode;
  set vacationMode(bool? vacationMode) => _$this._vacationMode = vacationMode;

  String? _supplierType;
  String? get supplierType => _$this._supplierType;
  set supplierType(String? supplierType) => _$this._supplierType = supplierType;

  ListingDetailVendorBuilder() {
    ListingDetailVendor._defaults(this);
  }

  ListingDetailVendorBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _name = $v.name;
      _logoUrl = $v.logoUrl;
      _scoreLabel = $v.scoreLabel.toBuilder();
      _address = $v.address.toBuilder();
      _openStatus = $v.openStatus.toBuilder();
      _vacationMode = $v.vacationMode;
      _supplierType = $v.supplierType;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ListingDetailVendor other) {
    _$v = other as _$ListingDetailVendor;
  }

  @override
  void update(void Function(ListingDetailVendorBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ListingDetailVendor build() => _build();

  _$ListingDetailVendor _build() {
    _$ListingDetailVendor _$result;
    try {
      _$result = _$v ??
          _$ListingDetailVendor._(
            id: BuiltValueNullFieldError.checkNotNull(
                id, r'ListingDetailVendor', 'id'),
            name: BuiltValueNullFieldError.checkNotNull(
                name, r'ListingDetailVendor', 'name'),
            logoUrl: logoUrl,
            scoreLabel: scoreLabel.build(),
            address: address.build(),
            openStatus: openStatus.build(),
            vacationMode: BuiltValueNullFieldError.checkNotNull(
                vacationMode, r'ListingDetailVendor', 'vacationMode'),
            supplierType: supplierType,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'scoreLabel';
        scoreLabel.build();
        _$failedField = 'address';
        address.build();
        _$failedField = 'openStatus';
        openStatus.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'ListingDetailVendor', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
