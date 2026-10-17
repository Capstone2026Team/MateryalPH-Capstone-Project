// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_product_analytics_detail_unusual_days.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const VendorProductAnalyticsDetailUnusualDaysStateEnum
    _$vendorProductAnalyticsDetailUnusualDaysStateEnum_OK =
    const VendorProductAnalyticsDetailUnusualDaysStateEnum._('OK');
const VendorProductAnalyticsDetailUnusualDaysStateEnum
    _$vendorProductAnalyticsDetailUnusualDaysStateEnum_INSUFFICIENT_DATA =
    const VendorProductAnalyticsDetailUnusualDaysStateEnum._(
        'INSUFFICIENT_DATA');

VendorProductAnalyticsDetailUnusualDaysStateEnum
    _$vendorProductAnalyticsDetailUnusualDaysStateEnumValueOf(String name) {
  switch (name) {
    case 'OK':
      return _$vendorProductAnalyticsDetailUnusualDaysStateEnum_OK;
    case 'INSUFFICIENT_DATA':
      return _$vendorProductAnalyticsDetailUnusualDaysStateEnum_INSUFFICIENT_DATA;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<VendorProductAnalyticsDetailUnusualDaysStateEnum>
    _$vendorProductAnalyticsDetailUnusualDaysStateEnumValues = BuiltSet<
        VendorProductAnalyticsDetailUnusualDaysStateEnum>(const <VendorProductAnalyticsDetailUnusualDaysStateEnum>[
  _$vendorProductAnalyticsDetailUnusualDaysStateEnum_OK,
  _$vendorProductAnalyticsDetailUnusualDaysStateEnum_INSUFFICIENT_DATA,
]);

Serializer<VendorProductAnalyticsDetailUnusualDaysStateEnum>
    _$vendorProductAnalyticsDetailUnusualDaysStateEnumSerializer =
    _$VendorProductAnalyticsDetailUnusualDaysStateEnumSerializer();

class _$VendorProductAnalyticsDetailUnusualDaysStateEnumSerializer
    implements
        PrimitiveSerializer<VendorProductAnalyticsDetailUnusualDaysStateEnum> {
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
    VendorProductAnalyticsDetailUnusualDaysStateEnum
  ];
  @override
  final String wireName = 'VendorProductAnalyticsDetailUnusualDaysStateEnum';

  @override
  Object serialize(Serializers serializers,
          VendorProductAnalyticsDetailUnusualDaysStateEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  VendorProductAnalyticsDetailUnusualDaysStateEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      VendorProductAnalyticsDetailUnusualDaysStateEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$VendorProductAnalyticsDetailUnusualDays
    extends VendorProductAnalyticsDetailUnusualDays {
  @override
  final VendorProductAnalyticsDetailUnusualDaysStateEnum state;
  @override
  final num? epsilon;
  @override
  final BuiltList<VendorProductAnalyticsDetailUnusualDaysDaysInner> days;

  factory _$VendorProductAnalyticsDetailUnusualDays(
          [void Function(VendorProductAnalyticsDetailUnusualDaysBuilder)?
              updates]) =>
      (VendorProductAnalyticsDetailUnusualDaysBuilder()..update(updates))
          ._build();

  _$VendorProductAnalyticsDetailUnusualDays._(
      {required this.state, this.epsilon, required this.days})
      : super._();
  @override
  VendorProductAnalyticsDetailUnusualDays rebuild(
          void Function(VendorProductAnalyticsDetailUnusualDaysBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  VendorProductAnalyticsDetailUnusualDaysBuilder toBuilder() =>
      VendorProductAnalyticsDetailUnusualDaysBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is VendorProductAnalyticsDetailUnusualDays &&
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
    return (newBuiltValueToStringHelper(
            r'VendorProductAnalyticsDetailUnusualDays')
          ..add('state', state)
          ..add('epsilon', epsilon)
          ..add('days', days))
        .toString();
  }
}

class VendorProductAnalyticsDetailUnusualDaysBuilder
    implements
        Builder<VendorProductAnalyticsDetailUnusualDays,
            VendorProductAnalyticsDetailUnusualDaysBuilder> {
  _$VendorProductAnalyticsDetailUnusualDays? _$v;

  VendorProductAnalyticsDetailUnusualDaysStateEnum? _state;
  VendorProductAnalyticsDetailUnusualDaysStateEnum? get state => _$this._state;
  set state(VendorProductAnalyticsDetailUnusualDaysStateEnum? state) =>
      _$this._state = state;

  num? _epsilon;
  num? get epsilon => _$this._epsilon;
  set epsilon(num? epsilon) => _$this._epsilon = epsilon;

  ListBuilder<VendorProductAnalyticsDetailUnusualDaysDaysInner>? _days;
  ListBuilder<VendorProductAnalyticsDetailUnusualDaysDaysInner> get days =>
      _$this._days ??=
          ListBuilder<VendorProductAnalyticsDetailUnusualDaysDaysInner>();
  set days(
          ListBuilder<VendorProductAnalyticsDetailUnusualDaysDaysInner>?
              days) =>
      _$this._days = days;

  VendorProductAnalyticsDetailUnusualDaysBuilder() {
    VendorProductAnalyticsDetailUnusualDays._defaults(this);
  }

  VendorProductAnalyticsDetailUnusualDaysBuilder get _$this {
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
  void replace(VendorProductAnalyticsDetailUnusualDays other) {
    _$v = other as _$VendorProductAnalyticsDetailUnusualDays;
  }

  @override
  void update(
      void Function(VendorProductAnalyticsDetailUnusualDaysBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  VendorProductAnalyticsDetailUnusualDays build() => _build();

  _$VendorProductAnalyticsDetailUnusualDays _build() {
    _$VendorProductAnalyticsDetailUnusualDays _$result;
    try {
      _$result = _$v ??
          _$VendorProductAnalyticsDetailUnusualDays._(
            state: BuiltValueNullFieldError.checkNotNull(
                state, r'VendorProductAnalyticsDetailUnusualDays', 'state'),
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
            r'VendorProductAnalyticsDetailUnusualDays',
            _$failedField,
            e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
