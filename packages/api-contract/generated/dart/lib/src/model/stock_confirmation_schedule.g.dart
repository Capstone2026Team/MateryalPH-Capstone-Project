// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stock_confirmation_schedule.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const StockConfirmationScheduleStateEnum
    _$stockConfirmationScheduleStateEnum_CONFIRMED =
    const StockConfirmationScheduleStateEnum._('CONFIRMED');
const StockConfirmationScheduleStateEnum
    _$stockConfirmationScheduleStateEnum_REMINDER =
    const StockConfirmationScheduleStateEnum._('REMINDER');
const StockConfirmationScheduleStateEnum
    _$stockConfirmationScheduleStateEnum_FINAL_REMINDER =
    const StockConfirmationScheduleStateEnum._('FINAL_REMINDER');
const StockConfirmationScheduleStateEnum
    _$stockConfirmationScheduleStateEnum_OVERDUE =
    const StockConfirmationScheduleStateEnum._('OVERDUE');
const StockConfirmationScheduleStateEnum
    _$stockConfirmationScheduleStateEnum_NOT_CONFIRMED =
    const StockConfirmationScheduleStateEnum._('NOT_CONFIRMED');

StockConfirmationScheduleStateEnum _$stockConfirmationScheduleStateEnumValueOf(
    String name) {
  switch (name) {
    case 'CONFIRMED':
      return _$stockConfirmationScheduleStateEnum_CONFIRMED;
    case 'REMINDER':
      return _$stockConfirmationScheduleStateEnum_REMINDER;
    case 'FINAL_REMINDER':
      return _$stockConfirmationScheduleStateEnum_FINAL_REMINDER;
    case 'OVERDUE':
      return _$stockConfirmationScheduleStateEnum_OVERDUE;
    case 'NOT_CONFIRMED':
      return _$stockConfirmationScheduleStateEnum_NOT_CONFIRMED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<StockConfirmationScheduleStateEnum>
    _$stockConfirmationScheduleStateEnumValues = BuiltSet<
        StockConfirmationScheduleStateEnum>(const <StockConfirmationScheduleStateEnum>[
  _$stockConfirmationScheduleStateEnum_CONFIRMED,
  _$stockConfirmationScheduleStateEnum_REMINDER,
  _$stockConfirmationScheduleStateEnum_FINAL_REMINDER,
  _$stockConfirmationScheduleStateEnum_OVERDUE,
  _$stockConfirmationScheduleStateEnum_NOT_CONFIRMED,
]);

Serializer<StockConfirmationScheduleStateEnum>
    _$stockConfirmationScheduleStateEnumSerializer =
    _$StockConfirmationScheduleStateEnumSerializer();

class _$StockConfirmationScheduleStateEnumSerializer
    implements PrimitiveSerializer<StockConfirmationScheduleStateEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'CONFIRMED': 'CONFIRMED',
    'REMINDER': 'REMINDER',
    'FINAL_REMINDER': 'FINAL_REMINDER',
    'OVERDUE': 'OVERDUE',
    'NOT_CONFIRMED': 'NOT_CONFIRMED',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'CONFIRMED': 'CONFIRMED',
    'REMINDER': 'REMINDER',
    'FINAL_REMINDER': 'FINAL_REMINDER',
    'OVERDUE': 'OVERDUE',
    'NOT_CONFIRMED': 'NOT_CONFIRMED',
  };

  @override
  final Iterable<Type> types = const <Type>[StockConfirmationScheduleStateEnum];
  @override
  final String wireName = 'StockConfirmationScheduleStateEnum';

  @override
  Object serialize(
          Serializers serializers, StockConfirmationScheduleStateEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  StockConfirmationScheduleStateEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      StockConfirmationScheduleStateEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$StockConfirmationSchedule extends StockConfirmationSchedule {
  @override
  final StockConfirmationScheduleStateEnum state;
  @override
  final DateTime? confirmedAt;
  @override
  final DateTime? firstReminderAt;
  @override
  final DateTime? finalReminderAt;
  @override
  final DateTime? hideAt;
  @override
  final int? daysSinceConfirmation;

  factory _$StockConfirmationSchedule(
          [void Function(StockConfirmationScheduleBuilder)? updates]) =>
      (StockConfirmationScheduleBuilder()..update(updates))._build();

  _$StockConfirmationSchedule._(
      {required this.state,
      this.confirmedAt,
      this.firstReminderAt,
      this.finalReminderAt,
      this.hideAt,
      this.daysSinceConfirmation})
      : super._();
  @override
  StockConfirmationSchedule rebuild(
          void Function(StockConfirmationScheduleBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  StockConfirmationScheduleBuilder toBuilder() =>
      StockConfirmationScheduleBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is StockConfirmationSchedule &&
        state == other.state &&
        confirmedAt == other.confirmedAt &&
        firstReminderAt == other.firstReminderAt &&
        finalReminderAt == other.finalReminderAt &&
        hideAt == other.hideAt &&
        daysSinceConfirmation == other.daysSinceConfirmation;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, state.hashCode);
    _$hash = $jc(_$hash, confirmedAt.hashCode);
    _$hash = $jc(_$hash, firstReminderAt.hashCode);
    _$hash = $jc(_$hash, finalReminderAt.hashCode);
    _$hash = $jc(_$hash, hideAt.hashCode);
    _$hash = $jc(_$hash, daysSinceConfirmation.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'StockConfirmationSchedule')
          ..add('state', state)
          ..add('confirmedAt', confirmedAt)
          ..add('firstReminderAt', firstReminderAt)
          ..add('finalReminderAt', finalReminderAt)
          ..add('hideAt', hideAt)
          ..add('daysSinceConfirmation', daysSinceConfirmation))
        .toString();
  }
}

class StockConfirmationScheduleBuilder
    implements
        Builder<StockConfirmationSchedule, StockConfirmationScheduleBuilder> {
  _$StockConfirmationSchedule? _$v;

  StockConfirmationScheduleStateEnum? _state;
  StockConfirmationScheduleStateEnum? get state => _$this._state;
  set state(StockConfirmationScheduleStateEnum? state) => _$this._state = state;

  DateTime? _confirmedAt;
  DateTime? get confirmedAt => _$this._confirmedAt;
  set confirmedAt(DateTime? confirmedAt) => _$this._confirmedAt = confirmedAt;

  DateTime? _firstReminderAt;
  DateTime? get firstReminderAt => _$this._firstReminderAt;
  set firstReminderAt(DateTime? firstReminderAt) =>
      _$this._firstReminderAt = firstReminderAt;

  DateTime? _finalReminderAt;
  DateTime? get finalReminderAt => _$this._finalReminderAt;
  set finalReminderAt(DateTime? finalReminderAt) =>
      _$this._finalReminderAt = finalReminderAt;

  DateTime? _hideAt;
  DateTime? get hideAt => _$this._hideAt;
  set hideAt(DateTime? hideAt) => _$this._hideAt = hideAt;

  int? _daysSinceConfirmation;
  int? get daysSinceConfirmation => _$this._daysSinceConfirmation;
  set daysSinceConfirmation(int? daysSinceConfirmation) =>
      _$this._daysSinceConfirmation = daysSinceConfirmation;

  StockConfirmationScheduleBuilder() {
    StockConfirmationSchedule._defaults(this);
  }

  StockConfirmationScheduleBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _state = $v.state;
      _confirmedAt = $v.confirmedAt;
      _firstReminderAt = $v.firstReminderAt;
      _finalReminderAt = $v.finalReminderAt;
      _hideAt = $v.hideAt;
      _daysSinceConfirmation = $v.daysSinceConfirmation;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(StockConfirmationSchedule other) {
    _$v = other as _$StockConfirmationSchedule;
  }

  @override
  void update(void Function(StockConfirmationScheduleBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  StockConfirmationSchedule build() => _build();

  _$StockConfirmationSchedule _build() {
    final _$result = _$v ??
        _$StockConfirmationSchedule._(
          state: BuiltValueNullFieldError.checkNotNull(
              state, r'StockConfirmationSchedule', 'state'),
          confirmedAt: confirmedAt,
          firstReminderAt: firstReminderAt,
          finalReminderAt: finalReminderAt,
          hideAt: hideAt,
          daysSinceConfirmation: daysSinceConfirmation,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
