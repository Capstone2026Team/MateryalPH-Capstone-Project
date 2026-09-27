// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_compliance_queue_item.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ProductComplianceQueueItem extends ProductComplianceQueueItem {
  @override
  final String id;
  @override
  final int version;
  @override
  final CompliancePath path;
  @override
  final String status;
  @override
  final String? markingType;
  @override
  final String? submittedAt;
  @override
  final String listingId;
  @override
  final String displayName;
  @override
  final String vendorSku;
  @override
  final String? publicStoreName;
  @override
  final String? materialName;
  @override
  final String? productName;
  @override
  final String? referenceStandard;
  @override
  final String? referenceResult;

  factory _$ProductComplianceQueueItem(
          [void Function(ProductComplianceQueueItemBuilder)? updates]) =>
      (ProductComplianceQueueItemBuilder()..update(updates))._build();

  _$ProductComplianceQueueItem._(
      {required this.id,
      required this.version,
      required this.path,
      required this.status,
      this.markingType,
      this.submittedAt,
      required this.listingId,
      required this.displayName,
      required this.vendorSku,
      this.publicStoreName,
      this.materialName,
      this.productName,
      this.referenceStandard,
      this.referenceResult})
      : super._();
  @override
  ProductComplianceQueueItem rebuild(
          void Function(ProductComplianceQueueItemBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ProductComplianceQueueItemBuilder toBuilder() =>
      ProductComplianceQueueItemBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ProductComplianceQueueItem &&
        id == other.id &&
        version == other.version &&
        path == other.path &&
        status == other.status &&
        markingType == other.markingType &&
        submittedAt == other.submittedAt &&
        listingId == other.listingId &&
        displayName == other.displayName &&
        vendorSku == other.vendorSku &&
        publicStoreName == other.publicStoreName &&
        materialName == other.materialName &&
        productName == other.productName &&
        referenceStandard == other.referenceStandard &&
        referenceResult == other.referenceResult;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, version.hashCode);
    _$hash = $jc(_$hash, path.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, markingType.hashCode);
    _$hash = $jc(_$hash, submittedAt.hashCode);
    _$hash = $jc(_$hash, listingId.hashCode);
    _$hash = $jc(_$hash, displayName.hashCode);
    _$hash = $jc(_$hash, vendorSku.hashCode);
    _$hash = $jc(_$hash, publicStoreName.hashCode);
    _$hash = $jc(_$hash, materialName.hashCode);
    _$hash = $jc(_$hash, productName.hashCode);
    _$hash = $jc(_$hash, referenceStandard.hashCode);
    _$hash = $jc(_$hash, referenceResult.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ProductComplianceQueueItem')
          ..add('id', id)
          ..add('version', version)
          ..add('path', path)
          ..add('status', status)
          ..add('markingType', markingType)
          ..add('submittedAt', submittedAt)
          ..add('listingId', listingId)
          ..add('displayName', displayName)
          ..add('vendorSku', vendorSku)
          ..add('publicStoreName', publicStoreName)
          ..add('materialName', materialName)
          ..add('productName', productName)
          ..add('referenceStandard', referenceStandard)
          ..add('referenceResult', referenceResult))
        .toString();
  }
}

class ProductComplianceQueueItemBuilder
    implements
        Builder<ProductComplianceQueueItem, ProductComplianceQueueItemBuilder> {
  _$ProductComplianceQueueItem? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  int? _version;
  int? get version => _$this._version;
  set version(int? version) => _$this._version = version;

  CompliancePath? _path;
  CompliancePath? get path => _$this._path;
  set path(CompliancePath? path) => _$this._path = path;

  String? _status;
  String? get status => _$this._status;
  set status(String? status) => _$this._status = status;

  String? _markingType;
  String? get markingType => _$this._markingType;
  set markingType(String? markingType) => _$this._markingType = markingType;

  String? _submittedAt;
  String? get submittedAt => _$this._submittedAt;
  set submittedAt(String? submittedAt) => _$this._submittedAt = submittedAt;

  String? _listingId;
  String? get listingId => _$this._listingId;
  set listingId(String? listingId) => _$this._listingId = listingId;

  String? _displayName;
  String? get displayName => _$this._displayName;
  set displayName(String? displayName) => _$this._displayName = displayName;

  String? _vendorSku;
  String? get vendorSku => _$this._vendorSku;
  set vendorSku(String? vendorSku) => _$this._vendorSku = vendorSku;

  String? _publicStoreName;
  String? get publicStoreName => _$this._publicStoreName;
  set publicStoreName(String? publicStoreName) =>
      _$this._publicStoreName = publicStoreName;

  String? _materialName;
  String? get materialName => _$this._materialName;
  set materialName(String? materialName) => _$this._materialName = materialName;

  String? _productName;
  String? get productName => _$this._productName;
  set productName(String? productName) => _$this._productName = productName;

  String? _referenceStandard;
  String? get referenceStandard => _$this._referenceStandard;
  set referenceStandard(String? referenceStandard) =>
      _$this._referenceStandard = referenceStandard;

  String? _referenceResult;
  String? get referenceResult => _$this._referenceResult;
  set referenceResult(String? referenceResult) =>
      _$this._referenceResult = referenceResult;

  ProductComplianceQueueItemBuilder() {
    ProductComplianceQueueItem._defaults(this);
  }

  ProductComplianceQueueItemBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _version = $v.version;
      _path = $v.path;
      _status = $v.status;
      _markingType = $v.markingType;
      _submittedAt = $v.submittedAt;
      _listingId = $v.listingId;
      _displayName = $v.displayName;
      _vendorSku = $v.vendorSku;
      _publicStoreName = $v.publicStoreName;
      _materialName = $v.materialName;
      _productName = $v.productName;
      _referenceStandard = $v.referenceStandard;
      _referenceResult = $v.referenceResult;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ProductComplianceQueueItem other) {
    _$v = other as _$ProductComplianceQueueItem;
  }

  @override
  void update(void Function(ProductComplianceQueueItemBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ProductComplianceQueueItem build() => _build();

  _$ProductComplianceQueueItem _build() {
    final _$result = _$v ??
        _$ProductComplianceQueueItem._(
          id: BuiltValueNullFieldError.checkNotNull(
              id, r'ProductComplianceQueueItem', 'id'),
          version: BuiltValueNullFieldError.checkNotNull(
              version, r'ProductComplianceQueueItem', 'version'),
          path: BuiltValueNullFieldError.checkNotNull(
              path, r'ProductComplianceQueueItem', 'path'),
          status: BuiltValueNullFieldError.checkNotNull(
              status, r'ProductComplianceQueueItem', 'status'),
          markingType: markingType,
          submittedAt: submittedAt,
          listingId: BuiltValueNullFieldError.checkNotNull(
              listingId, r'ProductComplianceQueueItem', 'listingId'),
          displayName: BuiltValueNullFieldError.checkNotNull(
              displayName, r'ProductComplianceQueueItem', 'displayName'),
          vendorSku: BuiltValueNullFieldError.checkNotNull(
              vendorSku, r'ProductComplianceQueueItem', 'vendorSku'),
          publicStoreName: publicStoreName,
          materialName: materialName,
          productName: productName,
          referenceStandard: referenceStandard,
          referenceResult: referenceResult,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
