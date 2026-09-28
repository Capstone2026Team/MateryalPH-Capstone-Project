// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'catalog_listing_summary.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const CatalogListingSummaryPublicAvailabilityEnum
    _$catalogListingSummaryPublicAvailabilityEnum_IN_STOCK =
    const CatalogListingSummaryPublicAvailabilityEnum._('IN_STOCK');
const CatalogListingSummaryPublicAvailabilityEnum
    _$catalogListingSummaryPublicAvailabilityEnum_OUT_OF_STOCK =
    const CatalogListingSummaryPublicAvailabilityEnum._('OUT_OF_STOCK');

CatalogListingSummaryPublicAvailabilityEnum
    _$catalogListingSummaryPublicAvailabilityEnumValueOf(String name) {
  switch (name) {
    case 'IN_STOCK':
      return _$catalogListingSummaryPublicAvailabilityEnum_IN_STOCK;
    case 'OUT_OF_STOCK':
      return _$catalogListingSummaryPublicAvailabilityEnum_OUT_OF_STOCK;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<CatalogListingSummaryPublicAvailabilityEnum>
    _$catalogListingSummaryPublicAvailabilityEnumValues = BuiltSet<
        CatalogListingSummaryPublicAvailabilityEnum>(const <CatalogListingSummaryPublicAvailabilityEnum>[
  _$catalogListingSummaryPublicAvailabilityEnum_IN_STOCK,
  _$catalogListingSummaryPublicAvailabilityEnum_OUT_OF_STOCK,
]);

Serializer<CatalogListingSummaryPublicAvailabilityEnum>
    _$catalogListingSummaryPublicAvailabilityEnumSerializer =
    _$CatalogListingSummaryPublicAvailabilityEnumSerializer();

class _$CatalogListingSummaryPublicAvailabilityEnumSerializer
    implements
        PrimitiveSerializer<CatalogListingSummaryPublicAvailabilityEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'IN_STOCK': 'IN_STOCK',
    'OUT_OF_STOCK': 'OUT_OF_STOCK',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'IN_STOCK': 'IN_STOCK',
    'OUT_OF_STOCK': 'OUT_OF_STOCK',
  };

  @override
  final Iterable<Type> types = const <Type>[
    CatalogListingSummaryPublicAvailabilityEnum
  ];
  @override
  final String wireName = 'CatalogListingSummaryPublicAvailabilityEnum';

  @override
  Object serialize(Serializers serializers,
          CatalogListingSummaryPublicAvailabilityEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  CatalogListingSummaryPublicAvailabilityEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      CatalogListingSummaryPublicAvailabilityEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$CatalogListingSummary extends CatalogListingSummary {
  @override
  final String id;
  @override
  final String displayName;
  @override
  final String vendorSku;
  @override
  final ListingStatus status;
  @override
  final ListingComplianceStatus complianceStatus;
  @override
  final bool regulated;
  @override
  final String? categoryName;
  @override
  final String? materialName;
  @override
  final String? otherLabel;
  @override
  final int lockVersion;
  @override
  final String? updatedAt;
  @override
  final int variantCount;
  @override
  final int? minPriceCentavos;
  @override
  final int? maxPriceCentavos;
  @override
  final CatalogListingSummaryPublicAvailabilityEnum publicAvailability;
  @override
  final String? primaryImageFileId;
  @override
  final bool? deletable;
  @override
  final String? primaryImageUrl;
  @override
  final String? unitCode;
  @override
  final String? availableQuantity;

  factory _$CatalogListingSummary(
          [void Function(CatalogListingSummaryBuilder)? updates]) =>
      (CatalogListingSummaryBuilder()..update(updates))._build();

  _$CatalogListingSummary._(
      {required this.id,
      required this.displayName,
      required this.vendorSku,
      required this.status,
      required this.complianceStatus,
      required this.regulated,
      this.categoryName,
      this.materialName,
      this.otherLabel,
      required this.lockVersion,
      this.updatedAt,
      required this.variantCount,
      this.minPriceCentavos,
      this.maxPriceCentavos,
      required this.publicAvailability,
      this.primaryImageFileId,
      this.deletable,
      this.primaryImageUrl,
      this.unitCode,
      this.availableQuantity})
      : super._();
  @override
  CatalogListingSummary rebuild(
          void Function(CatalogListingSummaryBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CatalogListingSummaryBuilder toBuilder() =>
      CatalogListingSummaryBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CatalogListingSummary &&
        id == other.id &&
        displayName == other.displayName &&
        vendorSku == other.vendorSku &&
        status == other.status &&
        complianceStatus == other.complianceStatus &&
        regulated == other.regulated &&
        categoryName == other.categoryName &&
        materialName == other.materialName &&
        otherLabel == other.otherLabel &&
        lockVersion == other.lockVersion &&
        updatedAt == other.updatedAt &&
        variantCount == other.variantCount &&
        minPriceCentavos == other.minPriceCentavos &&
        maxPriceCentavos == other.maxPriceCentavos &&
        publicAvailability == other.publicAvailability &&
        primaryImageFileId == other.primaryImageFileId &&
        deletable == other.deletable &&
        primaryImageUrl == other.primaryImageUrl &&
        unitCode == other.unitCode &&
        availableQuantity == other.availableQuantity;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, displayName.hashCode);
    _$hash = $jc(_$hash, vendorSku.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, complianceStatus.hashCode);
    _$hash = $jc(_$hash, regulated.hashCode);
    _$hash = $jc(_$hash, categoryName.hashCode);
    _$hash = $jc(_$hash, materialName.hashCode);
    _$hash = $jc(_$hash, otherLabel.hashCode);
    _$hash = $jc(_$hash, lockVersion.hashCode);
    _$hash = $jc(_$hash, updatedAt.hashCode);
    _$hash = $jc(_$hash, variantCount.hashCode);
    _$hash = $jc(_$hash, minPriceCentavos.hashCode);
    _$hash = $jc(_$hash, maxPriceCentavos.hashCode);
    _$hash = $jc(_$hash, publicAvailability.hashCode);
    _$hash = $jc(_$hash, primaryImageFileId.hashCode);
    _$hash = $jc(_$hash, deletable.hashCode);
    _$hash = $jc(_$hash, primaryImageUrl.hashCode);
    _$hash = $jc(_$hash, unitCode.hashCode);
    _$hash = $jc(_$hash, availableQuantity.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CatalogListingSummary')
          ..add('id', id)
          ..add('displayName', displayName)
          ..add('vendorSku', vendorSku)
          ..add('status', status)
          ..add('complianceStatus', complianceStatus)
          ..add('regulated', regulated)
          ..add('categoryName', categoryName)
          ..add('materialName', materialName)
          ..add('otherLabel', otherLabel)
          ..add('lockVersion', lockVersion)
          ..add('updatedAt', updatedAt)
          ..add('variantCount', variantCount)
          ..add('minPriceCentavos', minPriceCentavos)
          ..add('maxPriceCentavos', maxPriceCentavos)
          ..add('publicAvailability', publicAvailability)
          ..add('primaryImageFileId', primaryImageFileId)
          ..add('deletable', deletable)
          ..add('primaryImageUrl', primaryImageUrl)
          ..add('unitCode', unitCode)
          ..add('availableQuantity', availableQuantity))
        .toString();
  }
}

class CatalogListingSummaryBuilder
    implements Builder<CatalogListingSummary, CatalogListingSummaryBuilder> {
  _$CatalogListingSummary? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _displayName;
  String? get displayName => _$this._displayName;
  set displayName(String? displayName) => _$this._displayName = displayName;

  String? _vendorSku;
  String? get vendorSku => _$this._vendorSku;
  set vendorSku(String? vendorSku) => _$this._vendorSku = vendorSku;

  ListingStatus? _status;
  ListingStatus? get status => _$this._status;
  set status(ListingStatus? status) => _$this._status = status;

  ListingComplianceStatus? _complianceStatus;
  ListingComplianceStatus? get complianceStatus => _$this._complianceStatus;
  set complianceStatus(ListingComplianceStatus? complianceStatus) =>
      _$this._complianceStatus = complianceStatus;

  bool? _regulated;
  bool? get regulated => _$this._regulated;
  set regulated(bool? regulated) => _$this._regulated = regulated;

  String? _categoryName;
  String? get categoryName => _$this._categoryName;
  set categoryName(String? categoryName) => _$this._categoryName = categoryName;

  String? _materialName;
  String? get materialName => _$this._materialName;
  set materialName(String? materialName) => _$this._materialName = materialName;

  String? _otherLabel;
  String? get otherLabel => _$this._otherLabel;
  set otherLabel(String? otherLabel) => _$this._otherLabel = otherLabel;

  int? _lockVersion;
  int? get lockVersion => _$this._lockVersion;
  set lockVersion(int? lockVersion) => _$this._lockVersion = lockVersion;

  String? _updatedAt;
  String? get updatedAt => _$this._updatedAt;
  set updatedAt(String? updatedAt) => _$this._updatedAt = updatedAt;

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

  CatalogListingSummaryPublicAvailabilityEnum? _publicAvailability;
  CatalogListingSummaryPublicAvailabilityEnum? get publicAvailability =>
      _$this._publicAvailability;
  set publicAvailability(
          CatalogListingSummaryPublicAvailabilityEnum? publicAvailability) =>
      _$this._publicAvailability = publicAvailability;

  String? _primaryImageFileId;
  String? get primaryImageFileId => _$this._primaryImageFileId;
  set primaryImageFileId(String? primaryImageFileId) =>
      _$this._primaryImageFileId = primaryImageFileId;

  bool? _deletable;
  bool? get deletable => _$this._deletable;
  set deletable(bool? deletable) => _$this._deletable = deletable;

  String? _primaryImageUrl;
  String? get primaryImageUrl => _$this._primaryImageUrl;
  set primaryImageUrl(String? primaryImageUrl) =>
      _$this._primaryImageUrl = primaryImageUrl;

  String? _unitCode;
  String? get unitCode => _$this._unitCode;
  set unitCode(String? unitCode) => _$this._unitCode = unitCode;

  String? _availableQuantity;
  String? get availableQuantity => _$this._availableQuantity;
  set availableQuantity(String? availableQuantity) =>
      _$this._availableQuantity = availableQuantity;

  CatalogListingSummaryBuilder() {
    CatalogListingSummary._defaults(this);
  }

  CatalogListingSummaryBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _displayName = $v.displayName;
      _vendorSku = $v.vendorSku;
      _status = $v.status;
      _complianceStatus = $v.complianceStatus;
      _regulated = $v.regulated;
      _categoryName = $v.categoryName;
      _materialName = $v.materialName;
      _otherLabel = $v.otherLabel;
      _lockVersion = $v.lockVersion;
      _updatedAt = $v.updatedAt;
      _variantCount = $v.variantCount;
      _minPriceCentavos = $v.minPriceCentavos;
      _maxPriceCentavos = $v.maxPriceCentavos;
      _publicAvailability = $v.publicAvailability;
      _primaryImageFileId = $v.primaryImageFileId;
      _deletable = $v.deletable;
      _primaryImageUrl = $v.primaryImageUrl;
      _unitCode = $v.unitCode;
      _availableQuantity = $v.availableQuantity;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CatalogListingSummary other) {
    _$v = other as _$CatalogListingSummary;
  }

  @override
  void update(void Function(CatalogListingSummaryBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CatalogListingSummary build() => _build();

  _$CatalogListingSummary _build() {
    final _$result = _$v ??
        _$CatalogListingSummary._(
          id: BuiltValueNullFieldError.checkNotNull(
              id, r'CatalogListingSummary', 'id'),
          displayName: BuiltValueNullFieldError.checkNotNull(
              displayName, r'CatalogListingSummary', 'displayName'),
          vendorSku: BuiltValueNullFieldError.checkNotNull(
              vendorSku, r'CatalogListingSummary', 'vendorSku'),
          status: BuiltValueNullFieldError.checkNotNull(
              status, r'CatalogListingSummary', 'status'),
          complianceStatus: BuiltValueNullFieldError.checkNotNull(
              complianceStatus, r'CatalogListingSummary', 'complianceStatus'),
          regulated: BuiltValueNullFieldError.checkNotNull(
              regulated, r'CatalogListingSummary', 'regulated'),
          categoryName: categoryName,
          materialName: materialName,
          otherLabel: otherLabel,
          lockVersion: BuiltValueNullFieldError.checkNotNull(
              lockVersion, r'CatalogListingSummary', 'lockVersion'),
          updatedAt: updatedAt,
          variantCount: BuiltValueNullFieldError.checkNotNull(
              variantCount, r'CatalogListingSummary', 'variantCount'),
          minPriceCentavos: minPriceCentavos,
          maxPriceCentavos: maxPriceCentavos,
          publicAvailability: BuiltValueNullFieldError.checkNotNull(
              publicAvailability,
              r'CatalogListingSummary',
              'publicAvailability'),
          primaryImageFileId: primaryImageFileId,
          deletable: deletable,
          primaryImageUrl: primaryImageUrl,
          unitCode: unitCode,
          availableQuantity: availableQuantity,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
