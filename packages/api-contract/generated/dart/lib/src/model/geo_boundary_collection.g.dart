// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'geo_boundary_collection.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const GeoBoundaryCollectionTypeEnum
    _$geoBoundaryCollectionTypeEnum_featureCollection =
    const GeoBoundaryCollectionTypeEnum._('featureCollection');

GeoBoundaryCollectionTypeEnum _$geoBoundaryCollectionTypeEnumValueOf(
    String name) {
  switch (name) {
    case 'featureCollection':
      return _$geoBoundaryCollectionTypeEnum_featureCollection;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<GeoBoundaryCollectionTypeEnum>
    _$geoBoundaryCollectionTypeEnumValues = BuiltSet<
        GeoBoundaryCollectionTypeEnum>(const <GeoBoundaryCollectionTypeEnum>[
  _$geoBoundaryCollectionTypeEnum_featureCollection,
]);

Serializer<GeoBoundaryCollectionTypeEnum>
    _$geoBoundaryCollectionTypeEnumSerializer =
    _$GeoBoundaryCollectionTypeEnumSerializer();

class _$GeoBoundaryCollectionTypeEnumSerializer
    implements PrimitiveSerializer<GeoBoundaryCollectionTypeEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'featureCollection': 'FeatureCollection',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'FeatureCollection': 'featureCollection',
  };

  @override
  final Iterable<Type> types = const <Type>[GeoBoundaryCollectionTypeEnum];
  @override
  final String wireName = 'GeoBoundaryCollectionTypeEnum';

  @override
  Object serialize(
          Serializers serializers, GeoBoundaryCollectionTypeEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  GeoBoundaryCollectionTypeEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      GeoBoundaryCollectionTypeEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$GeoBoundaryCollection extends GeoBoundaryCollection {
  @override
  final GeoBoundaryCollectionTypeEnum type;
  @override
  final BuiltList<BuiltMap<String, JsonObject?>> features;
  @override
  final BuiltList<String> missingCodes;
  @override
  final GeoBoundaryCollectionPsgcVersion psgcVersion;

  factory _$GeoBoundaryCollection(
          [void Function(GeoBoundaryCollectionBuilder)? updates]) =>
      (GeoBoundaryCollectionBuilder()..update(updates))._build();

  _$GeoBoundaryCollection._(
      {required this.type,
      required this.features,
      required this.missingCodes,
      required this.psgcVersion})
      : super._();
  @override
  GeoBoundaryCollection rebuild(
          void Function(GeoBoundaryCollectionBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  GeoBoundaryCollectionBuilder toBuilder() =>
      GeoBoundaryCollectionBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is GeoBoundaryCollection &&
        type == other.type &&
        features == other.features &&
        missingCodes == other.missingCodes &&
        psgcVersion == other.psgcVersion;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, type.hashCode);
    _$hash = $jc(_$hash, features.hashCode);
    _$hash = $jc(_$hash, missingCodes.hashCode);
    _$hash = $jc(_$hash, psgcVersion.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'GeoBoundaryCollection')
          ..add('type', type)
          ..add('features', features)
          ..add('missingCodes', missingCodes)
          ..add('psgcVersion', psgcVersion))
        .toString();
  }
}

class GeoBoundaryCollectionBuilder
    implements Builder<GeoBoundaryCollection, GeoBoundaryCollectionBuilder> {
  _$GeoBoundaryCollection? _$v;

  GeoBoundaryCollectionTypeEnum? _type;
  GeoBoundaryCollectionTypeEnum? get type => _$this._type;
  set type(GeoBoundaryCollectionTypeEnum? type) => _$this._type = type;

  ListBuilder<BuiltMap<String, JsonObject?>>? _features;
  ListBuilder<BuiltMap<String, JsonObject?>> get features =>
      _$this._features ??= ListBuilder<BuiltMap<String, JsonObject?>>();
  set features(ListBuilder<BuiltMap<String, JsonObject?>>? features) =>
      _$this._features = features;

  ListBuilder<String>? _missingCodes;
  ListBuilder<String> get missingCodes =>
      _$this._missingCodes ??= ListBuilder<String>();
  set missingCodes(ListBuilder<String>? missingCodes) =>
      _$this._missingCodes = missingCodes;

  GeoBoundaryCollectionPsgcVersionBuilder? _psgcVersion;
  GeoBoundaryCollectionPsgcVersionBuilder get psgcVersion =>
      _$this._psgcVersion ??= GeoBoundaryCollectionPsgcVersionBuilder();
  set psgcVersion(GeoBoundaryCollectionPsgcVersionBuilder? psgcVersion) =>
      _$this._psgcVersion = psgcVersion;

  GeoBoundaryCollectionBuilder() {
    GeoBoundaryCollection._defaults(this);
  }

  GeoBoundaryCollectionBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _type = $v.type;
      _features = $v.features.toBuilder();
      _missingCodes = $v.missingCodes.toBuilder();
      _psgcVersion = $v.psgcVersion.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(GeoBoundaryCollection other) {
    _$v = other as _$GeoBoundaryCollection;
  }

  @override
  void update(void Function(GeoBoundaryCollectionBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  GeoBoundaryCollection build() => _build();

  _$GeoBoundaryCollection _build() {
    _$GeoBoundaryCollection _$result;
    try {
      _$result = _$v ??
          _$GeoBoundaryCollection._(
            type: BuiltValueNullFieldError.checkNotNull(
                type, r'GeoBoundaryCollection', 'type'),
            features: features.build(),
            missingCodes: missingCodes.build(),
            psgcVersion: psgcVersion.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'features';
        features.build();
        _$failedField = 'missingCodes';
        missingCodes.build();
        _$failedField = 'psgcVersion';
        psgcVersion.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'GeoBoundaryCollection', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
