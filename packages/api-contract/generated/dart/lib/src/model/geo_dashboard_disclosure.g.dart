// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'geo_dashboard_disclosure.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const GeoDashboardDisclosureMethodEnum
    _$geoDashboardDisclosureMethodEnum_ROLL_UP_TO_PARENT =
    const GeoDashboardDisclosureMethodEnum._('ROLL_UP_TO_PARENT');

GeoDashboardDisclosureMethodEnum _$geoDashboardDisclosureMethodEnumValueOf(
    String name) {
  switch (name) {
    case 'ROLL_UP_TO_PARENT':
      return _$geoDashboardDisclosureMethodEnum_ROLL_UP_TO_PARENT;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<GeoDashboardDisclosureMethodEnum>
    _$geoDashboardDisclosureMethodEnumValues = BuiltSet<
        GeoDashboardDisclosureMethodEnum>(const <GeoDashboardDisclosureMethodEnum>[
  _$geoDashboardDisclosureMethodEnum_ROLL_UP_TO_PARENT,
]);

Serializer<GeoDashboardDisclosureMethodEnum>
    _$geoDashboardDisclosureMethodEnumSerializer =
    _$GeoDashboardDisclosureMethodEnumSerializer();

class _$GeoDashboardDisclosureMethodEnumSerializer
    implements PrimitiveSerializer<GeoDashboardDisclosureMethodEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'ROLL_UP_TO_PARENT': 'ROLL_UP_TO_PARENT',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'ROLL_UP_TO_PARENT': 'ROLL_UP_TO_PARENT',
  };

  @override
  final Iterable<Type> types = const <Type>[GeoDashboardDisclosureMethodEnum];
  @override
  final String wireName = 'GeoDashboardDisclosureMethodEnum';

  @override
  Object serialize(
          Serializers serializers, GeoDashboardDisclosureMethodEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  GeoDashboardDisclosureMethodEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      GeoDashboardDisclosureMethodEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$GeoDashboardDisclosure extends GeoDashboardDisclosure {
  @override
  final int minimumPersons;
  @override
  final GeoDashboardDisclosureMethodEnum method;
  @override
  final String description;

  factory _$GeoDashboardDisclosure(
          [void Function(GeoDashboardDisclosureBuilder)? updates]) =>
      (GeoDashboardDisclosureBuilder()..update(updates))._build();

  _$GeoDashboardDisclosure._(
      {required this.minimumPersons,
      required this.method,
      required this.description})
      : super._();
  @override
  GeoDashboardDisclosure rebuild(
          void Function(GeoDashboardDisclosureBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  GeoDashboardDisclosureBuilder toBuilder() =>
      GeoDashboardDisclosureBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is GeoDashboardDisclosure &&
        minimumPersons == other.minimumPersons &&
        method == other.method &&
        description == other.description;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, minimumPersons.hashCode);
    _$hash = $jc(_$hash, method.hashCode);
    _$hash = $jc(_$hash, description.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'GeoDashboardDisclosure')
          ..add('minimumPersons', minimumPersons)
          ..add('method', method)
          ..add('description', description))
        .toString();
  }
}

class GeoDashboardDisclosureBuilder
    implements Builder<GeoDashboardDisclosure, GeoDashboardDisclosureBuilder> {
  _$GeoDashboardDisclosure? _$v;

  int? _minimumPersons;
  int? get minimumPersons => _$this._minimumPersons;
  set minimumPersons(int? minimumPersons) =>
      _$this._minimumPersons = minimumPersons;

  GeoDashboardDisclosureMethodEnum? _method;
  GeoDashboardDisclosureMethodEnum? get method => _$this._method;
  set method(GeoDashboardDisclosureMethodEnum? method) =>
      _$this._method = method;

  String? _description;
  String? get description => _$this._description;
  set description(String? description) => _$this._description = description;

  GeoDashboardDisclosureBuilder() {
    GeoDashboardDisclosure._defaults(this);
  }

  GeoDashboardDisclosureBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _minimumPersons = $v.minimumPersons;
      _method = $v.method;
      _description = $v.description;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(GeoDashboardDisclosure other) {
    _$v = other as _$GeoDashboardDisclosure;
  }

  @override
  void update(void Function(GeoDashboardDisclosureBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  GeoDashboardDisclosure build() => _build();

  _$GeoDashboardDisclosure _build() {
    final _$result = _$v ??
        _$GeoDashboardDisclosure._(
          minimumPersons: BuiltValueNullFieldError.checkNotNull(
              minimumPersons, r'GeoDashboardDisclosure', 'minimumPersons'),
          method: BuiltValueNullFieldError.checkNotNull(
              method, r'GeoDashboardDisclosure', 'method'),
          description: BuiltValueNullFieldError.checkNotNull(
              description, r'GeoDashboardDisclosure', 'description'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
