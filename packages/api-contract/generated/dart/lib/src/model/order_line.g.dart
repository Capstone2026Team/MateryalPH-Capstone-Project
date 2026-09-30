// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_line.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const OrderLineChangeEnum _$orderLineChangeEnum_QUANTITY_REDUCED =
    const OrderLineChangeEnum._('QUANTITY_REDUCED');
const OrderLineChangeEnum _$orderLineChangeEnum_LINE_REMOVED =
    const OrderLineChangeEnum._('LINE_REMOVED');

OrderLineChangeEnum _$orderLineChangeEnumValueOf(String name) {
  switch (name) {
    case 'QUANTITY_REDUCED':
      return _$orderLineChangeEnum_QUANTITY_REDUCED;
    case 'LINE_REMOVED':
      return _$orderLineChangeEnum_LINE_REMOVED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<OrderLineChangeEnum> _$orderLineChangeEnumValues =
    BuiltSet<OrderLineChangeEnum>(const <OrderLineChangeEnum>[
  _$orderLineChangeEnum_QUANTITY_REDUCED,
  _$orderLineChangeEnum_LINE_REMOVED,
]);

Serializer<OrderLineChangeEnum> _$orderLineChangeEnumSerializer =
    _$OrderLineChangeEnumSerializer();

class _$OrderLineChangeEnumSerializer
    implements PrimitiveSerializer<OrderLineChangeEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'QUANTITY_REDUCED': 'QUANTITY_REDUCED',
    'LINE_REMOVED': 'LINE_REMOVED',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'QUANTITY_REDUCED': 'QUANTITY_REDUCED',
    'LINE_REMOVED': 'LINE_REMOVED',
  };

  @override
  final Iterable<Type> types = const <Type>[OrderLineChangeEnum];
  @override
  final String wireName = 'OrderLineChangeEnum';

  @override
  Object serialize(Serializers serializers, OrderLineChangeEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  OrderLineChangeEnum deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      OrderLineChangeEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$OrderLine extends OrderLine {
  @override
  final String id;
  @override
  final int lineNumber;
  @override
  final String listingId;
  @override
  final String listingVariantId;
  @override
  final String displayName;
  @override
  final String? variantLabel;
  @override
  final String? brand;
  @override
  final String? category;
  @override
  final ListingImage? image;
  @override
  final String unitCode;
  @override
  final String unitName;
  @override
  final int unitPrecision;
  @override
  final String quantityStep;
  @override
  final String requestedQuantity;
  @override
  final String? confirmedQuantity;
  @override
  final int unitPriceCentavos;
  @override
  final int? ordinaryUnitPriceCentavos;
  @override
  final bool volumeTierApplied;
  @override
  final BuiltList<OrderVolumeTier> volumeTiers;
  @override
  final int grossCentavos;
  @override
  final int discountCentavos;
  @override
  final int lineTotalCentavos;
  @override
  final int includedVatCentavos;
  @override
  final TaxCategory taxCategory;
  @override
  final String vatLabel;
  @override
  final OrderLineChangeEnum? change;
  @override
  final String? priceVersionId;
  @override
  final OrderLineInventory? inventory;

  factory _$OrderLine([void Function(OrderLineBuilder)? updates]) =>
      (OrderLineBuilder()..update(updates))._build();

  _$OrderLine._(
      {required this.id,
      required this.lineNumber,
      required this.listingId,
      required this.listingVariantId,
      required this.displayName,
      this.variantLabel,
      this.brand,
      this.category,
      this.image,
      required this.unitCode,
      required this.unitName,
      required this.unitPrecision,
      required this.quantityStep,
      required this.requestedQuantity,
      this.confirmedQuantity,
      required this.unitPriceCentavos,
      this.ordinaryUnitPriceCentavos,
      required this.volumeTierApplied,
      required this.volumeTiers,
      required this.grossCentavos,
      required this.discountCentavos,
      required this.lineTotalCentavos,
      required this.includedVatCentavos,
      required this.taxCategory,
      required this.vatLabel,
      this.change,
      this.priceVersionId,
      this.inventory})
      : super._();
  @override
  OrderLine rebuild(void Function(OrderLineBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  OrderLineBuilder toBuilder() => OrderLineBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is OrderLine &&
        id == other.id &&
        lineNumber == other.lineNumber &&
        listingId == other.listingId &&
        listingVariantId == other.listingVariantId &&
        displayName == other.displayName &&
        variantLabel == other.variantLabel &&
        brand == other.brand &&
        category == other.category &&
        image == other.image &&
        unitCode == other.unitCode &&
        unitName == other.unitName &&
        unitPrecision == other.unitPrecision &&
        quantityStep == other.quantityStep &&
        requestedQuantity == other.requestedQuantity &&
        confirmedQuantity == other.confirmedQuantity &&
        unitPriceCentavos == other.unitPriceCentavos &&
        ordinaryUnitPriceCentavos == other.ordinaryUnitPriceCentavos &&
        volumeTierApplied == other.volumeTierApplied &&
        volumeTiers == other.volumeTiers &&
        grossCentavos == other.grossCentavos &&
        discountCentavos == other.discountCentavos &&
        lineTotalCentavos == other.lineTotalCentavos &&
        includedVatCentavos == other.includedVatCentavos &&
        taxCategory == other.taxCategory &&
        vatLabel == other.vatLabel &&
        change == other.change &&
        priceVersionId == other.priceVersionId &&
        inventory == other.inventory;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, lineNumber.hashCode);
    _$hash = $jc(_$hash, listingId.hashCode);
    _$hash = $jc(_$hash, listingVariantId.hashCode);
    _$hash = $jc(_$hash, displayName.hashCode);
    _$hash = $jc(_$hash, variantLabel.hashCode);
    _$hash = $jc(_$hash, brand.hashCode);
    _$hash = $jc(_$hash, category.hashCode);
    _$hash = $jc(_$hash, image.hashCode);
    _$hash = $jc(_$hash, unitCode.hashCode);
    _$hash = $jc(_$hash, unitName.hashCode);
    _$hash = $jc(_$hash, unitPrecision.hashCode);
    _$hash = $jc(_$hash, quantityStep.hashCode);
    _$hash = $jc(_$hash, requestedQuantity.hashCode);
    _$hash = $jc(_$hash, confirmedQuantity.hashCode);
    _$hash = $jc(_$hash, unitPriceCentavos.hashCode);
    _$hash = $jc(_$hash, ordinaryUnitPriceCentavos.hashCode);
    _$hash = $jc(_$hash, volumeTierApplied.hashCode);
    _$hash = $jc(_$hash, volumeTiers.hashCode);
    _$hash = $jc(_$hash, grossCentavos.hashCode);
    _$hash = $jc(_$hash, discountCentavos.hashCode);
    _$hash = $jc(_$hash, lineTotalCentavos.hashCode);
    _$hash = $jc(_$hash, includedVatCentavos.hashCode);
    _$hash = $jc(_$hash, taxCategory.hashCode);
    _$hash = $jc(_$hash, vatLabel.hashCode);
    _$hash = $jc(_$hash, change.hashCode);
    _$hash = $jc(_$hash, priceVersionId.hashCode);
    _$hash = $jc(_$hash, inventory.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'OrderLine')
          ..add('id', id)
          ..add('lineNumber', lineNumber)
          ..add('listingId', listingId)
          ..add('listingVariantId', listingVariantId)
          ..add('displayName', displayName)
          ..add('variantLabel', variantLabel)
          ..add('brand', brand)
          ..add('category', category)
          ..add('image', image)
          ..add('unitCode', unitCode)
          ..add('unitName', unitName)
          ..add('unitPrecision', unitPrecision)
          ..add('quantityStep', quantityStep)
          ..add('requestedQuantity', requestedQuantity)
          ..add('confirmedQuantity', confirmedQuantity)
          ..add('unitPriceCentavos', unitPriceCentavos)
          ..add('ordinaryUnitPriceCentavos', ordinaryUnitPriceCentavos)
          ..add('volumeTierApplied', volumeTierApplied)
          ..add('volumeTiers', volumeTiers)
          ..add('grossCentavos', grossCentavos)
          ..add('discountCentavos', discountCentavos)
          ..add('lineTotalCentavos', lineTotalCentavos)
          ..add('includedVatCentavos', includedVatCentavos)
          ..add('taxCategory', taxCategory)
          ..add('vatLabel', vatLabel)
          ..add('change', change)
          ..add('priceVersionId', priceVersionId)
          ..add('inventory', inventory))
        .toString();
  }
}

class OrderLineBuilder implements Builder<OrderLine, OrderLineBuilder> {
  _$OrderLine? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  int? _lineNumber;
  int? get lineNumber => _$this._lineNumber;
  set lineNumber(int? lineNumber) => _$this._lineNumber = lineNumber;

  String? _listingId;
  String? get listingId => _$this._listingId;
  set listingId(String? listingId) => _$this._listingId = listingId;

  String? _listingVariantId;
  String? get listingVariantId => _$this._listingVariantId;
  set listingVariantId(String? listingVariantId) =>
      _$this._listingVariantId = listingVariantId;

  String? _displayName;
  String? get displayName => _$this._displayName;
  set displayName(String? displayName) => _$this._displayName = displayName;

  String? _variantLabel;
  String? get variantLabel => _$this._variantLabel;
  set variantLabel(String? variantLabel) => _$this._variantLabel = variantLabel;

  String? _brand;
  String? get brand => _$this._brand;
  set brand(String? brand) => _$this._brand = brand;

  String? _category;
  String? get category => _$this._category;
  set category(String? category) => _$this._category = category;

  ListingImageBuilder? _image;
  ListingImageBuilder get image => _$this._image ??= ListingImageBuilder();
  set image(ListingImageBuilder? image) => _$this._image = image;

  String? _unitCode;
  String? get unitCode => _$this._unitCode;
  set unitCode(String? unitCode) => _$this._unitCode = unitCode;

  String? _unitName;
  String? get unitName => _$this._unitName;
  set unitName(String? unitName) => _$this._unitName = unitName;

  int? _unitPrecision;
  int? get unitPrecision => _$this._unitPrecision;
  set unitPrecision(int? unitPrecision) =>
      _$this._unitPrecision = unitPrecision;

  String? _quantityStep;
  String? get quantityStep => _$this._quantityStep;
  set quantityStep(String? quantityStep) => _$this._quantityStep = quantityStep;

  String? _requestedQuantity;
  String? get requestedQuantity => _$this._requestedQuantity;
  set requestedQuantity(String? requestedQuantity) =>
      _$this._requestedQuantity = requestedQuantity;

  String? _confirmedQuantity;
  String? get confirmedQuantity => _$this._confirmedQuantity;
  set confirmedQuantity(String? confirmedQuantity) =>
      _$this._confirmedQuantity = confirmedQuantity;

  int? _unitPriceCentavos;
  int? get unitPriceCentavos => _$this._unitPriceCentavos;
  set unitPriceCentavos(int? unitPriceCentavos) =>
      _$this._unitPriceCentavos = unitPriceCentavos;

  int? _ordinaryUnitPriceCentavos;
  int? get ordinaryUnitPriceCentavos => _$this._ordinaryUnitPriceCentavos;
  set ordinaryUnitPriceCentavos(int? ordinaryUnitPriceCentavos) =>
      _$this._ordinaryUnitPriceCentavos = ordinaryUnitPriceCentavos;

  bool? _volumeTierApplied;
  bool? get volumeTierApplied => _$this._volumeTierApplied;
  set volumeTierApplied(bool? volumeTierApplied) =>
      _$this._volumeTierApplied = volumeTierApplied;

  ListBuilder<OrderVolumeTier>? _volumeTiers;
  ListBuilder<OrderVolumeTier> get volumeTiers =>
      _$this._volumeTiers ??= ListBuilder<OrderVolumeTier>();
  set volumeTiers(ListBuilder<OrderVolumeTier>? volumeTiers) =>
      _$this._volumeTiers = volumeTiers;

  int? _grossCentavos;
  int? get grossCentavos => _$this._grossCentavos;
  set grossCentavos(int? grossCentavos) =>
      _$this._grossCentavos = grossCentavos;

  int? _discountCentavos;
  int? get discountCentavos => _$this._discountCentavos;
  set discountCentavos(int? discountCentavos) =>
      _$this._discountCentavos = discountCentavos;

  int? _lineTotalCentavos;
  int? get lineTotalCentavos => _$this._lineTotalCentavos;
  set lineTotalCentavos(int? lineTotalCentavos) =>
      _$this._lineTotalCentavos = lineTotalCentavos;

  int? _includedVatCentavos;
  int? get includedVatCentavos => _$this._includedVatCentavos;
  set includedVatCentavos(int? includedVatCentavos) =>
      _$this._includedVatCentavos = includedVatCentavos;

  TaxCategory? _taxCategory;
  TaxCategory? get taxCategory => _$this._taxCategory;
  set taxCategory(TaxCategory? taxCategory) =>
      _$this._taxCategory = taxCategory;

  String? _vatLabel;
  String? get vatLabel => _$this._vatLabel;
  set vatLabel(String? vatLabel) => _$this._vatLabel = vatLabel;

  OrderLineChangeEnum? _change;
  OrderLineChangeEnum? get change => _$this._change;
  set change(OrderLineChangeEnum? change) => _$this._change = change;

  String? _priceVersionId;
  String? get priceVersionId => _$this._priceVersionId;
  set priceVersionId(String? priceVersionId) =>
      _$this._priceVersionId = priceVersionId;

  OrderLineInventoryBuilder? _inventory;
  OrderLineInventoryBuilder get inventory =>
      _$this._inventory ??= OrderLineInventoryBuilder();
  set inventory(OrderLineInventoryBuilder? inventory) =>
      _$this._inventory = inventory;

  OrderLineBuilder() {
    OrderLine._defaults(this);
  }

  OrderLineBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _lineNumber = $v.lineNumber;
      _listingId = $v.listingId;
      _listingVariantId = $v.listingVariantId;
      _displayName = $v.displayName;
      _variantLabel = $v.variantLabel;
      _brand = $v.brand;
      _category = $v.category;
      _image = $v.image?.toBuilder();
      _unitCode = $v.unitCode;
      _unitName = $v.unitName;
      _unitPrecision = $v.unitPrecision;
      _quantityStep = $v.quantityStep;
      _requestedQuantity = $v.requestedQuantity;
      _confirmedQuantity = $v.confirmedQuantity;
      _unitPriceCentavos = $v.unitPriceCentavos;
      _ordinaryUnitPriceCentavos = $v.ordinaryUnitPriceCentavos;
      _volumeTierApplied = $v.volumeTierApplied;
      _volumeTiers = $v.volumeTiers.toBuilder();
      _grossCentavos = $v.grossCentavos;
      _discountCentavos = $v.discountCentavos;
      _lineTotalCentavos = $v.lineTotalCentavos;
      _includedVatCentavos = $v.includedVatCentavos;
      _taxCategory = $v.taxCategory;
      _vatLabel = $v.vatLabel;
      _change = $v.change;
      _priceVersionId = $v.priceVersionId;
      _inventory = $v.inventory?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(OrderLine other) {
    _$v = other as _$OrderLine;
  }

  @override
  void update(void Function(OrderLineBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  OrderLine build() => _build();

  _$OrderLine _build() {
    _$OrderLine _$result;
    try {
      _$result = _$v ??
          _$OrderLine._(
            id: BuiltValueNullFieldError.checkNotNull(id, r'OrderLine', 'id'),
            lineNumber: BuiltValueNullFieldError.checkNotNull(
                lineNumber, r'OrderLine', 'lineNumber'),
            listingId: BuiltValueNullFieldError.checkNotNull(
                listingId, r'OrderLine', 'listingId'),
            listingVariantId: BuiltValueNullFieldError.checkNotNull(
                listingVariantId, r'OrderLine', 'listingVariantId'),
            displayName: BuiltValueNullFieldError.checkNotNull(
                displayName, r'OrderLine', 'displayName'),
            variantLabel: variantLabel,
            brand: brand,
            category: category,
            image: _image?.build(),
            unitCode: BuiltValueNullFieldError.checkNotNull(
                unitCode, r'OrderLine', 'unitCode'),
            unitName: BuiltValueNullFieldError.checkNotNull(
                unitName, r'OrderLine', 'unitName'),
            unitPrecision: BuiltValueNullFieldError.checkNotNull(
                unitPrecision, r'OrderLine', 'unitPrecision'),
            quantityStep: BuiltValueNullFieldError.checkNotNull(
                quantityStep, r'OrderLine', 'quantityStep'),
            requestedQuantity: BuiltValueNullFieldError.checkNotNull(
                requestedQuantity, r'OrderLine', 'requestedQuantity'),
            confirmedQuantity: confirmedQuantity,
            unitPriceCentavos: BuiltValueNullFieldError.checkNotNull(
                unitPriceCentavos, r'OrderLine', 'unitPriceCentavos'),
            ordinaryUnitPriceCentavos: ordinaryUnitPriceCentavos,
            volumeTierApplied: BuiltValueNullFieldError.checkNotNull(
                volumeTierApplied, r'OrderLine', 'volumeTierApplied'),
            volumeTiers: volumeTiers.build(),
            grossCentavos: BuiltValueNullFieldError.checkNotNull(
                grossCentavos, r'OrderLine', 'grossCentavos'),
            discountCentavos: BuiltValueNullFieldError.checkNotNull(
                discountCentavos, r'OrderLine', 'discountCentavos'),
            lineTotalCentavos: BuiltValueNullFieldError.checkNotNull(
                lineTotalCentavos, r'OrderLine', 'lineTotalCentavos'),
            includedVatCentavos: BuiltValueNullFieldError.checkNotNull(
                includedVatCentavos, r'OrderLine', 'includedVatCentavos'),
            taxCategory: BuiltValueNullFieldError.checkNotNull(
                taxCategory, r'OrderLine', 'taxCategory'),
            vatLabel: BuiltValueNullFieldError.checkNotNull(
                vatLabel, r'OrderLine', 'vatLabel'),
            change: change,
            priceVersionId: priceVersionId,
            inventory: _inventory?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'image';
        _image?.build();

        _$failedField = 'volumeTiers';
        volumeTiers.build();

        _$failedField = 'inventory';
        _inventory?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'OrderLine', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
