// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_classification.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const DashboardClassificationClass_Enum
    _$dashboardClassificationClassEnum_BUILDING_TRACK_RECORD =
    const DashboardClassificationClass_Enum._('BUILDING_TRACK_RECORD');
const DashboardClassificationClass_Enum
    _$dashboardClassificationClassEnum_BELOW_WATCH_LEVEL =
    const DashboardClassificationClass_Enum._('BELOW_WATCH_LEVEL');
const DashboardClassificationClass_Enum
    _$dashboardClassificationClassEnum_WATCH =
    const DashboardClassificationClass_Enum._('WATCH');
const DashboardClassificationClass_Enum
    _$dashboardClassificationClassEnum_HEALTHY =
    const DashboardClassificationClass_Enum._('HEALTHY');

DashboardClassificationClass_Enum _$dashboardClassificationClassEnumValueOf(
    String name) {
  switch (name) {
    case 'BUILDING_TRACK_RECORD':
      return _$dashboardClassificationClassEnum_BUILDING_TRACK_RECORD;
    case 'BELOW_WATCH_LEVEL':
      return _$dashboardClassificationClassEnum_BELOW_WATCH_LEVEL;
    case 'WATCH':
      return _$dashboardClassificationClassEnum_WATCH;
    case 'HEALTHY':
      return _$dashboardClassificationClassEnum_HEALTHY;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<DashboardClassificationClass_Enum>
    _$dashboardClassificationClassEnumValues = BuiltSet<
        DashboardClassificationClass_Enum>(const <DashboardClassificationClass_Enum>[
  _$dashboardClassificationClassEnum_BUILDING_TRACK_RECORD,
  _$dashboardClassificationClassEnum_BELOW_WATCH_LEVEL,
  _$dashboardClassificationClassEnum_WATCH,
  _$dashboardClassificationClassEnum_HEALTHY,
]);

const DashboardClassificationBandsEnum _$dashboardClassificationBandsEnum_NONE =
    const DashboardClassificationBandsEnum._('NONE');
const DashboardClassificationBandsEnum _$dashboardClassificationBandsEnum_LOW =
    const DashboardClassificationBandsEnum._('LOW');
const DashboardClassificationBandsEnum
    _$dashboardClassificationBandsEnum_MEDIUM =
    const DashboardClassificationBandsEnum._('MEDIUM');
const DashboardClassificationBandsEnum _$dashboardClassificationBandsEnum_HIGH =
    const DashboardClassificationBandsEnum._('HIGH');

DashboardClassificationBandsEnum _$dashboardClassificationBandsEnumValueOf(
    String name) {
  switch (name) {
    case 'NONE':
      return _$dashboardClassificationBandsEnum_NONE;
    case 'LOW':
      return _$dashboardClassificationBandsEnum_LOW;
    case 'MEDIUM':
      return _$dashboardClassificationBandsEnum_MEDIUM;
    case 'HIGH':
      return _$dashboardClassificationBandsEnum_HIGH;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<DashboardClassificationBandsEnum>
    _$dashboardClassificationBandsEnumValues = BuiltSet<
        DashboardClassificationBandsEnum>(const <DashboardClassificationBandsEnum>[
  _$dashboardClassificationBandsEnum_NONE,
  _$dashboardClassificationBandsEnum_LOW,
  _$dashboardClassificationBandsEnum_MEDIUM,
  _$dashboardClassificationBandsEnum_HIGH,
]);

Serializer<DashboardClassificationClass_Enum>
    _$dashboardClassificationClassEnumSerializer =
    _$DashboardClassificationClass_EnumSerializer();
Serializer<DashboardClassificationBandsEnum>
    _$dashboardClassificationBandsEnumSerializer =
    _$DashboardClassificationBandsEnumSerializer();

class _$DashboardClassificationClass_EnumSerializer
    implements PrimitiveSerializer<DashboardClassificationClass_Enum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'BUILDING_TRACK_RECORD': 'BUILDING_TRACK_RECORD',
    'BELOW_WATCH_LEVEL': 'BELOW_WATCH_LEVEL',
    'WATCH': 'WATCH',
    'HEALTHY': 'HEALTHY',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'BUILDING_TRACK_RECORD': 'BUILDING_TRACK_RECORD',
    'BELOW_WATCH_LEVEL': 'BELOW_WATCH_LEVEL',
    'WATCH': 'WATCH',
    'HEALTHY': 'HEALTHY',
  };

  @override
  final Iterable<Type> types = const <Type>[DashboardClassificationClass_Enum];
  @override
  final String wireName = 'DashboardClassificationClass_Enum';

  @override
  Object serialize(
          Serializers serializers, DashboardClassificationClass_Enum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  DashboardClassificationClass_Enum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      DashboardClassificationClass_Enum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$DashboardClassificationBandsEnumSerializer
    implements PrimitiveSerializer<DashboardClassificationBandsEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'NONE': 'NONE',
    'LOW': 'LOW',
    'MEDIUM': 'MEDIUM',
    'HIGH': 'HIGH',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'NONE': 'NONE',
    'LOW': 'LOW',
    'MEDIUM': 'MEDIUM',
    'HIGH': 'HIGH',
  };

  @override
  final Iterable<Type> types = const <Type>[DashboardClassificationBandsEnum];
  @override
  final String wireName = 'DashboardClassificationBandsEnum';

  @override
  Object serialize(
          Serializers serializers, DashboardClassificationBandsEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  DashboardClassificationBandsEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      DashboardClassificationBandsEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$DashboardClassification extends DashboardClassification {
  @override
  final DashboardClassificationClass_Enum class_;
  @override
  final String label;
  @override
  final BuiltList<String> path;
  @override
  final BuiltMap<String, DashboardClassificationBandsEnum> bands;

  factory _$DashboardClassification(
          [void Function(DashboardClassificationBuilder)? updates]) =>
      (DashboardClassificationBuilder()..update(updates))._build();

  _$DashboardClassification._(
      {required this.class_,
      required this.label,
      required this.path,
      required this.bands})
      : super._();
  @override
  DashboardClassification rebuild(
          void Function(DashboardClassificationBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DashboardClassificationBuilder toBuilder() =>
      DashboardClassificationBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DashboardClassification &&
        class_ == other.class_ &&
        label == other.label &&
        path == other.path &&
        bands == other.bands;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, class_.hashCode);
    _$hash = $jc(_$hash, label.hashCode);
    _$hash = $jc(_$hash, path.hashCode);
    _$hash = $jc(_$hash, bands.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'DashboardClassification')
          ..add('class_', class_)
          ..add('label', label)
          ..add('path', path)
          ..add('bands', bands))
        .toString();
  }
}

class DashboardClassificationBuilder
    implements
        Builder<DashboardClassification, DashboardClassificationBuilder> {
  _$DashboardClassification? _$v;

  DashboardClassificationClass_Enum? _class_;
  DashboardClassificationClass_Enum? get class_ => _$this._class_;
  set class_(DashboardClassificationClass_Enum? class_) =>
      _$this._class_ = class_;

  String? _label;
  String? get label => _$this._label;
  set label(String? label) => _$this._label = label;

  ListBuilder<String>? _path;
  ListBuilder<String> get path => _$this._path ??= ListBuilder<String>();
  set path(ListBuilder<String>? path) => _$this._path = path;

  MapBuilder<String, DashboardClassificationBandsEnum>? _bands;
  MapBuilder<String, DashboardClassificationBandsEnum> get bands =>
      _$this._bands ??= MapBuilder<String, DashboardClassificationBandsEnum>();
  set bands(MapBuilder<String, DashboardClassificationBandsEnum>? bands) =>
      _$this._bands = bands;

  DashboardClassificationBuilder() {
    DashboardClassification._defaults(this);
  }

  DashboardClassificationBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _class_ = $v.class_;
      _label = $v.label;
      _path = $v.path.toBuilder();
      _bands = $v.bands.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DashboardClassification other) {
    _$v = other as _$DashboardClassification;
  }

  @override
  void update(void Function(DashboardClassificationBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DashboardClassification build() => _build();

  _$DashboardClassification _build() {
    _$DashboardClassification _$result;
    try {
      _$result = _$v ??
          _$DashboardClassification._(
            class_: BuiltValueNullFieldError.checkNotNull(
                class_, r'DashboardClassification', 'class_'),
            label: BuiltValueNullFieldError.checkNotNull(
                label, r'DashboardClassification', 'label'),
            path: path.build(),
            bands: bands.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'path';
        path.build();
        _$failedField = 'bands';
        bands.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'DashboardClassification', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
