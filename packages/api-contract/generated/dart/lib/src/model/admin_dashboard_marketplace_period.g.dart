// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_dashboard_marketplace_period.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminDashboardMarketplacePeriodGranularityEnum
    _$adminDashboardMarketplacePeriodGranularityEnum_DAY =
    const AdminDashboardMarketplacePeriodGranularityEnum._('DAY');
const AdminDashboardMarketplacePeriodGranularityEnum
    _$adminDashboardMarketplacePeriodGranularityEnum_WEEK =
    const AdminDashboardMarketplacePeriodGranularityEnum._('WEEK');
const AdminDashboardMarketplacePeriodGranularityEnum
    _$adminDashboardMarketplacePeriodGranularityEnum_MONTH =
    const AdminDashboardMarketplacePeriodGranularityEnum._('MONTH');

AdminDashboardMarketplacePeriodGranularityEnum
    _$adminDashboardMarketplacePeriodGranularityEnumValueOf(String name) {
  switch (name) {
    case 'DAY':
      return _$adminDashboardMarketplacePeriodGranularityEnum_DAY;
    case 'WEEK':
      return _$adminDashboardMarketplacePeriodGranularityEnum_WEEK;
    case 'MONTH':
      return _$adminDashboardMarketplacePeriodGranularityEnum_MONTH;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminDashboardMarketplacePeriodGranularityEnum>
    _$adminDashboardMarketplacePeriodGranularityEnumValues = BuiltSet<
        AdminDashboardMarketplacePeriodGranularityEnum>(const <AdminDashboardMarketplacePeriodGranularityEnum>[
  _$adminDashboardMarketplacePeriodGranularityEnum_DAY,
  _$adminDashboardMarketplacePeriodGranularityEnum_WEEK,
  _$adminDashboardMarketplacePeriodGranularityEnum_MONTH,
]);

Serializer<AdminDashboardMarketplacePeriodGranularityEnum>
    _$adminDashboardMarketplacePeriodGranularityEnumSerializer =
    _$AdminDashboardMarketplacePeriodGranularityEnumSerializer();

class _$AdminDashboardMarketplacePeriodGranularityEnumSerializer
    implements
        PrimitiveSerializer<AdminDashboardMarketplacePeriodGranularityEnum> {
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
  final Iterable<Type> types = const <Type>[
    AdminDashboardMarketplacePeriodGranularityEnum
  ];
  @override
  final String wireName = 'AdminDashboardMarketplacePeriodGranularityEnum';

  @override
  Object serialize(Serializers serializers,
          AdminDashboardMarketplacePeriodGranularityEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  AdminDashboardMarketplacePeriodGranularityEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      AdminDashboardMarketplacePeriodGranularityEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$AdminDashboardMarketplacePeriod
    extends AdminDashboardMarketplacePeriod {
  @override
  final Date from;
  @override
  final Date to;
  @override
  final AdminDashboardMarketplacePeriodGranularityEnum granularity;
  @override
  final int days;

  factory _$AdminDashboardMarketplacePeriod(
          [void Function(AdminDashboardMarketplacePeriodBuilder)? updates]) =>
      (AdminDashboardMarketplacePeriodBuilder()..update(updates))._build();

  _$AdminDashboardMarketplacePeriod._(
      {required this.from,
      required this.to,
      required this.granularity,
      required this.days})
      : super._();
  @override
  AdminDashboardMarketplacePeriod rebuild(
          void Function(AdminDashboardMarketplacePeriodBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AdminDashboardMarketplacePeriodBuilder toBuilder() =>
      AdminDashboardMarketplacePeriodBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminDashboardMarketplacePeriod &&
        from == other.from &&
        to == other.to &&
        granularity == other.granularity &&
        days == other.days;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, from.hashCode);
    _$hash = $jc(_$hash, to.hashCode);
    _$hash = $jc(_$hash, granularity.hashCode);
    _$hash = $jc(_$hash, days.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminDashboardMarketplacePeriod')
          ..add('from', from)
          ..add('to', to)
          ..add('granularity', granularity)
          ..add('days', days))
        .toString();
  }
}

class AdminDashboardMarketplacePeriodBuilder
    implements
        Builder<AdminDashboardMarketplacePeriod,
            AdminDashboardMarketplacePeriodBuilder> {
  _$AdminDashboardMarketplacePeriod? _$v;

  Date? _from;
  Date? get from => _$this._from;
  set from(Date? from) => _$this._from = from;

  Date? _to;
  Date? get to => _$this._to;
  set to(Date? to) => _$this._to = to;

  AdminDashboardMarketplacePeriodGranularityEnum? _granularity;
  AdminDashboardMarketplacePeriodGranularityEnum? get granularity =>
      _$this._granularity;
  set granularity(
          AdminDashboardMarketplacePeriodGranularityEnum? granularity) =>
      _$this._granularity = granularity;

  int? _days;
  int? get days => _$this._days;
  set days(int? days) => _$this._days = days;

  AdminDashboardMarketplacePeriodBuilder() {
    AdminDashboardMarketplacePeriod._defaults(this);
  }

  AdminDashboardMarketplacePeriodBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _from = $v.from;
      _to = $v.to;
      _granularity = $v.granularity;
      _days = $v.days;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminDashboardMarketplacePeriod other) {
    _$v = other as _$AdminDashboardMarketplacePeriod;
  }

  @override
  void update(void Function(AdminDashboardMarketplacePeriodBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminDashboardMarketplacePeriod build() => _build();

  _$AdminDashboardMarketplacePeriod _build() {
    final _$result = _$v ??
        _$AdminDashboardMarketplacePeriod._(
          from: BuiltValueNullFieldError.checkNotNull(
              from, r'AdminDashboardMarketplacePeriod', 'from'),
          to: BuiltValueNullFieldError.checkNotNull(
              to, r'AdminDashboardMarketplacePeriod', 'to'),
          granularity: BuiltValueNullFieldError.checkNotNull(
              granularity, r'AdminDashboardMarketplacePeriod', 'granularity'),
          days: BuiltValueNullFieldError.checkNotNull(
              days, r'AdminDashboardMarketplacePeriod', 'days'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
