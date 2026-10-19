// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'work_package_budget_estimate.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const WorkPackageBudgetEstimateDeliveryStatusEnum
    _$workPackageBudgetEstimateDeliveryStatusEnum_NOT_APPLICABLE =
    const WorkPackageBudgetEstimateDeliveryStatusEnum._('NOT_APPLICABLE');
const WorkPackageBudgetEstimateDeliveryStatusEnum
    _$workPackageBudgetEstimateDeliveryStatusEnum_ESTIMATED =
    const WorkPackageBudgetEstimateDeliveryStatusEnum._('ESTIMATED');
const WorkPackageBudgetEstimateDeliveryStatusEnum
    _$workPackageBudgetEstimateDeliveryStatusEnum_REVIEW_REQUIRED =
    const WorkPackageBudgetEstimateDeliveryStatusEnum._('REVIEW_REQUIRED');

WorkPackageBudgetEstimateDeliveryStatusEnum
    _$workPackageBudgetEstimateDeliveryStatusEnumValueOf(String name) {
  switch (name) {
    case 'NOT_APPLICABLE':
      return _$workPackageBudgetEstimateDeliveryStatusEnum_NOT_APPLICABLE;
    case 'ESTIMATED':
      return _$workPackageBudgetEstimateDeliveryStatusEnum_ESTIMATED;
    case 'REVIEW_REQUIRED':
      return _$workPackageBudgetEstimateDeliveryStatusEnum_REVIEW_REQUIRED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<WorkPackageBudgetEstimateDeliveryStatusEnum>
    _$workPackageBudgetEstimateDeliveryStatusEnumValues = BuiltSet<
        WorkPackageBudgetEstimateDeliveryStatusEnum>(const <WorkPackageBudgetEstimateDeliveryStatusEnum>[
  _$workPackageBudgetEstimateDeliveryStatusEnum_NOT_APPLICABLE,
  _$workPackageBudgetEstimateDeliveryStatusEnum_ESTIMATED,
  _$workPackageBudgetEstimateDeliveryStatusEnum_REVIEW_REQUIRED,
]);

const WorkPackageBudgetEstimateFulfillmentMethodEnum
    _$workPackageBudgetEstimateFulfillmentMethodEnum_DELIVERY =
    const WorkPackageBudgetEstimateFulfillmentMethodEnum._('DELIVERY');
const WorkPackageBudgetEstimateFulfillmentMethodEnum
    _$workPackageBudgetEstimateFulfillmentMethodEnum_PICKUP =
    const WorkPackageBudgetEstimateFulfillmentMethodEnum._('PICKUP');

WorkPackageBudgetEstimateFulfillmentMethodEnum
    _$workPackageBudgetEstimateFulfillmentMethodEnumValueOf(String name) {
  switch (name) {
    case 'DELIVERY':
      return _$workPackageBudgetEstimateFulfillmentMethodEnum_DELIVERY;
    case 'PICKUP':
      return _$workPackageBudgetEstimateFulfillmentMethodEnum_PICKUP;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<WorkPackageBudgetEstimateFulfillmentMethodEnum>
    _$workPackageBudgetEstimateFulfillmentMethodEnumValues = BuiltSet<
        WorkPackageBudgetEstimateFulfillmentMethodEnum>(const <WorkPackageBudgetEstimateFulfillmentMethodEnum>[
  _$workPackageBudgetEstimateFulfillmentMethodEnum_DELIVERY,
  _$workPackageBudgetEstimateFulfillmentMethodEnum_PICKUP,
]);

const WorkPackageBudgetEstimateBasisEnum
    _$workPackageBudgetEstimateBasisEnum_AVERAGE_OF_VENDOR_LOWEST_ELIGIBLE_PRICE =
    const WorkPackageBudgetEstimateBasisEnum._(
        'AVERAGE_OF_VENDOR_LOWEST_ELIGIBLE_PRICE');

WorkPackageBudgetEstimateBasisEnum _$workPackageBudgetEstimateBasisEnumValueOf(
    String name) {
  switch (name) {
    case 'AVERAGE_OF_VENDOR_LOWEST_ELIGIBLE_PRICE':
      return _$workPackageBudgetEstimateBasisEnum_AVERAGE_OF_VENDOR_LOWEST_ELIGIBLE_PRICE;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<WorkPackageBudgetEstimateBasisEnum>
    _$workPackageBudgetEstimateBasisEnumValues = BuiltSet<
        WorkPackageBudgetEstimateBasisEnum>(const <WorkPackageBudgetEstimateBasisEnum>[
  _$workPackageBudgetEstimateBasisEnum_AVERAGE_OF_VENDOR_LOWEST_ELIGIBLE_PRICE,
]);

Serializer<WorkPackageBudgetEstimateDeliveryStatusEnum>
    _$workPackageBudgetEstimateDeliveryStatusEnumSerializer =
    _$WorkPackageBudgetEstimateDeliveryStatusEnumSerializer();
Serializer<WorkPackageBudgetEstimateFulfillmentMethodEnum>
    _$workPackageBudgetEstimateFulfillmentMethodEnumSerializer =
    _$WorkPackageBudgetEstimateFulfillmentMethodEnumSerializer();
Serializer<WorkPackageBudgetEstimateBasisEnum>
    _$workPackageBudgetEstimateBasisEnumSerializer =
    _$WorkPackageBudgetEstimateBasisEnumSerializer();

class _$WorkPackageBudgetEstimateDeliveryStatusEnumSerializer
    implements
        PrimitiveSerializer<WorkPackageBudgetEstimateDeliveryStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'NOT_APPLICABLE': 'NOT_APPLICABLE',
    'ESTIMATED': 'ESTIMATED',
    'REVIEW_REQUIRED': 'REVIEW_REQUIRED',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'NOT_APPLICABLE': 'NOT_APPLICABLE',
    'ESTIMATED': 'ESTIMATED',
    'REVIEW_REQUIRED': 'REVIEW_REQUIRED',
  };

  @override
  final Iterable<Type> types = const <Type>[
    WorkPackageBudgetEstimateDeliveryStatusEnum
  ];
  @override
  final String wireName = 'WorkPackageBudgetEstimateDeliveryStatusEnum';

  @override
  Object serialize(Serializers serializers,
          WorkPackageBudgetEstimateDeliveryStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  WorkPackageBudgetEstimateDeliveryStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      WorkPackageBudgetEstimateDeliveryStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$WorkPackageBudgetEstimateFulfillmentMethodEnumSerializer
    implements
        PrimitiveSerializer<WorkPackageBudgetEstimateFulfillmentMethodEnum> {
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
    WorkPackageBudgetEstimateFulfillmentMethodEnum
  ];
  @override
  final String wireName = 'WorkPackageBudgetEstimateFulfillmentMethodEnum';

  @override
  Object serialize(Serializers serializers,
          WorkPackageBudgetEstimateFulfillmentMethodEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  WorkPackageBudgetEstimateFulfillmentMethodEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      WorkPackageBudgetEstimateFulfillmentMethodEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$WorkPackageBudgetEstimateBasisEnumSerializer
    implements PrimitiveSerializer<WorkPackageBudgetEstimateBasisEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'AVERAGE_OF_VENDOR_LOWEST_ELIGIBLE_PRICE':
        'AVERAGE_OF_VENDOR_LOWEST_ELIGIBLE_PRICE',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'AVERAGE_OF_VENDOR_LOWEST_ELIGIBLE_PRICE':
        'AVERAGE_OF_VENDOR_LOWEST_ELIGIBLE_PRICE',
  };

  @override
  final Iterable<Type> types = const <Type>[WorkPackageBudgetEstimateBasisEnum];
  @override
  final String wireName = 'WorkPackageBudgetEstimateBasisEnum';

  @override
  Object serialize(
          Serializers serializers, WorkPackageBudgetEstimateBasisEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  WorkPackageBudgetEstimateBasisEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      WorkPackageBudgetEstimateBasisEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$WorkPackageBudgetEstimate extends WorkPackageBudgetEstimate {
  @override
  final int? deliveryCentavos;
  @override
  final int? estimatedTotalCentavos;
  @override
  final WorkPackageBudgetEstimateDeliveryStatusEnum? deliveryStatus;
  @override
  final BuiltList<String>? deliveryIssues;
  @override
  final WorkPackageBudgetEstimateFulfillmentMethodEnum? fulfillmentMethod;
  @override
  final BuiltList<WorkPackageBudgetEstimateLine> lines;
  @override
  final int materialsTotalCentavos;
  @override
  final int pricedLineCount;
  @override
  final int unpricedLineCount;
  @override
  final int radiusKm;
  @override
  final WorkPackageBudgetEstimateBasisEnum basis;
  @override
  final BuiltList<String> excludes;
  @override
  final String computedAt;

  factory _$WorkPackageBudgetEstimate(
          [void Function(WorkPackageBudgetEstimateBuilder)? updates]) =>
      (WorkPackageBudgetEstimateBuilder()..update(updates))._build();

  _$WorkPackageBudgetEstimate._(
      {this.deliveryCentavos,
      this.estimatedTotalCentavos,
      this.deliveryStatus,
      this.deliveryIssues,
      this.fulfillmentMethod,
      required this.lines,
      required this.materialsTotalCentavos,
      required this.pricedLineCount,
      required this.unpricedLineCount,
      required this.radiusKm,
      required this.basis,
      required this.excludes,
      required this.computedAt})
      : super._();
  @override
  WorkPackageBudgetEstimate rebuild(
          void Function(WorkPackageBudgetEstimateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  WorkPackageBudgetEstimateBuilder toBuilder() =>
      WorkPackageBudgetEstimateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is WorkPackageBudgetEstimate &&
        deliveryCentavos == other.deliveryCentavos &&
        estimatedTotalCentavos == other.estimatedTotalCentavos &&
        deliveryStatus == other.deliveryStatus &&
        deliveryIssues == other.deliveryIssues &&
        fulfillmentMethod == other.fulfillmentMethod &&
        lines == other.lines &&
        materialsTotalCentavos == other.materialsTotalCentavos &&
        pricedLineCount == other.pricedLineCount &&
        unpricedLineCount == other.unpricedLineCount &&
        radiusKm == other.radiusKm &&
        basis == other.basis &&
        excludes == other.excludes &&
        computedAt == other.computedAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, deliveryCentavos.hashCode);
    _$hash = $jc(_$hash, estimatedTotalCentavos.hashCode);
    _$hash = $jc(_$hash, deliveryStatus.hashCode);
    _$hash = $jc(_$hash, deliveryIssues.hashCode);
    _$hash = $jc(_$hash, fulfillmentMethod.hashCode);
    _$hash = $jc(_$hash, lines.hashCode);
    _$hash = $jc(_$hash, materialsTotalCentavos.hashCode);
    _$hash = $jc(_$hash, pricedLineCount.hashCode);
    _$hash = $jc(_$hash, unpricedLineCount.hashCode);
    _$hash = $jc(_$hash, radiusKm.hashCode);
    _$hash = $jc(_$hash, basis.hashCode);
    _$hash = $jc(_$hash, excludes.hashCode);
    _$hash = $jc(_$hash, computedAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'WorkPackageBudgetEstimate')
          ..add('deliveryCentavos', deliveryCentavos)
          ..add('estimatedTotalCentavos', estimatedTotalCentavos)
          ..add('deliveryStatus', deliveryStatus)
          ..add('deliveryIssues', deliveryIssues)
          ..add('fulfillmentMethod', fulfillmentMethod)
          ..add('lines', lines)
          ..add('materialsTotalCentavos', materialsTotalCentavos)
          ..add('pricedLineCount', pricedLineCount)
          ..add('unpricedLineCount', unpricedLineCount)
          ..add('radiusKm', radiusKm)
          ..add('basis', basis)
          ..add('excludes', excludes)
          ..add('computedAt', computedAt))
        .toString();
  }
}

class WorkPackageBudgetEstimateBuilder
    implements
        Builder<WorkPackageBudgetEstimate, WorkPackageBudgetEstimateBuilder> {
  _$WorkPackageBudgetEstimate? _$v;

  int? _deliveryCentavos;
  int? get deliveryCentavos => _$this._deliveryCentavos;
  set deliveryCentavos(int? deliveryCentavos) =>
      _$this._deliveryCentavos = deliveryCentavos;

  int? _estimatedTotalCentavos;
  int? get estimatedTotalCentavos => _$this._estimatedTotalCentavos;
  set estimatedTotalCentavos(int? estimatedTotalCentavos) =>
      _$this._estimatedTotalCentavos = estimatedTotalCentavos;

  WorkPackageBudgetEstimateDeliveryStatusEnum? _deliveryStatus;
  WorkPackageBudgetEstimateDeliveryStatusEnum? get deliveryStatus =>
      _$this._deliveryStatus;
  set deliveryStatus(
          WorkPackageBudgetEstimateDeliveryStatusEnum? deliveryStatus) =>
      _$this._deliveryStatus = deliveryStatus;

  ListBuilder<String>? _deliveryIssues;
  ListBuilder<String> get deliveryIssues =>
      _$this._deliveryIssues ??= ListBuilder<String>();
  set deliveryIssues(ListBuilder<String>? deliveryIssues) =>
      _$this._deliveryIssues = deliveryIssues;

  WorkPackageBudgetEstimateFulfillmentMethodEnum? _fulfillmentMethod;
  WorkPackageBudgetEstimateFulfillmentMethodEnum? get fulfillmentMethod =>
      _$this._fulfillmentMethod;
  set fulfillmentMethod(
          WorkPackageBudgetEstimateFulfillmentMethodEnum? fulfillmentMethod) =>
      _$this._fulfillmentMethod = fulfillmentMethod;

  ListBuilder<WorkPackageBudgetEstimateLine>? _lines;
  ListBuilder<WorkPackageBudgetEstimateLine> get lines =>
      _$this._lines ??= ListBuilder<WorkPackageBudgetEstimateLine>();
  set lines(ListBuilder<WorkPackageBudgetEstimateLine>? lines) =>
      _$this._lines = lines;

  int? _materialsTotalCentavos;
  int? get materialsTotalCentavos => _$this._materialsTotalCentavos;
  set materialsTotalCentavos(int? materialsTotalCentavos) =>
      _$this._materialsTotalCentavos = materialsTotalCentavos;

  int? _pricedLineCount;
  int? get pricedLineCount => _$this._pricedLineCount;
  set pricedLineCount(int? pricedLineCount) =>
      _$this._pricedLineCount = pricedLineCount;

  int? _unpricedLineCount;
  int? get unpricedLineCount => _$this._unpricedLineCount;
  set unpricedLineCount(int? unpricedLineCount) =>
      _$this._unpricedLineCount = unpricedLineCount;

  int? _radiusKm;
  int? get radiusKm => _$this._radiusKm;
  set radiusKm(int? radiusKm) => _$this._radiusKm = radiusKm;

  WorkPackageBudgetEstimateBasisEnum? _basis;
  WorkPackageBudgetEstimateBasisEnum? get basis => _$this._basis;
  set basis(WorkPackageBudgetEstimateBasisEnum? basis) => _$this._basis = basis;

  ListBuilder<String>? _excludes;
  ListBuilder<String> get excludes =>
      _$this._excludes ??= ListBuilder<String>();
  set excludes(ListBuilder<String>? excludes) => _$this._excludes = excludes;

  String? _computedAt;
  String? get computedAt => _$this._computedAt;
  set computedAt(String? computedAt) => _$this._computedAt = computedAt;

  WorkPackageBudgetEstimateBuilder() {
    WorkPackageBudgetEstimate._defaults(this);
  }

  WorkPackageBudgetEstimateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _deliveryCentavos = $v.deliveryCentavos;
      _estimatedTotalCentavos = $v.estimatedTotalCentavos;
      _deliveryStatus = $v.deliveryStatus;
      _deliveryIssues = $v.deliveryIssues?.toBuilder();
      _fulfillmentMethod = $v.fulfillmentMethod;
      _lines = $v.lines.toBuilder();
      _materialsTotalCentavos = $v.materialsTotalCentavos;
      _pricedLineCount = $v.pricedLineCount;
      _unpricedLineCount = $v.unpricedLineCount;
      _radiusKm = $v.radiusKm;
      _basis = $v.basis;
      _excludes = $v.excludes.toBuilder();
      _computedAt = $v.computedAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(WorkPackageBudgetEstimate other) {
    _$v = other as _$WorkPackageBudgetEstimate;
  }

  @override
  void update(void Function(WorkPackageBudgetEstimateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  WorkPackageBudgetEstimate build() => _build();

  _$WorkPackageBudgetEstimate _build() {
    _$WorkPackageBudgetEstimate _$result;
    try {
      _$result = _$v ??
          _$WorkPackageBudgetEstimate._(
            deliveryCentavos: deliveryCentavos,
            estimatedTotalCentavos: estimatedTotalCentavos,
            deliveryStatus: deliveryStatus,
            deliveryIssues: _deliveryIssues?.build(),
            fulfillmentMethod: fulfillmentMethod,
            lines: lines.build(),
            materialsTotalCentavos: BuiltValueNullFieldError.checkNotNull(
                materialsTotalCentavos,
                r'WorkPackageBudgetEstimate',
                'materialsTotalCentavos'),
            pricedLineCount: BuiltValueNullFieldError.checkNotNull(
                pricedLineCount,
                r'WorkPackageBudgetEstimate',
                'pricedLineCount'),
            unpricedLineCount: BuiltValueNullFieldError.checkNotNull(
                unpricedLineCount,
                r'WorkPackageBudgetEstimate',
                'unpricedLineCount'),
            radiusKm: BuiltValueNullFieldError.checkNotNull(
                radiusKm, r'WorkPackageBudgetEstimate', 'radiusKm'),
            basis: BuiltValueNullFieldError.checkNotNull(
                basis, r'WorkPackageBudgetEstimate', 'basis'),
            excludes: excludes.build(),
            computedAt: BuiltValueNullFieldError.checkNotNull(
                computedAt, r'WorkPackageBudgetEstimate', 'computedAt'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'deliveryIssues';
        _deliveryIssues?.build();

        _$failedField = 'lines';
        lines.build();

        _$failedField = 'excludes';
        excludes.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'WorkPackageBudgetEstimate', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
