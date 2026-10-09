// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'geo_dataset.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const GeoDatasetEnvironmentEnum _$geoDatasetEnvironmentEnum_TEST =
    const GeoDatasetEnvironmentEnum._('TEST');
const GeoDatasetEnvironmentEnum _$geoDatasetEnvironmentEnum_DEMO =
    const GeoDatasetEnvironmentEnum._('DEMO');

GeoDatasetEnvironmentEnum _$geoDatasetEnvironmentEnumValueOf(String name) {
  switch (name) {
    case 'TEST':
      return _$geoDatasetEnvironmentEnum_TEST;
    case 'DEMO':
      return _$geoDatasetEnvironmentEnum_DEMO;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<GeoDatasetEnvironmentEnum> _$geoDatasetEnvironmentEnumValues =
    BuiltSet<GeoDatasetEnvironmentEnum>(const <GeoDatasetEnvironmentEnum>[
  _$geoDatasetEnvironmentEnum_TEST,
  _$geoDatasetEnvironmentEnum_DEMO,
]);

Serializer<GeoDatasetEnvironmentEnum> _$geoDatasetEnvironmentEnumSerializer =
    _$GeoDatasetEnvironmentEnumSerializer();

class _$GeoDatasetEnvironmentEnumSerializer
    implements PrimitiveSerializer<GeoDatasetEnvironmentEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'TEST': 'TEST',
    'DEMO': 'DEMO',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'TEST': 'TEST',
    'DEMO': 'DEMO',
  };

  @override
  final Iterable<Type> types = const <Type>[GeoDatasetEnvironmentEnum];
  @override
  final String wireName = 'GeoDatasetEnvironmentEnum';

  @override
  Object serialize(Serializers serializers, GeoDatasetEnvironmentEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  GeoDatasetEnvironmentEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      GeoDatasetEnvironmentEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$GeoDataset extends GeoDataset {
  @override
  final GeoDatasetEnvironmentEnum environment;
  @override
  final String label;
  @override
  final bool demo;
  @override
  final DateTime? lastAggregatedAt;
  @override
  final String? throughDate;
  @override
  final int? revision;
  @override
  final bool available;

  factory _$GeoDataset([void Function(GeoDatasetBuilder)? updates]) =>
      (GeoDatasetBuilder()..update(updates))._build();

  _$GeoDataset._(
      {required this.environment,
      required this.label,
      required this.demo,
      this.lastAggregatedAt,
      this.throughDate,
      this.revision,
      required this.available})
      : super._();
  @override
  GeoDataset rebuild(void Function(GeoDatasetBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  GeoDatasetBuilder toBuilder() => GeoDatasetBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is GeoDataset &&
        environment == other.environment &&
        label == other.label &&
        demo == other.demo &&
        lastAggregatedAt == other.lastAggregatedAt &&
        throughDate == other.throughDate &&
        revision == other.revision &&
        available == other.available;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, environment.hashCode);
    _$hash = $jc(_$hash, label.hashCode);
    _$hash = $jc(_$hash, demo.hashCode);
    _$hash = $jc(_$hash, lastAggregatedAt.hashCode);
    _$hash = $jc(_$hash, throughDate.hashCode);
    _$hash = $jc(_$hash, revision.hashCode);
    _$hash = $jc(_$hash, available.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'GeoDataset')
          ..add('environment', environment)
          ..add('label', label)
          ..add('demo', demo)
          ..add('lastAggregatedAt', lastAggregatedAt)
          ..add('throughDate', throughDate)
          ..add('revision', revision)
          ..add('available', available))
        .toString();
  }
}

class GeoDatasetBuilder implements Builder<GeoDataset, GeoDatasetBuilder> {
  _$GeoDataset? _$v;

  GeoDatasetEnvironmentEnum? _environment;
  GeoDatasetEnvironmentEnum? get environment => _$this._environment;
  set environment(GeoDatasetEnvironmentEnum? environment) =>
      _$this._environment = environment;

  String? _label;
  String? get label => _$this._label;
  set label(String? label) => _$this._label = label;

  bool? _demo;
  bool? get demo => _$this._demo;
  set demo(bool? demo) => _$this._demo = demo;

  DateTime? _lastAggregatedAt;
  DateTime? get lastAggregatedAt => _$this._lastAggregatedAt;
  set lastAggregatedAt(DateTime? lastAggregatedAt) =>
      _$this._lastAggregatedAt = lastAggregatedAt;

  String? _throughDate;
  String? get throughDate => _$this._throughDate;
  set throughDate(String? throughDate) => _$this._throughDate = throughDate;

  int? _revision;
  int? get revision => _$this._revision;
  set revision(int? revision) => _$this._revision = revision;

  bool? _available;
  bool? get available => _$this._available;
  set available(bool? available) => _$this._available = available;

  GeoDatasetBuilder() {
    GeoDataset._defaults(this);
  }

  GeoDatasetBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _environment = $v.environment;
      _label = $v.label;
      _demo = $v.demo;
      _lastAggregatedAt = $v.lastAggregatedAt;
      _throughDate = $v.throughDate;
      _revision = $v.revision;
      _available = $v.available;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(GeoDataset other) {
    _$v = other as _$GeoDataset;
  }

  @override
  void update(void Function(GeoDatasetBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  GeoDataset build() => _build();

  _$GeoDataset _build() {
    final _$result = _$v ??
        _$GeoDataset._(
          environment: BuiltValueNullFieldError.checkNotNull(
              environment, r'GeoDataset', 'environment'),
          label: BuiltValueNullFieldError.checkNotNull(
              label, r'GeoDataset', 'label'),
          demo: BuiltValueNullFieldError.checkNotNull(
              demo, r'GeoDataset', 'demo'),
          lastAggregatedAt: lastAggregatedAt,
          throughDate: throughDate,
          revision: revision,
          available: BuiltValueNullFieldError.checkNotNull(
              available, r'GeoDataset', 'available'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
