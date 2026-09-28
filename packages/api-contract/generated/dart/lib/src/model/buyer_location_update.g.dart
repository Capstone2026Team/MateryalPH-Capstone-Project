// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'buyer_location_update.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$BuyerLocationUpdate extends BuyerLocationUpdate {
  @override
  final int lockVersion;
  @override
  final String? resolutionToken;
  @override
  final String? label;
  @override
  final BuyerLocationKind? locationKind;
  @override
  final String? contactName;
  @override
  final String? contactPhoneE164;
  @override
  final String? siteInstructions;
  @override
  final String? addressLine;

  factory _$BuyerLocationUpdate(
          [void Function(BuyerLocationUpdateBuilder)? updates]) =>
      (BuyerLocationUpdateBuilder()..update(updates))._build();

  _$BuyerLocationUpdate._(
      {required this.lockVersion,
      this.resolutionToken,
      this.label,
      this.locationKind,
      this.contactName,
      this.contactPhoneE164,
      this.siteInstructions,
      this.addressLine})
      : super._();
  @override
  BuyerLocationUpdate rebuild(
          void Function(BuyerLocationUpdateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  BuyerLocationUpdateBuilder toBuilder() =>
      BuyerLocationUpdateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is BuyerLocationUpdate &&
        lockVersion == other.lockVersion &&
        resolutionToken == other.resolutionToken &&
        label == other.label &&
        locationKind == other.locationKind &&
        contactName == other.contactName &&
        contactPhoneE164 == other.contactPhoneE164 &&
        siteInstructions == other.siteInstructions &&
        addressLine == other.addressLine;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, lockVersion.hashCode);
    _$hash = $jc(_$hash, resolutionToken.hashCode);
    _$hash = $jc(_$hash, label.hashCode);
    _$hash = $jc(_$hash, locationKind.hashCode);
    _$hash = $jc(_$hash, contactName.hashCode);
    _$hash = $jc(_$hash, contactPhoneE164.hashCode);
    _$hash = $jc(_$hash, siteInstructions.hashCode);
    _$hash = $jc(_$hash, addressLine.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'BuyerLocationUpdate')
          ..add('lockVersion', lockVersion)
          ..add('resolutionToken', resolutionToken)
          ..add('label', label)
          ..add('locationKind', locationKind)
          ..add('contactName', contactName)
          ..add('contactPhoneE164', contactPhoneE164)
          ..add('siteInstructions', siteInstructions)
          ..add('addressLine', addressLine))
        .toString();
  }
}

class BuyerLocationUpdateBuilder
    implements Builder<BuyerLocationUpdate, BuyerLocationUpdateBuilder> {
  _$BuyerLocationUpdate? _$v;

  int? _lockVersion;
  int? get lockVersion => _$this._lockVersion;
  set lockVersion(int? lockVersion) => _$this._lockVersion = lockVersion;

  String? _resolutionToken;
  String? get resolutionToken => _$this._resolutionToken;
  set resolutionToken(String? resolutionToken) =>
      _$this._resolutionToken = resolutionToken;

  String? _label;
  String? get label => _$this._label;
  set label(String? label) => _$this._label = label;

  BuyerLocationKind? _locationKind;
  BuyerLocationKind? get locationKind => _$this._locationKind;
  set locationKind(BuyerLocationKind? locationKind) =>
      _$this._locationKind = locationKind;

  String? _contactName;
  String? get contactName => _$this._contactName;
  set contactName(String? contactName) => _$this._contactName = contactName;

  String? _contactPhoneE164;
  String? get contactPhoneE164 => _$this._contactPhoneE164;
  set contactPhoneE164(String? contactPhoneE164) =>
      _$this._contactPhoneE164 = contactPhoneE164;

  String? _siteInstructions;
  String? get siteInstructions => _$this._siteInstructions;
  set siteInstructions(String? siteInstructions) =>
      _$this._siteInstructions = siteInstructions;

  String? _addressLine;
  String? get addressLine => _$this._addressLine;
  set addressLine(String? addressLine) => _$this._addressLine = addressLine;

  BuyerLocationUpdateBuilder() {
    BuyerLocationUpdate._defaults(this);
  }

  BuyerLocationUpdateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _lockVersion = $v.lockVersion;
      _resolutionToken = $v.resolutionToken;
      _label = $v.label;
      _locationKind = $v.locationKind;
      _contactName = $v.contactName;
      _contactPhoneE164 = $v.contactPhoneE164;
      _siteInstructions = $v.siteInstructions;
      _addressLine = $v.addressLine;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(BuyerLocationUpdate other) {
    _$v = other as _$BuyerLocationUpdate;
  }

  @override
  void update(void Function(BuyerLocationUpdateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  BuyerLocationUpdate build() => _build();

  _$BuyerLocationUpdate _build() {
    final _$result = _$v ??
        _$BuyerLocationUpdate._(
          lockVersion: BuiltValueNullFieldError.checkNotNull(
              lockVersion, r'BuyerLocationUpdate', 'lockVersion'),
          resolutionToken: resolutionToken,
          label: label,
          locationKind: locationKind,
          contactName: contactName,
          contactPhoneE164: contactPhoneE164,
          siteInstructions: siteInstructions,
          addressLine: addressLine,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
