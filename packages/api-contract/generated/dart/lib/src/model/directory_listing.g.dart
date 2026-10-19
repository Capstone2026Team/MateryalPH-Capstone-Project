// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'directory_listing.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const DirectoryListingStockEnum _$directoryListingStockEnum_IN_STOCK =
    const DirectoryListingStockEnum._('IN_STOCK');
const DirectoryListingStockEnum _$directoryListingStockEnum_LIMITED_STOCK =
    const DirectoryListingStockEnum._('LIMITED_STOCK');
const DirectoryListingStockEnum _$directoryListingStockEnum_OUT_OF_STOCK =
    const DirectoryListingStockEnum._('OUT_OF_STOCK');

DirectoryListingStockEnum _$directoryListingStockEnumValueOf(String name) {
  switch (name) {
    case 'IN_STOCK':
      return _$directoryListingStockEnum_IN_STOCK;
    case 'LIMITED_STOCK':
      return _$directoryListingStockEnum_LIMITED_STOCK;
    case 'OUT_OF_STOCK':
      return _$directoryListingStockEnum_OUT_OF_STOCK;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<DirectoryListingStockEnum> _$directoryListingStockEnumValues =
    BuiltSet<DirectoryListingStockEnum>(const <DirectoryListingStockEnum>[
  _$directoryListingStockEnum_IN_STOCK,
  _$directoryListingStockEnum_LIMITED_STOCK,
  _$directoryListingStockEnum_OUT_OF_STOCK,
]);

Serializer<DirectoryListingStockEnum> _$directoryListingStockEnumSerializer =
    _$DirectoryListingStockEnumSerializer();

class _$DirectoryListingStockEnumSerializer
    implements PrimitiveSerializer<DirectoryListingStockEnum> {
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
  final Iterable<Type> types = const <Type>[DirectoryListingStockEnum];
  @override
  final String wireName = 'DirectoryListingStockEnum';

  @override
  Object serialize(Serializers serializers, DirectoryListingStockEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  DirectoryListingStockEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      DirectoryListingStockEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$DirectoryListing extends DirectoryListing {
  @override
  final String id;
  @override
  final String name;
  @override
  final String? sku;
  @override
  final String status;
  @override
  final DateTime updatedAt;
  @override
  final int variantCount;
  @override
  final int? minPriceCentavos;
  @override
  final int? maxPriceCentavos;
  @override
  final String? unitCode;
  @override
  final DirectoryListingStockEnum stock;
  @override
  final String? imageUrl;
  @override
  final String? imageAlt;

  factory _$DirectoryListing(
          [void Function(DirectoryListingBuilder)? updates]) =>
      (DirectoryListingBuilder()..update(updates))._build();

  _$DirectoryListing._(
      {required this.id,
      required this.name,
      this.sku,
      required this.status,
      required this.updatedAt,
      required this.variantCount,
      this.minPriceCentavos,
      this.maxPriceCentavos,
      this.unitCode,
      required this.stock,
      this.imageUrl,
      this.imageAlt})
      : super._();
  @override
  DirectoryListing rebuild(void Function(DirectoryListingBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DirectoryListingBuilder toBuilder() =>
      DirectoryListingBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DirectoryListing &&
        id == other.id &&
        name == other.name &&
        sku == other.sku &&
        status == other.status &&
        updatedAt == other.updatedAt &&
        variantCount == other.variantCount &&
        minPriceCentavos == other.minPriceCentavos &&
        maxPriceCentavos == other.maxPriceCentavos &&
        unitCode == other.unitCode &&
        stock == other.stock &&
        imageUrl == other.imageUrl &&
        imageAlt == other.imageAlt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, sku.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, updatedAt.hashCode);
    _$hash = $jc(_$hash, variantCount.hashCode);
    _$hash = $jc(_$hash, minPriceCentavos.hashCode);
    _$hash = $jc(_$hash, maxPriceCentavos.hashCode);
    _$hash = $jc(_$hash, unitCode.hashCode);
    _$hash = $jc(_$hash, stock.hashCode);
    _$hash = $jc(_$hash, imageUrl.hashCode);
    _$hash = $jc(_$hash, imageAlt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'DirectoryListing')
          ..add('id', id)
          ..add('name', name)
          ..add('sku', sku)
          ..add('status', status)
          ..add('updatedAt', updatedAt)
          ..add('variantCount', variantCount)
          ..add('minPriceCentavos', minPriceCentavos)
          ..add('maxPriceCentavos', maxPriceCentavos)
          ..add('unitCode', unitCode)
          ..add('stock', stock)
          ..add('imageUrl', imageUrl)
          ..add('imageAlt', imageAlt))
        .toString();
  }
}

class DirectoryListingBuilder
    implements Builder<DirectoryListing, DirectoryListingBuilder> {
  _$DirectoryListing? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _sku;
  String? get sku => _$this._sku;
  set sku(String? sku) => _$this._sku = sku;

  String? _status;
  String? get status => _$this._status;
  set status(String? status) => _$this._status = status;

  DateTime? _updatedAt;
  DateTime? get updatedAt => _$this._updatedAt;
  set updatedAt(DateTime? updatedAt) => _$this._updatedAt = updatedAt;

  int? _variantCount;
  int? get variantCount => _$this._variantCount;
  set variantCount(int? variantCount) => _$this._variantCount = variantCount;

  int? _minPriceCentavos;
  int? get minPriceCentavos => _$this._minPriceCentavos;
  set minPriceCentavos(int? minPriceCentavos) =>
      _$this._minPriceCentavos = minPriceCentavos;

  int? _maxPriceCentavos;
  int? get maxPriceCentavos => _$this._maxPriceCentavos;
  set maxPriceCentavos(int? maxPriceCentavos) =>
      _$this._maxPriceCentavos = maxPriceCentavos;

  String? _unitCode;
  String? get unitCode => _$this._unitCode;
  set unitCode(String? unitCode) => _$this._unitCode = unitCode;

  DirectoryListingStockEnum? _stock;
  DirectoryListingStockEnum? get stock => _$this._stock;
  set stock(DirectoryListingStockEnum? stock) => _$this._stock = stock;

  String? _imageUrl;
  String? get imageUrl => _$this._imageUrl;
  set imageUrl(String? imageUrl) => _$this._imageUrl = imageUrl;

  String? _imageAlt;
  String? get imageAlt => _$this._imageAlt;
  set imageAlt(String? imageAlt) => _$this._imageAlt = imageAlt;

  DirectoryListingBuilder() {
    DirectoryListing._defaults(this);
  }

  DirectoryListingBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _name = $v.name;
      _sku = $v.sku;
      _status = $v.status;
      _updatedAt = $v.updatedAt;
      _variantCount = $v.variantCount;
      _minPriceCentavos = $v.minPriceCentavos;
      _maxPriceCentavos = $v.maxPriceCentavos;
      _unitCode = $v.unitCode;
      _stock = $v.stock;
      _imageUrl = $v.imageUrl;
      _imageAlt = $v.imageAlt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DirectoryListing other) {
    _$v = other as _$DirectoryListing;
  }

  @override
  void update(void Function(DirectoryListingBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DirectoryListing build() => _build();

  _$DirectoryListing _build() {
    final _$result = _$v ??
        _$DirectoryListing._(
          id: BuiltValueNullFieldError.checkNotNull(
              id, r'DirectoryListing', 'id'),
          name: BuiltValueNullFieldError.checkNotNull(
              name, r'DirectoryListing', 'name'),
          sku: sku,
          status: BuiltValueNullFieldError.checkNotNull(
              status, r'DirectoryListing', 'status'),
          updatedAt: BuiltValueNullFieldError.checkNotNull(
              updatedAt, r'DirectoryListing', 'updatedAt'),
          variantCount: BuiltValueNullFieldError.checkNotNull(
              variantCount, r'DirectoryListing', 'variantCount'),
          minPriceCentavos: minPriceCentavos,
          maxPriceCentavos: maxPriceCentavos,
          unitCode: unitCode,
          stock: BuiltValueNullFieldError.checkNotNull(
              stock, r'DirectoryListing', 'stock'),
          imageUrl: imageUrl,
          imageAlt: imageAlt,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
