// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_earnings_trend.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const VendorEarningsTrendGranularityEnum
    _$vendorEarningsTrendGranularityEnum_DAY =
    const VendorEarningsTrendGranularityEnum._('DAY');
const VendorEarningsTrendGranularityEnum
    _$vendorEarningsTrendGranularityEnum_MONTH =
    const VendorEarningsTrendGranularityEnum._('MONTH');

VendorEarningsTrendGranularityEnum _$vendorEarningsTrendGranularityEnumValueOf(
    String name) {
  switch (name) {
    case 'DAY':
      return _$vendorEarningsTrendGranularityEnum_DAY;
    case 'MONTH':
      return _$vendorEarningsTrendGranularityEnum_MONTH;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<VendorEarningsTrendGranularityEnum>
    _$vendorEarningsTrendGranularityEnumValues = BuiltSet<
        VendorEarningsTrendGranularityEnum>(const <VendorEarningsTrendGranularityEnum>[
  _$vendorEarningsTrendGranularityEnum_DAY,
  _$vendorEarningsTrendGranularityEnum_MONTH,
]);

Serializer<VendorEarningsTrendGranularityEnum>
    _$vendorEarningsTrendGranularityEnumSerializer =
    _$VendorEarningsTrendGranularityEnumSerializer();

class _$VendorEarningsTrendGranularityEnumSerializer
    implements PrimitiveSerializer<VendorEarningsTrendGranularityEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'DAY': 'DAY',
    'MONTH': 'MONTH',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'DAY': 'DAY',
    'MONTH': 'MONTH',
  };

  @override
  final Iterable<Type> types = const <Type>[VendorEarningsTrendGranularityEnum];
  @override
  final String wireName = 'VendorEarningsTrendGranularityEnum';

  @override
  Object serialize(
          Serializers serializers, VendorEarningsTrendGranularityEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  VendorEarningsTrendGranularityEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      VendorEarningsTrendGranularityEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$VendorEarningsTrend extends VendorEarningsTrend {
  @override
  final VendorEarningsTrendGranularityEnum granularity;
  @override
  final String timezone;
  @override
  final Date from;
  @override
  final Date to;
  @override
  final int days;
  @override
  final BuiltList<VendorEarningsTrendPoint> points;
  @override
  final VendorEarningsTrendComparison? previous;

  factory _$VendorEarningsTrend(
          [void Function(VendorEarningsTrendBuilder)? updates]) =>
      (VendorEarningsTrendBuilder()..update(updates))._build();

  _$VendorEarningsTrend._(
      {required this.granularity,
      required this.timezone,
      required this.from,
      required this.to,
      required this.days,
      required this.points,
      this.previous})
      : super._();
  @override
  VendorEarningsTrend rebuild(
          void Function(VendorEarningsTrendBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  VendorEarningsTrendBuilder toBuilder() =>
      VendorEarningsTrendBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is VendorEarningsTrend &&
        granularity == other.granularity &&
        timezone == other.timezone &&
        from == other.from &&
        to == other.to &&
        days == other.days &&
        points == other.points &&
        previous == other.previous;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, granularity.hashCode);
    _$hash = $jc(_$hash, timezone.hashCode);
    _$hash = $jc(_$hash, from.hashCode);
    _$hash = $jc(_$hash, to.hashCode);
    _$hash = $jc(_$hash, days.hashCode);
    _$hash = $jc(_$hash, points.hashCode);
    _$hash = $jc(_$hash, previous.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'VendorEarningsTrend')
          ..add('granularity', granularity)
          ..add('timezone', timezone)
          ..add('from', from)
          ..add('to', to)
          ..add('days', days)
          ..add('points', points)
          ..add('previous', previous))
        .toString();
  }
}

class VendorEarningsTrendBuilder
    implements Builder<VendorEarningsTrend, VendorEarningsTrendBuilder> {
  _$VendorEarningsTrend? _$v;

  VendorEarningsTrendGranularityEnum? _granularity;
  VendorEarningsTrendGranularityEnum? get granularity => _$this._granularity;
  set granularity(VendorEarningsTrendGranularityEnum? granularity) =>
      _$this._granularity = granularity;

  String? _timezone;
  String? get timezone => _$this._timezone;
  set timezone(String? timezone) => _$this._timezone = timezone;

  Date? _from;
  Date? get from => _$this._from;
  set from(Date? from) => _$this._from = from;

  Date? _to;
  Date? get to => _$this._to;
  set to(Date? to) => _$this._to = to;

  int? _days;
  int? get days => _$this._days;
  set days(int? days) => _$this._days = days;

  ListBuilder<VendorEarningsTrendPoint>? _points;
  ListBuilder<VendorEarningsTrendPoint> get points =>
      _$this._points ??= ListBuilder<VendorEarningsTrendPoint>();
  set points(ListBuilder<VendorEarningsTrendPoint>? points) =>
      _$this._points = points;

  VendorEarningsTrendComparisonBuilder? _previous;
  VendorEarningsTrendComparisonBuilder get previous =>
      _$this._previous ??= VendorEarningsTrendComparisonBuilder();
  set previous(VendorEarningsTrendComparisonBuilder? previous) =>
      _$this._previous = previous;

  VendorEarningsTrendBuilder() {
    VendorEarningsTrend._defaults(this);
  }

  VendorEarningsTrendBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _granularity = $v.granularity;
      _timezone = $v.timezone;
      _from = $v.from;
      _to = $v.to;
      _days = $v.days;
      _points = $v.points.toBuilder();
      _previous = $v.previous?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(VendorEarningsTrend other) {
    _$v = other as _$VendorEarningsTrend;
  }

  @override
  void update(void Function(VendorEarningsTrendBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  VendorEarningsTrend build() => _build();

  _$VendorEarningsTrend _build() {
    _$VendorEarningsTrend _$result;
    try {
      _$result = _$v ??
          _$VendorEarningsTrend._(
            granularity: BuiltValueNullFieldError.checkNotNull(
                granularity, r'VendorEarningsTrend', 'granularity'),
            timezone: BuiltValueNullFieldError.checkNotNull(
                timezone, r'VendorEarningsTrend', 'timezone'),
            from: BuiltValueNullFieldError.checkNotNull(
                from, r'VendorEarningsTrend', 'from'),
            to: BuiltValueNullFieldError.checkNotNull(
                to, r'VendorEarningsTrend', 'to'),
            days: BuiltValueNullFieldError.checkNotNull(
                days, r'VendorEarningsTrend', 'days'),
            points: points.build(),
            previous: _previous?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'points';
        points.build();
        _$failedField = 'previous';
        _previous?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'VendorEarningsTrend', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
