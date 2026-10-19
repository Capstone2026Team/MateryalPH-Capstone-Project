// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'work_package_budget_estimate_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const WorkPackageBudgetEstimateRequestHeavyVehicleRestrictionEnum
    _$workPackageBudgetEstimateRequestHeavyVehicleRestrictionEnum_NO =
    const WorkPackageBudgetEstimateRequestHeavyVehicleRestrictionEnum._('NO');
const WorkPackageBudgetEstimateRequestHeavyVehicleRestrictionEnum
    _$workPackageBudgetEstimateRequestHeavyVehicleRestrictionEnum_YES =
    const WorkPackageBudgetEstimateRequestHeavyVehicleRestrictionEnum._('YES');
const WorkPackageBudgetEstimateRequestHeavyVehicleRestrictionEnum
    _$workPackageBudgetEstimateRequestHeavyVehicleRestrictionEnum_UNANSWERED =
    const WorkPackageBudgetEstimateRequestHeavyVehicleRestrictionEnum._(
        'UNANSWERED');

WorkPackageBudgetEstimateRequestHeavyVehicleRestrictionEnum
    _$workPackageBudgetEstimateRequestHeavyVehicleRestrictionEnumValueOf(
        String name) {
  switch (name) {
    case 'NO':
      return _$workPackageBudgetEstimateRequestHeavyVehicleRestrictionEnum_NO;
    case 'YES':
      return _$workPackageBudgetEstimateRequestHeavyVehicleRestrictionEnum_YES;
    case 'UNANSWERED':
      return _$workPackageBudgetEstimateRequestHeavyVehicleRestrictionEnum_UNANSWERED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<WorkPackageBudgetEstimateRequestHeavyVehicleRestrictionEnum>
    _$workPackageBudgetEstimateRequestHeavyVehicleRestrictionEnumValues =
    BuiltSet<
        WorkPackageBudgetEstimateRequestHeavyVehicleRestrictionEnum>(const <WorkPackageBudgetEstimateRequestHeavyVehicleRestrictionEnum>[
  _$workPackageBudgetEstimateRequestHeavyVehicleRestrictionEnum_NO,
  _$workPackageBudgetEstimateRequestHeavyVehicleRestrictionEnum_YES,
  _$workPackageBudgetEstimateRequestHeavyVehicleRestrictionEnum_UNANSWERED,
]);

const WorkPackageBudgetEstimateRequestRadiusKmEnum
    _$workPackageBudgetEstimateRequestRadiusKmEnum_number50 =
    const WorkPackageBudgetEstimateRequestRadiusKmEnum._('number50');

WorkPackageBudgetEstimateRequestRadiusKmEnum
    _$workPackageBudgetEstimateRequestRadiusKmEnumValueOf(String name) {
  switch (name) {
    case 'number50':
      return _$workPackageBudgetEstimateRequestRadiusKmEnum_number50;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<WorkPackageBudgetEstimateRequestRadiusKmEnum>
    _$workPackageBudgetEstimateRequestRadiusKmEnumValues = BuiltSet<
        WorkPackageBudgetEstimateRequestRadiusKmEnum>(const <WorkPackageBudgetEstimateRequestRadiusKmEnum>[
  _$workPackageBudgetEstimateRequestRadiusKmEnum_number50,
]);

const WorkPackageBudgetEstimateRequestFulfillmentMethodEnum
    _$workPackageBudgetEstimateRequestFulfillmentMethodEnum_PICKUP =
    const WorkPackageBudgetEstimateRequestFulfillmentMethodEnum._('PICKUP');
const WorkPackageBudgetEstimateRequestFulfillmentMethodEnum
    _$workPackageBudgetEstimateRequestFulfillmentMethodEnum_DELIVERY =
    const WorkPackageBudgetEstimateRequestFulfillmentMethodEnum._('DELIVERY');
const WorkPackageBudgetEstimateRequestFulfillmentMethodEnum
    _$workPackageBudgetEstimateRequestFulfillmentMethodEnum_BOTH =
    const WorkPackageBudgetEstimateRequestFulfillmentMethodEnum._('BOTH');

WorkPackageBudgetEstimateRequestFulfillmentMethodEnum
    _$workPackageBudgetEstimateRequestFulfillmentMethodEnumValueOf(
        String name) {
  switch (name) {
    case 'PICKUP':
      return _$workPackageBudgetEstimateRequestFulfillmentMethodEnum_PICKUP;
    case 'DELIVERY':
      return _$workPackageBudgetEstimateRequestFulfillmentMethodEnum_DELIVERY;
    case 'BOTH':
      return _$workPackageBudgetEstimateRequestFulfillmentMethodEnum_BOTH;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<WorkPackageBudgetEstimateRequestFulfillmentMethodEnum>
    _$workPackageBudgetEstimateRequestFulfillmentMethodEnumValues = BuiltSet<
        WorkPackageBudgetEstimateRequestFulfillmentMethodEnum>(const <WorkPackageBudgetEstimateRequestFulfillmentMethodEnum>[
  _$workPackageBudgetEstimateRequestFulfillmentMethodEnum_PICKUP,
  _$workPackageBudgetEstimateRequestFulfillmentMethodEnum_DELIVERY,
  _$workPackageBudgetEstimateRequestFulfillmentMethodEnum_BOTH,
]);

Serializer<WorkPackageBudgetEstimateRequestHeavyVehicleRestrictionEnum>
    _$workPackageBudgetEstimateRequestHeavyVehicleRestrictionEnumSerializer =
    _$WorkPackageBudgetEstimateRequestHeavyVehicleRestrictionEnumSerializer();
Serializer<WorkPackageBudgetEstimateRequestRadiusKmEnum>
    _$workPackageBudgetEstimateRequestRadiusKmEnumSerializer =
    _$WorkPackageBudgetEstimateRequestRadiusKmEnumSerializer();
Serializer<WorkPackageBudgetEstimateRequestFulfillmentMethodEnum>
    _$workPackageBudgetEstimateRequestFulfillmentMethodEnumSerializer =
    _$WorkPackageBudgetEstimateRequestFulfillmentMethodEnumSerializer();

class _$WorkPackageBudgetEstimateRequestHeavyVehicleRestrictionEnumSerializer
    implements
        PrimitiveSerializer<
            WorkPackageBudgetEstimateRequestHeavyVehicleRestrictionEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'NO': 'NO',
    'YES': 'YES',
    'UNANSWERED': 'UNANSWERED',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'NO': 'NO',
    'YES': 'YES',
    'UNANSWERED': 'UNANSWERED',
  };

  @override
  final Iterable<Type> types = const <Type>[
    WorkPackageBudgetEstimateRequestHeavyVehicleRestrictionEnum
  ];
  @override
  final String wireName =
      'WorkPackageBudgetEstimateRequestHeavyVehicleRestrictionEnum';

  @override
  Object serialize(Serializers serializers,
          WorkPackageBudgetEstimateRequestHeavyVehicleRestrictionEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  WorkPackageBudgetEstimateRequestHeavyVehicleRestrictionEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      WorkPackageBudgetEstimateRequestHeavyVehicleRestrictionEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$WorkPackageBudgetEstimateRequestRadiusKmEnumSerializer
    implements
        PrimitiveSerializer<WorkPackageBudgetEstimateRequestRadiusKmEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'number50': 50,
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    50: 'number50',
  };

  @override
  final Iterable<Type> types = const <Type>[
    WorkPackageBudgetEstimateRequestRadiusKmEnum
  ];
  @override
  final String wireName = 'WorkPackageBudgetEstimateRequestRadiusKmEnum';

  @override
  Object serialize(Serializers serializers,
          WorkPackageBudgetEstimateRequestRadiusKmEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  WorkPackageBudgetEstimateRequestRadiusKmEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      WorkPackageBudgetEstimateRequestRadiusKmEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$WorkPackageBudgetEstimateRequestFulfillmentMethodEnumSerializer
    implements
        PrimitiveSerializer<
            WorkPackageBudgetEstimateRequestFulfillmentMethodEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'PICKUP': 'PICKUP',
    'DELIVERY': 'DELIVERY',
    'BOTH': 'BOTH',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'PICKUP': 'PICKUP',
    'DELIVERY': 'DELIVERY',
    'BOTH': 'BOTH',
  };

  @override
  final Iterable<Type> types = const <Type>[
    WorkPackageBudgetEstimateRequestFulfillmentMethodEnum
  ];
  @override
  final String wireName =
      'WorkPackageBudgetEstimateRequestFulfillmentMethodEnum';

  @override
  Object serialize(Serializers serializers,
          WorkPackageBudgetEstimateRequestFulfillmentMethodEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  WorkPackageBudgetEstimateRequestFulfillmentMethodEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      WorkPackageBudgetEstimateRequestFulfillmentMethodEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$WorkPackageBudgetEstimateRequest
    extends WorkPackageBudgetEstimateRequest {
  @override
  final WorkPackageBudgetEstimateRequestHeavyVehicleRestrictionEnum?
      heavyVehicleRestriction;
  @override
  final String? alternateDropOffLocationId;
  @override
  final String siteId;
  @override
  final WorkPackageBudgetEstimateRequestRadiusKmEnum? radiusKm;
  @override
  final WorkPackageBudgetEstimateRequestFulfillmentMethodEnum fulfillmentMethod;
  @override
  final BuiltList<WorkPackageBudgetEstimateLineInput> lines;

  factory _$WorkPackageBudgetEstimateRequest(
          [void Function(WorkPackageBudgetEstimateRequestBuilder)? updates]) =>
      (WorkPackageBudgetEstimateRequestBuilder()..update(updates))._build();

  _$WorkPackageBudgetEstimateRequest._(
      {this.heavyVehicleRestriction,
      this.alternateDropOffLocationId,
      required this.siteId,
      this.radiusKm,
      required this.fulfillmentMethod,
      required this.lines})
      : super._();
  @override
  WorkPackageBudgetEstimateRequest rebuild(
          void Function(WorkPackageBudgetEstimateRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  WorkPackageBudgetEstimateRequestBuilder toBuilder() =>
      WorkPackageBudgetEstimateRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is WorkPackageBudgetEstimateRequest &&
        heavyVehicleRestriction == other.heavyVehicleRestriction &&
        alternateDropOffLocationId == other.alternateDropOffLocationId &&
        siteId == other.siteId &&
        radiusKm == other.radiusKm &&
        fulfillmentMethod == other.fulfillmentMethod &&
        lines == other.lines;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, heavyVehicleRestriction.hashCode);
    _$hash = $jc(_$hash, alternateDropOffLocationId.hashCode);
    _$hash = $jc(_$hash, siteId.hashCode);
    _$hash = $jc(_$hash, radiusKm.hashCode);
    _$hash = $jc(_$hash, fulfillmentMethod.hashCode);
    _$hash = $jc(_$hash, lines.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'WorkPackageBudgetEstimateRequest')
          ..add('heavyVehicleRestriction', heavyVehicleRestriction)
          ..add('alternateDropOffLocationId', alternateDropOffLocationId)
          ..add('siteId', siteId)
          ..add('radiusKm', radiusKm)
          ..add('fulfillmentMethod', fulfillmentMethod)
          ..add('lines', lines))
        .toString();
  }
}

class WorkPackageBudgetEstimateRequestBuilder
    implements
        Builder<WorkPackageBudgetEstimateRequest,
            WorkPackageBudgetEstimateRequestBuilder> {
  _$WorkPackageBudgetEstimateRequest? _$v;

  WorkPackageBudgetEstimateRequestHeavyVehicleRestrictionEnum?
      _heavyVehicleRestriction;
  WorkPackageBudgetEstimateRequestHeavyVehicleRestrictionEnum?
      get heavyVehicleRestriction => _$this._heavyVehicleRestriction;
  set heavyVehicleRestriction(
          WorkPackageBudgetEstimateRequestHeavyVehicleRestrictionEnum?
              heavyVehicleRestriction) =>
      _$this._heavyVehicleRestriction = heavyVehicleRestriction;

  String? _alternateDropOffLocationId;
  String? get alternateDropOffLocationId => _$this._alternateDropOffLocationId;
  set alternateDropOffLocationId(String? alternateDropOffLocationId) =>
      _$this._alternateDropOffLocationId = alternateDropOffLocationId;

  String? _siteId;
  String? get siteId => _$this._siteId;
  set siteId(String? siteId) => _$this._siteId = siteId;

  WorkPackageBudgetEstimateRequestRadiusKmEnum? _radiusKm;
  WorkPackageBudgetEstimateRequestRadiusKmEnum? get radiusKm =>
      _$this._radiusKm;
  set radiusKm(WorkPackageBudgetEstimateRequestRadiusKmEnum? radiusKm) =>
      _$this._radiusKm = radiusKm;

  WorkPackageBudgetEstimateRequestFulfillmentMethodEnum? _fulfillmentMethod;
  WorkPackageBudgetEstimateRequestFulfillmentMethodEnum?
      get fulfillmentMethod => _$this._fulfillmentMethod;
  set fulfillmentMethod(
          WorkPackageBudgetEstimateRequestFulfillmentMethodEnum?
              fulfillmentMethod) =>
      _$this._fulfillmentMethod = fulfillmentMethod;

  ListBuilder<WorkPackageBudgetEstimateLineInput>? _lines;
  ListBuilder<WorkPackageBudgetEstimateLineInput> get lines =>
      _$this._lines ??= ListBuilder<WorkPackageBudgetEstimateLineInput>();
  set lines(ListBuilder<WorkPackageBudgetEstimateLineInput>? lines) =>
      _$this._lines = lines;

  WorkPackageBudgetEstimateRequestBuilder() {
    WorkPackageBudgetEstimateRequest._defaults(this);
  }

  WorkPackageBudgetEstimateRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _heavyVehicleRestriction = $v.heavyVehicleRestriction;
      _alternateDropOffLocationId = $v.alternateDropOffLocationId;
      _siteId = $v.siteId;
      _radiusKm = $v.radiusKm;
      _fulfillmentMethod = $v.fulfillmentMethod;
      _lines = $v.lines.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(WorkPackageBudgetEstimateRequest other) {
    _$v = other as _$WorkPackageBudgetEstimateRequest;
  }

  @override
  void update(void Function(WorkPackageBudgetEstimateRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  WorkPackageBudgetEstimateRequest build() => _build();

  _$WorkPackageBudgetEstimateRequest _build() {
    _$WorkPackageBudgetEstimateRequest _$result;
    try {
      _$result = _$v ??
          _$WorkPackageBudgetEstimateRequest._(
            heavyVehicleRestriction: heavyVehicleRestriction,
            alternateDropOffLocationId: alternateDropOffLocationId,
            siteId: BuiltValueNullFieldError.checkNotNull(
                siteId, r'WorkPackageBudgetEstimateRequest', 'siteId'),
            radiusKm: radiusKm,
            fulfillmentMethod: BuiltValueNullFieldError.checkNotNull(
                fulfillmentMethod,
                r'WorkPackageBudgetEstimateRequest',
                'fulfillmentMethod'),
            lines: lines.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'lines';
        lines.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'WorkPackageBudgetEstimateRequest', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
