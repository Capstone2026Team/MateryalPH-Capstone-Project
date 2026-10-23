// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'material_offer.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const MaterialOfferAvailabilityEnum _$materialOfferAvailabilityEnum_IN_STOCK =
    const MaterialOfferAvailabilityEnum._('IN_STOCK');
const MaterialOfferAvailabilityEnum
    _$materialOfferAvailabilityEnum_LIMITED_STOCK =
    const MaterialOfferAvailabilityEnum._('LIMITED_STOCK');
const MaterialOfferAvailabilityEnum
    _$materialOfferAvailabilityEnum_OUT_OF_STOCK =
    const MaterialOfferAvailabilityEnum._('OUT_OF_STOCK');

MaterialOfferAvailabilityEnum _$materialOfferAvailabilityEnumValueOf(
    String name) {
  switch (name) {
    case 'IN_STOCK':
      return _$materialOfferAvailabilityEnum_IN_STOCK;
    case 'LIMITED_STOCK':
      return _$materialOfferAvailabilityEnum_LIMITED_STOCK;
    case 'OUT_OF_STOCK':
      return _$materialOfferAvailabilityEnum_OUT_OF_STOCK;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<MaterialOfferAvailabilityEnum>
    _$materialOfferAvailabilityEnumValues = BuiltSet<
        MaterialOfferAvailabilityEnum>(const <MaterialOfferAvailabilityEnum>[
  _$materialOfferAvailabilityEnum_IN_STOCK,
  _$materialOfferAvailabilityEnum_LIMITED_STOCK,
  _$materialOfferAvailabilityEnum_OUT_OF_STOCK,
]);

Serializer<MaterialOfferAvailabilityEnum>
    _$materialOfferAvailabilityEnumSerializer =
    _$MaterialOfferAvailabilityEnumSerializer();

class _$MaterialOfferAvailabilityEnumSerializer
    implements PrimitiveSerializer<MaterialOfferAvailabilityEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'IN_STOCK': 'IN_STOCK',
    'LIMITED_STOCK': 'LIMITED_STOCK',
    'OUT_OF_STOCK': 'OUT_OF_STOCK',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'IN_STOCK': 'IN_STOCK',
    'LIMITED_STOCK': 'LIMITED_STOCK',
    'OUT_OF_STOCK': 'OUT_OF_STOCK',
  };

  @override
  final Iterable<Type> types = const <Type>[MaterialOfferAvailabilityEnum];
  @override
  final String wireName = 'MaterialOfferAvailabilityEnum';

  @override
  Object serialize(
          Serializers serializers, MaterialOfferAvailabilityEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  MaterialOfferAvailabilityEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      MaterialOfferAvailabilityEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$MaterialOffer extends MaterialOffer {
  @override
  final String vendorId;
  @override
  final String storeName;
  @override
  final String listingId;
  @override
  final String variantId;
  @override
  final String displayName;
  @override
  final String? variantLabel;
  @override
  final int priceCentavos;
  @override
  final String normalizedPhp;
  @override
  final String taxCategory;
  @override
  final String taxLabel;
  @override
  final MaterialOfferAvailabilityEnum availability;
  @override
  final int distanceMeters;
  @override
  final DateTime priceAsOf;
  @override
  final ListingImage? image;

  factory _$MaterialOffer([void Function(MaterialOfferBuilder)? updates]) =>
      (MaterialOfferBuilder()..update(updates))._build();

  _$MaterialOffer._(
      {required this.vendorId,
      required this.storeName,
      required this.listingId,
      required this.variantId,
      required this.displayName,
      this.variantLabel,
      required this.priceCentavos,
      required this.normalizedPhp,
      required this.taxCategory,
      required this.taxLabel,
      required this.availability,
      required this.distanceMeters,
      required this.priceAsOf,
      this.image})
      : super._();
  @override
  MaterialOffer rebuild(void Function(MaterialOfferBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  MaterialOfferBuilder toBuilder() => MaterialOfferBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MaterialOffer &&
        vendorId == other.vendorId &&
        storeName == other.storeName &&
        listingId == other.listingId &&
        variantId == other.variantId &&
        displayName == other.displayName &&
        variantLabel == other.variantLabel &&
        priceCentavos == other.priceCentavos &&
        normalizedPhp == other.normalizedPhp &&
        taxCategory == other.taxCategory &&
        taxLabel == other.taxLabel &&
        availability == other.availability &&
        distanceMeters == other.distanceMeters &&
        priceAsOf == other.priceAsOf &&
        image == other.image;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, vendorId.hashCode);
    _$hash = $jc(_$hash, storeName.hashCode);
    _$hash = $jc(_$hash, listingId.hashCode);
    _$hash = $jc(_$hash, variantId.hashCode);
    _$hash = $jc(_$hash, displayName.hashCode);
    _$hash = $jc(_$hash, variantLabel.hashCode);
    _$hash = $jc(_$hash, priceCentavos.hashCode);
    _$hash = $jc(_$hash, normalizedPhp.hashCode);
    _$hash = $jc(_$hash, taxCategory.hashCode);
    _$hash = $jc(_$hash, taxLabel.hashCode);
    _$hash = $jc(_$hash, availability.hashCode);
    _$hash = $jc(_$hash, distanceMeters.hashCode);
    _$hash = $jc(_$hash, priceAsOf.hashCode);
    _$hash = $jc(_$hash, image.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'MaterialOffer')
          ..add('vendorId', vendorId)
          ..add('storeName', storeName)
          ..add('listingId', listingId)
          ..add('variantId', variantId)
          ..add('displayName', displayName)
          ..add('variantLabel', variantLabel)
          ..add('priceCentavos', priceCentavos)
          ..add('normalizedPhp', normalizedPhp)
          ..add('taxCategory', taxCategory)
          ..add('taxLabel', taxLabel)
          ..add('availability', availability)
          ..add('distanceMeters', distanceMeters)
          ..add('priceAsOf', priceAsOf)
          ..add('image', image))
        .toString();
  }
}

class MaterialOfferBuilder
    implements Builder<MaterialOffer, MaterialOfferBuilder> {
  _$MaterialOffer? _$v;

  String? _vendorId;
  String? get vendorId => _$this._vendorId;
  set vendorId(String? vendorId) => _$this._vendorId = vendorId;

  String? _storeName;
  String? get storeName => _$this._storeName;
  set storeName(String? storeName) => _$this._storeName = storeName;

  String? _listingId;
  String? get listingId => _$this._listingId;
  set listingId(String? listingId) => _$this._listingId = listingId;

  String? _variantId;
  String? get variantId => _$this._variantId;
  set variantId(String? variantId) => _$this._variantId = variantId;

  String? _displayName;
  String? get displayName => _$this._displayName;
  set displayName(String? displayName) => _$this._displayName = displayName;

  String? _variantLabel;
  String? get variantLabel => _$this._variantLabel;
  set variantLabel(String? variantLabel) => _$this._variantLabel = variantLabel;

  int? _priceCentavos;
  int? get priceCentavos => _$this._priceCentavos;
  set priceCentavos(int? priceCentavos) =>
      _$this._priceCentavos = priceCentavos;

  String? _normalizedPhp;
  String? get normalizedPhp => _$this._normalizedPhp;
  set normalizedPhp(String? normalizedPhp) =>
      _$this._normalizedPhp = normalizedPhp;

  String? _taxCategory;
  String? get taxCategory => _$this._taxCategory;
  set taxCategory(String? taxCategory) => _$this._taxCategory = taxCategory;

  String? _taxLabel;
  String? get taxLabel => _$this._taxLabel;
  set taxLabel(String? taxLabel) => _$this._taxLabel = taxLabel;

  MaterialOfferAvailabilityEnum? _availability;
  MaterialOfferAvailabilityEnum? get availability => _$this._availability;
  set availability(MaterialOfferAvailabilityEnum? availability) =>
      _$this._availability = availability;

  int? _distanceMeters;
  int? get distanceMeters => _$this._distanceMeters;
  set distanceMeters(int? distanceMeters) =>
      _$this._distanceMeters = distanceMeters;

  DateTime? _priceAsOf;
  DateTime? get priceAsOf => _$this._priceAsOf;
  set priceAsOf(DateTime? priceAsOf) => _$this._priceAsOf = priceAsOf;

  ListingImageBuilder? _image;
  ListingImageBuilder get image => _$this._image ??= ListingImageBuilder();
  set image(ListingImageBuilder? image) => _$this._image = image;

  MaterialOfferBuilder() {
    MaterialOffer._defaults(this);
  }

  MaterialOfferBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _vendorId = $v.vendorId;
      _storeName = $v.storeName;
      _listingId = $v.listingId;
      _variantId = $v.variantId;
      _displayName = $v.displayName;
      _variantLabel = $v.variantLabel;
      _priceCentavos = $v.priceCentavos;
      _normalizedPhp = $v.normalizedPhp;
      _taxCategory = $v.taxCategory;
      _taxLabel = $v.taxLabel;
      _availability = $v.availability;
      _distanceMeters = $v.distanceMeters;
      _priceAsOf = $v.priceAsOf;
      _image = $v.image?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MaterialOffer other) {
    _$v = other as _$MaterialOffer;
  }

  @override
  void update(void Function(MaterialOfferBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  MaterialOffer build() => _build();

  _$MaterialOffer _build() {
    _$MaterialOffer _$result;
    try {
      _$result = _$v ??
          _$MaterialOffer._(
            vendorId: BuiltValueNullFieldError.checkNotNull(
                vendorId, r'MaterialOffer', 'vendorId'),
            storeName: BuiltValueNullFieldError.checkNotNull(
                storeName, r'MaterialOffer', 'storeName'),
            listingId: BuiltValueNullFieldError.checkNotNull(
                listingId, r'MaterialOffer', 'listingId'),
            variantId: BuiltValueNullFieldError.checkNotNull(
                variantId, r'MaterialOffer', 'variantId'),
            displayName: BuiltValueNullFieldError.checkNotNull(
                displayName, r'MaterialOffer', 'displayName'),
            variantLabel: variantLabel,
            priceCentavos: BuiltValueNullFieldError.checkNotNull(
                priceCentavos, r'MaterialOffer', 'priceCentavos'),
            normalizedPhp: BuiltValueNullFieldError.checkNotNull(
                normalizedPhp, r'MaterialOffer', 'normalizedPhp'),
            taxCategory: BuiltValueNullFieldError.checkNotNull(
                taxCategory, r'MaterialOffer', 'taxCategory'),
            taxLabel: BuiltValueNullFieldError.checkNotNull(
                taxLabel, r'MaterialOffer', 'taxLabel'),
            availability: BuiltValueNullFieldError.checkNotNull(
                availability, r'MaterialOffer', 'availability'),
            distanceMeters: BuiltValueNullFieldError.checkNotNull(
                distanceMeters, r'MaterialOffer', 'distanceMeters'),
            priceAsOf: BuiltValueNullFieldError.checkNotNull(
                priceAsOf, r'MaterialOffer', 'priceAsOf'),
            image: _image?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'image';
        _image?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'MaterialOffer', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
