// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'score_metric.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const ScoreMetricKeyEnum _$scoreMetricKeyEnum_VPS =
    const ScoreMetricKeyEnum._('VPS');
const ScoreMetricKeyEnum _$scoreMetricKeyEnum_VCS =
    const ScoreMetricKeyEnum._('VCS');
const ScoreMetricKeyEnum _$scoreMetricKeyEnum_MQS =
    const ScoreMetricKeyEnum._('MQS');
const ScoreMetricKeyEnum _$scoreMetricKeyEnum_OHS =
    const ScoreMetricKeyEnum._('OHS');

ScoreMetricKeyEnum _$scoreMetricKeyEnumValueOf(String name) {
  switch (name) {
    case 'VPS':
      return _$scoreMetricKeyEnum_VPS;
    case 'VCS':
      return _$scoreMetricKeyEnum_VCS;
    case 'MQS':
      return _$scoreMetricKeyEnum_MQS;
    case 'OHS':
      return _$scoreMetricKeyEnum_OHS;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<ScoreMetricKeyEnum> _$scoreMetricKeyEnumValues =
    BuiltSet<ScoreMetricKeyEnum>(const <ScoreMetricKeyEnum>[
  _$scoreMetricKeyEnum_VPS,
  _$scoreMetricKeyEnum_VCS,
  _$scoreMetricKeyEnum_MQS,
  _$scoreMetricKeyEnum_OHS,
]);

Serializer<ScoreMetricKeyEnum> _$scoreMetricKeyEnumSerializer =
    _$ScoreMetricKeyEnumSerializer();

class _$ScoreMetricKeyEnumSerializer
    implements PrimitiveSerializer<ScoreMetricKeyEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'VPS': 'VPS',
    'VCS': 'VCS',
    'MQS': 'MQS',
    'OHS': 'OHS',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'VPS': 'VPS',
    'VCS': 'VCS',
    'MQS': 'MQS',
    'OHS': 'OHS',
  };

  @override
  final Iterable<Type> types = const <Type>[ScoreMetricKeyEnum];
  @override
  final String wireName = 'ScoreMetricKeyEnum';

  @override
  Object serialize(Serializers serializers, ScoreMetricKeyEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  ScoreMetricKeyEnum deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      ScoreMetricKeyEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$ScoreMetric extends ScoreMetric {
  @override
  final ScoreMetricKeyEnum key;
  @override
  final String? value;
  @override
  final bool published;
  @override
  final int sampleCount;
  @override
  final int minimumSample;
  @override
  final String window;
  @override
  final String statusText;

  factory _$ScoreMetric([void Function(ScoreMetricBuilder)? updates]) =>
      (ScoreMetricBuilder()..update(updates))._build();

  _$ScoreMetric._(
      {required this.key,
      this.value,
      required this.published,
      required this.sampleCount,
      required this.minimumSample,
      required this.window,
      required this.statusText})
      : super._();
  @override
  ScoreMetric rebuild(void Function(ScoreMetricBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ScoreMetricBuilder toBuilder() => ScoreMetricBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ScoreMetric &&
        key == other.key &&
        value == other.value &&
        published == other.published &&
        sampleCount == other.sampleCount &&
        minimumSample == other.minimumSample &&
        window == other.window &&
        statusText == other.statusText;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, key.hashCode);
    _$hash = $jc(_$hash, value.hashCode);
    _$hash = $jc(_$hash, published.hashCode);
    _$hash = $jc(_$hash, sampleCount.hashCode);
    _$hash = $jc(_$hash, minimumSample.hashCode);
    _$hash = $jc(_$hash, window.hashCode);
    _$hash = $jc(_$hash, statusText.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ScoreMetric')
          ..add('key', key)
          ..add('value', value)
          ..add('published', published)
          ..add('sampleCount', sampleCount)
          ..add('minimumSample', minimumSample)
          ..add('window', window)
          ..add('statusText', statusText))
        .toString();
  }
}

class ScoreMetricBuilder implements Builder<ScoreMetric, ScoreMetricBuilder> {
  _$ScoreMetric? _$v;

  ScoreMetricKeyEnum? _key;
  ScoreMetricKeyEnum? get key => _$this._key;
  set key(ScoreMetricKeyEnum? key) => _$this._key = key;

  String? _value;
  String? get value => _$this._value;
  set value(String? value) => _$this._value = value;

  bool? _published;
  bool? get published => _$this._published;
  set published(bool? published) => _$this._published = published;

  int? _sampleCount;
  int? get sampleCount => _$this._sampleCount;
  set sampleCount(int? sampleCount) => _$this._sampleCount = sampleCount;

  int? _minimumSample;
  int? get minimumSample => _$this._minimumSample;
  set minimumSample(int? minimumSample) =>
      _$this._minimumSample = minimumSample;

  String? _window;
  String? get window => _$this._window;
  set window(String? window) => _$this._window = window;

  String? _statusText;
  String? get statusText => _$this._statusText;
  set statusText(String? statusText) => _$this._statusText = statusText;

  ScoreMetricBuilder() {
    ScoreMetric._defaults(this);
  }

  ScoreMetricBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _key = $v.key;
      _value = $v.value;
      _published = $v.published;
      _sampleCount = $v.sampleCount;
      _minimumSample = $v.minimumSample;
      _window = $v.window;
      _statusText = $v.statusText;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ScoreMetric other) {
    _$v = other as _$ScoreMetric;
  }

  @override
  void update(void Function(ScoreMetricBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ScoreMetric build() => _build();

  _$ScoreMetric _build() {
    final _$result = _$v ??
        _$ScoreMetric._(
          key:
              BuiltValueNullFieldError.checkNotNull(key, r'ScoreMetric', 'key'),
          value: value,
          published: BuiltValueNullFieldError.checkNotNull(
              published, r'ScoreMetric', 'published'),
          sampleCount: BuiltValueNullFieldError.checkNotNull(
              sampleCount, r'ScoreMetric', 'sampleCount'),
          minimumSample: BuiltValueNullFieldError.checkNotNull(
              minimumSample, r'ScoreMetric', 'minimumSample'),
          window: BuiltValueNullFieldError.checkNotNull(
              window, r'ScoreMetric', 'window'),
          statusText: BuiltValueNullFieldError.checkNotNull(
              statusText, r'ScoreMetric', 'statusText'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
