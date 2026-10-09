// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'geo_dashboard_period.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const GeoDashboardPeriodGranularityEnum
    _$geoDashboardPeriodGranularityEnum_DAY =
    const GeoDashboardPeriodGranularityEnum._('DAY');
const GeoDashboardPeriodGranularityEnum
    _$geoDashboardPeriodGranularityEnum_WEEK =
    const GeoDashboardPeriodGranularityEnum._('WEEK');
const GeoDashboardPeriodGranularityEnum
    _$geoDashboardPeriodGranularityEnum_MONTH =
    const GeoDashboardPeriodGranularityEnum._('MONTH');

GeoDashboardPeriodGranularityEnum _$geoDashboardPeriodGranularityEnumValueOf(
    String name) {
  switch (name) {
    case 'DAY':
      return _$geoDashboardPeriodGranularityEnum_DAY;
    case 'WEEK':
      return _$geoDashboardPeriodGranularityEnum_WEEK;
    case 'MONTH':
      return _$geoDashboardPeriodGranularityEnum_MONTH;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<GeoDashboardPeriodGranularityEnum>
    _$geoDashboardPeriodGranularityEnumValues = BuiltSet<
        GeoDashboardPeriodGranularityEnum>(const <GeoDashboardPeriodGranularityEnum>[
  _$geoDashboardPeriodGranularityEnum_DAY,
  _$geoDashboardPeriodGranularityEnum_WEEK,
  _$geoDashboardPeriodGranularityEnum_MONTH,
]);

Serializer<GeoDashboardPeriodGranularityEnum>
    _$geoDashboardPeriodGranularityEnumSerializer =
    _$GeoDashboardPeriodGranularityEnumSerializer();

class _$GeoDashboardPeriodGranularityEnumSerializer
    implements PrimitiveSerializer<GeoDashboardPeriodGranularityEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'DAY': 'DAY',
    'WEEK': 'WEEK',
    'MONTH': 'MONTH',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'DAY': 'DAY',
    'WEEK': 'WEEK',
    'MONTH': 'MONTH',
  };

  @override
  final Iterable<Type> types = const <Type>[GeoDashboardPeriodGranularityEnum];
  @override
  final String wireName = 'GeoDashboardPeriodGranularityEnum';

  @override
  Object serialize(
          Serializers serializers, GeoDashboardPeriodGranularityEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  GeoDashboardPeriodGranularityEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      GeoDashboardPeriodGranularityEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$GeoDashboardPeriod extends GeoDashboardPeriod {
  @override
  final Date from;
  @override
  final Date to;
  @override
  final GeoDashboardPeriodGranularityEnum granularity;

  factory _$GeoDashboardPeriod(
          [void Function(GeoDashboardPeriodBuilder)? updates]) =>
      (GeoDashboardPeriodBuilder()..update(updates))._build();

  _$GeoDashboardPeriod._(
      {required this.from, required this.to, required this.granularity})
      : super._();
  @override
  GeoDashboardPeriod rebuild(
          void Function(GeoDashboardPeriodBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  GeoDashboardPeriodBuilder toBuilder() =>
      GeoDashboardPeriodBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is GeoDashboardPeriod &&
        from == other.from &&
        to == other.to &&
        granularity == other.granularity;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, from.hashCode);
    _$hash = $jc(_$hash, to.hashCode);
    _$hash = $jc(_$hash, granularity.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'GeoDashboardPeriod')
          ..add('from', from)
          ..add('to', to)
          ..add('granularity', granularity))
        .toString();
  }
}

class GeoDashboardPeriodBuilder
    implements Builder<GeoDashboardPeriod, GeoDashboardPeriodBuilder> {
  _$GeoDashboardPeriod? _$v;

  Date? _from;
  Date? get from => _$this._from;
  set from(Date? from) => _$this._from = from;

  Date? _to;
  Date? get to => _$this._to;
  set to(Date? to) => _$this._to = to;

  GeoDashboardPeriodGranularityEnum? _granularity;
  GeoDashboardPeriodGranularityEnum? get granularity => _$this._granularity;
  set granularity(GeoDashboardPeriodGranularityEnum? granularity) =>
      _$this._granularity = granularity;

  GeoDashboardPeriodBuilder() {
    GeoDashboardPeriod._defaults(this);
  }

  GeoDashboardPeriodBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _from = $v.from;
      _to = $v.to;
      _granularity = $v.granularity;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(GeoDashboardPeriod other) {
    _$v = other as _$GeoDashboardPeriod;
  }

  @override
  void update(void Function(GeoDashboardPeriodBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  GeoDashboardPeriod build() => _build();

  _$GeoDashboardPeriod _build() {
    final _$result = _$v ??
        _$GeoDashboardPeriod._(
          from: BuiltValueNullFieldError.checkNotNull(
              from, r'GeoDashboardPeriod', 'from'),
          to: BuiltValueNullFieldError.checkNotNull(
              to, r'GeoDashboardPeriod', 'to'),
          granularity: BuiltValueNullFieldError.checkNotNull(
              granularity, r'GeoDashboardPeriod', 'granularity'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
