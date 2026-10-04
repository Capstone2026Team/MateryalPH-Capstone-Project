// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dispute_timeline_actor.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const DisputeTimelineActorPartyEnum _$disputeTimelineActorPartyEnum_BUYER =
    const DisputeTimelineActorPartyEnum._('BUYER');
const DisputeTimelineActorPartyEnum _$disputeTimelineActorPartyEnum_VENDOR =
    const DisputeTimelineActorPartyEnum._('VENDOR');
const DisputeTimelineActorPartyEnum _$disputeTimelineActorPartyEnum_ADMIN =
    const DisputeTimelineActorPartyEnum._('ADMIN');
const DisputeTimelineActorPartyEnum _$disputeTimelineActorPartyEnum_SYSTEM =
    const DisputeTimelineActorPartyEnum._('SYSTEM');

DisputeTimelineActorPartyEnum _$disputeTimelineActorPartyEnumValueOf(
    String name) {
  switch (name) {
    case 'BUYER':
      return _$disputeTimelineActorPartyEnum_BUYER;
    case 'VENDOR':
      return _$disputeTimelineActorPartyEnum_VENDOR;
    case 'ADMIN':
      return _$disputeTimelineActorPartyEnum_ADMIN;
    case 'SYSTEM':
      return _$disputeTimelineActorPartyEnum_SYSTEM;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<DisputeTimelineActorPartyEnum>
    _$disputeTimelineActorPartyEnumValues = BuiltSet<
        DisputeTimelineActorPartyEnum>(const <DisputeTimelineActorPartyEnum>[
  _$disputeTimelineActorPartyEnum_BUYER,
  _$disputeTimelineActorPartyEnum_VENDOR,
  _$disputeTimelineActorPartyEnum_ADMIN,
  _$disputeTimelineActorPartyEnum_SYSTEM,
]);

Serializer<DisputeTimelineActorPartyEnum>
    _$disputeTimelineActorPartyEnumSerializer =
    _$DisputeTimelineActorPartyEnumSerializer();

class _$DisputeTimelineActorPartyEnumSerializer
    implements PrimitiveSerializer<DisputeTimelineActorPartyEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'BUYER': 'BUYER',
    'VENDOR': 'VENDOR',
    'ADMIN': 'ADMIN',
    'SYSTEM': 'SYSTEM',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'BUYER': 'BUYER',
    'VENDOR': 'VENDOR',
    'ADMIN': 'ADMIN',
    'SYSTEM': 'SYSTEM',
  };

  @override
  final Iterable<Type> types = const <Type>[DisputeTimelineActorPartyEnum];
  @override
  final String wireName = 'DisputeTimelineActorPartyEnum';

  @override
  Object serialize(
          Serializers serializers, DisputeTimelineActorPartyEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  DisputeTimelineActorPartyEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      DisputeTimelineActorPartyEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$DisputeTimelineActor extends DisputeTimelineActor {
  @override
  final DisputeTimelineActorPartyEnum party;
  @override
  final String? role;
  @override
  final String displayName;

  factory _$DisputeTimelineActor(
          [void Function(DisputeTimelineActorBuilder)? updates]) =>
      (DisputeTimelineActorBuilder()..update(updates))._build();

  _$DisputeTimelineActor._(
      {required this.party, this.role, required this.displayName})
      : super._();
  @override
  DisputeTimelineActor rebuild(
          void Function(DisputeTimelineActorBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DisputeTimelineActorBuilder toBuilder() =>
      DisputeTimelineActorBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DisputeTimelineActor &&
        party == other.party &&
        role == other.role &&
        displayName == other.displayName;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, party.hashCode);
    _$hash = $jc(_$hash, role.hashCode);
    _$hash = $jc(_$hash, displayName.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'DisputeTimelineActor')
          ..add('party', party)
          ..add('role', role)
          ..add('displayName', displayName))
        .toString();
  }
}

class DisputeTimelineActorBuilder
    implements Builder<DisputeTimelineActor, DisputeTimelineActorBuilder> {
  _$DisputeTimelineActor? _$v;

  DisputeTimelineActorPartyEnum? _party;
  DisputeTimelineActorPartyEnum? get party => _$this._party;
  set party(DisputeTimelineActorPartyEnum? party) => _$this._party = party;

  String? _role;
  String? get role => _$this._role;
  set role(String? role) => _$this._role = role;

  String? _displayName;
  String? get displayName => _$this._displayName;
  set displayName(String? displayName) => _$this._displayName = displayName;

  DisputeTimelineActorBuilder() {
    DisputeTimelineActor._defaults(this);
  }

  DisputeTimelineActorBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _party = $v.party;
      _role = $v.role;
      _displayName = $v.displayName;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DisputeTimelineActor other) {
    _$v = other as _$DisputeTimelineActor;
  }

  @override
  void update(void Function(DisputeTimelineActorBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DisputeTimelineActor build() => _build();

  _$DisputeTimelineActor _build() {
    final _$result = _$v ??
        _$DisputeTimelineActor._(
          party: BuiltValueNullFieldError.checkNotNull(
              party, r'DisputeTimelineActor', 'party'),
          role: role,
          displayName: BuiltValueNullFieldError.checkNotNull(
              displayName, r'DisputeTimelineActor', 'displayName'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
