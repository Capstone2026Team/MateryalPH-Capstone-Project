// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'verified_vendor_summary.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$VerifiedVendorSummary extends VerifiedVendorSummary {
  @override
  final String? logoUrl;
  @override
  final String? supplierType;
  @override
  final BuiltList<String> niches;
  @override
  final String? fulfillmentMethod;
  @override
  final bool vacationMode;
  @override
  final String? publicPhone;
  @override
  final PublicAddressSummary address;
  @override
  final SupplierOpenStatus openStatus;
  @override
  final SupplierServiceability serviceability;

  factory _$VerifiedVendorSummary(
          [void Function(VerifiedVendorSummaryBuilder)? updates]) =>
      (VerifiedVendorSummaryBuilder()..update(updates))._build();

  _$VerifiedVendorSummary._(
      {this.logoUrl,
      this.supplierType,
      required this.niches,
      this.fulfillmentMethod,
      required this.vacationMode,
      this.publicPhone,
      required this.address,
      required this.openStatus,
      required this.serviceability})
      : super._();
  @override
  VerifiedVendorSummary rebuild(
          void Function(VerifiedVendorSummaryBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  VerifiedVendorSummaryBuilder toBuilder() =>
      VerifiedVendorSummaryBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is VerifiedVendorSummary &&
        logoUrl == other.logoUrl &&
        supplierType == other.supplierType &&
        niches == other.niches &&
        fulfillmentMethod == other.fulfillmentMethod &&
        vacationMode == other.vacationMode &&
        publicPhone == other.publicPhone &&
        address == other.address &&
        openStatus == other.openStatus &&
        serviceability == other.serviceability;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, logoUrl.hashCode);
    _$hash = $jc(_$hash, supplierType.hashCode);
    _$hash = $jc(_$hash, niches.hashCode);
    _$hash = $jc(_$hash, fulfillmentMethod.hashCode);
    _$hash = $jc(_$hash, vacationMode.hashCode);
    _$hash = $jc(_$hash, publicPhone.hashCode);
    _$hash = $jc(_$hash, address.hashCode);
    _$hash = $jc(_$hash, openStatus.hashCode);
    _$hash = $jc(_$hash, serviceability.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'VerifiedVendorSummary')
          ..add('logoUrl', logoUrl)
          ..add('supplierType', supplierType)
          ..add('niches', niches)
          ..add('fulfillmentMethod', fulfillmentMethod)
          ..add('vacationMode', vacationMode)
          ..add('publicPhone', publicPhone)
          ..add('address', address)
          ..add('openStatus', openStatus)
          ..add('serviceability', serviceability))
        .toString();
  }
}

class VerifiedVendorSummaryBuilder
    implements Builder<VerifiedVendorSummary, VerifiedVendorSummaryBuilder> {
  _$VerifiedVendorSummary? _$v;

  String? _logoUrl;
  String? get logoUrl => _$this._logoUrl;
  set logoUrl(String? logoUrl) => _$this._logoUrl = logoUrl;

  String? _supplierType;
  String? get supplierType => _$this._supplierType;
  set supplierType(String? supplierType) => _$this._supplierType = supplierType;

  ListBuilder<String>? _niches;
  ListBuilder<String> get niches => _$this._niches ??= ListBuilder<String>();
  set niches(ListBuilder<String>? niches) => _$this._niches = niches;

  String? _fulfillmentMethod;
  String? get fulfillmentMethod => _$this._fulfillmentMethod;
  set fulfillmentMethod(String? fulfillmentMethod) =>
      _$this._fulfillmentMethod = fulfillmentMethod;

  bool? _vacationMode;
  bool? get vacationMode => _$this._vacationMode;
  set vacationMode(bool? vacationMode) => _$this._vacationMode = vacationMode;

  String? _publicPhone;
  String? get publicPhone => _$this._publicPhone;
  set publicPhone(String? publicPhone) => _$this._publicPhone = publicPhone;

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

  SupplierServiceabilityBuilder? _serviceability;
  SupplierServiceabilityBuilder get serviceability =>
      _$this._serviceability ??= SupplierServiceabilityBuilder();
  set serviceability(SupplierServiceabilityBuilder? serviceability) =>
      _$this._serviceability = serviceability;

  VerifiedVendorSummaryBuilder() {
    VerifiedVendorSummary._defaults(this);
  }

  VerifiedVendorSummaryBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _logoUrl = $v.logoUrl;
      _supplierType = $v.supplierType;
      _niches = $v.niches.toBuilder();
      _fulfillmentMethod = $v.fulfillmentMethod;
      _vacationMode = $v.vacationMode;
      _publicPhone = $v.publicPhone;
      _address = $v.address.toBuilder();
      _openStatus = $v.openStatus.toBuilder();
      _serviceability = $v.serviceability.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(VerifiedVendorSummary other) {
    _$v = other as _$VerifiedVendorSummary;
  }

  @override
  void update(void Function(VerifiedVendorSummaryBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  VerifiedVendorSummary build() => _build();

  _$VerifiedVendorSummary _build() {
    _$VerifiedVendorSummary _$result;
    try {
      _$result = _$v ??
          _$VerifiedVendorSummary._(
            logoUrl: logoUrl,
            supplierType: supplierType,
            niches: niches.build(),
            fulfillmentMethod: fulfillmentMethod,
            vacationMode: BuiltValueNullFieldError.checkNotNull(
                vacationMode, r'VerifiedVendorSummary', 'vacationMode'),
            publicPhone: publicPhone,
            address: address.build(),
            openStatus: openStatus.build(),
            serviceability: serviceability.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'niches';
        niches.build();

        _$failedField = 'address';
        address.build();
        _$failedField = 'openStatus';
        openStatus.build();
        _$failedField = 'serviceability';
        serviceability.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'VerifiedVendorSummary', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
