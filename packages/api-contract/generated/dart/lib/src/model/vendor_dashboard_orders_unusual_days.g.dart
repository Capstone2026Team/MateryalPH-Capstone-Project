// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_dashboard_orders_unusual_days.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const VendorDashboardOrdersUnusualDaysStateEnum
    _$vendorDashboardOrdersUnusualDaysStateEnum_OK =
    const VendorDashboardOrdersUnusualDaysStateEnum._('OK');
const VendorDashboardOrdersUnusualDaysStateEnum
    _$vendorDashboardOrdersUnusualDaysStateEnum_INSUFFICIENT_DATA =
    const VendorDashboardOrdersUnusualDaysStateEnum._('INSUFFICIENT_DATA');

VendorDashboardOrdersUnusualDaysStateEnum
    _$vendorDashboardOrdersUnusualDaysStateEnumValueOf(String name) {
  switch (name) {
    case 'OK':
      return _$vendorDashboardOrdersUnusualDaysStateEnum_OK;
    case 'INSUFFICIENT_DATA':
      return _$vendorDashboardOrdersUnusualDaysStateEnum_INSUFFICIENT_DATA;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<VendorDashboardOrdersUnusualDaysStateEnum>
    _$vendorDashboardOrdersUnusualDaysStateEnumValues = BuiltSet<
        VendorDashboardOrdersUnusualDaysStateEnum>(const <VendorDashboardOrdersUnusualDaysStateEnum>[
  _$vendorDashboardOrdersUnusualDaysStateEnum_OK,
  _$vendorDashboardOrdersUnusualDaysStateEnum_INSUFFICIENT_DATA,
]);

Serializer<VendorDashboardOrdersUnusualDaysStateEnum>
    _$vendorDashboardOrdersUnusualDaysStateEnumSerializer =
    _$VendorDashboardOrdersUnusualDaysStateEnumSerializer();

class _$VendorDashboardOrdersUnusualDaysStateEnumSerializer
    implements PrimitiveSerializer<VendorDashboardOrdersUnusualDaysStateEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'OK': 'OK',
    'INSUFFICIENT_DATA': 'INSUFFICIENT_DATA',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'OK': 'OK',
    'INSUFFICIENT_DATA': 'INSUFFICIENT_DATA',
  };

  @override
  final Iterable<Type> types = const <Type>[
    VendorDashboardOrdersUnusualDaysStateEnum
  ];
  @override
  final String wireName = 'VendorDashboardOrdersUnusualDaysStateEnum';

  @override
  Object serialize(Serializers serializers,
          VendorDashboardOrdersUnusualDaysStateEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  VendorDashboardOrdersUnusualDaysStateEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      VendorDashboardOrdersUnusualDaysStateEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$VendorDashboardOrdersUnusualDays
    extends VendorDashboardOrdersUnusualDays {
  @override
  final VendorDashboardOrdersUnusualDaysStateEnum state;
  @override
  final num? epsilon;
  @override
  final BuiltList<VendorDashboardOrdersUnusualDaysDaysInner> days;

  factory _$VendorDashboardOrdersUnusualDays(
          [void Function(VendorDashboardOrdersUnusualDaysBuilder)? updates]) =>
      (VendorDashboardOrdersUnusualDaysBuilder()..update(updates))._build();

  _$VendorDashboardOrdersUnusualDays._(
      {required this.state, this.epsilon, required this.days})
      : super._();
  @override
  VendorDashboardOrdersUnusualDays rebuild(
          void Function(VendorDashboardOrdersUnusualDaysBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  VendorDashboardOrdersUnusualDaysBuilder toBuilder() =>
      VendorDashboardOrdersUnusualDaysBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is VendorDashboardOrdersUnusualDays &&
        state == other.state &&
        epsilon == other.epsilon &&
        days == other.days;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, state.hashCode);
    _$hash = $jc(_$hash, epsilon.hashCode);
    _$hash = $jc(_$hash, days.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'VendorDashboardOrdersUnusualDays')
          ..add('state', state)
          ..add('epsilon', epsilon)
          ..add('days', days))
        .toString();
  }
}

class VendorDashboardOrdersUnusualDaysBuilder
    implements
        Builder<VendorDashboardOrdersUnusualDays,
            VendorDashboardOrdersUnusualDaysBuilder> {
  _$VendorDashboardOrdersUnusualDays? _$v;

  VendorDashboardOrdersUnusualDaysStateEnum? _state;
  VendorDashboardOrdersUnusualDaysStateEnum? get state => _$this._state;
  set state(VendorDashboardOrdersUnusualDaysStateEnum? state) =>
      _$this._state = state;

  num? _epsilon;
  num? get epsilon => _$this._epsilon;
  set epsilon(num? epsilon) => _$this._epsilon = epsilon;

  ListBuilder<VendorDashboardOrdersUnusualDaysDaysInner>? _days;
  ListBuilder<VendorDashboardOrdersUnusualDaysDaysInner> get days =>
      _$this._days ??= ListBuilder<VendorDashboardOrdersUnusualDaysDaysInner>();
  set days(ListBuilder<VendorDashboardOrdersUnusualDaysDaysInner>? days) =>
      _$this._days = days;

  VendorDashboardOrdersUnusualDaysBuilder() {
    VendorDashboardOrdersUnusualDays._defaults(this);
  }

  VendorDashboardOrdersUnusualDaysBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _state = $v.state;
      _epsilon = $v.epsilon;
      _days = $v.days.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(VendorDashboardOrdersUnusualDays other) {
    _$v = other as _$VendorDashboardOrdersUnusualDays;
  }

  @override
  void update(void Function(VendorDashboardOrdersUnusualDaysBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  VendorDashboardOrdersUnusualDays build() => _build();

  _$VendorDashboardOrdersUnusualDays _build() {
    _$VendorDashboardOrdersUnusualDays _$result;
    try {
      _$result = _$v ??
          _$VendorDashboardOrdersUnusualDays._(
            state: BuiltValueNullFieldError.checkNotNull(
                state, r'VendorDashboardOrdersUnusualDays', 'state'),
            epsilon: epsilon,
            days: days.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'days';
        days.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'VendorDashboardOrdersUnusualDays', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
