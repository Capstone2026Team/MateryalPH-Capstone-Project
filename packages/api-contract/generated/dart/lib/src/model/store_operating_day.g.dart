// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'store_operating_day.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const StoreOperatingDayStatusEnum _$storeOperatingDayStatusEnum_OPEN =
    const StoreOperatingDayStatusEnum._('OPEN');
const StoreOperatingDayStatusEnum _$storeOperatingDayStatusEnum_CLOSED =
    const StoreOperatingDayStatusEnum._('CLOSED');

StoreOperatingDayStatusEnum _$storeOperatingDayStatusEnumValueOf(String name) {
  switch (name) {
    case 'OPEN':
      return _$storeOperatingDayStatusEnum_OPEN;
    case 'CLOSED':
      return _$storeOperatingDayStatusEnum_CLOSED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<StoreOperatingDayStatusEnum>
    _$storeOperatingDayStatusEnumValues =
    BuiltSet<StoreOperatingDayStatusEnum>(const <StoreOperatingDayStatusEnum>[
  _$storeOperatingDayStatusEnum_OPEN,
  _$storeOperatingDayStatusEnum_CLOSED,
]);

Serializer<StoreOperatingDayStatusEnum>
    _$storeOperatingDayStatusEnumSerializer =
    _$StoreOperatingDayStatusEnumSerializer();

class _$StoreOperatingDayStatusEnumSerializer
    implements PrimitiveSerializer<StoreOperatingDayStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'OPEN': 'OPEN',
    'CLOSED': 'CLOSED',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'OPEN': 'OPEN',
    'CLOSED': 'CLOSED',
  };

  @override
  final Iterable<Type> types = const <Type>[StoreOperatingDayStatusEnum];
  @override
  final String wireName = 'StoreOperatingDayStatusEnum';

  @override
  Object serialize(Serializers serializers, StoreOperatingDayStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  StoreOperatingDayStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      StoreOperatingDayStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$StoreOperatingDay extends StoreOperatingDay {
  @override
  final int dayOfWeek;
  @override
  final StoreOperatingDayStatusEnum status;
  @override
  final String? opensAt;
  @override
  final String? closesAt;

  factory _$StoreOperatingDay(
          [void Function(StoreOperatingDayBuilder)? updates]) =>
      (StoreOperatingDayBuilder()..update(updates))._build();

  _$StoreOperatingDay._(
      {required this.dayOfWeek,
      required this.status,
      this.opensAt,
      this.closesAt})
      : super._();
  @override
  StoreOperatingDay rebuild(void Function(StoreOperatingDayBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  StoreOperatingDayBuilder toBuilder() =>
      StoreOperatingDayBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is StoreOperatingDay &&
        dayOfWeek == other.dayOfWeek &&
        status == other.status &&
        opensAt == other.opensAt &&
        closesAt == other.closesAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, dayOfWeek.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, opensAt.hashCode);
    _$hash = $jc(_$hash, closesAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'StoreOperatingDay')
          ..add('dayOfWeek', dayOfWeek)
          ..add('status', status)
          ..add('opensAt', opensAt)
          ..add('closesAt', closesAt))
        .toString();
  }
}

class StoreOperatingDayBuilder
    implements Builder<StoreOperatingDay, StoreOperatingDayBuilder> {
  _$StoreOperatingDay? _$v;

  int? _dayOfWeek;
  int? get dayOfWeek => _$this._dayOfWeek;
  set dayOfWeek(int? dayOfWeek) => _$this._dayOfWeek = dayOfWeek;

  StoreOperatingDayStatusEnum? _status;
  StoreOperatingDayStatusEnum? get status => _$this._status;
  set status(StoreOperatingDayStatusEnum? status) => _$this._status = status;

  String? _opensAt;
  String? get opensAt => _$this._opensAt;
  set opensAt(String? opensAt) => _$this._opensAt = opensAt;

  String? _closesAt;
  String? get closesAt => _$this._closesAt;
  set closesAt(String? closesAt) => _$this._closesAt = closesAt;

  StoreOperatingDayBuilder() {
    StoreOperatingDay._defaults(this);
  }

  StoreOperatingDayBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _dayOfWeek = $v.dayOfWeek;
      _status = $v.status;
      _opensAt = $v.opensAt;
      _closesAt = $v.closesAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(StoreOperatingDay other) {
    _$v = other as _$StoreOperatingDay;
  }

  @override
  void update(void Function(StoreOperatingDayBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  StoreOperatingDay build() => _build();

  _$StoreOperatingDay _build() {
    final _$result = _$v ??
        _$StoreOperatingDay._(
          dayOfWeek: BuiltValueNullFieldError.checkNotNull(
              dayOfWeek, r'StoreOperatingDay', 'dayOfWeek'),
          status: BuiltValueNullFieldError.checkNotNull(
              status, r'StoreOperatingDay', 'status'),
          opensAt: opensAt,
          closesAt: closesAt,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
