// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'work_package_alternative.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const WorkPackageAlternativeAvailabilityEnum
    _$workPackageAlternativeAvailabilityEnum_FULL =
    const WorkPackageAlternativeAvailabilityEnum._('FULL');
const WorkPackageAlternativeAvailabilityEnum
    _$workPackageAlternativeAvailabilityEnum_PARTIAL =
    const WorkPackageAlternativeAvailabilityEnum._('PARTIAL');

WorkPackageAlternativeAvailabilityEnum
    _$workPackageAlternativeAvailabilityEnumValueOf(String name) {
  switch (name) {
    case 'FULL':
      return _$workPackageAlternativeAvailabilityEnum_FULL;
    case 'PARTIAL':
      return _$workPackageAlternativeAvailabilityEnum_PARTIAL;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<WorkPackageAlternativeAvailabilityEnum>
    _$workPackageAlternativeAvailabilityEnumValues = BuiltSet<
        WorkPackageAlternativeAvailabilityEnum>(const <WorkPackageAlternativeAvailabilityEnum>[
  _$workPackageAlternativeAvailabilityEnum_FULL,
  _$workPackageAlternativeAvailabilityEnum_PARTIAL,
]);

const WorkPackageAlternativeFulfillmentMethodsEnum
    _$workPackageAlternativeFulfillmentMethodsEnum_DELIVERY =
    const WorkPackageAlternativeFulfillmentMethodsEnum._('DELIVERY');
const WorkPackageAlternativeFulfillmentMethodsEnum
    _$workPackageAlternativeFulfillmentMethodsEnum_PICKUP =
    const WorkPackageAlternativeFulfillmentMethodsEnum._('PICKUP');

WorkPackageAlternativeFulfillmentMethodsEnum
    _$workPackageAlternativeFulfillmentMethodsEnumValueOf(String name) {
  switch (name) {
    case 'DELIVERY':
      return _$workPackageAlternativeFulfillmentMethodsEnum_DELIVERY;
    case 'PICKUP':
      return _$workPackageAlternativeFulfillmentMethodsEnum_PICKUP;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<WorkPackageAlternativeFulfillmentMethodsEnum>
    _$workPackageAlternativeFulfillmentMethodsEnumValues = BuiltSet<
        WorkPackageAlternativeFulfillmentMethodsEnum>(const <WorkPackageAlternativeFulfillmentMethodsEnum>[
  _$workPackageAlternativeFulfillmentMethodsEnum_DELIVERY,
  _$workPackageAlternativeFulfillmentMethodsEnum_PICKUP,
]);

Serializer<WorkPackageAlternativeAvailabilityEnum>
    _$workPackageAlternativeAvailabilityEnumSerializer =
    _$WorkPackageAlternativeAvailabilityEnumSerializer();
Serializer<WorkPackageAlternativeFulfillmentMethodsEnum>
    _$workPackageAlternativeFulfillmentMethodsEnumSerializer =
    _$WorkPackageAlternativeFulfillmentMethodsEnumSerializer();

class _$WorkPackageAlternativeAvailabilityEnumSerializer
    implements PrimitiveSerializer<WorkPackageAlternativeAvailabilityEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'FULL': 'FULL',
    'PARTIAL': 'PARTIAL',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'FULL': 'FULL',
    'PARTIAL': 'PARTIAL',
  };

  @override
  final Iterable<Type> types = const <Type>[
    WorkPackageAlternativeAvailabilityEnum
  ];
  @override
  final String wireName = 'WorkPackageAlternativeAvailabilityEnum';

  @override
  Object serialize(Serializers serializers,
          WorkPackageAlternativeAvailabilityEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  WorkPackageAlternativeAvailabilityEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      WorkPackageAlternativeAvailabilityEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$WorkPackageAlternativeFulfillmentMethodsEnumSerializer
    implements
        PrimitiveSerializer<WorkPackageAlternativeFulfillmentMethodsEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'DELIVERY': 'DELIVERY',
    'PICKUP': 'PICKUP',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'DELIVERY': 'DELIVERY',
    'PICKUP': 'PICKUP',
  };

  @override
  final Iterable<Type> types = const <Type>[
    WorkPackageAlternativeFulfillmentMethodsEnum
  ];
  @override
  final String wireName = 'WorkPackageAlternativeFulfillmentMethodsEnum';

  @override
  Object serialize(Serializers serializers,
          WorkPackageAlternativeFulfillmentMethodsEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  WorkPackageAlternativeFulfillmentMethodsEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      WorkPackageAlternativeFulfillmentMethodsEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$WorkPackageAlternative extends WorkPackageAlternative {
  @override
  final String listingId;
  @override
  final String variantId;
  @override
  final String priceVersionId;
  @override
  final String displayName;
  @override
  final String? variantLabel;
  @override
  final String? brand;
  @override
  final String vendorId;
  @override
  final String? storeName;
  @override
  final ListingImage? image;
  @override
  final int unitPriceCentavos;
  @override
  final String unitCode;
  @override
  final int unitPrecision;
  @override
  final int distanceMeters;
  @override
  final String stockLabel;
  @override
  final BuiltList<ProjectSpecificationDetail>? specifications;
  @override
  final bool exactMatch;
  @override
  final WorkPackageAlternativeAvailabilityEnum availability;
  @override
  final int estimatedTotalCentavos;
  @override
  final BuiltList<WorkPackageAlternativeFulfillmentMethodsEnum>
      fulfillmentMethods;
  @override
  final bool alreadyAdded;

  factory _$WorkPackageAlternative(
          [void Function(WorkPackageAlternativeBuilder)? updates]) =>
      (WorkPackageAlternativeBuilder()..update(updates))._build();

  _$WorkPackageAlternative._(
      {required this.listingId,
      required this.variantId,
      required this.priceVersionId,
      required this.displayName,
      this.variantLabel,
      this.brand,
      required this.vendorId,
      this.storeName,
      this.image,
      required this.unitPriceCentavos,
      required this.unitCode,
      required this.unitPrecision,
      required this.distanceMeters,
      required this.stockLabel,
      this.specifications,
      required this.exactMatch,
      required this.availability,
      required this.estimatedTotalCentavos,
      required this.fulfillmentMethods,
      required this.alreadyAdded})
      : super._();
  @override
  WorkPackageAlternative rebuild(
          void Function(WorkPackageAlternativeBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  WorkPackageAlternativeBuilder toBuilder() =>
      WorkPackageAlternativeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is WorkPackageAlternative &&
        listingId == other.listingId &&
        variantId == other.variantId &&
        priceVersionId == other.priceVersionId &&
        displayName == other.displayName &&
        variantLabel == other.variantLabel &&
        brand == other.brand &&
        vendorId == other.vendorId &&
        storeName == other.storeName &&
        image == other.image &&
        unitPriceCentavos == other.unitPriceCentavos &&
        unitCode == other.unitCode &&
        unitPrecision == other.unitPrecision &&
        distanceMeters == other.distanceMeters &&
        stockLabel == other.stockLabel &&
        specifications == other.specifications &&
        exactMatch == other.exactMatch &&
        availability == other.availability &&
        estimatedTotalCentavos == other.estimatedTotalCentavos &&
        fulfillmentMethods == other.fulfillmentMethods &&
        alreadyAdded == other.alreadyAdded;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, listingId.hashCode);
    _$hash = $jc(_$hash, variantId.hashCode);
    _$hash = $jc(_$hash, priceVersionId.hashCode);
    _$hash = $jc(_$hash, displayName.hashCode);
    _$hash = $jc(_$hash, variantLabel.hashCode);
    _$hash = $jc(_$hash, brand.hashCode);
    _$hash = $jc(_$hash, vendorId.hashCode);
    _$hash = $jc(_$hash, storeName.hashCode);
    _$hash = $jc(_$hash, image.hashCode);
    _$hash = $jc(_$hash, unitPriceCentavos.hashCode);
    _$hash = $jc(_$hash, unitCode.hashCode);
    _$hash = $jc(_$hash, unitPrecision.hashCode);
    _$hash = $jc(_$hash, distanceMeters.hashCode);
    _$hash = $jc(_$hash, stockLabel.hashCode);
    _$hash = $jc(_$hash, specifications.hashCode);
    _$hash = $jc(_$hash, exactMatch.hashCode);
    _$hash = $jc(_$hash, availability.hashCode);
    _$hash = $jc(_$hash, estimatedTotalCentavos.hashCode);
    _$hash = $jc(_$hash, fulfillmentMethods.hashCode);
    _$hash = $jc(_$hash, alreadyAdded.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'WorkPackageAlternative')
          ..add('listingId', listingId)
          ..add('variantId', variantId)
          ..add('priceVersionId', priceVersionId)
          ..add('displayName', displayName)
          ..add('variantLabel', variantLabel)
          ..add('brand', brand)
          ..add('vendorId', vendorId)
          ..add('storeName', storeName)
          ..add('image', image)
          ..add('unitPriceCentavos', unitPriceCentavos)
          ..add('unitCode', unitCode)
          ..add('unitPrecision', unitPrecision)
          ..add('distanceMeters', distanceMeters)
          ..add('stockLabel', stockLabel)
          ..add('specifications', specifications)
          ..add('exactMatch', exactMatch)
          ..add('availability', availability)
          ..add('estimatedTotalCentavos', estimatedTotalCentavos)
          ..add('fulfillmentMethods', fulfillmentMethods)
          ..add('alreadyAdded', alreadyAdded))
        .toString();
  }
}

class WorkPackageAlternativeBuilder
    implements Builder<WorkPackageAlternative, WorkPackageAlternativeBuilder> {
  _$WorkPackageAlternative? _$v;

  String? _listingId;
  String? get listingId => _$this._listingId;
  set listingId(String? listingId) => _$this._listingId = listingId;

  String? _variantId;
  String? get variantId => _$this._variantId;
  set variantId(String? variantId) => _$this._variantId = variantId;

  String? _priceVersionId;
  String? get priceVersionId => _$this._priceVersionId;
  set priceVersionId(String? priceVersionId) =>
      _$this._priceVersionId = priceVersionId;

  String? _displayName;
  String? get displayName => _$this._displayName;
  set displayName(String? displayName) => _$this._displayName = displayName;

  String? _variantLabel;
  String? get variantLabel => _$this._variantLabel;
  set variantLabel(String? variantLabel) => _$this._variantLabel = variantLabel;

  String? _brand;
  String? get brand => _$this._brand;
  set brand(String? brand) => _$this._brand = brand;

  String? _vendorId;
  String? get vendorId => _$this._vendorId;
  set vendorId(String? vendorId) => _$this._vendorId = vendorId;

  String? _storeName;
  String? get storeName => _$this._storeName;
  set storeName(String? storeName) => _$this._storeName = storeName;

  ListingImageBuilder? _image;
  ListingImageBuilder get image => _$this._image ??= ListingImageBuilder();
  set image(ListingImageBuilder? image) => _$this._image = image;

  int? _unitPriceCentavos;
  int? get unitPriceCentavos => _$this._unitPriceCentavos;
  set unitPriceCentavos(int? unitPriceCentavos) =>
      _$this._unitPriceCentavos = unitPriceCentavos;

  String? _unitCode;
  String? get unitCode => _$this._unitCode;
  set unitCode(String? unitCode) => _$this._unitCode = unitCode;

  int? _unitPrecision;
  int? get unitPrecision => _$this._unitPrecision;
  set unitPrecision(int? unitPrecision) =>
      _$this._unitPrecision = unitPrecision;

  int? _distanceMeters;
  int? get distanceMeters => _$this._distanceMeters;
  set distanceMeters(int? distanceMeters) =>
      _$this._distanceMeters = distanceMeters;

  String? _stockLabel;
  String? get stockLabel => _$this._stockLabel;
  set stockLabel(String? stockLabel) => _$this._stockLabel = stockLabel;

  ListBuilder<ProjectSpecificationDetail>? _specifications;
  ListBuilder<ProjectSpecificationDetail> get specifications =>
      _$this._specifications ??= ListBuilder<ProjectSpecificationDetail>();
  set specifications(ListBuilder<ProjectSpecificationDetail>? specifications) =>
      _$this._specifications = specifications;

  bool? _exactMatch;
  bool? get exactMatch => _$this._exactMatch;
  set exactMatch(bool? exactMatch) => _$this._exactMatch = exactMatch;

  WorkPackageAlternativeAvailabilityEnum? _availability;
  WorkPackageAlternativeAvailabilityEnum? get availability =>
      _$this._availability;
  set availability(WorkPackageAlternativeAvailabilityEnum? availability) =>
      _$this._availability = availability;

  int? _estimatedTotalCentavos;
  int? get estimatedTotalCentavos => _$this._estimatedTotalCentavos;
  set estimatedTotalCentavos(int? estimatedTotalCentavos) =>
      _$this._estimatedTotalCentavos = estimatedTotalCentavos;

  ListBuilder<WorkPackageAlternativeFulfillmentMethodsEnum>?
      _fulfillmentMethods;
  ListBuilder<WorkPackageAlternativeFulfillmentMethodsEnum>
      get fulfillmentMethods => _$this._fulfillmentMethods ??=
          ListBuilder<WorkPackageAlternativeFulfillmentMethodsEnum>();
  set fulfillmentMethods(
          ListBuilder<WorkPackageAlternativeFulfillmentMethodsEnum>?
              fulfillmentMethods) =>
      _$this._fulfillmentMethods = fulfillmentMethods;

  bool? _alreadyAdded;
  bool? get alreadyAdded => _$this._alreadyAdded;
  set alreadyAdded(bool? alreadyAdded) => _$this._alreadyAdded = alreadyAdded;

  WorkPackageAlternativeBuilder() {
    WorkPackageAlternative._defaults(this);
  }

  WorkPackageAlternativeBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _listingId = $v.listingId;
      _variantId = $v.variantId;
      _priceVersionId = $v.priceVersionId;
      _displayName = $v.displayName;
      _variantLabel = $v.variantLabel;
      _brand = $v.brand;
      _vendorId = $v.vendorId;
      _storeName = $v.storeName;
      _image = $v.image?.toBuilder();
      _unitPriceCentavos = $v.unitPriceCentavos;
      _unitCode = $v.unitCode;
      _unitPrecision = $v.unitPrecision;
      _distanceMeters = $v.distanceMeters;
      _stockLabel = $v.stockLabel;
      _specifications = $v.specifications?.toBuilder();
      _exactMatch = $v.exactMatch;
      _availability = $v.availability;
      _estimatedTotalCentavos = $v.estimatedTotalCentavos;
      _fulfillmentMethods = $v.fulfillmentMethods.toBuilder();
      _alreadyAdded = $v.alreadyAdded;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(WorkPackageAlternative other) {
    _$v = other as _$WorkPackageAlternative;
  }

  @override
  void update(void Function(WorkPackageAlternativeBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  WorkPackageAlternative build() => _build();

  _$WorkPackageAlternative _build() {
    _$WorkPackageAlternative _$result;
    try {
      _$result = _$v ??
          _$WorkPackageAlternative._(
            listingId: BuiltValueNullFieldError.checkNotNull(
                listingId, r'WorkPackageAlternative', 'listingId'),
            variantId: BuiltValueNullFieldError.checkNotNull(
                variantId, r'WorkPackageAlternative', 'variantId'),
            priceVersionId: BuiltValueNullFieldError.checkNotNull(
                priceVersionId, r'WorkPackageAlternative', 'priceVersionId'),
            displayName: BuiltValueNullFieldError.checkNotNull(
                displayName, r'WorkPackageAlternative', 'displayName'),
            variantLabel: variantLabel,
            brand: brand,
            vendorId: BuiltValueNullFieldError.checkNotNull(
                vendorId, r'WorkPackageAlternative', 'vendorId'),
            storeName: storeName,
            image: _image?.build(),
            unitPriceCentavos: BuiltValueNullFieldError.checkNotNull(
                unitPriceCentavos,
                r'WorkPackageAlternative',
                'unitPriceCentavos'),
            unitCode: BuiltValueNullFieldError.checkNotNull(
                unitCode, r'WorkPackageAlternative', 'unitCode'),
            unitPrecision: BuiltValueNullFieldError.checkNotNull(
                unitPrecision, r'WorkPackageAlternative', 'unitPrecision'),
            distanceMeters: BuiltValueNullFieldError.checkNotNull(
                distanceMeters, r'WorkPackageAlternative', 'distanceMeters'),
            stockLabel: BuiltValueNullFieldError.checkNotNull(
                stockLabel, r'WorkPackageAlternative', 'stockLabel'),
            specifications: _specifications?.build(),
            exactMatch: BuiltValueNullFieldError.checkNotNull(
                exactMatch, r'WorkPackageAlternative', 'exactMatch'),
            availability: BuiltValueNullFieldError.checkNotNull(
                availability, r'WorkPackageAlternative', 'availability'),
            estimatedTotalCentavos: BuiltValueNullFieldError.checkNotNull(
                estimatedTotalCentavos,
                r'WorkPackageAlternative',
                'estimatedTotalCentavos'),
            fulfillmentMethods: fulfillmentMethods.build(),
            alreadyAdded: BuiltValueNullFieldError.checkNotNull(
                alreadyAdded, r'WorkPackageAlternative', 'alreadyAdded'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'image';
        _image?.build();

        _$failedField = 'specifications';
        _specifications?.build();

        _$failedField = 'fulfillmentMethods';
        fulfillmentMethods.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'WorkPackageAlternative', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
