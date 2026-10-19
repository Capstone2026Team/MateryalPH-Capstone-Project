// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'directory_sanction.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const DirectorySanctionActionEnum _$directorySanctionActionEnum_WARNING =
    const DirectorySanctionActionEnum._('WARNING');
const DirectorySanctionActionEnum
    _$directorySanctionActionEnum_TEMPORARY_RESTRICTION =
    const DirectorySanctionActionEnum._('TEMPORARY_RESTRICTION');
const DirectorySanctionActionEnum _$directorySanctionActionEnum_SUSPENSION =
    const DirectorySanctionActionEnum._('SUSPENSION');
const DirectorySanctionActionEnum _$directorySanctionActionEnum_PERMANENT_BAN =
    const DirectorySanctionActionEnum._('PERMANENT_BAN');

DirectorySanctionActionEnum _$directorySanctionActionEnumValueOf(String name) {
  switch (name) {
    case 'WARNING':
      return _$directorySanctionActionEnum_WARNING;
    case 'TEMPORARY_RESTRICTION':
      return _$directorySanctionActionEnum_TEMPORARY_RESTRICTION;
    case 'SUSPENSION':
      return _$directorySanctionActionEnum_SUSPENSION;
    case 'PERMANENT_BAN':
      return _$directorySanctionActionEnum_PERMANENT_BAN;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<DirectorySanctionActionEnum>
    _$directorySanctionActionEnumValues =
    BuiltSet<DirectorySanctionActionEnum>(const <DirectorySanctionActionEnum>[
  _$directorySanctionActionEnum_WARNING,
  _$directorySanctionActionEnum_TEMPORARY_RESTRICTION,
  _$directorySanctionActionEnum_SUSPENSION,
  _$directorySanctionActionEnum_PERMANENT_BAN,
]);

const DirectorySanctionStateEnum _$directorySanctionStateEnum_EFFECTIVE =
    const DirectorySanctionStateEnum._('EFFECTIVE');
const DirectorySanctionStateEnum _$directorySanctionStateEnum_REFERRED =
    const DirectorySanctionStateEnum._('REFERRED');
const DirectorySanctionStateEnum _$directorySanctionStateEnum_APPLIED =
    const DirectorySanctionStateEnum._('APPLIED');
const DirectorySanctionStateEnum _$directorySanctionStateEnum_LIFTED =
    const DirectorySanctionStateEnum._('LIFTED');
const DirectorySanctionStateEnum _$directorySanctionStateEnum_DECLINED =
    const DirectorySanctionStateEnum._('DECLINED');

DirectorySanctionStateEnum _$directorySanctionStateEnumValueOf(String name) {
  switch (name) {
    case 'EFFECTIVE':
      return _$directorySanctionStateEnum_EFFECTIVE;
    case 'REFERRED':
      return _$directorySanctionStateEnum_REFERRED;
    case 'APPLIED':
      return _$directorySanctionStateEnum_APPLIED;
    case 'LIFTED':
      return _$directorySanctionStateEnum_LIFTED;
    case 'DECLINED':
      return _$directorySanctionStateEnum_DECLINED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<DirectorySanctionStateEnum> _$directorySanctionStateEnumValues =
    BuiltSet<DirectorySanctionStateEnum>(const <DirectorySanctionStateEnum>[
  _$directorySanctionStateEnum_EFFECTIVE,
  _$directorySanctionStateEnum_REFERRED,
  _$directorySanctionStateEnum_APPLIED,
  _$directorySanctionStateEnum_LIFTED,
  _$directorySanctionStateEnum_DECLINED,
]);

Serializer<DirectorySanctionActionEnum>
    _$directorySanctionActionEnumSerializer =
    _$DirectorySanctionActionEnumSerializer();
Serializer<DirectorySanctionStateEnum> _$directorySanctionStateEnumSerializer =
    _$DirectorySanctionStateEnumSerializer();

class _$DirectorySanctionActionEnumSerializer
    implements PrimitiveSerializer<DirectorySanctionActionEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'WARNING': 'WARNING',
    'TEMPORARY_RESTRICTION': 'TEMPORARY_RESTRICTION',
    'SUSPENSION': 'SUSPENSION',
    'PERMANENT_BAN': 'PERMANENT_BAN',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'WARNING': 'WARNING',
    'TEMPORARY_RESTRICTION': 'TEMPORARY_RESTRICTION',
    'SUSPENSION': 'SUSPENSION',
    'PERMANENT_BAN': 'PERMANENT_BAN',
  };

  @override
  final Iterable<Type> types = const <Type>[DirectorySanctionActionEnum];
  @override
  final String wireName = 'DirectorySanctionActionEnum';

  @override
  Object serialize(Serializers serializers, DirectorySanctionActionEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  DirectorySanctionActionEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      DirectorySanctionActionEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$DirectorySanctionStateEnumSerializer
    implements PrimitiveSerializer<DirectorySanctionStateEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'EFFECTIVE': 'EFFECTIVE',
    'REFERRED': 'REFERRED',
    'APPLIED': 'APPLIED',
    'LIFTED': 'LIFTED',
    'DECLINED': 'DECLINED',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'EFFECTIVE': 'EFFECTIVE',
    'REFERRED': 'REFERRED',
    'APPLIED': 'APPLIED',
    'LIFTED': 'LIFTED',
    'DECLINED': 'DECLINED',
  };

  @override
  final Iterable<Type> types = const <Type>[DirectorySanctionStateEnum];
  @override
  final String wireName = 'DirectorySanctionStateEnum';

  @override
  Object serialize(Serializers serializers, DirectorySanctionStateEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  DirectorySanctionStateEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      DirectorySanctionStateEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$DirectorySanction extends DirectorySanction {
  @override
  final String id;
  @override
  final DirectorySanctionActionEnum action;
  @override
  final String actionLabel;
  @override
  final DirectorySanctionStateEnum state;
  @override
  final String reason;
  @override
  final DateTime createdAt;
  @override
  final DateTime? expiresAt;

  factory _$DirectorySanction(
          [void Function(DirectorySanctionBuilder)? updates]) =>
      (DirectorySanctionBuilder()..update(updates))._build();

  _$DirectorySanction._(
      {required this.id,
      required this.action,
      required this.actionLabel,
      required this.state,
      required this.reason,
      required this.createdAt,
      this.expiresAt})
      : super._();
  @override
  DirectorySanction rebuild(void Function(DirectorySanctionBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DirectorySanctionBuilder toBuilder() =>
      DirectorySanctionBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DirectorySanction &&
        id == other.id &&
        action == other.action &&
        actionLabel == other.actionLabel &&
        state == other.state &&
        reason == other.reason &&
        createdAt == other.createdAt &&
        expiresAt == other.expiresAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, action.hashCode);
    _$hash = $jc(_$hash, actionLabel.hashCode);
    _$hash = $jc(_$hash, state.hashCode);
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, expiresAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'DirectorySanction')
          ..add('id', id)
          ..add('action', action)
          ..add('actionLabel', actionLabel)
          ..add('state', state)
          ..add('reason', reason)
          ..add('createdAt', createdAt)
          ..add('expiresAt', expiresAt))
        .toString();
  }
}

class DirectorySanctionBuilder
    implements Builder<DirectorySanction, DirectorySanctionBuilder> {
  _$DirectorySanction? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  DirectorySanctionActionEnum? _action;
  DirectorySanctionActionEnum? get action => _$this._action;
  set action(DirectorySanctionActionEnum? action) => _$this._action = action;

  String? _actionLabel;
  String? get actionLabel => _$this._actionLabel;
  set actionLabel(String? actionLabel) => _$this._actionLabel = actionLabel;

  DirectorySanctionStateEnum? _state;
  DirectorySanctionStateEnum? get state => _$this._state;
  set state(DirectorySanctionStateEnum? state) => _$this._state = state;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  DateTime? _expiresAt;
  DateTime? get expiresAt => _$this._expiresAt;
  set expiresAt(DateTime? expiresAt) => _$this._expiresAt = expiresAt;

  DirectorySanctionBuilder() {
    DirectorySanction._defaults(this);
  }

  DirectorySanctionBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _action = $v.action;
      _actionLabel = $v.actionLabel;
      _state = $v.state;
      _reason = $v.reason;
      _createdAt = $v.createdAt;
      _expiresAt = $v.expiresAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DirectorySanction other) {
    _$v = other as _$DirectorySanction;
  }

  @override
  void update(void Function(DirectorySanctionBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DirectorySanction build() => _build();

  _$DirectorySanction _build() {
    final _$result = _$v ??
        _$DirectorySanction._(
          id: BuiltValueNullFieldError.checkNotNull(
              id, r'DirectorySanction', 'id'),
          action: BuiltValueNullFieldError.checkNotNull(
              action, r'DirectorySanction', 'action'),
          actionLabel: BuiltValueNullFieldError.checkNotNull(
              actionLabel, r'DirectorySanction', 'actionLabel'),
          state: BuiltValueNullFieldError.checkNotNull(
              state, r'DirectorySanction', 'state'),
          reason: BuiltValueNullFieldError.checkNotNull(
              reason, r'DirectorySanction', 'reason'),
          createdAt: BuiltValueNullFieldError.checkNotNull(
              createdAt, r'DirectorySanction', 'createdAt'),
          expiresAt: expiresAt,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
