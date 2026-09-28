// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'buyer_location_create.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$BuyerLocationCreate extends BuyerLocationCreate {
  @override
  final String resolutionToken;
  @override
  final String label;
  @override
  final BuyerLocationKind? locationKind;
  @override
  final bool? makePrimary;
  @override
  final String? contactName;
  @override
  final String? contactPhoneE164;
  @override
  final String? siteInstructions;
  @override
  final String? addressLine;

  factory _$BuyerLocationCreate(
          [void Function(BuyerLocationCreateBuilder)? updates]) =>
      (BuyerLocationCreateBuilder()..update(updates))._build();

  _$BuyerLocationCreate._(
      {required this.resolutionToken,
      required this.label,
      this.locationKind,
      this.makePrimary,
      this.contactName,
      this.contactPhoneE164,
      this.siteInstructions,
      this.addressLine})
      : super._();
  @override
  BuyerLocationCreate rebuild(
          void Function(BuyerLocationCreateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  BuyerLocationCreateBuilder toBuilder() =>
      BuyerLocationCreateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is BuyerLocationCreate &&
        resolutionToken == other.resolutionToken &&
        label == other.label &&
        locationKind == other.locationKind &&
        makePrimary == other.makePrimary &&
        contactName == other.contactName &&
        contactPhoneE164 == other.contactPhoneE164 &&
        siteInstructions == other.siteInstructions &&
        addressLine == other.addressLine;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, resolutionToken.hashCode);
    _$hash = $jc(_$hash, label.hashCode);
    _$hash = $jc(_$hash, locationKind.hashCode);
    _$hash = $jc(_$hash, makePrimary.hashCode);
    _$hash = $jc(_$hash, contactName.hashCode);
    _$hash = $jc(_$hash, contactPhoneE164.hashCode);
    _$hash = $jc(_$hash, siteInstructions.hashCode);
    _$hash = $jc(_$hash, addressLine.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'BuyerLocationCreate')
          ..add('resolutionToken', resolutionToken)
          ..add('label', label)
          ..add('locationKind', locationKind)
          ..add('makePrimary', makePrimary)
          ..add('contactName', contactName)
          ..add('contactPhoneE164', contactPhoneE164)
          ..add('siteInstructions', siteInstructions)
          ..add('addressLine', addressLine))
        .toString();
  }
}

class BuyerLocationCreateBuilder
    implements Builder<BuyerLocationCreate, BuyerLocationCreateBuilder> {
  _$BuyerLocationCreate? _$v;

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

  bool? _makePrimary;
  bool? get makePrimary => _$this._makePrimary;
  set makePrimary(bool? makePrimary) => _$this._makePrimary = makePrimary;

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

  BuyerLocationCreateBuilder() {
    BuyerLocationCreate._defaults(this);
  }

  BuyerLocationCreateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _resolutionToken = $v.resolutionToken;
      _label = $v.label;
      _locationKind = $v.locationKind;
      _makePrimary = $v.makePrimary;
      _contactName = $v.contactName;
      _contactPhoneE164 = $v.contactPhoneE164;
      _siteInstructions = $v.siteInstructions;
      _addressLine = $v.addressLine;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(BuyerLocationCreate other) {
    _$v = other as _$BuyerLocationCreate;
  }

  @override
  void update(void Function(BuyerLocationCreateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  BuyerLocationCreate build() => _build();

  _$BuyerLocationCreate _build() {
    final _$result = _$v ??
        _$BuyerLocationCreate._(
          resolutionToken: BuiltValueNullFieldError.checkNotNull(
              resolutionToken, r'BuyerLocationCreate', 'resolutionToken'),
          label: BuiltValueNullFieldError.checkNotNull(
              label, r'BuyerLocationCreate', 'label'),
          locationKind: locationKind,
          makePrimary: makePrimary,
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
