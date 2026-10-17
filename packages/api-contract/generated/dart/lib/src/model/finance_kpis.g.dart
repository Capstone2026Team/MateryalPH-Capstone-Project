// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'finance_kpis.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const FinanceKpisTrendGranularityEnum _$financeKpisTrendGranularityEnum_DAY =
    const FinanceKpisTrendGranularityEnum._('DAY');
const FinanceKpisTrendGranularityEnum _$financeKpisTrendGranularityEnum_MONTH =
    const FinanceKpisTrendGranularityEnum._('MONTH');

FinanceKpisTrendGranularityEnum _$financeKpisTrendGranularityEnumValueOf(
    String name) {
  switch (name) {
    case 'DAY':
      return _$financeKpisTrendGranularityEnum_DAY;
    case 'MONTH':
      return _$financeKpisTrendGranularityEnum_MONTH;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<FinanceKpisTrendGranularityEnum>
    _$financeKpisTrendGranularityEnumValues = BuiltSet<
        FinanceKpisTrendGranularityEnum>(const <FinanceKpisTrendGranularityEnum>[
  _$financeKpisTrendGranularityEnum_DAY,
  _$financeKpisTrendGranularityEnum_MONTH,
]);

Serializer<FinanceKpisTrendGranularityEnum>
    _$financeKpisTrendGranularityEnumSerializer =
    _$FinanceKpisTrendGranularityEnumSerializer();

class _$FinanceKpisTrendGranularityEnumSerializer
    implements PrimitiveSerializer<FinanceKpisTrendGranularityEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'DAY': 'DAY',
    'MONTH': 'MONTH',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'DAY': 'DAY',
    'MONTH': 'MONTH',
  };

  @override
  final Iterable<Type> types = const <Type>[FinanceKpisTrendGranularityEnum];
  @override
  final String wireName = 'FinanceKpisTrendGranularityEnum';

  @override
  Object serialize(
          Serializers serializers, FinanceKpisTrendGranularityEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  FinanceKpisTrendGranularityEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      FinanceKpisTrendGranularityEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$FinanceKpis extends FinanceKpis {
  @override
  final String label;
  @override
  final String scenario;
  @override
  final FinanceKpisPeriod period;
  @override
  final BuiltList<FinanceKpi> commerce;
  @override
  final BuiltList<FinanceKpi> finance;
  @override
  final BuiltMap<String, int> counts;
  @override
  final BuiltList<CommissionTrendPoint>? trend;
  @override
  final FinanceKpisTrendGranularityEnum? trendGranularity;

  factory _$FinanceKpis([void Function(FinanceKpisBuilder)? updates]) =>
      (FinanceKpisBuilder()..update(updates))._build();

  _$FinanceKpis._(
      {required this.label,
      required this.scenario,
      required this.period,
      required this.commerce,
      required this.finance,
      required this.counts,
      this.trend,
      this.trendGranularity})
      : super._();
  @override
  FinanceKpis rebuild(void Function(FinanceKpisBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  FinanceKpisBuilder toBuilder() => FinanceKpisBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is FinanceKpis &&
        label == other.label &&
        scenario == other.scenario &&
        period == other.period &&
        commerce == other.commerce &&
        finance == other.finance &&
        counts == other.counts &&
        trend == other.trend &&
        trendGranularity == other.trendGranularity;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, label.hashCode);
    _$hash = $jc(_$hash, scenario.hashCode);
    _$hash = $jc(_$hash, period.hashCode);
    _$hash = $jc(_$hash, commerce.hashCode);
    _$hash = $jc(_$hash, finance.hashCode);
    _$hash = $jc(_$hash, counts.hashCode);
    _$hash = $jc(_$hash, trend.hashCode);
    _$hash = $jc(_$hash, trendGranularity.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'FinanceKpis')
          ..add('label', label)
          ..add('scenario', scenario)
          ..add('period', period)
          ..add('commerce', commerce)
          ..add('finance', finance)
          ..add('counts', counts)
          ..add('trend', trend)
          ..add('trendGranularity', trendGranularity))
        .toString();
  }
}

class FinanceKpisBuilder implements Builder<FinanceKpis, FinanceKpisBuilder> {
  _$FinanceKpis? _$v;

  String? _label;
  String? get label => _$this._label;
  set label(String? label) => _$this._label = label;

  String? _scenario;
  String? get scenario => _$this._scenario;
  set scenario(String? scenario) => _$this._scenario = scenario;

  FinanceKpisPeriodBuilder? _period;
  FinanceKpisPeriodBuilder get period =>
      _$this._period ??= FinanceKpisPeriodBuilder();
  set period(FinanceKpisPeriodBuilder? period) => _$this._period = period;

  ListBuilder<FinanceKpi>? _commerce;
  ListBuilder<FinanceKpi> get commerce =>
      _$this._commerce ??= ListBuilder<FinanceKpi>();
  set commerce(ListBuilder<FinanceKpi>? commerce) =>
      _$this._commerce = commerce;

  ListBuilder<FinanceKpi>? _finance;
  ListBuilder<FinanceKpi> get finance =>
      _$this._finance ??= ListBuilder<FinanceKpi>();
  set finance(ListBuilder<FinanceKpi>? finance) => _$this._finance = finance;

  MapBuilder<String, int>? _counts;
  MapBuilder<String, int> get counts =>
      _$this._counts ??= MapBuilder<String, int>();
  set counts(MapBuilder<String, int>? counts) => _$this._counts = counts;

  ListBuilder<CommissionTrendPoint>? _trend;
  ListBuilder<CommissionTrendPoint> get trend =>
      _$this._trend ??= ListBuilder<CommissionTrendPoint>();
  set trend(ListBuilder<CommissionTrendPoint>? trend) => _$this._trend = trend;

  FinanceKpisTrendGranularityEnum? _trendGranularity;
  FinanceKpisTrendGranularityEnum? get trendGranularity =>
      _$this._trendGranularity;
  set trendGranularity(FinanceKpisTrendGranularityEnum? trendGranularity) =>
      _$this._trendGranularity = trendGranularity;

  FinanceKpisBuilder() {
    FinanceKpis._defaults(this);
  }

  FinanceKpisBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _label = $v.label;
      _scenario = $v.scenario;
      _period = $v.period.toBuilder();
      _commerce = $v.commerce.toBuilder();
      _finance = $v.finance.toBuilder();
      _counts = $v.counts.toBuilder();
      _trend = $v.trend?.toBuilder();
      _trendGranularity = $v.trendGranularity;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(FinanceKpis other) {
    _$v = other as _$FinanceKpis;
  }

  @override
  void update(void Function(FinanceKpisBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  FinanceKpis build() => _build();

  _$FinanceKpis _build() {
    _$FinanceKpis _$result;
    try {
      _$result = _$v ??
          _$FinanceKpis._(
            label: BuiltValueNullFieldError.checkNotNull(
                label, r'FinanceKpis', 'label'),
            scenario: BuiltValueNullFieldError.checkNotNull(
                scenario, r'FinanceKpis', 'scenario'),
            period: period.build(),
            commerce: commerce.build(),
            finance: finance.build(),
            counts: counts.build(),
            trend: _trend?.build(),
            trendGranularity: trendGranularity,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'period';
        period.build();
        _$failedField = 'commerce';
        commerce.build();
        _$failedField = 'finance';
        finance.build();
        _$failedField = 'counts';
        counts.build();
        _$failedField = 'trend';
        _trend?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'FinanceKpis', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
