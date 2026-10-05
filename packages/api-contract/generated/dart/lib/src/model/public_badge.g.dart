// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'public_badge.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const PublicBadgeCodeEnum _$publicBadgeCodeEnum_FAST_RESPONDER =
    const PublicBadgeCodeEnum._('FAST_RESPONDER');
const PublicBadgeCodeEnum _$publicBadgeCodeEnum_ON_TIME =
    const PublicBadgeCodeEnum._('ON_TIME');
const PublicBadgeCodeEnum _$publicBadgeCodeEnum_MOST_ORDERED =
    const PublicBadgeCodeEnum._('MOST_ORDERED');
const PublicBadgeCodeEnum _$publicBadgeCodeEnum_HIGHLY_RATED =
    const PublicBadgeCodeEnum._('HIGHLY_RATED');
const PublicBadgeCodeEnum _$publicBadgeCodeEnum_HIGH_QUALITY_MATERIALS =
    const PublicBadgeCodeEnum._('HIGH_QUALITY_MATERIALS');
const PublicBadgeCodeEnum _$publicBadgeCodeEnum_TRUSTED_SUPPLIER =
    const PublicBadgeCodeEnum._('TRUSTED_SUPPLIER');
const PublicBadgeCodeEnum _$publicBadgeCodeEnum_BEST_PRICE =
    const PublicBadgeCodeEnum._('BEST_PRICE');

PublicBadgeCodeEnum _$publicBadgeCodeEnumValueOf(String name) {
  switch (name) {
    case 'FAST_RESPONDER':
      return _$publicBadgeCodeEnum_FAST_RESPONDER;
    case 'ON_TIME':
      return _$publicBadgeCodeEnum_ON_TIME;
    case 'MOST_ORDERED':
      return _$publicBadgeCodeEnum_MOST_ORDERED;
    case 'HIGHLY_RATED':
      return _$publicBadgeCodeEnum_HIGHLY_RATED;
    case 'HIGH_QUALITY_MATERIALS':
      return _$publicBadgeCodeEnum_HIGH_QUALITY_MATERIALS;
    case 'TRUSTED_SUPPLIER':
      return _$publicBadgeCodeEnum_TRUSTED_SUPPLIER;
    case 'BEST_PRICE':
      return _$publicBadgeCodeEnum_BEST_PRICE;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<PublicBadgeCodeEnum> _$publicBadgeCodeEnumValues =
    BuiltSet<PublicBadgeCodeEnum>(const <PublicBadgeCodeEnum>[
  _$publicBadgeCodeEnum_FAST_RESPONDER,
  _$publicBadgeCodeEnum_ON_TIME,
  _$publicBadgeCodeEnum_MOST_ORDERED,
  _$publicBadgeCodeEnum_HIGHLY_RATED,
  _$publicBadgeCodeEnum_HIGH_QUALITY_MATERIALS,
  _$publicBadgeCodeEnum_TRUSTED_SUPPLIER,
  _$publicBadgeCodeEnum_BEST_PRICE,
]);

Serializer<PublicBadgeCodeEnum> _$publicBadgeCodeEnumSerializer =
    _$PublicBadgeCodeEnumSerializer();

class _$PublicBadgeCodeEnumSerializer
    implements PrimitiveSerializer<PublicBadgeCodeEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'FAST_RESPONDER': 'FAST_RESPONDER',
    'ON_TIME': 'ON_TIME',
    'MOST_ORDERED': 'MOST_ORDERED',
    'HIGHLY_RATED': 'HIGHLY_RATED',
    'HIGH_QUALITY_MATERIALS': 'HIGH_QUALITY_MATERIALS',
    'TRUSTED_SUPPLIER': 'TRUSTED_SUPPLIER',
    'BEST_PRICE': 'BEST_PRICE',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'FAST_RESPONDER': 'FAST_RESPONDER',
    'ON_TIME': 'ON_TIME',
    'MOST_ORDERED': 'MOST_ORDERED',
    'HIGHLY_RATED': 'HIGHLY_RATED',
    'HIGH_QUALITY_MATERIALS': 'HIGH_QUALITY_MATERIALS',
    'TRUSTED_SUPPLIER': 'TRUSTED_SUPPLIER',
    'BEST_PRICE': 'BEST_PRICE',
  };

  @override
  final Iterable<Type> types = const <Type>[PublicBadgeCodeEnum];
  @override
  final String wireName = 'PublicBadgeCodeEnum';

  @override
  Object serialize(Serializers serializers, PublicBadgeCodeEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  PublicBadgeCodeEnum deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      PublicBadgeCodeEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$PublicBadge extends PublicBadge {
  @override
  final PublicBadgeCodeEnum code;
  @override
  final String name;
  @override
  final String? scopeLabel;
  @override
  final String description;
  @override
  final DateTime earnedAt;

  factory _$PublicBadge([void Function(PublicBadgeBuilder)? updates]) =>
      (PublicBadgeBuilder()..update(updates))._build();

  _$PublicBadge._(
      {required this.code,
      required this.name,
      this.scopeLabel,
      required this.description,
      required this.earnedAt})
      : super._();
  @override
  PublicBadge rebuild(void Function(PublicBadgeBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PublicBadgeBuilder toBuilder() => PublicBadgeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PublicBadge &&
        code == other.code &&
        name == other.name &&
        scopeLabel == other.scopeLabel &&
        description == other.description &&
        earnedAt == other.earnedAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, code.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, scopeLabel.hashCode);
    _$hash = $jc(_$hash, description.hashCode);
    _$hash = $jc(_$hash, earnedAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PublicBadge')
          ..add('code', code)
          ..add('name', name)
          ..add('scopeLabel', scopeLabel)
          ..add('description', description)
          ..add('earnedAt', earnedAt))
        .toString();
  }
}

class PublicBadgeBuilder implements Builder<PublicBadge, PublicBadgeBuilder> {
  _$PublicBadge? _$v;

  PublicBadgeCodeEnum? _code;
  PublicBadgeCodeEnum? get code => _$this._code;
  set code(PublicBadgeCodeEnum? code) => _$this._code = code;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _scopeLabel;
  String? get scopeLabel => _$this._scopeLabel;
  set scopeLabel(String? scopeLabel) => _$this._scopeLabel = scopeLabel;

  String? _description;
  String? get description => _$this._description;
  set description(String? description) => _$this._description = description;

  DateTime? _earnedAt;
  DateTime? get earnedAt => _$this._earnedAt;
  set earnedAt(DateTime? earnedAt) => _$this._earnedAt = earnedAt;

  PublicBadgeBuilder() {
    PublicBadge._defaults(this);
  }

  PublicBadgeBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _code = $v.code;
      _name = $v.name;
      _scopeLabel = $v.scopeLabel;
      _description = $v.description;
      _earnedAt = $v.earnedAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PublicBadge other) {
    _$v = other as _$PublicBadge;
  }

  @override
  void update(void Function(PublicBadgeBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PublicBadge build() => _build();

  _$PublicBadge _build() {
    final _$result = _$v ??
        _$PublicBadge._(
          code: BuiltValueNullFieldError.checkNotNull(
              code, r'PublicBadge', 'code'),
          name: BuiltValueNullFieldError.checkNotNull(
              name, r'PublicBadge', 'name'),
          scopeLabel: scopeLabel,
          description: BuiltValueNullFieldError.checkNotNull(
              description, r'PublicBadge', 'description'),
          earnedAt: BuiltValueNullFieldError.checkNotNull(
              earnedAt, r'PublicBadge', 'earnedAt'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
