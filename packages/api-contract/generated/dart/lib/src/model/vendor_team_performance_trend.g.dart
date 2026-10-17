// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_team_performance_trend.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const VendorTeamPerformanceTrendMetricEnum
    _$vendorTeamPerformanceTrendMetricEnum_SALES =
    const VendorTeamPerformanceTrendMetricEnum._('SALES');
const VendorTeamPerformanceTrendMetricEnum
    _$vendorTeamPerformanceTrendMetricEnum_INVENTORY_UPDATES =
    const VendorTeamPerformanceTrendMetricEnum._('INVENTORY_UPDATES');
const VendorTeamPerformanceTrendMetricEnum
    _$vendorTeamPerformanceTrendMetricEnum_HANDOVERS =
    const VendorTeamPerformanceTrendMetricEnum._('HANDOVERS');
const VendorTeamPerformanceTrendMetricEnum
    _$vendorTeamPerformanceTrendMetricEnum_ACTIONS =
    const VendorTeamPerformanceTrendMetricEnum._('ACTIONS');

VendorTeamPerformanceTrendMetricEnum
    _$vendorTeamPerformanceTrendMetricEnumValueOf(String name) {
  switch (name) {
    case 'SALES':
      return _$vendorTeamPerformanceTrendMetricEnum_SALES;
    case 'INVENTORY_UPDATES':
      return _$vendorTeamPerformanceTrendMetricEnum_INVENTORY_UPDATES;
    case 'HANDOVERS':
      return _$vendorTeamPerformanceTrendMetricEnum_HANDOVERS;
    case 'ACTIONS':
      return _$vendorTeamPerformanceTrendMetricEnum_ACTIONS;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<VendorTeamPerformanceTrendMetricEnum>
    _$vendorTeamPerformanceTrendMetricEnumValues = BuiltSet<
        VendorTeamPerformanceTrendMetricEnum>(const <VendorTeamPerformanceTrendMetricEnum>[
  _$vendorTeamPerformanceTrendMetricEnum_SALES,
  _$vendorTeamPerformanceTrendMetricEnum_INVENTORY_UPDATES,
  _$vendorTeamPerformanceTrendMetricEnum_HANDOVERS,
  _$vendorTeamPerformanceTrendMetricEnum_ACTIONS,
]);

const VendorTeamPerformanceTrendGranularityEnum
    _$vendorTeamPerformanceTrendGranularityEnum_DAY =
    const VendorTeamPerformanceTrendGranularityEnum._('DAY');
const VendorTeamPerformanceTrendGranularityEnum
    _$vendorTeamPerformanceTrendGranularityEnum_MONTH =
    const VendorTeamPerformanceTrendGranularityEnum._('MONTH');

VendorTeamPerformanceTrendGranularityEnum
    _$vendorTeamPerformanceTrendGranularityEnumValueOf(String name) {
  switch (name) {
    case 'DAY':
      return _$vendorTeamPerformanceTrendGranularityEnum_DAY;
    case 'MONTH':
      return _$vendorTeamPerformanceTrendGranularityEnum_MONTH;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<VendorTeamPerformanceTrendGranularityEnum>
    _$vendorTeamPerformanceTrendGranularityEnumValues = BuiltSet<
        VendorTeamPerformanceTrendGranularityEnum>(const <VendorTeamPerformanceTrendGranularityEnum>[
  _$vendorTeamPerformanceTrendGranularityEnum_DAY,
  _$vendorTeamPerformanceTrendGranularityEnum_MONTH,
]);

Serializer<VendorTeamPerformanceTrendMetricEnum>
    _$vendorTeamPerformanceTrendMetricEnumSerializer =
    _$VendorTeamPerformanceTrendMetricEnumSerializer();
Serializer<VendorTeamPerformanceTrendGranularityEnum>
    _$vendorTeamPerformanceTrendGranularityEnumSerializer =
    _$VendorTeamPerformanceTrendGranularityEnumSerializer();

class _$VendorTeamPerformanceTrendMetricEnumSerializer
    implements PrimitiveSerializer<VendorTeamPerformanceTrendMetricEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'SALES': 'SALES',
    'INVENTORY_UPDATES': 'INVENTORY_UPDATES',
    'HANDOVERS': 'HANDOVERS',
    'ACTIONS': 'ACTIONS',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'SALES': 'SALES',
    'INVENTORY_UPDATES': 'INVENTORY_UPDATES',
    'HANDOVERS': 'HANDOVERS',
    'ACTIONS': 'ACTIONS',
  };

  @override
  final Iterable<Type> types = const <Type>[
    VendorTeamPerformanceTrendMetricEnum
  ];
  @override
  final String wireName = 'VendorTeamPerformanceTrendMetricEnum';

  @override
  Object serialize(
          Serializers serializers, VendorTeamPerformanceTrendMetricEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  VendorTeamPerformanceTrendMetricEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      VendorTeamPerformanceTrendMetricEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$VendorTeamPerformanceTrendGranularityEnumSerializer
    implements PrimitiveSerializer<VendorTeamPerformanceTrendGranularityEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'DAY': 'DAY',
    'MONTH': 'MONTH',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'DAY': 'DAY',
    'MONTH': 'MONTH',
  };

  @override
  final Iterable<Type> types = const <Type>[
    VendorTeamPerformanceTrendGranularityEnum
  ];
  @override
  final String wireName = 'VendorTeamPerformanceTrendGranularityEnum';

  @override
  Object serialize(Serializers serializers,
          VendorTeamPerformanceTrendGranularityEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  VendorTeamPerformanceTrendGranularityEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      VendorTeamPerformanceTrendGranularityEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$VendorTeamPerformanceTrend extends VendorTeamPerformanceTrend {
  @override
  final VendorTeamPerformanceTrendMetricEnum metric;
  @override
  final VendorTeamPerformanceTrendGranularityEnum granularity;
  @override
  final String from;
  @override
  final String to;
  @override
  final BuiltList<VendorTeamPerformanceTrendPointsInner> points;

  factory _$VendorTeamPerformanceTrend(
          [void Function(VendorTeamPerformanceTrendBuilder)? updates]) =>
      (VendorTeamPerformanceTrendBuilder()..update(updates))._build();

  _$VendorTeamPerformanceTrend._(
      {required this.metric,
      required this.granularity,
      required this.from,
      required this.to,
      required this.points})
      : super._();
  @override
  VendorTeamPerformanceTrend rebuild(
          void Function(VendorTeamPerformanceTrendBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  VendorTeamPerformanceTrendBuilder toBuilder() =>
      VendorTeamPerformanceTrendBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is VendorTeamPerformanceTrend &&
        metric == other.metric &&
        granularity == other.granularity &&
        from == other.from &&
        to == other.to &&
        points == other.points;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, metric.hashCode);
    _$hash = $jc(_$hash, granularity.hashCode);
    _$hash = $jc(_$hash, from.hashCode);
    _$hash = $jc(_$hash, to.hashCode);
    _$hash = $jc(_$hash, points.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'VendorTeamPerformanceTrend')
          ..add('metric', metric)
          ..add('granularity', granularity)
          ..add('from', from)
          ..add('to', to)
          ..add('points', points))
        .toString();
  }
}

class VendorTeamPerformanceTrendBuilder
    implements
        Builder<VendorTeamPerformanceTrend, VendorTeamPerformanceTrendBuilder> {
  _$VendorTeamPerformanceTrend? _$v;

  VendorTeamPerformanceTrendMetricEnum? _metric;
  VendorTeamPerformanceTrendMetricEnum? get metric => _$this._metric;
  set metric(VendorTeamPerformanceTrendMetricEnum? metric) =>
      _$this._metric = metric;

  VendorTeamPerformanceTrendGranularityEnum? _granularity;
  VendorTeamPerformanceTrendGranularityEnum? get granularity =>
      _$this._granularity;
  set granularity(VendorTeamPerformanceTrendGranularityEnum? granularity) =>
      _$this._granularity = granularity;

  String? _from;
  String? get from => _$this._from;
  set from(String? from) => _$this._from = from;

  String? _to;
  String? get to => _$this._to;
  set to(String? to) => _$this._to = to;

  ListBuilder<VendorTeamPerformanceTrendPointsInner>? _points;
  ListBuilder<VendorTeamPerformanceTrendPointsInner> get points =>
      _$this._points ??= ListBuilder<VendorTeamPerformanceTrendPointsInner>();
  set points(ListBuilder<VendorTeamPerformanceTrendPointsInner>? points) =>
      _$this._points = points;

  VendorTeamPerformanceTrendBuilder() {
    VendorTeamPerformanceTrend._defaults(this);
  }

  VendorTeamPerformanceTrendBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _metric = $v.metric;
      _granularity = $v.granularity;
      _from = $v.from;
      _to = $v.to;
      _points = $v.points.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(VendorTeamPerformanceTrend other) {
    _$v = other as _$VendorTeamPerformanceTrend;
  }

  @override
  void update(void Function(VendorTeamPerformanceTrendBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  VendorTeamPerformanceTrend build() => _build();

  _$VendorTeamPerformanceTrend _build() {
    _$VendorTeamPerformanceTrend _$result;
    try {
      _$result = _$v ??
          _$VendorTeamPerformanceTrend._(
            metric: BuiltValueNullFieldError.checkNotNull(
                metric, r'VendorTeamPerformanceTrend', 'metric'),
            granularity: BuiltValueNullFieldError.checkNotNull(
                granularity, r'VendorTeamPerformanceTrend', 'granularity'),
            from: BuiltValueNullFieldError.checkNotNull(
                from, r'VendorTeamPerformanceTrend', 'from'),
            to: BuiltValueNullFieldError.checkNotNull(
                to, r'VendorTeamPerformanceTrend', 'to'),
            points: points.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'points';
        points.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'VendorTeamPerformanceTrend', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
