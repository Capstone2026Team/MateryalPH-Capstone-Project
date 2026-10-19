// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project_separate_purchase.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const ProjectSeparatePurchaseStageEnum
    _$projectSeparatePurchaseStageEnum_IN_CART =
    const ProjectSeparatePurchaseStageEnum._('IN_CART');
const ProjectSeparatePurchaseStageEnum
    _$projectSeparatePurchaseStageEnum_ORDERED =
    const ProjectSeparatePurchaseStageEnum._('ORDERED');
const ProjectSeparatePurchaseStageEnum
    _$projectSeparatePurchaseStageEnum_DRAFT =
    const ProjectSeparatePurchaseStageEnum._('DRAFT');

ProjectSeparatePurchaseStageEnum _$projectSeparatePurchaseStageEnumValueOf(
    String name) {
  switch (name) {
    case 'IN_CART':
      return _$projectSeparatePurchaseStageEnum_IN_CART;
    case 'ORDERED':
      return _$projectSeparatePurchaseStageEnum_ORDERED;
    case 'DRAFT':
      return _$projectSeparatePurchaseStageEnum_DRAFT;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<ProjectSeparatePurchaseStageEnum>
    _$projectSeparatePurchaseStageEnumValues = BuiltSet<
        ProjectSeparatePurchaseStageEnum>(const <ProjectSeparatePurchaseStageEnum>[
  _$projectSeparatePurchaseStageEnum_IN_CART,
  _$projectSeparatePurchaseStageEnum_ORDERED,
  _$projectSeparatePurchaseStageEnum_DRAFT,
]);

Serializer<ProjectSeparatePurchaseStageEnum>
    _$projectSeparatePurchaseStageEnumSerializer =
    _$ProjectSeparatePurchaseStageEnumSerializer();

class _$ProjectSeparatePurchaseStageEnumSerializer
    implements PrimitiveSerializer<ProjectSeparatePurchaseStageEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'IN_CART': 'IN_CART',
    'ORDERED': 'ORDERED',
    'DRAFT': 'DRAFT',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'IN_CART': 'IN_CART',
    'ORDERED': 'ORDERED',
    'DRAFT': 'DRAFT',
  };

  @override
  final Iterable<Type> types = const <Type>[ProjectSeparatePurchaseStageEnum];
  @override
  final String wireName = 'ProjectSeparatePurchaseStageEnum';

  @override
  Object serialize(
          Serializers serializers, ProjectSeparatePurchaseStageEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  ProjectSeparatePurchaseStageEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      ProjectSeparatePurchaseStageEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$ProjectSeparatePurchase extends ProjectSeparatePurchase {
  @override
  final ProjectSeparatePurchaseStageEnum stage;
  @override
  final String lineId;
  @override
  final String variantId;
  @override
  final String listingId;
  @override
  final String displayName;
  @override
  final String? variantLabel;
  @override
  final String vendorId;
  @override
  final String? storeName;
  @override
  final String quantity;
  @override
  final String unitCode;
  @override
  final int unitPriceCentavos;
  @override
  final int lineTotalCentavos;
  @override
  final bool satisfiesRequirement;
  @override
  final String? orderId;
  @override
  final String? orderReference;
  @override
  final String? draftItemId;
  @override
  final ListingImage? image;
  @override
  final BuiltList<ProjectSpecificationDetail>? specifications;
  @override
  final String? coverageQuantity;

  factory _$ProjectSeparatePurchase(
          [void Function(ProjectSeparatePurchaseBuilder)? updates]) =>
      (ProjectSeparatePurchaseBuilder()..update(updates))._build();

  _$ProjectSeparatePurchase._(
      {required this.stage,
      required this.lineId,
      required this.variantId,
      required this.listingId,
      required this.displayName,
      this.variantLabel,
      required this.vendorId,
      this.storeName,
      required this.quantity,
      required this.unitCode,
      required this.unitPriceCentavos,
      required this.lineTotalCentavos,
      required this.satisfiesRequirement,
      this.orderId,
      this.orderReference,
      this.draftItemId,
      this.image,
      this.specifications,
      this.coverageQuantity})
      : super._();
  @override
  ProjectSeparatePurchase rebuild(
          void Function(ProjectSeparatePurchaseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ProjectSeparatePurchaseBuilder toBuilder() =>
      ProjectSeparatePurchaseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ProjectSeparatePurchase &&
        stage == other.stage &&
        lineId == other.lineId &&
        variantId == other.variantId &&
        listingId == other.listingId &&
        displayName == other.displayName &&
        variantLabel == other.variantLabel &&
        vendorId == other.vendorId &&
        storeName == other.storeName &&
        quantity == other.quantity &&
        unitCode == other.unitCode &&
        unitPriceCentavos == other.unitPriceCentavos &&
        lineTotalCentavos == other.lineTotalCentavos &&
        satisfiesRequirement == other.satisfiesRequirement &&
        orderId == other.orderId &&
        orderReference == other.orderReference &&
        draftItemId == other.draftItemId &&
        image == other.image &&
        specifications == other.specifications &&
        coverageQuantity == other.coverageQuantity;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, stage.hashCode);
    _$hash = $jc(_$hash, lineId.hashCode);
    _$hash = $jc(_$hash, variantId.hashCode);
    _$hash = $jc(_$hash, listingId.hashCode);
    _$hash = $jc(_$hash, displayName.hashCode);
    _$hash = $jc(_$hash, variantLabel.hashCode);
    _$hash = $jc(_$hash, vendorId.hashCode);
    _$hash = $jc(_$hash, storeName.hashCode);
    _$hash = $jc(_$hash, quantity.hashCode);
    _$hash = $jc(_$hash, unitCode.hashCode);
    _$hash = $jc(_$hash, unitPriceCentavos.hashCode);
    _$hash = $jc(_$hash, lineTotalCentavos.hashCode);
    _$hash = $jc(_$hash, satisfiesRequirement.hashCode);
    _$hash = $jc(_$hash, orderId.hashCode);
    _$hash = $jc(_$hash, orderReference.hashCode);
    _$hash = $jc(_$hash, draftItemId.hashCode);
    _$hash = $jc(_$hash, image.hashCode);
    _$hash = $jc(_$hash, specifications.hashCode);
    _$hash = $jc(_$hash, coverageQuantity.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ProjectSeparatePurchase')
          ..add('stage', stage)
          ..add('lineId', lineId)
          ..add('variantId', variantId)
          ..add('listingId', listingId)
          ..add('displayName', displayName)
          ..add('variantLabel', variantLabel)
          ..add('vendorId', vendorId)
          ..add('storeName', storeName)
          ..add('quantity', quantity)
          ..add('unitCode', unitCode)
          ..add('unitPriceCentavos', unitPriceCentavos)
          ..add('lineTotalCentavos', lineTotalCentavos)
          ..add('satisfiesRequirement', satisfiesRequirement)
          ..add('orderId', orderId)
          ..add('orderReference', orderReference)
          ..add('draftItemId', draftItemId)
          ..add('image', image)
          ..add('specifications', specifications)
          ..add('coverageQuantity', coverageQuantity))
        .toString();
  }
}

class ProjectSeparatePurchaseBuilder
    implements
        Builder<ProjectSeparatePurchase, ProjectSeparatePurchaseBuilder> {
  _$ProjectSeparatePurchase? _$v;

  ProjectSeparatePurchaseStageEnum? _stage;
  ProjectSeparatePurchaseStageEnum? get stage => _$this._stage;
  set stage(ProjectSeparatePurchaseStageEnum? stage) => _$this._stage = stage;

  String? _lineId;
  String? get lineId => _$this._lineId;
  set lineId(String? lineId) => _$this._lineId = lineId;

  String? _variantId;
  String? get variantId => _$this._variantId;
  set variantId(String? variantId) => _$this._variantId = variantId;

  String? _listingId;
  String? get listingId => _$this._listingId;
  set listingId(String? listingId) => _$this._listingId = listingId;

  String? _displayName;
  String? get displayName => _$this._displayName;
  set displayName(String? displayName) => _$this._displayName = displayName;

  String? _variantLabel;
  String? get variantLabel => _$this._variantLabel;
  set variantLabel(String? variantLabel) => _$this._variantLabel = variantLabel;

  String? _vendorId;
  String? get vendorId => _$this._vendorId;
  set vendorId(String? vendorId) => _$this._vendorId = vendorId;

  String? _storeName;
  String? get storeName => _$this._storeName;
  set storeName(String? storeName) => _$this._storeName = storeName;

  String? _quantity;
  String? get quantity => _$this._quantity;
  set quantity(String? quantity) => _$this._quantity = quantity;

  String? _unitCode;
  String? get unitCode => _$this._unitCode;
  set unitCode(String? unitCode) => _$this._unitCode = unitCode;

  int? _unitPriceCentavos;
  int? get unitPriceCentavos => _$this._unitPriceCentavos;
  set unitPriceCentavos(int? unitPriceCentavos) =>
      _$this._unitPriceCentavos = unitPriceCentavos;

  int? _lineTotalCentavos;
  int? get lineTotalCentavos => _$this._lineTotalCentavos;
  set lineTotalCentavos(int? lineTotalCentavos) =>
      _$this._lineTotalCentavos = lineTotalCentavos;

  bool? _satisfiesRequirement;
  bool? get satisfiesRequirement => _$this._satisfiesRequirement;
  set satisfiesRequirement(bool? satisfiesRequirement) =>
      _$this._satisfiesRequirement = satisfiesRequirement;

  String? _orderId;
  String? get orderId => _$this._orderId;
  set orderId(String? orderId) => _$this._orderId = orderId;

  String? _orderReference;
  String? get orderReference => _$this._orderReference;
  set orderReference(String? orderReference) =>
      _$this._orderReference = orderReference;

  String? _draftItemId;
  String? get draftItemId => _$this._draftItemId;
  set draftItemId(String? draftItemId) => _$this._draftItemId = draftItemId;

  ListingImageBuilder? _image;
  ListingImageBuilder get image => _$this._image ??= ListingImageBuilder();
  set image(ListingImageBuilder? image) => _$this._image = image;

  ListBuilder<ProjectSpecificationDetail>? _specifications;
  ListBuilder<ProjectSpecificationDetail> get specifications =>
      _$this._specifications ??= ListBuilder<ProjectSpecificationDetail>();
  set specifications(ListBuilder<ProjectSpecificationDetail>? specifications) =>
      _$this._specifications = specifications;

  String? _coverageQuantity;
  String? get coverageQuantity => _$this._coverageQuantity;
  set coverageQuantity(String? coverageQuantity) =>
      _$this._coverageQuantity = coverageQuantity;

  ProjectSeparatePurchaseBuilder() {
    ProjectSeparatePurchase._defaults(this);
  }

  ProjectSeparatePurchaseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _stage = $v.stage;
      _lineId = $v.lineId;
      _variantId = $v.variantId;
      _listingId = $v.listingId;
      _displayName = $v.displayName;
      _variantLabel = $v.variantLabel;
      _vendorId = $v.vendorId;
      _storeName = $v.storeName;
      _quantity = $v.quantity;
      _unitCode = $v.unitCode;
      _unitPriceCentavos = $v.unitPriceCentavos;
      _lineTotalCentavos = $v.lineTotalCentavos;
      _satisfiesRequirement = $v.satisfiesRequirement;
      _orderId = $v.orderId;
      _orderReference = $v.orderReference;
      _draftItemId = $v.draftItemId;
      _image = $v.image?.toBuilder();
      _specifications = $v.specifications?.toBuilder();
      _coverageQuantity = $v.coverageQuantity;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ProjectSeparatePurchase other) {
    _$v = other as _$ProjectSeparatePurchase;
  }

  @override
  void update(void Function(ProjectSeparatePurchaseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ProjectSeparatePurchase build() => _build();

  _$ProjectSeparatePurchase _build() {
    _$ProjectSeparatePurchase _$result;
    try {
      _$result = _$v ??
          _$ProjectSeparatePurchase._(
            stage: BuiltValueNullFieldError.checkNotNull(
                stage, r'ProjectSeparatePurchase', 'stage'),
            lineId: BuiltValueNullFieldError.checkNotNull(
                lineId, r'ProjectSeparatePurchase', 'lineId'),
            variantId: BuiltValueNullFieldError.checkNotNull(
                variantId, r'ProjectSeparatePurchase', 'variantId'),
            listingId: BuiltValueNullFieldError.checkNotNull(
                listingId, r'ProjectSeparatePurchase', 'listingId'),
            displayName: BuiltValueNullFieldError.checkNotNull(
                displayName, r'ProjectSeparatePurchase', 'displayName'),
            variantLabel: variantLabel,
            vendorId: BuiltValueNullFieldError.checkNotNull(
                vendorId, r'ProjectSeparatePurchase', 'vendorId'),
            storeName: storeName,
            quantity: BuiltValueNullFieldError.checkNotNull(
                quantity, r'ProjectSeparatePurchase', 'quantity'),
            unitCode: BuiltValueNullFieldError.checkNotNull(
                unitCode, r'ProjectSeparatePurchase', 'unitCode'),
            unitPriceCentavos: BuiltValueNullFieldError.checkNotNull(
                unitPriceCentavos,
                r'ProjectSeparatePurchase',
                'unitPriceCentavos'),
            lineTotalCentavos: BuiltValueNullFieldError.checkNotNull(
                lineTotalCentavos,
                r'ProjectSeparatePurchase',
                'lineTotalCentavos'),
            satisfiesRequirement: BuiltValueNullFieldError.checkNotNull(
                satisfiesRequirement,
                r'ProjectSeparatePurchase',
                'satisfiesRequirement'),
            orderId: orderId,
            orderReference: orderReference,
            draftItemId: draftItemId,
            image: _image?.build(),
            specifications: _specifications?.build(),
            coverageQuantity: coverageQuantity,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'image';
        _image?.build();
        _$failedField = 'specifications';
        _specifications?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'ProjectSeparatePurchase', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
