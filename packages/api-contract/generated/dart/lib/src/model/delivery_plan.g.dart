// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delivery_plan.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const DeliveryPlanAdvisoryEnum _$deliveryPlanAdvisoryEnum_true_ =
    const DeliveryPlanAdvisoryEnum._('true_');

DeliveryPlanAdvisoryEnum _$deliveryPlanAdvisoryEnumValueOf(String name) {
  switch (name) {
    case 'true_':
      return _$deliveryPlanAdvisoryEnum_true_;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<DeliveryPlanAdvisoryEnum> _$deliveryPlanAdvisoryEnumValues =
    BuiltSet<DeliveryPlanAdvisoryEnum>(const <DeliveryPlanAdvisoryEnum>[
  _$deliveryPlanAdvisoryEnum_true_,
]);

const DeliveryPlanStatusEnum _$deliveryPlanStatusEnum_CANDIDATES_AVAILABLE =
    const DeliveryPlanStatusEnum._('CANDIDATES_AVAILABLE');
const DeliveryPlanStatusEnum _$deliveryPlanStatusEnum_MANUAL_REVIEW_REQUIRED =
    const DeliveryPlanStatusEnum._('MANUAL_REVIEW_REQUIRED');
const DeliveryPlanStatusEnum _$deliveryPlanStatusEnum_NO_ELIGIBLE_VEHICLE =
    const DeliveryPlanStatusEnum._('NO_ELIGIBLE_VEHICLE');
const DeliveryPlanStatusEnum _$deliveryPlanStatusEnum_ACCESS_NOT_CONFIRMED =
    const DeliveryPlanStatusEnum._('ACCESS_NOT_CONFIRMED');
const DeliveryPlanStatusEnum _$deliveryPlanStatusEnum_ROUTE_REQUIRED =
    const DeliveryPlanStatusEnum._('ROUTE_REQUIRED');

DeliveryPlanStatusEnum _$deliveryPlanStatusEnumValueOf(String name) {
  switch (name) {
    case 'CANDIDATES_AVAILABLE':
      return _$deliveryPlanStatusEnum_CANDIDATES_AVAILABLE;
    case 'MANUAL_REVIEW_REQUIRED':
      return _$deliveryPlanStatusEnum_MANUAL_REVIEW_REQUIRED;
    case 'NO_ELIGIBLE_VEHICLE':
      return _$deliveryPlanStatusEnum_NO_ELIGIBLE_VEHICLE;
    case 'ACCESS_NOT_CONFIRMED':
      return _$deliveryPlanStatusEnum_ACCESS_NOT_CONFIRMED;
    case 'ROUTE_REQUIRED':
      return _$deliveryPlanStatusEnum_ROUTE_REQUIRED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<DeliveryPlanStatusEnum> _$deliveryPlanStatusEnumValues =
    BuiltSet<DeliveryPlanStatusEnum>(const <DeliveryPlanStatusEnum>[
  _$deliveryPlanStatusEnum_CANDIDATES_AVAILABLE,
  _$deliveryPlanStatusEnum_MANUAL_REVIEW_REQUIRED,
  _$deliveryPlanStatusEnum_NO_ELIGIBLE_VEHICLE,
  _$deliveryPlanStatusEnum_ACCESS_NOT_CONFIRMED,
  _$deliveryPlanStatusEnum_ROUTE_REQUIRED,
]);

Serializer<DeliveryPlanAdvisoryEnum> _$deliveryPlanAdvisoryEnumSerializer =
    _$DeliveryPlanAdvisoryEnumSerializer();
Serializer<DeliveryPlanStatusEnum> _$deliveryPlanStatusEnumSerializer =
    _$DeliveryPlanStatusEnumSerializer();

class _$DeliveryPlanAdvisoryEnumSerializer
    implements PrimitiveSerializer<DeliveryPlanAdvisoryEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'true_': 'true',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'true': 'true_',
  };

  @override
  final Iterable<Type> types = const <Type>[DeliveryPlanAdvisoryEnum];
  @override
  final String wireName = 'DeliveryPlanAdvisoryEnum';

  @override
  Object serialize(Serializers serializers, DeliveryPlanAdvisoryEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  DeliveryPlanAdvisoryEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      DeliveryPlanAdvisoryEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$DeliveryPlanStatusEnumSerializer
    implements PrimitiveSerializer<DeliveryPlanStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'CANDIDATES_AVAILABLE': 'CANDIDATES_AVAILABLE',
    'MANUAL_REVIEW_REQUIRED': 'MANUAL_REVIEW_REQUIRED',
    'NO_ELIGIBLE_VEHICLE': 'NO_ELIGIBLE_VEHICLE',
    'ACCESS_NOT_CONFIRMED': 'ACCESS_NOT_CONFIRMED',
    'ROUTE_REQUIRED': 'ROUTE_REQUIRED',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'CANDIDATES_AVAILABLE': 'CANDIDATES_AVAILABLE',
    'MANUAL_REVIEW_REQUIRED': 'MANUAL_REVIEW_REQUIRED',
    'NO_ELIGIBLE_VEHICLE': 'NO_ELIGIBLE_VEHICLE',
    'ACCESS_NOT_CONFIRMED': 'ACCESS_NOT_CONFIRMED',
    'ROUTE_REQUIRED': 'ROUTE_REQUIRED',
  };

  @override
  final Iterable<Type> types = const <Type>[DeliveryPlanStatusEnum];
  @override
  final String wireName = 'DeliveryPlanStatusEnum';

  @override
  Object serialize(Serializers serializers, DeliveryPlanStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  DeliveryPlanStatusEnum deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      DeliveryPlanStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$DeliveryPlan extends DeliveryPlan {
  @override
  final DeliveryPlanAdvisoryEnum advisory;
  @override
  final DeliveryPlanStatusEnum status;
  @override
  final String reason;
  @override
  final DeliveryPlanRoute route;
  @override
  final DeliveryPlanEndpoint endpoint;
  @override
  final BuiltList<DeliveryPlanGroup> groups;
  @override
  final BuiltList<DeliveryPlanVehicle> eligibleVehicles;
  @override
  final DeliveryPlanFormula feeFormula;
  @override
  final String notice;

  factory _$DeliveryPlan([void Function(DeliveryPlanBuilder)? updates]) =>
      (DeliveryPlanBuilder()..update(updates))._build();

  _$DeliveryPlan._(
      {required this.advisory,
      required this.status,
      required this.reason,
      required this.route,
      required this.endpoint,
      required this.groups,
      required this.eligibleVehicles,
      required this.feeFormula,
      required this.notice})
      : super._();
  @override
  DeliveryPlan rebuild(void Function(DeliveryPlanBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DeliveryPlanBuilder toBuilder() => DeliveryPlanBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DeliveryPlan &&
        advisory == other.advisory &&
        status == other.status &&
        reason == other.reason &&
        route == other.route &&
        endpoint == other.endpoint &&
        groups == other.groups &&
        eligibleVehicles == other.eligibleVehicles &&
        feeFormula == other.feeFormula &&
        notice == other.notice;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, advisory.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jc(_$hash, route.hashCode);
    _$hash = $jc(_$hash, endpoint.hashCode);
    _$hash = $jc(_$hash, groups.hashCode);
    _$hash = $jc(_$hash, eligibleVehicles.hashCode);
    _$hash = $jc(_$hash, feeFormula.hashCode);
    _$hash = $jc(_$hash, notice.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'DeliveryPlan')
          ..add('advisory', advisory)
          ..add('status', status)
          ..add('reason', reason)
          ..add('route', route)
          ..add('endpoint', endpoint)
          ..add('groups', groups)
          ..add('eligibleVehicles', eligibleVehicles)
          ..add('feeFormula', feeFormula)
          ..add('notice', notice))
        .toString();
  }
}

class DeliveryPlanBuilder
    implements Builder<DeliveryPlan, DeliveryPlanBuilder> {
  _$DeliveryPlan? _$v;

  DeliveryPlanAdvisoryEnum? _advisory;
  DeliveryPlanAdvisoryEnum? get advisory => _$this._advisory;
  set advisory(DeliveryPlanAdvisoryEnum? advisory) =>
      _$this._advisory = advisory;

  DeliveryPlanStatusEnum? _status;
  DeliveryPlanStatusEnum? get status => _$this._status;
  set status(DeliveryPlanStatusEnum? status) => _$this._status = status;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  DeliveryPlanRouteBuilder? _route;
  DeliveryPlanRouteBuilder get route =>
      _$this._route ??= DeliveryPlanRouteBuilder();
  set route(DeliveryPlanRouteBuilder? route) => _$this._route = route;

  DeliveryPlanEndpointBuilder? _endpoint;
  DeliveryPlanEndpointBuilder get endpoint =>
      _$this._endpoint ??= DeliveryPlanEndpointBuilder();
  set endpoint(DeliveryPlanEndpointBuilder? endpoint) =>
      _$this._endpoint = endpoint;

  ListBuilder<DeliveryPlanGroup>? _groups;
  ListBuilder<DeliveryPlanGroup> get groups =>
      _$this._groups ??= ListBuilder<DeliveryPlanGroup>();
  set groups(ListBuilder<DeliveryPlanGroup>? groups) => _$this._groups = groups;

  ListBuilder<DeliveryPlanVehicle>? _eligibleVehicles;
  ListBuilder<DeliveryPlanVehicle> get eligibleVehicles =>
      _$this._eligibleVehicles ??= ListBuilder<DeliveryPlanVehicle>();
  set eligibleVehicles(ListBuilder<DeliveryPlanVehicle>? eligibleVehicles) =>
      _$this._eligibleVehicles = eligibleVehicles;

  DeliveryPlanFormulaBuilder? _feeFormula;
  DeliveryPlanFormulaBuilder get feeFormula =>
      _$this._feeFormula ??= DeliveryPlanFormulaBuilder();
  set feeFormula(DeliveryPlanFormulaBuilder? feeFormula) =>
      _$this._feeFormula = feeFormula;

  String? _notice;
  String? get notice => _$this._notice;
  set notice(String? notice) => _$this._notice = notice;

  DeliveryPlanBuilder() {
    DeliveryPlan._defaults(this);
  }

  DeliveryPlanBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _advisory = $v.advisory;
      _status = $v.status;
      _reason = $v.reason;
      _route = $v.route.toBuilder();
      _endpoint = $v.endpoint.toBuilder();
      _groups = $v.groups.toBuilder();
      _eligibleVehicles = $v.eligibleVehicles.toBuilder();
      _feeFormula = $v.feeFormula.toBuilder();
      _notice = $v.notice;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DeliveryPlan other) {
    _$v = other as _$DeliveryPlan;
  }

  @override
  void update(void Function(DeliveryPlanBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DeliveryPlan build() => _build();

  _$DeliveryPlan _build() {
    _$DeliveryPlan _$result;
    try {
      _$result = _$v ??
          _$DeliveryPlan._(
            advisory: BuiltValueNullFieldError.checkNotNull(
                advisory, r'DeliveryPlan', 'advisory'),
            status: BuiltValueNullFieldError.checkNotNull(
                status, r'DeliveryPlan', 'status'),
            reason: BuiltValueNullFieldError.checkNotNull(
                reason, r'DeliveryPlan', 'reason'),
            route: route.build(),
            endpoint: endpoint.build(),
            groups: groups.build(),
            eligibleVehicles: eligibleVehicles.build(),
            feeFormula: feeFormula.build(),
            notice: BuiltValueNullFieldError.checkNotNull(
                notice, r'DeliveryPlan', 'notice'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'route';
        route.build();
        _$failedField = 'endpoint';
        endpoint.build();
        _$failedField = 'groups';
        groups.build();
        _$failedField = 'eligibleVehicles';
        eligibleVehicles.build();
        _$failedField = 'feeFormula';
        feeFormula.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'DeliveryPlan', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
