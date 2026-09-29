// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ranking_preferences.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const RankingPreferencesProcurementTypeEnum
    _$rankingPreferencesProcurementTypeEnum_ITEM_BASED =
    const RankingPreferencesProcurementTypeEnum._('ITEM_BASED');

RankingPreferencesProcurementTypeEnum
    _$rankingPreferencesProcurementTypeEnumValueOf(String name) {
  switch (name) {
    case 'ITEM_BASED':
      return _$rankingPreferencesProcurementTypeEnum_ITEM_BASED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<RankingPreferencesProcurementTypeEnum>
    _$rankingPreferencesProcurementTypeEnumValues = BuiltSet<
        RankingPreferencesProcurementTypeEnum>(const <RankingPreferencesProcurementTypeEnum>[
  _$rankingPreferencesProcurementTypeEnum_ITEM_BASED,
]);

const RankingPreferencesTotalPercentEnum
    _$rankingPreferencesTotalPercentEnum_number100 =
    const RankingPreferencesTotalPercentEnum._('number100');

RankingPreferencesTotalPercentEnum _$rankingPreferencesTotalPercentEnumValueOf(
    String name) {
  switch (name) {
    case 'number100':
      return _$rankingPreferencesTotalPercentEnum_number100;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<RankingPreferencesTotalPercentEnum>
    _$rankingPreferencesTotalPercentEnumValues = BuiltSet<
        RankingPreferencesTotalPercentEnum>(const <RankingPreferencesTotalPercentEnum>[
  _$rankingPreferencesTotalPercentEnum_number100,
]);

Serializer<RankingPreferencesProcurementTypeEnum>
    _$rankingPreferencesProcurementTypeEnumSerializer =
    _$RankingPreferencesProcurementTypeEnumSerializer();
Serializer<RankingPreferencesTotalPercentEnum>
    _$rankingPreferencesTotalPercentEnumSerializer =
    _$RankingPreferencesTotalPercentEnumSerializer();

class _$RankingPreferencesProcurementTypeEnumSerializer
    implements PrimitiveSerializer<RankingPreferencesProcurementTypeEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'ITEM_BASED': 'ITEM_BASED',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'ITEM_BASED': 'ITEM_BASED',
  };

  @override
  final Iterable<Type> types = const <Type>[
    RankingPreferencesProcurementTypeEnum
  ];
  @override
  final String wireName = 'RankingPreferencesProcurementTypeEnum';

  @override
  Object serialize(
          Serializers serializers, RankingPreferencesProcurementTypeEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  RankingPreferencesProcurementTypeEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      RankingPreferencesProcurementTypeEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$RankingPreferencesTotalPercentEnumSerializer
    implements PrimitiveSerializer<RankingPreferencesTotalPercentEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'number100': 100,
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    100: 'number100',
  };

  @override
  final Iterable<Type> types = const <Type>[RankingPreferencesTotalPercentEnum];
  @override
  final String wireName = 'RankingPreferencesTotalPercentEnum';

  @override
  Object serialize(
          Serializers serializers, RankingPreferencesTotalPercentEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  RankingPreferencesTotalPercentEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      RankingPreferencesTotalPercentEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$RankingPreferences extends RankingPreferences {
  @override
  final RankingPreferencesProcurementTypeEnum procurementType;
  @override
  final RankingWeightSet weights;
  @override
  final RankingWeightSet defaultWeights;
  @override
  final int defaultsVersion;
  @override
  final bool personalized;
  @override
  final int version;
  @override
  final RankingPreferencesTotalPercentEnum totalPercent;
  @override
  final String algorithmVersion;

  factory _$RankingPreferences(
          [void Function(RankingPreferencesBuilder)? updates]) =>
      (RankingPreferencesBuilder()..update(updates))._build();

  _$RankingPreferences._(
      {required this.procurementType,
      required this.weights,
      required this.defaultWeights,
      required this.defaultsVersion,
      required this.personalized,
      required this.version,
      required this.totalPercent,
      required this.algorithmVersion})
      : super._();
  @override
  RankingPreferences rebuild(
          void Function(RankingPreferencesBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  RankingPreferencesBuilder toBuilder() =>
      RankingPreferencesBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is RankingPreferences &&
        procurementType == other.procurementType &&
        weights == other.weights &&
        defaultWeights == other.defaultWeights &&
        defaultsVersion == other.defaultsVersion &&
        personalized == other.personalized &&
        version == other.version &&
        totalPercent == other.totalPercent &&
        algorithmVersion == other.algorithmVersion;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, procurementType.hashCode);
    _$hash = $jc(_$hash, weights.hashCode);
    _$hash = $jc(_$hash, defaultWeights.hashCode);
    _$hash = $jc(_$hash, defaultsVersion.hashCode);
    _$hash = $jc(_$hash, personalized.hashCode);
    _$hash = $jc(_$hash, version.hashCode);
    _$hash = $jc(_$hash, totalPercent.hashCode);
    _$hash = $jc(_$hash, algorithmVersion.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'RankingPreferences')
          ..add('procurementType', procurementType)
          ..add('weights', weights)
          ..add('defaultWeights', defaultWeights)
          ..add('defaultsVersion', defaultsVersion)
          ..add('personalized', personalized)
          ..add('version', version)
          ..add('totalPercent', totalPercent)
          ..add('algorithmVersion', algorithmVersion))
        .toString();
  }
}

class RankingPreferencesBuilder
    implements Builder<RankingPreferences, RankingPreferencesBuilder> {
  _$RankingPreferences? _$v;

  RankingPreferencesProcurementTypeEnum? _procurementType;
  RankingPreferencesProcurementTypeEnum? get procurementType =>
      _$this._procurementType;
  set procurementType(RankingPreferencesProcurementTypeEnum? procurementType) =>
      _$this._procurementType = procurementType;

  RankingWeightSetBuilder? _weights;
  RankingWeightSetBuilder get weights =>
      _$this._weights ??= RankingWeightSetBuilder();
  set weights(RankingWeightSetBuilder? weights) => _$this._weights = weights;

  RankingWeightSetBuilder? _defaultWeights;
  RankingWeightSetBuilder get defaultWeights =>
      _$this._defaultWeights ??= RankingWeightSetBuilder();
  set defaultWeights(RankingWeightSetBuilder? defaultWeights) =>
      _$this._defaultWeights = defaultWeights;

  int? _defaultsVersion;
  int? get defaultsVersion => _$this._defaultsVersion;
  set defaultsVersion(int? defaultsVersion) =>
      _$this._defaultsVersion = defaultsVersion;

  bool? _personalized;
  bool? get personalized => _$this._personalized;
  set personalized(bool? personalized) => _$this._personalized = personalized;

  int? _version;
  int? get version => _$this._version;
  set version(int? version) => _$this._version = version;

  RankingPreferencesTotalPercentEnum? _totalPercent;
  RankingPreferencesTotalPercentEnum? get totalPercent => _$this._totalPercent;
  set totalPercent(RankingPreferencesTotalPercentEnum? totalPercent) =>
      _$this._totalPercent = totalPercent;

  String? _algorithmVersion;
  String? get algorithmVersion => _$this._algorithmVersion;
  set algorithmVersion(String? algorithmVersion) =>
      _$this._algorithmVersion = algorithmVersion;

  RankingPreferencesBuilder() {
    RankingPreferences._defaults(this);
  }

  RankingPreferencesBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _procurementType = $v.procurementType;
      _weights = $v.weights.toBuilder();
      _defaultWeights = $v.defaultWeights.toBuilder();
      _defaultsVersion = $v.defaultsVersion;
      _personalized = $v.personalized;
      _version = $v.version;
      _totalPercent = $v.totalPercent;
      _algorithmVersion = $v.algorithmVersion;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(RankingPreferences other) {
    _$v = other as _$RankingPreferences;
  }

  @override
  void update(void Function(RankingPreferencesBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  RankingPreferences build() => _build();

  _$RankingPreferences _build() {
    _$RankingPreferences _$result;
    try {
      _$result = _$v ??
          _$RankingPreferences._(
            procurementType: BuiltValueNullFieldError.checkNotNull(
                procurementType, r'RankingPreferences', 'procurementType'),
            weights: weights.build(),
            defaultWeights: defaultWeights.build(),
            defaultsVersion: BuiltValueNullFieldError.checkNotNull(
                defaultsVersion, r'RankingPreferences', 'defaultsVersion'),
            personalized: BuiltValueNullFieldError.checkNotNull(
                personalized, r'RankingPreferences', 'personalized'),
            version: BuiltValueNullFieldError.checkNotNull(
                version, r'RankingPreferences', 'version'),
            totalPercent: BuiltValueNullFieldError.checkNotNull(
                totalPercent, r'RankingPreferences', 'totalPercent'),
            algorithmVersion: BuiltValueNullFieldError.checkNotNull(
                algorithmVersion, r'RankingPreferences', 'algorithmVersion'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'weights';
        weights.build();
        _$failedField = 'defaultWeights';
        defaultWeights.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'RankingPreferences', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
