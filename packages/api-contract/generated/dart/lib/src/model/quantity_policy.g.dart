// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quantity_policy.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const QuantityPolicyModeEnum _$quantityPolicyModeEnum_COUNT =
    const QuantityPolicyModeEnum._('COUNT');
const QuantityPolicyModeEnum _$quantityPolicyModeEnum_PACK =
    const QuantityPolicyModeEnum._('PACK');
const QuantityPolicyModeEnum _$quantityPolicyModeEnum_MEASURED =
    const QuantityPolicyModeEnum._('MEASURED');

QuantityPolicyModeEnum _$quantityPolicyModeEnumValueOf(String name) {
  switch (name) {
    case 'COUNT':
      return _$quantityPolicyModeEnum_COUNT;
    case 'PACK':
      return _$quantityPolicyModeEnum_PACK;
    case 'MEASURED':
      return _$quantityPolicyModeEnum_MEASURED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<QuantityPolicyModeEnum> _$quantityPolicyModeEnumValues =
    BuiltSet<QuantityPolicyModeEnum>(const <QuantityPolicyModeEnum>[
  _$quantityPolicyModeEnum_COUNT,
  _$quantityPolicyModeEnum_PACK,
  _$quantityPolicyModeEnum_MEASURED,
]);

Serializer<QuantityPolicyModeEnum> _$quantityPolicyModeEnumSerializer =
    _$QuantityPolicyModeEnumSerializer();

class _$QuantityPolicyModeEnumSerializer
    implements PrimitiveSerializer<QuantityPolicyModeEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'COUNT': 'COUNT',
    'PACK': 'PACK',
    'MEASURED': 'MEASURED',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'COUNT': 'COUNT',
    'PACK': 'PACK',
    'MEASURED': 'MEASURED',
  };

  @override
  final Iterable<Type> types = const <Type>[QuantityPolicyModeEnum];
  @override
  final String wireName = 'QuantityPolicyModeEnum';

  @override
  Object serialize(Serializers serializers, QuantityPolicyModeEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  QuantityPolicyModeEnum deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      QuantityPolicyModeEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$QuantityPolicy extends QuantityPolicy {
  @override
  final QuantityPolicyModeEnum mode;
  @override
  final String dimension;
  @override
  final int precision;
  @override
  final String step;

  factory _$QuantityPolicy([void Function(QuantityPolicyBuilder)? updates]) =>
      (QuantityPolicyBuilder()..update(updates))._build();

  _$QuantityPolicy._(
      {required this.mode,
      required this.dimension,
      required this.precision,
      required this.step})
      : super._();
  @override
  QuantityPolicy rebuild(void Function(QuantityPolicyBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  QuantityPolicyBuilder toBuilder() => QuantityPolicyBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is QuantityPolicy &&
        mode == other.mode &&
        dimension == other.dimension &&
        precision == other.precision &&
        step == other.step;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, mode.hashCode);
    _$hash = $jc(_$hash, dimension.hashCode);
    _$hash = $jc(_$hash, precision.hashCode);
    _$hash = $jc(_$hash, step.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'QuantityPolicy')
          ..add('mode', mode)
          ..add('dimension', dimension)
          ..add('precision', precision)
          ..add('step', step))
        .toString();
  }
}

class QuantityPolicyBuilder
    implements Builder<QuantityPolicy, QuantityPolicyBuilder> {
  _$QuantityPolicy? _$v;

  QuantityPolicyModeEnum? _mode;
  QuantityPolicyModeEnum? get mode => _$this._mode;
  set mode(QuantityPolicyModeEnum? mode) => _$this._mode = mode;

  String? _dimension;
  String? get dimension => _$this._dimension;
  set dimension(String? dimension) => _$this._dimension = dimension;

  int? _precision;
  int? get precision => _$this._precision;
  set precision(int? precision) => _$this._precision = precision;

  String? _step;
  String? get step => _$this._step;
  set step(String? step) => _$this._step = step;

  QuantityPolicyBuilder() {
    QuantityPolicy._defaults(this);
  }

  QuantityPolicyBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _mode = $v.mode;
      _dimension = $v.dimension;
      _precision = $v.precision;
      _step = $v.step;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(QuantityPolicy other) {
    _$v = other as _$QuantityPolicy;
  }

  @override
  void update(void Function(QuantityPolicyBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  QuantityPolicy build() => _build();

  _$QuantityPolicy _build() {
    final _$result = _$v ??
        _$QuantityPolicy._(
          mode: BuiltValueNullFieldError.checkNotNull(
              mode, r'QuantityPolicy', 'mode'),
          dimension: BuiltValueNullFieldError.checkNotNull(
              dimension, r'QuantityPolicy', 'dimension'),
          precision: BuiltValueNullFieldError.checkNotNull(
              precision, r'QuantityPolicy', 'precision'),
          step: BuiltValueNullFieldError.checkNotNull(
              step, r'QuantityPolicy', 'step'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
