// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'work_package_budget_estimate_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const WorkPackageBudgetEstimateRequestRadiusKmEnum
    _$workPackageBudgetEstimateRequestRadiusKmEnum_number5 =
    const WorkPackageBudgetEstimateRequestRadiusKmEnum._('number5');
const WorkPackageBudgetEstimateRequestRadiusKmEnum
    _$workPackageBudgetEstimateRequestRadiusKmEnum_number10 =
    const WorkPackageBudgetEstimateRequestRadiusKmEnum._('number10');
const WorkPackageBudgetEstimateRequestRadiusKmEnum
    _$workPackageBudgetEstimateRequestRadiusKmEnum_number20 =
    const WorkPackageBudgetEstimateRequestRadiusKmEnum._('number20');
const WorkPackageBudgetEstimateRequestRadiusKmEnum
    _$workPackageBudgetEstimateRequestRadiusKmEnum_number30 =
    const WorkPackageBudgetEstimateRequestRadiusKmEnum._('number30');
const WorkPackageBudgetEstimateRequestRadiusKmEnum
    _$workPackageBudgetEstimateRequestRadiusKmEnum_number40 =
    const WorkPackageBudgetEstimateRequestRadiusKmEnum._('number40');
const WorkPackageBudgetEstimateRequestRadiusKmEnum
    _$workPackageBudgetEstimateRequestRadiusKmEnum_number50 =
    const WorkPackageBudgetEstimateRequestRadiusKmEnum._('number50');

WorkPackageBudgetEstimateRequestRadiusKmEnum
    _$workPackageBudgetEstimateRequestRadiusKmEnumValueOf(String name) {
  switch (name) {
    case 'number5':
      return _$workPackageBudgetEstimateRequestRadiusKmEnum_number5;
    case 'number10':
      return _$workPackageBudgetEstimateRequestRadiusKmEnum_number10;
    case 'number20':
      return _$workPackageBudgetEstimateRequestRadiusKmEnum_number20;
    case 'number30':
      return _$workPackageBudgetEstimateRequestRadiusKmEnum_number30;
    case 'number40':
      return _$workPackageBudgetEstimateRequestRadiusKmEnum_number40;
    case 'number50':
      return _$workPackageBudgetEstimateRequestRadiusKmEnum_number50;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<WorkPackageBudgetEstimateRequestRadiusKmEnum>
    _$workPackageBudgetEstimateRequestRadiusKmEnumValues = BuiltSet<
        WorkPackageBudgetEstimateRequestRadiusKmEnum>(const <WorkPackageBudgetEstimateRequestRadiusKmEnum>[
  _$workPackageBudgetEstimateRequestRadiusKmEnum_number5,
  _$workPackageBudgetEstimateRequestRadiusKmEnum_number10,
  _$workPackageBudgetEstimateRequestRadiusKmEnum_number20,
  _$workPackageBudgetEstimateRequestRadiusKmEnum_number30,
  _$workPackageBudgetEstimateRequestRadiusKmEnum_number40,
  _$workPackageBudgetEstimateRequestRadiusKmEnum_number50,
]);

const WorkPackageBudgetEstimateRequestFulfillmentMethodEnum
    _$workPackageBudgetEstimateRequestFulfillmentMethodEnum_PICKUP =
    const WorkPackageBudgetEstimateRequestFulfillmentMethodEnum._('PICKUP');
const WorkPackageBudgetEstimateRequestFulfillmentMethodEnum
    _$workPackageBudgetEstimateRequestFulfillmentMethodEnum_DELIVERY =
    const WorkPackageBudgetEstimateRequestFulfillmentMethodEnum._('DELIVERY');

WorkPackageBudgetEstimateRequestFulfillmentMethodEnum
    _$workPackageBudgetEstimateRequestFulfillmentMethodEnumValueOf(
        String name) {
  switch (name) {
    case 'PICKUP':
      return _$workPackageBudgetEstimateRequestFulfillmentMethodEnum_PICKUP;
    case 'DELIVERY':
      return _$workPackageBudgetEstimateRequestFulfillmentMethodEnum_DELIVERY;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<WorkPackageBudgetEstimateRequestFulfillmentMethodEnum>
    _$workPackageBudgetEstimateRequestFulfillmentMethodEnumValues = BuiltSet<
        WorkPackageBudgetEstimateRequestFulfillmentMethodEnum>(const <WorkPackageBudgetEstimateRequestFulfillmentMethodEnum>[
  _$workPackageBudgetEstimateRequestFulfillmentMethodEnum_PICKUP,
  _$workPackageBudgetEstimateRequestFulfillmentMethodEnum_DELIVERY,
]);

Serializer<WorkPackageBudgetEstimateRequestRadiusKmEnum>
    _$workPackageBudgetEstimateRequestRadiusKmEnumSerializer =
    _$WorkPackageBudgetEstimateRequestRadiusKmEnumSerializer();
Serializer<WorkPackageBudgetEstimateRequestFulfillmentMethodEnum>
    _$workPackageBudgetEstimateRequestFulfillmentMethodEnumSerializer =
    _$WorkPackageBudgetEstimateRequestFulfillmentMethodEnumSerializer();

class _$WorkPackageBudgetEstimateRequestRadiusKmEnumSerializer
    implements
        PrimitiveSerializer<WorkPackageBudgetEstimateRequestRadiusKmEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'number5': 5,
    'number10': 10,
    'number20': 20,
    'number30': 30,
    'number40': 40,
    'number50': 50,
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    5: 'number5',
    10: 'number10',
    20: 'number20',
    30: 'number30',
    40: 'number40',
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
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'PICKUP': 'PICKUP',
    'DELIVERY': 'DELIVERY',
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
  final String siteId;
  @override
  final WorkPackageBudgetEstimateRequestRadiusKmEnum radiusKm;
  @override
  final WorkPackageBudgetEstimateRequestFulfillmentMethodEnum fulfillmentMethod;
  @override
  final BuiltList<WorkPackageBudgetEstimateLineInput> lines;

  factory _$WorkPackageBudgetEstimateRequest(
          [void Function(WorkPackageBudgetEstimateRequestBuilder)? updates]) =>
      (WorkPackageBudgetEstimateRequestBuilder()..update(updates))._build();

  _$WorkPackageBudgetEstimateRequest._(
      {required this.siteId,
      required this.radiusKm,
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
        siteId == other.siteId &&
        radiusKm == other.radiusKm &&
        fulfillmentMethod == other.fulfillmentMethod &&
        lines == other.lines;
  }

  @override
  int get hashCode {
    var _$hash = 0;
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
            siteId: BuiltValueNullFieldError.checkNotNull(
                siteId, r'WorkPackageBudgetEstimateRequest', 'siteId'),
            radiusKm: BuiltValueNullFieldError.checkNotNull(
                radiusKm, r'WorkPackageBudgetEstimateRequest', 'radiusKm'),
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
