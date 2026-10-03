// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delivery_preview.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const DeliveryPreviewStatusEnum _$deliveryPreviewStatusEnum_NOT_APPLICABLE =
    const DeliveryPreviewStatusEnum._('NOT_APPLICABLE');
const DeliveryPreviewStatusEnum _$deliveryPreviewStatusEnum_ACTION_REQUIRED =
    const DeliveryPreviewStatusEnum._('ACTION_REQUIRED');
const DeliveryPreviewStatusEnum _$deliveryPreviewStatusEnum_BLOCKED =
    const DeliveryPreviewStatusEnum._('BLOCKED');
const DeliveryPreviewStatusEnum _$deliveryPreviewStatusEnum_MANUAL_REVIEW =
    const DeliveryPreviewStatusEnum._('MANUAL_REVIEW');
const DeliveryPreviewStatusEnum _$deliveryPreviewStatusEnum_ADVISORY_ESTIMATE =
    const DeliveryPreviewStatusEnum._('ADVISORY_ESTIMATE');

DeliveryPreviewStatusEnum _$deliveryPreviewStatusEnumValueOf(String name) {
  switch (name) {
    case 'NOT_APPLICABLE':
      return _$deliveryPreviewStatusEnum_NOT_APPLICABLE;
    case 'ACTION_REQUIRED':
      return _$deliveryPreviewStatusEnum_ACTION_REQUIRED;
    case 'BLOCKED':
      return _$deliveryPreviewStatusEnum_BLOCKED;
    case 'MANUAL_REVIEW':
      return _$deliveryPreviewStatusEnum_MANUAL_REVIEW;
    case 'ADVISORY_ESTIMATE':
      return _$deliveryPreviewStatusEnum_ADVISORY_ESTIMATE;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<DeliveryPreviewStatusEnum> _$deliveryPreviewStatusEnumValues =
    BuiltSet<DeliveryPreviewStatusEnum>(const <DeliveryPreviewStatusEnum>[
  _$deliveryPreviewStatusEnum_NOT_APPLICABLE,
  _$deliveryPreviewStatusEnum_ACTION_REQUIRED,
  _$deliveryPreviewStatusEnum_BLOCKED,
  _$deliveryPreviewStatusEnum_MANUAL_REVIEW,
  _$deliveryPreviewStatusEnum_ADVISORY_ESTIMATE,
]);

const DeliveryPreviewEndpointEnum
    _$deliveryPreviewEndpointEnum_INTENDED_LOCATION =
    const DeliveryPreviewEndpointEnum._('INTENDED_LOCATION');
const DeliveryPreviewEndpointEnum
    _$deliveryPreviewEndpointEnum_ALTERNATE_DROP_OFF =
    const DeliveryPreviewEndpointEnum._('ALTERNATE_DROP_OFF');

DeliveryPreviewEndpointEnum _$deliveryPreviewEndpointEnumValueOf(String name) {
  switch (name) {
    case 'INTENDED_LOCATION':
      return _$deliveryPreviewEndpointEnum_INTENDED_LOCATION;
    case 'ALTERNATE_DROP_OFF':
      return _$deliveryPreviewEndpointEnum_ALTERNATE_DROP_OFF;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<DeliveryPreviewEndpointEnum>
    _$deliveryPreviewEndpointEnumValues =
    BuiltSet<DeliveryPreviewEndpointEnum>(const <DeliveryPreviewEndpointEnum>[
  _$deliveryPreviewEndpointEnum_INTENDED_LOCATION,
  _$deliveryPreviewEndpointEnum_ALTERNATE_DROP_OFF,
]);

Serializer<DeliveryPreviewStatusEnum> _$deliveryPreviewStatusEnumSerializer =
    _$DeliveryPreviewStatusEnumSerializer();
Serializer<DeliveryPreviewEndpointEnum>
    _$deliveryPreviewEndpointEnumSerializer =
    _$DeliveryPreviewEndpointEnumSerializer();

class _$DeliveryPreviewStatusEnumSerializer
    implements PrimitiveSerializer<DeliveryPreviewStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'NOT_APPLICABLE': 'NOT_APPLICABLE',
    'ACTION_REQUIRED': 'ACTION_REQUIRED',
    'BLOCKED': 'BLOCKED',
    'MANUAL_REVIEW': 'MANUAL_REVIEW',
    'ADVISORY_ESTIMATE': 'ADVISORY_ESTIMATE',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'NOT_APPLICABLE': 'NOT_APPLICABLE',
    'ACTION_REQUIRED': 'ACTION_REQUIRED',
    'BLOCKED': 'BLOCKED',
    'MANUAL_REVIEW': 'MANUAL_REVIEW',
    'ADVISORY_ESTIMATE': 'ADVISORY_ESTIMATE',
  };

  @override
  final Iterable<Type> types = const <Type>[DeliveryPreviewStatusEnum];
  @override
  final String wireName = 'DeliveryPreviewStatusEnum';

  @override
  Object serialize(Serializers serializers, DeliveryPreviewStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  DeliveryPreviewStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      DeliveryPreviewStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$DeliveryPreviewEndpointEnumSerializer
    implements PrimitiveSerializer<DeliveryPreviewEndpointEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'INTENDED_LOCATION': 'INTENDED_LOCATION',
    'ALTERNATE_DROP_OFF': 'ALTERNATE_DROP_OFF',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'INTENDED_LOCATION': 'INTENDED_LOCATION',
    'ALTERNATE_DROP_OFF': 'ALTERNATE_DROP_OFF',
  };

  @override
  final Iterable<Type> types = const <Type>[DeliveryPreviewEndpointEnum];
  @override
  final String wireName = 'DeliveryPreviewEndpointEnum';

  @override
  Object serialize(Serializers serializers, DeliveryPreviewEndpointEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  DeliveryPreviewEndpointEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      DeliveryPreviewEndpointEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$DeliveryPreview extends DeliveryPreview {
  @override
  final DeliveryPreviewStatusEnum status;
  @override
  final BuiltList<CartIssue> issues;
  @override
  final DeliveryPreviewEndpointEnum? endpoint;
  @override
  final DeliveryRoute? route;
  @override
  final int? straightLineMeters;
  @override
  final int? coverageKm;
  @override
  final DeliveryEstimate? estimate;
  @override
  final BuiltList<String> manualReviewReasons;
  @override
  final BuiltMap<String, JsonObject?>? confirmedOffer;
  @override
  final String calculationVersion;
  @override
  final String? notice;

  factory _$DeliveryPreview([void Function(DeliveryPreviewBuilder)? updates]) =>
      (DeliveryPreviewBuilder()..update(updates))._build();

  _$DeliveryPreview._(
      {required this.status,
      required this.issues,
      this.endpoint,
      this.route,
      this.straightLineMeters,
      this.coverageKm,
      this.estimate,
      required this.manualReviewReasons,
      this.confirmedOffer,
      required this.calculationVersion,
      this.notice})
      : super._();
  @override
  DeliveryPreview rebuild(void Function(DeliveryPreviewBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DeliveryPreviewBuilder toBuilder() => DeliveryPreviewBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DeliveryPreview &&
        status == other.status &&
        issues == other.issues &&
        endpoint == other.endpoint &&
        route == other.route &&
        straightLineMeters == other.straightLineMeters &&
        coverageKm == other.coverageKm &&
        estimate == other.estimate &&
        manualReviewReasons == other.manualReviewReasons &&
        confirmedOffer == other.confirmedOffer &&
        calculationVersion == other.calculationVersion &&
        notice == other.notice;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, issues.hashCode);
    _$hash = $jc(_$hash, endpoint.hashCode);
    _$hash = $jc(_$hash, route.hashCode);
    _$hash = $jc(_$hash, straightLineMeters.hashCode);
    _$hash = $jc(_$hash, coverageKm.hashCode);
    _$hash = $jc(_$hash, estimate.hashCode);
    _$hash = $jc(_$hash, manualReviewReasons.hashCode);
    _$hash = $jc(_$hash, confirmedOffer.hashCode);
    _$hash = $jc(_$hash, calculationVersion.hashCode);
    _$hash = $jc(_$hash, notice.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'DeliveryPreview')
          ..add('status', status)
          ..add('issues', issues)
          ..add('endpoint', endpoint)
          ..add('route', route)
          ..add('straightLineMeters', straightLineMeters)
          ..add('coverageKm', coverageKm)
          ..add('estimate', estimate)
          ..add('manualReviewReasons', manualReviewReasons)
          ..add('confirmedOffer', confirmedOffer)
          ..add('calculationVersion', calculationVersion)
          ..add('notice', notice))
        .toString();
  }
}

class DeliveryPreviewBuilder
    implements Builder<DeliveryPreview, DeliveryPreviewBuilder> {
  _$DeliveryPreview? _$v;

  DeliveryPreviewStatusEnum? _status;
  DeliveryPreviewStatusEnum? get status => _$this._status;
  set status(DeliveryPreviewStatusEnum? status) => _$this._status = status;

  ListBuilder<CartIssue>? _issues;
  ListBuilder<CartIssue> get issues =>
      _$this._issues ??= ListBuilder<CartIssue>();
  set issues(ListBuilder<CartIssue>? issues) => _$this._issues = issues;

  DeliveryPreviewEndpointEnum? _endpoint;
  DeliveryPreviewEndpointEnum? get endpoint => _$this._endpoint;
  set endpoint(DeliveryPreviewEndpointEnum? endpoint) =>
      _$this._endpoint = endpoint;

  DeliveryRouteBuilder? _route;
  DeliveryRouteBuilder get route => _$this._route ??= DeliveryRouteBuilder();
  set route(DeliveryRouteBuilder? route) => _$this._route = route;

  int? _straightLineMeters;
  int? get straightLineMeters => _$this._straightLineMeters;
  set straightLineMeters(int? straightLineMeters) =>
      _$this._straightLineMeters = straightLineMeters;

  int? _coverageKm;
  int? get coverageKm => _$this._coverageKm;
  set coverageKm(int? coverageKm) => _$this._coverageKm = coverageKm;

  DeliveryEstimateBuilder? _estimate;
  DeliveryEstimateBuilder get estimate =>
      _$this._estimate ??= DeliveryEstimateBuilder();
  set estimate(DeliveryEstimateBuilder? estimate) =>
      _$this._estimate = estimate;

  ListBuilder<String>? _manualReviewReasons;
  ListBuilder<String> get manualReviewReasons =>
      _$this._manualReviewReasons ??= ListBuilder<String>();
  set manualReviewReasons(ListBuilder<String>? manualReviewReasons) =>
      _$this._manualReviewReasons = manualReviewReasons;

  MapBuilder<String, JsonObject?>? _confirmedOffer;
  MapBuilder<String, JsonObject?> get confirmedOffer =>
      _$this._confirmedOffer ??= MapBuilder<String, JsonObject?>();
  set confirmedOffer(MapBuilder<String, JsonObject?>? confirmedOffer) =>
      _$this._confirmedOffer = confirmedOffer;

  String? _calculationVersion;
  String? get calculationVersion => _$this._calculationVersion;
  set calculationVersion(String? calculationVersion) =>
      _$this._calculationVersion = calculationVersion;

  String? _notice;
  String? get notice => _$this._notice;
  set notice(String? notice) => _$this._notice = notice;

  DeliveryPreviewBuilder() {
    DeliveryPreview._defaults(this);
  }

  DeliveryPreviewBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _status = $v.status;
      _issues = $v.issues.toBuilder();
      _endpoint = $v.endpoint;
      _route = $v.route?.toBuilder();
      _straightLineMeters = $v.straightLineMeters;
      _coverageKm = $v.coverageKm;
      _estimate = $v.estimate?.toBuilder();
      _manualReviewReasons = $v.manualReviewReasons.toBuilder();
      _confirmedOffer = $v.confirmedOffer?.toBuilder();
      _calculationVersion = $v.calculationVersion;
      _notice = $v.notice;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DeliveryPreview other) {
    _$v = other as _$DeliveryPreview;
  }

  @override
  void update(void Function(DeliveryPreviewBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DeliveryPreview build() => _build();

  _$DeliveryPreview _build() {
    _$DeliveryPreview _$result;
    try {
      _$result = _$v ??
          _$DeliveryPreview._(
            status: BuiltValueNullFieldError.checkNotNull(
                status, r'DeliveryPreview', 'status'),
            issues: issues.build(),
            endpoint: endpoint,
            route: _route?.build(),
            straightLineMeters: straightLineMeters,
            coverageKm: coverageKm,
            estimate: _estimate?.build(),
            manualReviewReasons: manualReviewReasons.build(),
            confirmedOffer: _confirmedOffer?.build(),
            calculationVersion: BuiltValueNullFieldError.checkNotNull(
                calculationVersion, r'DeliveryPreview', 'calculationVersion'),
            notice: notice,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'issues';
        issues.build();

        _$failedField = 'route';
        _route?.build();

        _$failedField = 'estimate';
        _estimate?.build();
        _$failedField = 'manualReviewReasons';
        manualReviewReasons.build();
        _$failedField = 'confirmedOffer';
        _confirmedOffer?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'DeliveryPreview', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
