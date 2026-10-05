// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'badge_metric.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const BadgeMetricKeyEnum _$badgeMetricKeyEnum_CRR =
    const BadgeMetricKeyEnum._('CRR');
const BadgeMetricKeyEnum _$badgeMetricKeyEnum_FRR =
    const BadgeMetricKeyEnum._('FRR');

BadgeMetricKeyEnum _$badgeMetricKeyEnumValueOf(String name) {
  switch (name) {
    case 'CRR':
      return _$badgeMetricKeyEnum_CRR;
    case 'FRR':
      return _$badgeMetricKeyEnum_FRR;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<BadgeMetricKeyEnum> _$badgeMetricKeyEnumValues =
    BuiltSet<BadgeMetricKeyEnum>(const <BadgeMetricKeyEnum>[
  _$badgeMetricKeyEnum_CRR,
  _$badgeMetricKeyEnum_FRR,
]);

Serializer<BadgeMetricKeyEnum> _$badgeMetricKeyEnumSerializer =
    _$BadgeMetricKeyEnumSerializer();

class _$BadgeMetricKeyEnumSerializer
    implements PrimitiveSerializer<BadgeMetricKeyEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'CRR': 'CRR',
    'FRR': 'FRR',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'CRR': 'CRR',
    'FRR': 'FRR',
  };

  @override
  final Iterable<Type> types = const <Type>[BadgeMetricKeyEnum];
  @override
  final String wireName = 'BadgeMetricKeyEnum';

  @override
  Object serialize(Serializers serializers, BadgeMetricKeyEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  BadgeMetricKeyEnum deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      BadgeMetricKeyEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$BadgeMetric extends BadgeMetric {
  @override
  final BadgeMetricKeyEnum key;
  @override
  final String? value;
  @override
  final int sampleCount;
  @override
  final String window;
  @override
  final String definition;

  factory _$BadgeMetric([void Function(BadgeMetricBuilder)? updates]) =>
      (BadgeMetricBuilder()..update(updates))._build();

  _$BadgeMetric._(
      {required this.key,
      this.value,
      required this.sampleCount,
      required this.window,
      required this.definition})
      : super._();
  @override
  BadgeMetric rebuild(void Function(BadgeMetricBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  BadgeMetricBuilder toBuilder() => BadgeMetricBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is BadgeMetric &&
        key == other.key &&
        value == other.value &&
        sampleCount == other.sampleCount &&
        window == other.window &&
        definition == other.definition;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, key.hashCode);
    _$hash = $jc(_$hash, value.hashCode);
    _$hash = $jc(_$hash, sampleCount.hashCode);
    _$hash = $jc(_$hash, window.hashCode);
    _$hash = $jc(_$hash, definition.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'BadgeMetric')
          ..add('key', key)
          ..add('value', value)
          ..add('sampleCount', sampleCount)
          ..add('window', window)
          ..add('definition', definition))
        .toString();
  }
}

class BadgeMetricBuilder implements Builder<BadgeMetric, BadgeMetricBuilder> {
  _$BadgeMetric? _$v;

  BadgeMetricKeyEnum? _key;
  BadgeMetricKeyEnum? get key => _$this._key;
  set key(BadgeMetricKeyEnum? key) => _$this._key = key;

  String? _value;
  String? get value => _$this._value;
  set value(String? value) => _$this._value = value;

  int? _sampleCount;
  int? get sampleCount => _$this._sampleCount;
  set sampleCount(int? sampleCount) => _$this._sampleCount = sampleCount;

  String? _window;
  String? get window => _$this._window;
  set window(String? window) => _$this._window = window;

  String? _definition;
  String? get definition => _$this._definition;
  set definition(String? definition) => _$this._definition = definition;

  BadgeMetricBuilder() {
    BadgeMetric._defaults(this);
  }

  BadgeMetricBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _key = $v.key;
      _value = $v.value;
      _sampleCount = $v.sampleCount;
      _window = $v.window;
      _definition = $v.definition;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(BadgeMetric other) {
    _$v = other as _$BadgeMetric;
  }

  @override
  void update(void Function(BadgeMetricBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  BadgeMetric build() => _build();

  _$BadgeMetric _build() {
    final _$result = _$v ??
        _$BadgeMetric._(
          key:
              BuiltValueNullFieldError.checkNotNull(key, r'BadgeMetric', 'key'),
          value: value,
          sampleCount: BuiltValueNullFieldError.checkNotNull(
              sampleCount, r'BadgeMetric', 'sampleCount'),
          window: BuiltValueNullFieldError.checkNotNull(
              window, r'BadgeMetric', 'window'),
          definition: BuiltValueNullFieldError.checkNotNull(
              definition, r'BadgeMetric', 'definition'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
