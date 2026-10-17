// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'work_package_alternative.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

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
  final String? image;
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
      required this.exactMatch})
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
        exactMatch == other.exactMatch;
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
          ..add('exactMatch', exactMatch))
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

  String? _image;
  String? get image => _$this._image;
  set image(String? image) => _$this._image = image;

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
      _image = $v.image;
      _unitPriceCentavos = $v.unitPriceCentavos;
      _unitCode = $v.unitCode;
      _unitPrecision = $v.unitPrecision;
      _distanceMeters = $v.distanceMeters;
      _stockLabel = $v.stockLabel;
      _specifications = $v.specifications?.toBuilder();
      _exactMatch = $v.exactMatch;
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
            image: image,
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
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'specifications';
        _specifications?.build();
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
