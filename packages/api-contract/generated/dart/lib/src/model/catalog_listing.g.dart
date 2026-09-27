// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'catalog_listing.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const CatalogListingMaterialMatchEnum _$catalogListingMaterialMatchEnum_EXACT =
    const CatalogListingMaterialMatchEnum._('EXACT');
const CatalogListingMaterialMatchEnum _$catalogListingMaterialMatchEnum_ALIAS =
    const CatalogListingMaterialMatchEnum._('ALIAS');
const CatalogListingMaterialMatchEnum
    _$catalogListingMaterialMatchEnum_FUZZY_CONFIRMED =
    const CatalogListingMaterialMatchEnum._('FUZZY_CONFIRMED');
const CatalogListingMaterialMatchEnum
    _$catalogListingMaterialMatchEnum_UNMATCHED =
    const CatalogListingMaterialMatchEnum._('UNMATCHED');

CatalogListingMaterialMatchEnum _$catalogListingMaterialMatchEnumValueOf(
    String name) {
  switch (name) {
    case 'EXACT':
      return _$catalogListingMaterialMatchEnum_EXACT;
    case 'ALIAS':
      return _$catalogListingMaterialMatchEnum_ALIAS;
    case 'FUZZY_CONFIRMED':
      return _$catalogListingMaterialMatchEnum_FUZZY_CONFIRMED;
    case 'UNMATCHED':
      return _$catalogListingMaterialMatchEnum_UNMATCHED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<CatalogListingMaterialMatchEnum>
    _$catalogListingMaterialMatchEnumValues = BuiltSet<
        CatalogListingMaterialMatchEnum>(const <CatalogListingMaterialMatchEnum>[
  _$catalogListingMaterialMatchEnum_EXACT,
  _$catalogListingMaterialMatchEnum_ALIAS,
  _$catalogListingMaterialMatchEnum_FUZZY_CONFIRMED,
  _$catalogListingMaterialMatchEnum_UNMATCHED,
]);

Serializer<CatalogListingMaterialMatchEnum>
    _$catalogListingMaterialMatchEnumSerializer =
    _$CatalogListingMaterialMatchEnumSerializer();

class _$CatalogListingMaterialMatchEnumSerializer
    implements PrimitiveSerializer<CatalogListingMaterialMatchEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'EXACT': 'EXACT',
    'ALIAS': 'ALIAS',
    'FUZZY_CONFIRMED': 'FUZZY_CONFIRMED',
    'UNMATCHED': 'UNMATCHED',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'EXACT': 'EXACT',
    'ALIAS': 'ALIAS',
    'FUZZY_CONFIRMED': 'FUZZY_CONFIRMED',
    'UNMATCHED': 'UNMATCHED',
  };

  @override
  final Iterable<Type> types = const <Type>[CatalogListingMaterialMatchEnum];
  @override
  final String wireName = 'CatalogListingMaterialMatchEnum';

  @override
  Object serialize(
          Serializers serializers, CatalogListingMaterialMatchEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  CatalogListingMaterialMatchEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      CatalogListingMaterialMatchEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$CatalogListing extends CatalogListing {
  @override
  final String id;
  @override
  final ListingStatus status;
  @override
  final int lockVersion;
  @override
  final String displayName;
  @override
  final String vendorSku;
  @override
  final String? description;
  @override
  final CatalogListingMaterial? material;
  @override
  final CatalogListingMaterialMatchEnum materialMatch;
  @override
  final String? materialCategoryId;
  @override
  final String? otherLabel;
  @override
  final BuiltList<String> tagIds;
  @override
  final BuiltMap<String, String> technicalAttributes;
  @override
  final String? brand;
  @override
  final String? model;
  @override
  final String? manufacturer;
  @override
  final String? manufacturerAddress;
  @override
  final String? countryOfManufacture;
  @override
  final bool regulated;
  @override
  final ListingComplianceStatus complianceStatus;
  @override
  final RegulatedMaterialRule? regulatedRule;
  @override
  final int publicationVersion;
  @override
  final String? publishedAt;
  @override
  final String? publicationRequestedAt;
  @override
  final BuiltList<CatalogVariant> variants;
  @override
  final BuiltList<CatalogMedia> media;
  @override
  final BuiltList<ComplianceSubmissionSummary> complianceSubmissions;
  @override
  final BuiltList<ListingStatusChange> statusHistory;
  @override
  final CatalogCompletion completion;
  @override
  final BuiltList<CatalogBlocker> blockers;
  @override
  final CatalogListingPermissions permissions;
  @override
  final String? uploadedMediaId;

  factory _$CatalogListing([void Function(CatalogListingBuilder)? updates]) =>
      (CatalogListingBuilder()..update(updates))._build();

  _$CatalogListing._(
      {required this.id,
      required this.status,
      required this.lockVersion,
      required this.displayName,
      required this.vendorSku,
      this.description,
      this.material,
      required this.materialMatch,
      this.materialCategoryId,
      this.otherLabel,
      required this.tagIds,
      required this.technicalAttributes,
      this.brand,
      this.model,
      this.manufacturer,
      this.manufacturerAddress,
      this.countryOfManufacture,
      required this.regulated,
      required this.complianceStatus,
      this.regulatedRule,
      required this.publicationVersion,
      this.publishedAt,
      this.publicationRequestedAt,
      required this.variants,
      required this.media,
      required this.complianceSubmissions,
      required this.statusHistory,
      required this.completion,
      required this.blockers,
      required this.permissions,
      this.uploadedMediaId})
      : super._();
  @override
  CatalogListing rebuild(void Function(CatalogListingBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CatalogListingBuilder toBuilder() => CatalogListingBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CatalogListing &&
        id == other.id &&
        status == other.status &&
        lockVersion == other.lockVersion &&
        displayName == other.displayName &&
        vendorSku == other.vendorSku &&
        description == other.description &&
        material == other.material &&
        materialMatch == other.materialMatch &&
        materialCategoryId == other.materialCategoryId &&
        otherLabel == other.otherLabel &&
        tagIds == other.tagIds &&
        technicalAttributes == other.technicalAttributes &&
        brand == other.brand &&
        model == other.model &&
        manufacturer == other.manufacturer &&
        manufacturerAddress == other.manufacturerAddress &&
        countryOfManufacture == other.countryOfManufacture &&
        regulated == other.regulated &&
        complianceStatus == other.complianceStatus &&
        regulatedRule == other.regulatedRule &&
        publicationVersion == other.publicationVersion &&
        publishedAt == other.publishedAt &&
        publicationRequestedAt == other.publicationRequestedAt &&
        variants == other.variants &&
        media == other.media &&
        complianceSubmissions == other.complianceSubmissions &&
        statusHistory == other.statusHistory &&
        completion == other.completion &&
        blockers == other.blockers &&
        permissions == other.permissions &&
        uploadedMediaId == other.uploadedMediaId;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, lockVersion.hashCode);
    _$hash = $jc(_$hash, displayName.hashCode);
    _$hash = $jc(_$hash, vendorSku.hashCode);
    _$hash = $jc(_$hash, description.hashCode);
    _$hash = $jc(_$hash, material.hashCode);
    _$hash = $jc(_$hash, materialMatch.hashCode);
    _$hash = $jc(_$hash, materialCategoryId.hashCode);
    _$hash = $jc(_$hash, otherLabel.hashCode);
    _$hash = $jc(_$hash, tagIds.hashCode);
    _$hash = $jc(_$hash, technicalAttributes.hashCode);
    _$hash = $jc(_$hash, brand.hashCode);
    _$hash = $jc(_$hash, model.hashCode);
    _$hash = $jc(_$hash, manufacturer.hashCode);
    _$hash = $jc(_$hash, manufacturerAddress.hashCode);
    _$hash = $jc(_$hash, countryOfManufacture.hashCode);
    _$hash = $jc(_$hash, regulated.hashCode);
    _$hash = $jc(_$hash, complianceStatus.hashCode);
    _$hash = $jc(_$hash, regulatedRule.hashCode);
    _$hash = $jc(_$hash, publicationVersion.hashCode);
    _$hash = $jc(_$hash, publishedAt.hashCode);
    _$hash = $jc(_$hash, publicationRequestedAt.hashCode);
    _$hash = $jc(_$hash, variants.hashCode);
    _$hash = $jc(_$hash, media.hashCode);
    _$hash = $jc(_$hash, complianceSubmissions.hashCode);
    _$hash = $jc(_$hash, statusHistory.hashCode);
    _$hash = $jc(_$hash, completion.hashCode);
    _$hash = $jc(_$hash, blockers.hashCode);
    _$hash = $jc(_$hash, permissions.hashCode);
    _$hash = $jc(_$hash, uploadedMediaId.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CatalogListing')
          ..add('id', id)
          ..add('status', status)
          ..add('lockVersion', lockVersion)
          ..add('displayName', displayName)
          ..add('vendorSku', vendorSku)
          ..add('description', description)
          ..add('material', material)
          ..add('materialMatch', materialMatch)
          ..add('materialCategoryId', materialCategoryId)
          ..add('otherLabel', otherLabel)
          ..add('tagIds', tagIds)
          ..add('technicalAttributes', technicalAttributes)
          ..add('brand', brand)
          ..add('model', model)
          ..add('manufacturer', manufacturer)
          ..add('manufacturerAddress', manufacturerAddress)
          ..add('countryOfManufacture', countryOfManufacture)
          ..add('regulated', regulated)
          ..add('complianceStatus', complianceStatus)
          ..add('regulatedRule', regulatedRule)
          ..add('publicationVersion', publicationVersion)
          ..add('publishedAt', publishedAt)
          ..add('publicationRequestedAt', publicationRequestedAt)
          ..add('variants', variants)
          ..add('media', media)
          ..add('complianceSubmissions', complianceSubmissions)
          ..add('statusHistory', statusHistory)
          ..add('completion', completion)
          ..add('blockers', blockers)
          ..add('permissions', permissions)
          ..add('uploadedMediaId', uploadedMediaId))
        .toString();
  }
}

class CatalogListingBuilder
    implements Builder<CatalogListing, CatalogListingBuilder> {
  _$CatalogListing? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  ListingStatus? _status;
  ListingStatus? get status => _$this._status;
  set status(ListingStatus? status) => _$this._status = status;

  int? _lockVersion;
  int? get lockVersion => _$this._lockVersion;
  set lockVersion(int? lockVersion) => _$this._lockVersion = lockVersion;

  String? _displayName;
  String? get displayName => _$this._displayName;
  set displayName(String? displayName) => _$this._displayName = displayName;

  String? _vendorSku;
  String? get vendorSku => _$this._vendorSku;
  set vendorSku(String? vendorSku) => _$this._vendorSku = vendorSku;

  String? _description;
  String? get description => _$this._description;
  set description(String? description) => _$this._description = description;

  CatalogListingMaterialBuilder? _material;
  CatalogListingMaterialBuilder get material =>
      _$this._material ??= CatalogListingMaterialBuilder();
  set material(CatalogListingMaterialBuilder? material) =>
      _$this._material = material;

  CatalogListingMaterialMatchEnum? _materialMatch;
  CatalogListingMaterialMatchEnum? get materialMatch => _$this._materialMatch;
  set materialMatch(CatalogListingMaterialMatchEnum? materialMatch) =>
      _$this._materialMatch = materialMatch;

  String? _materialCategoryId;
  String? get materialCategoryId => _$this._materialCategoryId;
  set materialCategoryId(String? materialCategoryId) =>
      _$this._materialCategoryId = materialCategoryId;

  String? _otherLabel;
  String? get otherLabel => _$this._otherLabel;
  set otherLabel(String? otherLabel) => _$this._otherLabel = otherLabel;

  ListBuilder<String>? _tagIds;
  ListBuilder<String> get tagIds => _$this._tagIds ??= ListBuilder<String>();
  set tagIds(ListBuilder<String>? tagIds) => _$this._tagIds = tagIds;

  MapBuilder<String, String>? _technicalAttributes;
  MapBuilder<String, String> get technicalAttributes =>
      _$this._technicalAttributes ??= MapBuilder<String, String>();
  set technicalAttributes(MapBuilder<String, String>? technicalAttributes) =>
      _$this._technicalAttributes = technicalAttributes;

  String? _brand;
  String? get brand => _$this._brand;
  set brand(String? brand) => _$this._brand = brand;

  String? _model;
  String? get model => _$this._model;
  set model(String? model) => _$this._model = model;

  String? _manufacturer;
  String? get manufacturer => _$this._manufacturer;
  set manufacturer(String? manufacturer) => _$this._manufacturer = manufacturer;

  String? _manufacturerAddress;
  String? get manufacturerAddress => _$this._manufacturerAddress;
  set manufacturerAddress(String? manufacturerAddress) =>
      _$this._manufacturerAddress = manufacturerAddress;

  String? _countryOfManufacture;
  String? get countryOfManufacture => _$this._countryOfManufacture;
  set countryOfManufacture(String? countryOfManufacture) =>
      _$this._countryOfManufacture = countryOfManufacture;

  bool? _regulated;
  bool? get regulated => _$this._regulated;
  set regulated(bool? regulated) => _$this._regulated = regulated;

  ListingComplianceStatus? _complianceStatus;
  ListingComplianceStatus? get complianceStatus => _$this._complianceStatus;
  set complianceStatus(ListingComplianceStatus? complianceStatus) =>
      _$this._complianceStatus = complianceStatus;

  RegulatedMaterialRuleBuilder? _regulatedRule;
  RegulatedMaterialRuleBuilder get regulatedRule =>
      _$this._regulatedRule ??= RegulatedMaterialRuleBuilder();
  set regulatedRule(RegulatedMaterialRuleBuilder? regulatedRule) =>
      _$this._regulatedRule = regulatedRule;

  int? _publicationVersion;
  int? get publicationVersion => _$this._publicationVersion;
  set publicationVersion(int? publicationVersion) =>
      _$this._publicationVersion = publicationVersion;

  String? _publishedAt;
  String? get publishedAt => _$this._publishedAt;
  set publishedAt(String? publishedAt) => _$this._publishedAt = publishedAt;

  String? _publicationRequestedAt;
  String? get publicationRequestedAt => _$this._publicationRequestedAt;
  set publicationRequestedAt(String? publicationRequestedAt) =>
      _$this._publicationRequestedAt = publicationRequestedAt;

  ListBuilder<CatalogVariant>? _variants;
  ListBuilder<CatalogVariant> get variants =>
      _$this._variants ??= ListBuilder<CatalogVariant>();
  set variants(ListBuilder<CatalogVariant>? variants) =>
      _$this._variants = variants;

  ListBuilder<CatalogMedia>? _media;
  ListBuilder<CatalogMedia> get media =>
      _$this._media ??= ListBuilder<CatalogMedia>();
  set media(ListBuilder<CatalogMedia>? media) => _$this._media = media;

  ListBuilder<ComplianceSubmissionSummary>? _complianceSubmissions;
  ListBuilder<ComplianceSubmissionSummary> get complianceSubmissions =>
      _$this._complianceSubmissions ??=
          ListBuilder<ComplianceSubmissionSummary>();
  set complianceSubmissions(
          ListBuilder<ComplianceSubmissionSummary>? complianceSubmissions) =>
      _$this._complianceSubmissions = complianceSubmissions;

  ListBuilder<ListingStatusChange>? _statusHistory;
  ListBuilder<ListingStatusChange> get statusHistory =>
      _$this._statusHistory ??= ListBuilder<ListingStatusChange>();
  set statusHistory(ListBuilder<ListingStatusChange>? statusHistory) =>
      _$this._statusHistory = statusHistory;

  CatalogCompletionBuilder? _completion;
  CatalogCompletionBuilder get completion =>
      _$this._completion ??= CatalogCompletionBuilder();
  set completion(CatalogCompletionBuilder? completion) =>
      _$this._completion = completion;

  ListBuilder<CatalogBlocker>? _blockers;
  ListBuilder<CatalogBlocker> get blockers =>
      _$this._blockers ??= ListBuilder<CatalogBlocker>();
  set blockers(ListBuilder<CatalogBlocker>? blockers) =>
      _$this._blockers = blockers;

  CatalogListingPermissionsBuilder? _permissions;
  CatalogListingPermissionsBuilder get permissions =>
      _$this._permissions ??= CatalogListingPermissionsBuilder();
  set permissions(CatalogListingPermissionsBuilder? permissions) =>
      _$this._permissions = permissions;

  String? _uploadedMediaId;
  String? get uploadedMediaId => _$this._uploadedMediaId;
  set uploadedMediaId(String? uploadedMediaId) =>
      _$this._uploadedMediaId = uploadedMediaId;

  CatalogListingBuilder() {
    CatalogListing._defaults(this);
  }

  CatalogListingBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _status = $v.status;
      _lockVersion = $v.lockVersion;
      _displayName = $v.displayName;
      _vendorSku = $v.vendorSku;
      _description = $v.description;
      _material = $v.material?.toBuilder();
      _materialMatch = $v.materialMatch;
      _materialCategoryId = $v.materialCategoryId;
      _otherLabel = $v.otherLabel;
      _tagIds = $v.tagIds.toBuilder();
      _technicalAttributes = $v.technicalAttributes.toBuilder();
      _brand = $v.brand;
      _model = $v.model;
      _manufacturer = $v.manufacturer;
      _manufacturerAddress = $v.manufacturerAddress;
      _countryOfManufacture = $v.countryOfManufacture;
      _regulated = $v.regulated;
      _complianceStatus = $v.complianceStatus;
      _regulatedRule = $v.regulatedRule?.toBuilder();
      _publicationVersion = $v.publicationVersion;
      _publishedAt = $v.publishedAt;
      _publicationRequestedAt = $v.publicationRequestedAt;
      _variants = $v.variants.toBuilder();
      _media = $v.media.toBuilder();
      _complianceSubmissions = $v.complianceSubmissions.toBuilder();
      _statusHistory = $v.statusHistory.toBuilder();
      _completion = $v.completion.toBuilder();
      _blockers = $v.blockers.toBuilder();
      _permissions = $v.permissions.toBuilder();
      _uploadedMediaId = $v.uploadedMediaId;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CatalogListing other) {
    _$v = other as _$CatalogListing;
  }

  @override
  void update(void Function(CatalogListingBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CatalogListing build() => _build();

  _$CatalogListing _build() {
    _$CatalogListing _$result;
    try {
      _$result = _$v ??
          _$CatalogListing._(
            id: BuiltValueNullFieldError.checkNotNull(
                id, r'CatalogListing', 'id'),
            status: BuiltValueNullFieldError.checkNotNull(
                status, r'CatalogListing', 'status'),
            lockVersion: BuiltValueNullFieldError.checkNotNull(
                lockVersion, r'CatalogListing', 'lockVersion'),
            displayName: BuiltValueNullFieldError.checkNotNull(
                displayName, r'CatalogListing', 'displayName'),
            vendorSku: BuiltValueNullFieldError.checkNotNull(
                vendorSku, r'CatalogListing', 'vendorSku'),
            description: description,
            material: _material?.build(),
            materialMatch: BuiltValueNullFieldError.checkNotNull(
                materialMatch, r'CatalogListing', 'materialMatch'),
            materialCategoryId: materialCategoryId,
            otherLabel: otherLabel,
            tagIds: tagIds.build(),
            technicalAttributes: technicalAttributes.build(),
            brand: brand,
            model: model,
            manufacturer: manufacturer,
            manufacturerAddress: manufacturerAddress,
            countryOfManufacture: countryOfManufacture,
            regulated: BuiltValueNullFieldError.checkNotNull(
                regulated, r'CatalogListing', 'regulated'),
            complianceStatus: BuiltValueNullFieldError.checkNotNull(
                complianceStatus, r'CatalogListing', 'complianceStatus'),
            regulatedRule: _regulatedRule?.build(),
            publicationVersion: BuiltValueNullFieldError.checkNotNull(
                publicationVersion, r'CatalogListing', 'publicationVersion'),
            publishedAt: publishedAt,
            publicationRequestedAt: publicationRequestedAt,
            variants: variants.build(),
            media: media.build(),
            complianceSubmissions: complianceSubmissions.build(),
            statusHistory: statusHistory.build(),
            completion: completion.build(),
            blockers: blockers.build(),
            permissions: permissions.build(),
            uploadedMediaId: uploadedMediaId,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'material';
        _material?.build();

        _$failedField = 'tagIds';
        tagIds.build();
        _$failedField = 'technicalAttributes';
        technicalAttributes.build();

        _$failedField = 'regulatedRule';
        _regulatedRule?.build();

        _$failedField = 'variants';
        variants.build();
        _$failedField = 'media';
        media.build();
        _$failedField = 'complianceSubmissions';
        complianceSubmissions.build();
        _$failedField = 'statusHistory';
        statusHistory.build();
        _$failedField = 'completion';
        completion.build();
        _$failedField = 'blockers';
        blockers.build();
        _$failedField = 'permissions';
        permissions.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'CatalogListing', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
