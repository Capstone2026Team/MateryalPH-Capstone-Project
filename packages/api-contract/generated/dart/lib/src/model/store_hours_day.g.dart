// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'store_hours_day.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const StoreHoursDayStatusEnum _$storeHoursDayStatusEnum_OPEN =
    const StoreHoursDayStatusEnum._('OPEN');
const StoreHoursDayStatusEnum _$storeHoursDayStatusEnum_CLOSED =
    const StoreHoursDayStatusEnum._('CLOSED');

StoreHoursDayStatusEnum _$storeHoursDayStatusEnumValueOf(String name) {
  switch (name) {
    case 'OPEN':
      return _$storeHoursDayStatusEnum_OPEN;
    case 'CLOSED':
      return _$storeHoursDayStatusEnum_CLOSED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<StoreHoursDayStatusEnum> _$storeHoursDayStatusEnumValues =
    BuiltSet<StoreHoursDayStatusEnum>(const <StoreHoursDayStatusEnum>[
  _$storeHoursDayStatusEnum_OPEN,
  _$storeHoursDayStatusEnum_CLOSED,
]);

const StoreHoursDaySource_Enum _$storeHoursDaySourceEnum_WEEKLY =
    const StoreHoursDaySource_Enum._('WEEKLY');
const StoreHoursDaySource_Enum _$storeHoursDaySourceEnum_DATE_OVERRIDE =
    const StoreHoursDaySource_Enum._('DATE_OVERRIDE');

StoreHoursDaySource_Enum _$storeHoursDaySourceEnumValueOf(String name) {
  switch (name) {
    case 'WEEKLY':
      return _$storeHoursDaySourceEnum_WEEKLY;
    case 'DATE_OVERRIDE':
      return _$storeHoursDaySourceEnum_DATE_OVERRIDE;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<StoreHoursDaySource_Enum> _$storeHoursDaySourceEnumValues =
    BuiltSet<StoreHoursDaySource_Enum>(const <StoreHoursDaySource_Enum>[
  _$storeHoursDaySourceEnum_WEEKLY,
  _$storeHoursDaySourceEnum_DATE_OVERRIDE,
]);

Serializer<StoreHoursDayStatusEnum> _$storeHoursDayStatusEnumSerializer =
    _$StoreHoursDayStatusEnumSerializer();
Serializer<StoreHoursDaySource_Enum> _$storeHoursDaySourceEnumSerializer =
    _$StoreHoursDaySource_EnumSerializer();

class _$StoreHoursDayStatusEnumSerializer
    implements PrimitiveSerializer<StoreHoursDayStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'OPEN': 'OPEN',
    'CLOSED': 'CLOSED',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'OPEN': 'OPEN',
    'CLOSED': 'CLOSED',
  };

  @override
  final Iterable<Type> types = const <Type>[StoreHoursDayStatusEnum];
  @override
  final String wireName = 'StoreHoursDayStatusEnum';

  @override
  Object serialize(Serializers serializers, StoreHoursDayStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  StoreHoursDayStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      StoreHoursDayStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$StoreHoursDaySource_EnumSerializer
    implements PrimitiveSerializer<StoreHoursDaySource_Enum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'WEEKLY': 'WEEKLY',
    'DATE_OVERRIDE': 'DATE_OVERRIDE',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'WEEKLY': 'WEEKLY',
    'DATE_OVERRIDE': 'DATE_OVERRIDE',
  };

  @override
  final Iterable<Type> types = const <Type>[StoreHoursDaySource_Enum];
  @override
  final String wireName = 'StoreHoursDaySource_Enum';

  @override
  Object serialize(Serializers serializers, StoreHoursDaySource_Enum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  StoreHoursDaySource_Enum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      StoreHoursDaySource_Enum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$StoreHoursDay extends StoreHoursDay {
  @override
  final Date date;
  @override
  final int dayOfWeek;
  @override
  final String weekday;
  @override
  final StoreHoursDayStatusEnum status;
  @override
  final String? opensAt;
  @override
  final String? closesAt;
  @override
  final StoreHoursDaySource_Enum source_;

  factory _$StoreHoursDay([void Function(StoreHoursDayBuilder)? updates]) =>
      (StoreHoursDayBuilder()..update(updates))._build();

  _$StoreHoursDay._(
      {required this.date,
      required this.dayOfWeek,
      required this.weekday,
      required this.status,
      this.opensAt,
      this.closesAt,
      required this.source_})
      : super._();
  @override
  StoreHoursDay rebuild(void Function(StoreHoursDayBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  StoreHoursDayBuilder toBuilder() => StoreHoursDayBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is StoreHoursDay &&
        date == other.date &&
        dayOfWeek == other.dayOfWeek &&
        weekday == other.weekday &&
        status == other.status &&
        opensAt == other.opensAt &&
        closesAt == other.closesAt &&
        source_ == other.source_;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, date.hashCode);
    _$hash = $jc(_$hash, dayOfWeek.hashCode);
    _$hash = $jc(_$hash, weekday.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, opensAt.hashCode);
    _$hash = $jc(_$hash, closesAt.hashCode);
    _$hash = $jc(_$hash, source_.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'StoreHoursDay')
          ..add('date', date)
          ..add('dayOfWeek', dayOfWeek)
          ..add('weekday', weekday)
          ..add('status', status)
          ..add('opensAt', opensAt)
          ..add('closesAt', closesAt)
          ..add('source_', source_))
        .toString();
  }
}

class StoreHoursDayBuilder
    implements Builder<StoreHoursDay, StoreHoursDayBuilder> {
  _$StoreHoursDay? _$v;

  Date? _date;
  Date? get date => _$this._date;
  set date(Date? date) => _$this._date = date;

  int? _dayOfWeek;
  int? get dayOfWeek => _$this._dayOfWeek;
  set dayOfWeek(int? dayOfWeek) => _$this._dayOfWeek = dayOfWeek;

  String? _weekday;
  String? get weekday => _$this._weekday;
  set weekday(String? weekday) => _$this._weekday = weekday;

  StoreHoursDayStatusEnum? _status;
  StoreHoursDayStatusEnum? get status => _$this._status;
  set status(StoreHoursDayStatusEnum? status) => _$this._status = status;

  String? _opensAt;
  String? get opensAt => _$this._opensAt;
  set opensAt(String? opensAt) => _$this._opensAt = opensAt;

  String? _closesAt;
  String? get closesAt => _$this._closesAt;
  set closesAt(String? closesAt) => _$this._closesAt = closesAt;

  StoreHoursDaySource_Enum? _source_;
  StoreHoursDaySource_Enum? get source_ => _$this._source_;
  set source_(StoreHoursDaySource_Enum? source_) => _$this._source_ = source_;

  StoreHoursDayBuilder() {
    StoreHoursDay._defaults(this);
  }

  StoreHoursDayBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _date = $v.date;
      _dayOfWeek = $v.dayOfWeek;
      _weekday = $v.weekday;
      _status = $v.status;
      _opensAt = $v.opensAt;
      _closesAt = $v.closesAt;
      _source_ = $v.source_;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(StoreHoursDay other) {
    _$v = other as _$StoreHoursDay;
  }

  @override
  void update(void Function(StoreHoursDayBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  StoreHoursDay build() => _build();

  _$StoreHoursDay _build() {
    final _$result = _$v ??
        _$StoreHoursDay._(
          date: BuiltValueNullFieldError.checkNotNull(
              date, r'StoreHoursDay', 'date'),
          dayOfWeek: BuiltValueNullFieldError.checkNotNull(
              dayOfWeek, r'StoreHoursDay', 'dayOfWeek'),
          weekday: BuiltValueNullFieldError.checkNotNull(
              weekday, r'StoreHoursDay', 'weekday'),
          status: BuiltValueNullFieldError.checkNotNull(
              status, r'StoreHoursDay', 'status'),
          opensAt: opensAt,
          closesAt: closesAt,
          source_: BuiltValueNullFieldError.checkNotNull(
              source_, r'StoreHoursDay', 'source_'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
