// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project_candidate.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const ProjectCandidateFulfillmentOptionsEnum
    _$projectCandidateFulfillmentOptionsEnum_DELIVERY =
    const ProjectCandidateFulfillmentOptionsEnum._('DELIVERY');
const ProjectCandidateFulfillmentOptionsEnum
    _$projectCandidateFulfillmentOptionsEnum_PICKUP =
    const ProjectCandidateFulfillmentOptionsEnum._('PICKUP');

ProjectCandidateFulfillmentOptionsEnum
    _$projectCandidateFulfillmentOptionsEnumValueOf(String name) {
  switch (name) {
    case 'DELIVERY':
      return _$projectCandidateFulfillmentOptionsEnum_DELIVERY;
    case 'PICKUP':
      return _$projectCandidateFulfillmentOptionsEnum_PICKUP;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<ProjectCandidateFulfillmentOptionsEnum>
    _$projectCandidateFulfillmentOptionsEnumValues = BuiltSet<
        ProjectCandidateFulfillmentOptionsEnum>(const <ProjectCandidateFulfillmentOptionsEnum>[
  _$projectCandidateFulfillmentOptionsEnum_DELIVERY,
  _$projectCandidateFulfillmentOptionsEnum_PICKUP,
]);

const ProjectCandidateProcurementBudgetLabelEnum
    _$projectCandidateProcurementBudgetLabelEnum_UNDER_BUDGET =
    const ProjectCandidateProcurementBudgetLabelEnum._('UNDER_BUDGET');
const ProjectCandidateProcurementBudgetLabelEnum
    _$projectCandidateProcurementBudgetLabelEnum_WITHIN_BUDGET =
    const ProjectCandidateProcurementBudgetLabelEnum._('WITHIN_BUDGET');
const ProjectCandidateProcurementBudgetLabelEnum
    _$projectCandidateProcurementBudgetLabelEnum_OVER_BUDGET =
    const ProjectCandidateProcurementBudgetLabelEnum._('OVER_BUDGET');
const ProjectCandidateProcurementBudgetLabelEnum
    _$projectCandidateProcurementBudgetLabelEnum_COST_REVIEW_REQUIRED =
    const ProjectCandidateProcurementBudgetLabelEnum._('COST_REVIEW_REQUIRED');

ProjectCandidateProcurementBudgetLabelEnum
    _$projectCandidateProcurementBudgetLabelEnumValueOf(String name) {
  switch (name) {
    case 'UNDER_BUDGET':
      return _$projectCandidateProcurementBudgetLabelEnum_UNDER_BUDGET;
    case 'WITHIN_BUDGET':
      return _$projectCandidateProcurementBudgetLabelEnum_WITHIN_BUDGET;
    case 'OVER_BUDGET':
      return _$projectCandidateProcurementBudgetLabelEnum_OVER_BUDGET;
    case 'COST_REVIEW_REQUIRED':
      return _$projectCandidateProcurementBudgetLabelEnum_COST_REVIEW_REQUIRED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<ProjectCandidateProcurementBudgetLabelEnum>
    _$projectCandidateProcurementBudgetLabelEnumValues = BuiltSet<
        ProjectCandidateProcurementBudgetLabelEnum>(const <ProjectCandidateProcurementBudgetLabelEnum>[
  _$projectCandidateProcurementBudgetLabelEnum_UNDER_BUDGET,
  _$projectCandidateProcurementBudgetLabelEnum_WITHIN_BUDGET,
  _$projectCandidateProcurementBudgetLabelEnum_OVER_BUDGET,
  _$projectCandidateProcurementBudgetLabelEnum_COST_REVIEW_REQUIRED,
]);

Serializer<ProjectCandidateFulfillmentOptionsEnum>
    _$projectCandidateFulfillmentOptionsEnumSerializer =
    _$ProjectCandidateFulfillmentOptionsEnumSerializer();
Serializer<ProjectCandidateProcurementBudgetLabelEnum>
    _$projectCandidateProcurementBudgetLabelEnumSerializer =
    _$ProjectCandidateProcurementBudgetLabelEnumSerializer();

class _$ProjectCandidateFulfillmentOptionsEnumSerializer
    implements PrimitiveSerializer<ProjectCandidateFulfillmentOptionsEnum> {
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
    ProjectCandidateFulfillmentOptionsEnum
  ];
  @override
  final String wireName = 'ProjectCandidateFulfillmentOptionsEnum';

  @override
  Object serialize(Serializers serializers,
          ProjectCandidateFulfillmentOptionsEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  ProjectCandidateFulfillmentOptionsEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      ProjectCandidateFulfillmentOptionsEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$ProjectCandidateProcurementBudgetLabelEnumSerializer
    implements PrimitiveSerializer<ProjectCandidateProcurementBudgetLabelEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'UNDER_BUDGET': 'UNDER_BUDGET',
    'WITHIN_BUDGET': 'WITHIN_BUDGET',
    'OVER_BUDGET': 'OVER_BUDGET',
    'COST_REVIEW_REQUIRED': 'COST_REVIEW_REQUIRED',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'UNDER_BUDGET': 'UNDER_BUDGET',
    'WITHIN_BUDGET': 'WITHIN_BUDGET',
    'OVER_BUDGET': 'OVER_BUDGET',
    'COST_REVIEW_REQUIRED': 'COST_REVIEW_REQUIRED',
  };

  @override
  final Iterable<Type> types = const <Type>[
    ProjectCandidateProcurementBudgetLabelEnum
  ];
  @override
  final String wireName = 'ProjectCandidateProcurementBudgetLabelEnum';

  @override
  Object serialize(Serializers serializers,
          ProjectCandidateProcurementBudgetLabelEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  ProjectCandidateProcurementBudgetLabelEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      ProjectCandidateProcurementBudgetLabelEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$ProjectCandidate extends ProjectCandidate {
  @override
  final String id;
  @override
  final String estimateId;
  @override
  final String vendorId;
  @override
  final String storeName;
  @override
  final int rank;
  @override
  final num latitude;
  @override
  final num longitude;
  @override
  final String scoreLabel;
  @override
  final String? vps;
  @override
  final BuiltMap<String, JsonObject?> fms;
  @override
  final bool complete;
  @override
  final String fulfillmentPercent;
  @override
  final BuiltList<BuiltMap<String, JsonObject?>> missingLines;
  @override
  final BuiltList<BuiltMap<String, JsonObject?>> lines;
  @override
  final bool? selectionRequired;
  @override
  final BuiltMap<String, String>? specificationSelections;
  @override
  final int materialsCentavos;
  @override
  final int includedVatCentavos;
  @override
  final int? deliveryCentavos;
  @override
  final int? processingFeeCentavos;
  @override
  final String processingFeeStatus;
  @override
  final int? projectedTotalCentavos;
  @override
  final String budgetLabel;
  @override
  final int distanceMeters;
  @override
  final String distanceBasis;
  @override
  final int? etaSeconds;
  @override
  final String fulfillmentMethod;
  @override
  final BuiltList<ProjectCandidateFulfillmentOptionsEnum>? fulfillmentOptions;
  @override
  final String paymentMethod;
  @override
  final BuiltMap<String, JsonObject?> delivery;
  @override
  final BuiltMap<String, JsonObject?> destination;
  @override
  final String expiresAt;
  @override
  final bool stale;
  @override
  final String label;
  @override
  final String currentQuotationState;
  @override
  final bool? isFavorite;
  @override
  final ProjectFulfillment fulfillment;
  @override
  final BuiltList<ProjectPaymentMethod>? paymentMethods;
  @override
  final BuiltList<ProjectDraftVendorGroup>? draftGroups;
  @override
  final String? primaryOrderId;
  @override
  final int? procurementMaterialsCentavos;
  @override
  final int? separateDeliveryCentavos;
  @override
  final int? procurementDeliveryCentavos;
  @override
  final ProjectCandidateProcurementBudgetLabelEnum? procurementBudgetLabel;
  @override
  final int? procurementTotalCentavos;

  factory _$ProjectCandidate(
          [void Function(ProjectCandidateBuilder)? updates]) =>
      (ProjectCandidateBuilder()..update(updates))._build();

  _$ProjectCandidate._(
      {required this.id,
      required this.estimateId,
      required this.vendorId,
      required this.storeName,
      required this.rank,
      required this.latitude,
      required this.longitude,
      required this.scoreLabel,
      this.vps,
      required this.fms,
      required this.complete,
      required this.fulfillmentPercent,
      required this.missingLines,
      required this.lines,
      this.selectionRequired,
      this.specificationSelections,
      required this.materialsCentavos,
      required this.includedVatCentavos,
      this.deliveryCentavos,
      this.processingFeeCentavos,
      required this.processingFeeStatus,
      this.projectedTotalCentavos,
      required this.budgetLabel,
      required this.distanceMeters,
      required this.distanceBasis,
      this.etaSeconds,
      required this.fulfillmentMethod,
      this.fulfillmentOptions,
      required this.paymentMethod,
      required this.delivery,
      required this.destination,
      required this.expiresAt,
      required this.stale,
      required this.label,
      required this.currentQuotationState,
      this.isFavorite,
      required this.fulfillment,
      this.paymentMethods,
      this.draftGroups,
      this.primaryOrderId,
      this.procurementMaterialsCentavos,
      this.separateDeliveryCentavos,
      this.procurementDeliveryCentavos,
      this.procurementBudgetLabel,
      this.procurementTotalCentavos})
      : super._();
  @override
  ProjectCandidate rebuild(void Function(ProjectCandidateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ProjectCandidateBuilder toBuilder() =>
      ProjectCandidateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ProjectCandidate &&
        id == other.id &&
        estimateId == other.estimateId &&
        vendorId == other.vendorId &&
        storeName == other.storeName &&
        rank == other.rank &&
        latitude == other.latitude &&
        longitude == other.longitude &&
        scoreLabel == other.scoreLabel &&
        vps == other.vps &&
        fms == other.fms &&
        complete == other.complete &&
        fulfillmentPercent == other.fulfillmentPercent &&
        missingLines == other.missingLines &&
        lines == other.lines &&
        selectionRequired == other.selectionRequired &&
        specificationSelections == other.specificationSelections &&
        materialsCentavos == other.materialsCentavos &&
        includedVatCentavos == other.includedVatCentavos &&
        deliveryCentavos == other.deliveryCentavos &&
        processingFeeCentavos == other.processingFeeCentavos &&
        processingFeeStatus == other.processingFeeStatus &&
        projectedTotalCentavos == other.projectedTotalCentavos &&
        budgetLabel == other.budgetLabel &&
        distanceMeters == other.distanceMeters &&
        distanceBasis == other.distanceBasis &&
        etaSeconds == other.etaSeconds &&
        fulfillmentMethod == other.fulfillmentMethod &&
        fulfillmentOptions == other.fulfillmentOptions &&
        paymentMethod == other.paymentMethod &&
        delivery == other.delivery &&
        destination == other.destination &&
        expiresAt == other.expiresAt &&
        stale == other.stale &&
        label == other.label &&
        currentQuotationState == other.currentQuotationState &&
        isFavorite == other.isFavorite &&
        fulfillment == other.fulfillment &&
        paymentMethods == other.paymentMethods &&
        draftGroups == other.draftGroups &&
        primaryOrderId == other.primaryOrderId &&
        procurementMaterialsCentavos == other.procurementMaterialsCentavos &&
        separateDeliveryCentavos == other.separateDeliveryCentavos &&
        procurementDeliveryCentavos == other.procurementDeliveryCentavos &&
        procurementBudgetLabel == other.procurementBudgetLabel &&
        procurementTotalCentavos == other.procurementTotalCentavos;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, estimateId.hashCode);
    _$hash = $jc(_$hash, vendorId.hashCode);
    _$hash = $jc(_$hash, storeName.hashCode);
    _$hash = $jc(_$hash, rank.hashCode);
    _$hash = $jc(_$hash, latitude.hashCode);
    _$hash = $jc(_$hash, longitude.hashCode);
    _$hash = $jc(_$hash, scoreLabel.hashCode);
    _$hash = $jc(_$hash, vps.hashCode);
    _$hash = $jc(_$hash, fms.hashCode);
    _$hash = $jc(_$hash, complete.hashCode);
    _$hash = $jc(_$hash, fulfillmentPercent.hashCode);
    _$hash = $jc(_$hash, missingLines.hashCode);
    _$hash = $jc(_$hash, lines.hashCode);
    _$hash = $jc(_$hash, selectionRequired.hashCode);
    _$hash = $jc(_$hash, specificationSelections.hashCode);
    _$hash = $jc(_$hash, materialsCentavos.hashCode);
    _$hash = $jc(_$hash, includedVatCentavos.hashCode);
    _$hash = $jc(_$hash, deliveryCentavos.hashCode);
    _$hash = $jc(_$hash, processingFeeCentavos.hashCode);
    _$hash = $jc(_$hash, processingFeeStatus.hashCode);
    _$hash = $jc(_$hash, projectedTotalCentavos.hashCode);
    _$hash = $jc(_$hash, budgetLabel.hashCode);
    _$hash = $jc(_$hash, distanceMeters.hashCode);
    _$hash = $jc(_$hash, distanceBasis.hashCode);
    _$hash = $jc(_$hash, etaSeconds.hashCode);
    _$hash = $jc(_$hash, fulfillmentMethod.hashCode);
    _$hash = $jc(_$hash, fulfillmentOptions.hashCode);
    _$hash = $jc(_$hash, paymentMethod.hashCode);
    _$hash = $jc(_$hash, delivery.hashCode);
    _$hash = $jc(_$hash, destination.hashCode);
    _$hash = $jc(_$hash, expiresAt.hashCode);
    _$hash = $jc(_$hash, stale.hashCode);
    _$hash = $jc(_$hash, label.hashCode);
    _$hash = $jc(_$hash, currentQuotationState.hashCode);
    _$hash = $jc(_$hash, isFavorite.hashCode);
    _$hash = $jc(_$hash, fulfillment.hashCode);
    _$hash = $jc(_$hash, paymentMethods.hashCode);
    _$hash = $jc(_$hash, draftGroups.hashCode);
    _$hash = $jc(_$hash, primaryOrderId.hashCode);
    _$hash = $jc(_$hash, procurementMaterialsCentavos.hashCode);
    _$hash = $jc(_$hash, separateDeliveryCentavos.hashCode);
    _$hash = $jc(_$hash, procurementDeliveryCentavos.hashCode);
    _$hash = $jc(_$hash, procurementBudgetLabel.hashCode);
    _$hash = $jc(_$hash, procurementTotalCentavos.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ProjectCandidate')
          ..add('id', id)
          ..add('estimateId', estimateId)
          ..add('vendorId', vendorId)
          ..add('storeName', storeName)
          ..add('rank', rank)
          ..add('latitude', latitude)
          ..add('longitude', longitude)
          ..add('scoreLabel', scoreLabel)
          ..add('vps', vps)
          ..add('fms', fms)
          ..add('complete', complete)
          ..add('fulfillmentPercent', fulfillmentPercent)
          ..add('missingLines', missingLines)
          ..add('lines', lines)
          ..add('selectionRequired', selectionRequired)
          ..add('specificationSelections', specificationSelections)
          ..add('materialsCentavos', materialsCentavos)
          ..add('includedVatCentavos', includedVatCentavos)
          ..add('deliveryCentavos', deliveryCentavos)
          ..add('processingFeeCentavos', processingFeeCentavos)
          ..add('processingFeeStatus', processingFeeStatus)
          ..add('projectedTotalCentavos', projectedTotalCentavos)
          ..add('budgetLabel', budgetLabel)
          ..add('distanceMeters', distanceMeters)
          ..add('distanceBasis', distanceBasis)
          ..add('etaSeconds', etaSeconds)
          ..add('fulfillmentMethod', fulfillmentMethod)
          ..add('fulfillmentOptions', fulfillmentOptions)
          ..add('paymentMethod', paymentMethod)
          ..add('delivery', delivery)
          ..add('destination', destination)
          ..add('expiresAt', expiresAt)
          ..add('stale', stale)
          ..add('label', label)
          ..add('currentQuotationState', currentQuotationState)
          ..add('isFavorite', isFavorite)
          ..add('fulfillment', fulfillment)
          ..add('paymentMethods', paymentMethods)
          ..add('draftGroups', draftGroups)
          ..add('primaryOrderId', primaryOrderId)
          ..add('procurementMaterialsCentavos', procurementMaterialsCentavos)
          ..add('separateDeliveryCentavos', separateDeliveryCentavos)
          ..add('procurementDeliveryCentavos', procurementDeliveryCentavos)
          ..add('procurementBudgetLabel', procurementBudgetLabel)
          ..add('procurementTotalCentavos', procurementTotalCentavos))
        .toString();
  }
}

class ProjectCandidateBuilder
    implements Builder<ProjectCandidate, ProjectCandidateBuilder> {
  _$ProjectCandidate? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _estimateId;
  String? get estimateId => _$this._estimateId;
  set estimateId(String? estimateId) => _$this._estimateId = estimateId;

  String? _vendorId;
  String? get vendorId => _$this._vendorId;
  set vendorId(String? vendorId) => _$this._vendorId = vendorId;

  String? _storeName;
  String? get storeName => _$this._storeName;
  set storeName(String? storeName) => _$this._storeName = storeName;

  int? _rank;
  int? get rank => _$this._rank;
  set rank(int? rank) => _$this._rank = rank;

  num? _latitude;
  num? get latitude => _$this._latitude;
  set latitude(num? latitude) => _$this._latitude = latitude;

  num? _longitude;
  num? get longitude => _$this._longitude;
  set longitude(num? longitude) => _$this._longitude = longitude;

  String? _scoreLabel;
  String? get scoreLabel => _$this._scoreLabel;
  set scoreLabel(String? scoreLabel) => _$this._scoreLabel = scoreLabel;

  String? _vps;
  String? get vps => _$this._vps;
  set vps(String? vps) => _$this._vps = vps;

  MapBuilder<String, JsonObject?>? _fms;
  MapBuilder<String, JsonObject?> get fms =>
      _$this._fms ??= MapBuilder<String, JsonObject?>();
  set fms(MapBuilder<String, JsonObject?>? fms) => _$this._fms = fms;

  bool? _complete;
  bool? get complete => _$this._complete;
  set complete(bool? complete) => _$this._complete = complete;

  String? _fulfillmentPercent;
  String? get fulfillmentPercent => _$this._fulfillmentPercent;
  set fulfillmentPercent(String? fulfillmentPercent) =>
      _$this._fulfillmentPercent = fulfillmentPercent;

  ListBuilder<BuiltMap<String, JsonObject?>>? _missingLines;
  ListBuilder<BuiltMap<String, JsonObject?>> get missingLines =>
      _$this._missingLines ??= ListBuilder<BuiltMap<String, JsonObject?>>();
  set missingLines(ListBuilder<BuiltMap<String, JsonObject?>>? missingLines) =>
      _$this._missingLines = missingLines;

  ListBuilder<BuiltMap<String, JsonObject?>>? _lines;
  ListBuilder<BuiltMap<String, JsonObject?>> get lines =>
      _$this._lines ??= ListBuilder<BuiltMap<String, JsonObject?>>();
  set lines(ListBuilder<BuiltMap<String, JsonObject?>>? lines) =>
      _$this._lines = lines;

  bool? _selectionRequired;
  bool? get selectionRequired => _$this._selectionRequired;
  set selectionRequired(bool? selectionRequired) =>
      _$this._selectionRequired = selectionRequired;

  MapBuilder<String, String>? _specificationSelections;
  MapBuilder<String, String> get specificationSelections =>
      _$this._specificationSelections ??= MapBuilder<String, String>();
  set specificationSelections(
          MapBuilder<String, String>? specificationSelections) =>
      _$this._specificationSelections = specificationSelections;

  int? _materialsCentavos;
  int? get materialsCentavos => _$this._materialsCentavos;
  set materialsCentavos(int? materialsCentavos) =>
      _$this._materialsCentavos = materialsCentavos;

  int? _includedVatCentavos;
  int? get includedVatCentavos => _$this._includedVatCentavos;
  set includedVatCentavos(int? includedVatCentavos) =>
      _$this._includedVatCentavos = includedVatCentavos;

  int? _deliveryCentavos;
  int? get deliveryCentavos => _$this._deliveryCentavos;
  set deliveryCentavos(int? deliveryCentavos) =>
      _$this._deliveryCentavos = deliveryCentavos;

  int? _processingFeeCentavos;
  int? get processingFeeCentavos => _$this._processingFeeCentavos;
  set processingFeeCentavos(int? processingFeeCentavos) =>
      _$this._processingFeeCentavos = processingFeeCentavos;

  String? _processingFeeStatus;
  String? get processingFeeStatus => _$this._processingFeeStatus;
  set processingFeeStatus(String? processingFeeStatus) =>
      _$this._processingFeeStatus = processingFeeStatus;

  int? _projectedTotalCentavos;
  int? get projectedTotalCentavos => _$this._projectedTotalCentavos;
  set projectedTotalCentavos(int? projectedTotalCentavos) =>
      _$this._projectedTotalCentavos = projectedTotalCentavos;

  String? _budgetLabel;
  String? get budgetLabel => _$this._budgetLabel;
  set budgetLabel(String? budgetLabel) => _$this._budgetLabel = budgetLabel;

  int? _distanceMeters;
  int? get distanceMeters => _$this._distanceMeters;
  set distanceMeters(int? distanceMeters) =>
      _$this._distanceMeters = distanceMeters;

  String? _distanceBasis;
  String? get distanceBasis => _$this._distanceBasis;
  set distanceBasis(String? distanceBasis) =>
      _$this._distanceBasis = distanceBasis;

  int? _etaSeconds;
  int? get etaSeconds => _$this._etaSeconds;
  set etaSeconds(int? etaSeconds) => _$this._etaSeconds = etaSeconds;

  String? _fulfillmentMethod;
  String? get fulfillmentMethod => _$this._fulfillmentMethod;
  set fulfillmentMethod(String? fulfillmentMethod) =>
      _$this._fulfillmentMethod = fulfillmentMethod;

  ListBuilder<ProjectCandidateFulfillmentOptionsEnum>? _fulfillmentOptions;
  ListBuilder<ProjectCandidateFulfillmentOptionsEnum> get fulfillmentOptions =>
      _$this._fulfillmentOptions ??=
          ListBuilder<ProjectCandidateFulfillmentOptionsEnum>();
  set fulfillmentOptions(
          ListBuilder<ProjectCandidateFulfillmentOptionsEnum>?
              fulfillmentOptions) =>
      _$this._fulfillmentOptions = fulfillmentOptions;

  String? _paymentMethod;
  String? get paymentMethod => _$this._paymentMethod;
  set paymentMethod(String? paymentMethod) =>
      _$this._paymentMethod = paymentMethod;

  MapBuilder<String, JsonObject?>? _delivery;
  MapBuilder<String, JsonObject?> get delivery =>
      _$this._delivery ??= MapBuilder<String, JsonObject?>();
  set delivery(MapBuilder<String, JsonObject?>? delivery) =>
      _$this._delivery = delivery;

  MapBuilder<String, JsonObject?>? _destination;
  MapBuilder<String, JsonObject?> get destination =>
      _$this._destination ??= MapBuilder<String, JsonObject?>();
  set destination(MapBuilder<String, JsonObject?>? destination) =>
      _$this._destination = destination;

  String? _expiresAt;
  String? get expiresAt => _$this._expiresAt;
  set expiresAt(String? expiresAt) => _$this._expiresAt = expiresAt;

  bool? _stale;
  bool? get stale => _$this._stale;
  set stale(bool? stale) => _$this._stale = stale;

  String? _label;
  String? get label => _$this._label;
  set label(String? label) => _$this._label = label;

  String? _currentQuotationState;
  String? get currentQuotationState => _$this._currentQuotationState;
  set currentQuotationState(String? currentQuotationState) =>
      _$this._currentQuotationState = currentQuotationState;

  bool? _isFavorite;
  bool? get isFavorite => _$this._isFavorite;
  set isFavorite(bool? isFavorite) => _$this._isFavorite = isFavorite;

  ProjectFulfillmentBuilder? _fulfillment;
  ProjectFulfillmentBuilder get fulfillment =>
      _$this._fulfillment ??= ProjectFulfillmentBuilder();
  set fulfillment(ProjectFulfillmentBuilder? fulfillment) =>
      _$this._fulfillment = fulfillment;

  ListBuilder<ProjectPaymentMethod>? _paymentMethods;
  ListBuilder<ProjectPaymentMethod> get paymentMethods =>
      _$this._paymentMethods ??= ListBuilder<ProjectPaymentMethod>();
  set paymentMethods(ListBuilder<ProjectPaymentMethod>? paymentMethods) =>
      _$this._paymentMethods = paymentMethods;

  ListBuilder<ProjectDraftVendorGroup>? _draftGroups;
  ListBuilder<ProjectDraftVendorGroup> get draftGroups =>
      _$this._draftGroups ??= ListBuilder<ProjectDraftVendorGroup>();
  set draftGroups(ListBuilder<ProjectDraftVendorGroup>? draftGroups) =>
      _$this._draftGroups = draftGroups;

  String? _primaryOrderId;
  String? get primaryOrderId => _$this._primaryOrderId;
  set primaryOrderId(String? primaryOrderId) =>
      _$this._primaryOrderId = primaryOrderId;

  int? _procurementMaterialsCentavos;
  int? get procurementMaterialsCentavos => _$this._procurementMaterialsCentavos;
  set procurementMaterialsCentavos(int? procurementMaterialsCentavos) =>
      _$this._procurementMaterialsCentavos = procurementMaterialsCentavos;

  int? _separateDeliveryCentavos;
  int? get separateDeliveryCentavos => _$this._separateDeliveryCentavos;
  set separateDeliveryCentavos(int? separateDeliveryCentavos) =>
      _$this._separateDeliveryCentavos = separateDeliveryCentavos;

  int? _procurementDeliveryCentavos;
  int? get procurementDeliveryCentavos => _$this._procurementDeliveryCentavos;
  set procurementDeliveryCentavos(int? procurementDeliveryCentavos) =>
      _$this._procurementDeliveryCentavos = procurementDeliveryCentavos;

  ProjectCandidateProcurementBudgetLabelEnum? _procurementBudgetLabel;
  ProjectCandidateProcurementBudgetLabelEnum? get procurementBudgetLabel =>
      _$this._procurementBudgetLabel;
  set procurementBudgetLabel(
          ProjectCandidateProcurementBudgetLabelEnum? procurementBudgetLabel) =>
      _$this._procurementBudgetLabel = procurementBudgetLabel;

  int? _procurementTotalCentavos;
  int? get procurementTotalCentavos => _$this._procurementTotalCentavos;
  set procurementTotalCentavos(int? procurementTotalCentavos) =>
      _$this._procurementTotalCentavos = procurementTotalCentavos;

  ProjectCandidateBuilder() {
    ProjectCandidate._defaults(this);
  }

  ProjectCandidateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _estimateId = $v.estimateId;
      _vendorId = $v.vendorId;
      _storeName = $v.storeName;
      _rank = $v.rank;
      _latitude = $v.latitude;
      _longitude = $v.longitude;
      _scoreLabel = $v.scoreLabel;
      _vps = $v.vps;
      _fms = $v.fms.toBuilder();
      _complete = $v.complete;
      _fulfillmentPercent = $v.fulfillmentPercent;
      _missingLines = $v.missingLines.toBuilder();
      _lines = $v.lines.toBuilder();
      _selectionRequired = $v.selectionRequired;
      _specificationSelections = $v.specificationSelections?.toBuilder();
      _materialsCentavos = $v.materialsCentavos;
      _includedVatCentavos = $v.includedVatCentavos;
      _deliveryCentavos = $v.deliveryCentavos;
      _processingFeeCentavos = $v.processingFeeCentavos;
      _processingFeeStatus = $v.processingFeeStatus;
      _projectedTotalCentavos = $v.projectedTotalCentavos;
      _budgetLabel = $v.budgetLabel;
      _distanceMeters = $v.distanceMeters;
      _distanceBasis = $v.distanceBasis;
      _etaSeconds = $v.etaSeconds;
      _fulfillmentMethod = $v.fulfillmentMethod;
      _fulfillmentOptions = $v.fulfillmentOptions?.toBuilder();
      _paymentMethod = $v.paymentMethod;
      _delivery = $v.delivery.toBuilder();
      _destination = $v.destination.toBuilder();
      _expiresAt = $v.expiresAt;
      _stale = $v.stale;
      _label = $v.label;
      _currentQuotationState = $v.currentQuotationState;
      _isFavorite = $v.isFavorite;
      _fulfillment = $v.fulfillment.toBuilder();
      _paymentMethods = $v.paymentMethods?.toBuilder();
      _draftGroups = $v.draftGroups?.toBuilder();
      _primaryOrderId = $v.primaryOrderId;
      _procurementMaterialsCentavos = $v.procurementMaterialsCentavos;
      _separateDeliveryCentavos = $v.separateDeliveryCentavos;
      _procurementDeliveryCentavos = $v.procurementDeliveryCentavos;
      _procurementBudgetLabel = $v.procurementBudgetLabel;
      _procurementTotalCentavos = $v.procurementTotalCentavos;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ProjectCandidate other) {
    _$v = other as _$ProjectCandidate;
  }

  @override
  void update(void Function(ProjectCandidateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ProjectCandidate build() => _build();

  _$ProjectCandidate _build() {
    _$ProjectCandidate _$result;
    try {
      _$result = _$v ??
          _$ProjectCandidate._(
            id: BuiltValueNullFieldError.checkNotNull(
                id, r'ProjectCandidate', 'id'),
            estimateId: BuiltValueNullFieldError.checkNotNull(
                estimateId, r'ProjectCandidate', 'estimateId'),
            vendorId: BuiltValueNullFieldError.checkNotNull(
                vendorId, r'ProjectCandidate', 'vendorId'),
            storeName: BuiltValueNullFieldError.checkNotNull(
                storeName, r'ProjectCandidate', 'storeName'),
            rank: BuiltValueNullFieldError.checkNotNull(
                rank, r'ProjectCandidate', 'rank'),
            latitude: BuiltValueNullFieldError.checkNotNull(
                latitude, r'ProjectCandidate', 'latitude'),
            longitude: BuiltValueNullFieldError.checkNotNull(
                longitude, r'ProjectCandidate', 'longitude'),
            scoreLabel: BuiltValueNullFieldError.checkNotNull(
                scoreLabel, r'ProjectCandidate', 'scoreLabel'),
            vps: vps,
            fms: fms.build(),
            complete: BuiltValueNullFieldError.checkNotNull(
                complete, r'ProjectCandidate', 'complete'),
            fulfillmentPercent: BuiltValueNullFieldError.checkNotNull(
                fulfillmentPercent, r'ProjectCandidate', 'fulfillmentPercent'),
            missingLines: missingLines.build(),
            lines: lines.build(),
            selectionRequired: selectionRequired,
            specificationSelections: _specificationSelections?.build(),
            materialsCentavos: BuiltValueNullFieldError.checkNotNull(
                materialsCentavos, r'ProjectCandidate', 'materialsCentavos'),
            includedVatCentavos: BuiltValueNullFieldError.checkNotNull(
                includedVatCentavos,
                r'ProjectCandidate',
                'includedVatCentavos'),
            deliveryCentavos: deliveryCentavos,
            processingFeeCentavos: processingFeeCentavos,
            processingFeeStatus: BuiltValueNullFieldError.checkNotNull(
                processingFeeStatus,
                r'ProjectCandidate',
                'processingFeeStatus'),
            projectedTotalCentavos: projectedTotalCentavos,
            budgetLabel: BuiltValueNullFieldError.checkNotNull(
                budgetLabel, r'ProjectCandidate', 'budgetLabel'),
            distanceMeters: BuiltValueNullFieldError.checkNotNull(
                distanceMeters, r'ProjectCandidate', 'distanceMeters'),
            distanceBasis: BuiltValueNullFieldError.checkNotNull(
                distanceBasis, r'ProjectCandidate', 'distanceBasis'),
            etaSeconds: etaSeconds,
            fulfillmentMethod: BuiltValueNullFieldError.checkNotNull(
                fulfillmentMethod, r'ProjectCandidate', 'fulfillmentMethod'),
            fulfillmentOptions: _fulfillmentOptions?.build(),
            paymentMethod: BuiltValueNullFieldError.checkNotNull(
                paymentMethod, r'ProjectCandidate', 'paymentMethod'),
            delivery: delivery.build(),
            destination: destination.build(),
            expiresAt: BuiltValueNullFieldError.checkNotNull(
                expiresAt, r'ProjectCandidate', 'expiresAt'),
            stale: BuiltValueNullFieldError.checkNotNull(
                stale, r'ProjectCandidate', 'stale'),
            label: BuiltValueNullFieldError.checkNotNull(
                label, r'ProjectCandidate', 'label'),
            currentQuotationState: BuiltValueNullFieldError.checkNotNull(
                currentQuotationState,
                r'ProjectCandidate',
                'currentQuotationState'),
            isFavorite: isFavorite,
            fulfillment: fulfillment.build(),
            paymentMethods: _paymentMethods?.build(),
            draftGroups: _draftGroups?.build(),
            primaryOrderId: primaryOrderId,
            procurementMaterialsCentavos: procurementMaterialsCentavos,
            separateDeliveryCentavos: separateDeliveryCentavos,
            procurementDeliveryCentavos: procurementDeliveryCentavos,
            procurementBudgetLabel: procurementBudgetLabel,
            procurementTotalCentavos: procurementTotalCentavos,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'fms';
        fms.build();

        _$failedField = 'missingLines';
        missingLines.build();
        _$failedField = 'lines';
        lines.build();

        _$failedField = 'specificationSelections';
        _specificationSelections?.build();

        _$failedField = 'fulfillmentOptions';
        _fulfillmentOptions?.build();

        _$failedField = 'delivery';
        delivery.build();
        _$failedField = 'destination';
        destination.build();

        _$failedField = 'fulfillment';
        fulfillment.build();
        _$failedField = 'paymentMethods';
        _paymentMethods?.build();
        _$failedField = 'draftGroups';
        _draftGroups?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'ProjectCandidate', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
