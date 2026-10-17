// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'badge_state.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const BadgeStateCodeEnum _$badgeStateCodeEnum_FAST_RESPONDER =
    const BadgeStateCodeEnum._('FAST_RESPONDER');
const BadgeStateCodeEnum _$badgeStateCodeEnum_ON_TIME =
    const BadgeStateCodeEnum._('ON_TIME');
const BadgeStateCodeEnum _$badgeStateCodeEnum_MOST_ORDERED =
    const BadgeStateCodeEnum._('MOST_ORDERED');
const BadgeStateCodeEnum _$badgeStateCodeEnum_HIGHLY_RATED =
    const BadgeStateCodeEnum._('HIGHLY_RATED');
const BadgeStateCodeEnum _$badgeStateCodeEnum_HIGH_QUALITY_MATERIALS =
    const BadgeStateCodeEnum._('HIGH_QUALITY_MATERIALS');
const BadgeStateCodeEnum _$badgeStateCodeEnum_TRUSTED_SUPPLIER =
    const BadgeStateCodeEnum._('TRUSTED_SUPPLIER');

BadgeStateCodeEnum _$badgeStateCodeEnumValueOf(String name) {
  switch (name) {
    case 'FAST_RESPONDER':
      return _$badgeStateCodeEnum_FAST_RESPONDER;
    case 'ON_TIME':
      return _$badgeStateCodeEnum_ON_TIME;
    case 'MOST_ORDERED':
      return _$badgeStateCodeEnum_MOST_ORDERED;
    case 'HIGHLY_RATED':
      return _$badgeStateCodeEnum_HIGHLY_RATED;
    case 'HIGH_QUALITY_MATERIALS':
      return _$badgeStateCodeEnum_HIGH_QUALITY_MATERIALS;
    case 'TRUSTED_SUPPLIER':
      return _$badgeStateCodeEnum_TRUSTED_SUPPLIER;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<BadgeStateCodeEnum> _$badgeStateCodeEnumValues =
    BuiltSet<BadgeStateCodeEnum>(const <BadgeStateCodeEnum>[
  _$badgeStateCodeEnum_FAST_RESPONDER,
  _$badgeStateCodeEnum_ON_TIME,
  _$badgeStateCodeEnum_MOST_ORDERED,
  _$badgeStateCodeEnum_HIGHLY_RATED,
  _$badgeStateCodeEnum_HIGH_QUALITY_MATERIALS,
  _$badgeStateCodeEnum_TRUSTED_SUPPLIER,
]);

const BadgeStateStatusEnum _$badgeStateStatusEnum_EARNED =
    const BadgeStateStatusEnum._('EARNED');
const BadgeStateStatusEnum _$badgeStateStatusEnum_NOT_EARNED =
    const BadgeStateStatusEnum._('NOT_EARNED');
const BadgeStateStatusEnum _$badgeStateStatusEnum_SUPPRESSED =
    const BadgeStateStatusEnum._('SUPPRESSED');

BadgeStateStatusEnum _$badgeStateStatusEnumValueOf(String name) {
  switch (name) {
    case 'EARNED':
      return _$badgeStateStatusEnum_EARNED;
    case 'NOT_EARNED':
      return _$badgeStateStatusEnum_NOT_EARNED;
    case 'SUPPRESSED':
      return _$badgeStateStatusEnum_SUPPRESSED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<BadgeStateStatusEnum> _$badgeStateStatusEnumValues =
    BuiltSet<BadgeStateStatusEnum>(const <BadgeStateStatusEnum>[
  _$badgeStateStatusEnum_EARNED,
  _$badgeStateStatusEnum_NOT_EARNED,
  _$badgeStateStatusEnum_SUPPRESSED,
]);

Serializer<BadgeStateCodeEnum> _$badgeStateCodeEnumSerializer =
    _$BadgeStateCodeEnumSerializer();
Serializer<BadgeStateStatusEnum> _$badgeStateStatusEnumSerializer =
    _$BadgeStateStatusEnumSerializer();

class _$BadgeStateCodeEnumSerializer
    implements PrimitiveSerializer<BadgeStateCodeEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'FAST_RESPONDER': 'FAST_RESPONDER',
    'ON_TIME': 'ON_TIME',
    'MOST_ORDERED': 'MOST_ORDERED',
    'HIGHLY_RATED': 'HIGHLY_RATED',
    'HIGH_QUALITY_MATERIALS': 'HIGH_QUALITY_MATERIALS',
    'TRUSTED_SUPPLIER': 'TRUSTED_SUPPLIER',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'FAST_RESPONDER': 'FAST_RESPONDER',
    'ON_TIME': 'ON_TIME',
    'MOST_ORDERED': 'MOST_ORDERED',
    'HIGHLY_RATED': 'HIGHLY_RATED',
    'HIGH_QUALITY_MATERIALS': 'HIGH_QUALITY_MATERIALS',
    'TRUSTED_SUPPLIER': 'TRUSTED_SUPPLIER',
  };

  @override
  final Iterable<Type> types = const <Type>[BadgeStateCodeEnum];
  @override
  final String wireName = 'BadgeStateCodeEnum';

  @override
  Object serialize(Serializers serializers, BadgeStateCodeEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  BadgeStateCodeEnum deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      BadgeStateCodeEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$BadgeStateStatusEnumSerializer
    implements PrimitiveSerializer<BadgeStateStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'EARNED': 'EARNED',
    'NOT_EARNED': 'NOT_EARNED',
    'SUPPRESSED': 'SUPPRESSED',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'EARNED': 'EARNED',
    'NOT_EARNED': 'NOT_EARNED',
    'SUPPRESSED': 'SUPPRESSED',
  };

  @override
  final Iterable<Type> types = const <Type>[BadgeStateStatusEnum];
  @override
  final String wireName = 'BadgeStateStatusEnum';

  @override
  Object serialize(Serializers serializers, BadgeStateStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  BadgeStateStatusEnum deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      BadgeStateStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$BadgeState extends BadgeState {
  @override
  final BadgeStateCodeEnum code;
  @override
  final String name;
  @override
  final String description;
  @override
  final BadgeStateStatusEnum status;
  @override
  final BuiltList<BadgeStateScopesInner> scopes;
  @override
  final BuiltMap<String, JsonObject?>? suppression;

  factory _$BadgeState([void Function(BadgeStateBuilder)? updates]) =>
      (BadgeStateBuilder()..update(updates))._build();

  _$BadgeState._(
      {required this.code,
      required this.name,
      required this.description,
      required this.status,
      required this.scopes,
      this.suppression})
      : super._();
  @override
  BadgeState rebuild(void Function(BadgeStateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  BadgeStateBuilder toBuilder() => BadgeStateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is BadgeState &&
        code == other.code &&
        name == other.name &&
        description == other.description &&
        status == other.status &&
        scopes == other.scopes &&
        suppression == other.suppression;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, code.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, description.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, scopes.hashCode);
    _$hash = $jc(_$hash, suppression.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'BadgeState')
          ..add('code', code)
          ..add('name', name)
          ..add('description', description)
          ..add('status', status)
          ..add('scopes', scopes)
          ..add('suppression', suppression))
        .toString();
  }
}

class BadgeStateBuilder implements Builder<BadgeState, BadgeStateBuilder> {
  _$BadgeState? _$v;

  BadgeStateCodeEnum? _code;
  BadgeStateCodeEnum? get code => _$this._code;
  set code(BadgeStateCodeEnum? code) => _$this._code = code;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _description;
  String? get description => _$this._description;
  set description(String? description) => _$this._description = description;

  BadgeStateStatusEnum? _status;
  BadgeStateStatusEnum? get status => _$this._status;
  set status(BadgeStateStatusEnum? status) => _$this._status = status;

  ListBuilder<BadgeStateScopesInner>? _scopes;
  ListBuilder<BadgeStateScopesInner> get scopes =>
      _$this._scopes ??= ListBuilder<BadgeStateScopesInner>();
  set scopes(ListBuilder<BadgeStateScopesInner>? scopes) =>
      _$this._scopes = scopes;

  MapBuilder<String, JsonObject?>? _suppression;
  MapBuilder<String, JsonObject?> get suppression =>
      _$this._suppression ??= MapBuilder<String, JsonObject?>();
  set suppression(MapBuilder<String, JsonObject?>? suppression) =>
      _$this._suppression = suppression;

  BadgeStateBuilder() {
    BadgeState._defaults(this);
  }

  BadgeStateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _code = $v.code;
      _name = $v.name;
      _description = $v.description;
      _status = $v.status;
      _scopes = $v.scopes.toBuilder();
      _suppression = $v.suppression?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(BadgeState other) {
    _$v = other as _$BadgeState;
  }

  @override
  void update(void Function(BadgeStateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  BadgeState build() => _build();

  _$BadgeState _build() {
    _$BadgeState _$result;
    try {
      _$result = _$v ??
          _$BadgeState._(
            code: BuiltValueNullFieldError.checkNotNull(
                code, r'BadgeState', 'code'),
            name: BuiltValueNullFieldError.checkNotNull(
                name, r'BadgeState', 'name'),
            description: BuiltValueNullFieldError.checkNotNull(
                description, r'BadgeState', 'description'),
            status: BuiltValueNullFieldError.checkNotNull(
                status, r'BadgeState', 'status'),
            scopes: scopes.build(),
            suppression: _suppression?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'scopes';
        scopes.build();
        _$failedField = 'suppression';
        _suppression?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'BadgeState', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
