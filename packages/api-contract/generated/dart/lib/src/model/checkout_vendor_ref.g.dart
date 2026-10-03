// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'checkout_vendor_ref.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CheckoutVendorRef extends CheckoutVendorRef {
  @override
  final String id;
  @override
  final String name;
  @override
  final String? logoUrl;
  @override
  final PublicAddressSummary? address;
  @override
  final SupplierOpenStatus? openStatus;

  factory _$CheckoutVendorRef(
          [void Function(CheckoutVendorRefBuilder)? updates]) =>
      (CheckoutVendorRefBuilder()..update(updates))._build();

  _$CheckoutVendorRef._(
      {required this.id,
      required this.name,
      this.logoUrl,
      this.address,
      this.openStatus})
      : super._();
  @override
  CheckoutVendorRef rebuild(void Function(CheckoutVendorRefBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CheckoutVendorRefBuilder toBuilder() =>
      CheckoutVendorRefBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CheckoutVendorRef &&
        id == other.id &&
        name == other.name &&
        logoUrl == other.logoUrl &&
        address == other.address &&
        openStatus == other.openStatus;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, logoUrl.hashCode);
    _$hash = $jc(_$hash, address.hashCode);
    _$hash = $jc(_$hash, openStatus.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CheckoutVendorRef')
          ..add('id', id)
          ..add('name', name)
          ..add('logoUrl', logoUrl)
          ..add('address', address)
          ..add('openStatus', openStatus))
        .toString();
  }
}

class CheckoutVendorRefBuilder
    implements Builder<CheckoutVendorRef, CheckoutVendorRefBuilder> {
  _$CheckoutVendorRef? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _logoUrl;
  String? get logoUrl => _$this._logoUrl;
  set logoUrl(String? logoUrl) => _$this._logoUrl = logoUrl;

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

  CheckoutVendorRefBuilder() {
    CheckoutVendorRef._defaults(this);
  }

  CheckoutVendorRefBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _name = $v.name;
      _logoUrl = $v.logoUrl;
      _address = $v.address?.toBuilder();
      _openStatus = $v.openStatus?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CheckoutVendorRef other) {
    _$v = other as _$CheckoutVendorRef;
  }

  @override
  void update(void Function(CheckoutVendorRefBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CheckoutVendorRef build() => _build();

  _$CheckoutVendorRef _build() {
    _$CheckoutVendorRef _$result;
    try {
      _$result = _$v ??
          _$CheckoutVendorRef._(
            id: BuiltValueNullFieldError.checkNotNull(
                id, r'CheckoutVendorRef', 'id'),
            name: BuiltValueNullFieldError.checkNotNull(
                name, r'CheckoutVendorRef', 'name'),
            logoUrl: logoUrl,
            address: _address?.build(),
            openStatus: _openStatus?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'address';
        _address?.build();
        _$failedField = 'openStatus';
        _openStatus?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'CheckoutVendorRef', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
