// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'enforcement_subject_match.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const EnforcementSubjectMatchTypeEnum _$enforcementSubjectMatchTypeEnum_BUYER =
    const EnforcementSubjectMatchTypeEnum._('BUYER');
const EnforcementSubjectMatchTypeEnum
    _$enforcementSubjectMatchTypeEnum_VENDOR_ORGANIZATION =
    const EnforcementSubjectMatchTypeEnum._('VENDOR_ORGANIZATION');

EnforcementSubjectMatchTypeEnum _$enforcementSubjectMatchTypeEnumValueOf(
    String name) {
  switch (name) {
    case 'BUYER':
      return _$enforcementSubjectMatchTypeEnum_BUYER;
    case 'VENDOR_ORGANIZATION':
      return _$enforcementSubjectMatchTypeEnum_VENDOR_ORGANIZATION;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<EnforcementSubjectMatchTypeEnum>
    _$enforcementSubjectMatchTypeEnumValues = BuiltSet<
        EnforcementSubjectMatchTypeEnum>(const <EnforcementSubjectMatchTypeEnum>[
  _$enforcementSubjectMatchTypeEnum_BUYER,
  _$enforcementSubjectMatchTypeEnum_VENDOR_ORGANIZATION,
]);

Serializer<EnforcementSubjectMatchTypeEnum>
    _$enforcementSubjectMatchTypeEnumSerializer =
    _$EnforcementSubjectMatchTypeEnumSerializer();

class _$EnforcementSubjectMatchTypeEnumSerializer
    implements PrimitiveSerializer<EnforcementSubjectMatchTypeEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'BUYER': 'BUYER',
    'VENDOR_ORGANIZATION': 'VENDOR_ORGANIZATION',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'BUYER': 'BUYER',
    'VENDOR_ORGANIZATION': 'VENDOR_ORGANIZATION',
  };

  @override
  final Iterable<Type> types = const <Type>[EnforcementSubjectMatchTypeEnum];
  @override
  final String wireName = 'EnforcementSubjectMatchTypeEnum';

  @override
  Object serialize(
          Serializers serializers, EnforcementSubjectMatchTypeEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  EnforcementSubjectMatchTypeEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      EnforcementSubjectMatchTypeEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$EnforcementSubjectMatch extends EnforcementSubjectMatch {
  @override
  final EnforcementSubjectMatchTypeEnum type;
  @override
  final String id;
  @override
  final String displayName;
  @override
  final String status;

  factory _$EnforcementSubjectMatch(
          [void Function(EnforcementSubjectMatchBuilder)? updates]) =>
      (EnforcementSubjectMatchBuilder()..update(updates))._build();

  _$EnforcementSubjectMatch._(
      {required this.type,
      required this.id,
      required this.displayName,
      required this.status})
      : super._();
  @override
  EnforcementSubjectMatch rebuild(
          void Function(EnforcementSubjectMatchBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  EnforcementSubjectMatchBuilder toBuilder() =>
      EnforcementSubjectMatchBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is EnforcementSubjectMatch &&
        type == other.type &&
        id == other.id &&
        displayName == other.displayName &&
        status == other.status;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, type.hashCode);
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, displayName.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'EnforcementSubjectMatch')
          ..add('type', type)
          ..add('id', id)
          ..add('displayName', displayName)
          ..add('status', status))
        .toString();
  }
}

class EnforcementSubjectMatchBuilder
    implements
        Builder<EnforcementSubjectMatch, EnforcementSubjectMatchBuilder> {
  _$EnforcementSubjectMatch? _$v;

  EnforcementSubjectMatchTypeEnum? _type;
  EnforcementSubjectMatchTypeEnum? get type => _$this._type;
  set type(EnforcementSubjectMatchTypeEnum? type) => _$this._type = type;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _displayName;
  String? get displayName => _$this._displayName;
  set displayName(String? displayName) => _$this._displayName = displayName;

  String? _status;
  String? get status => _$this._status;
  set status(String? status) => _$this._status = status;

  EnforcementSubjectMatchBuilder() {
    EnforcementSubjectMatch._defaults(this);
  }

  EnforcementSubjectMatchBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _type = $v.type;
      _id = $v.id;
      _displayName = $v.displayName;
      _status = $v.status;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(EnforcementSubjectMatch other) {
    _$v = other as _$EnforcementSubjectMatch;
  }

  @override
  void update(void Function(EnforcementSubjectMatchBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  EnforcementSubjectMatch build() => _build();

  _$EnforcementSubjectMatch _build() {
    final _$result = _$v ??
        _$EnforcementSubjectMatch._(
          type: BuiltValueNullFieldError.checkNotNull(
              type, r'EnforcementSubjectMatch', 'type'),
          id: BuiltValueNullFieldError.checkNotNull(
              id, r'EnforcementSubjectMatch', 'id'),
          displayName: BuiltValueNullFieldError.checkNotNull(
              displayName, r'EnforcementSubjectMatch', 'displayName'),
          status: BuiltValueNullFieldError.checkNotNull(
              status, r'EnforcementSubjectMatch', 'status'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
