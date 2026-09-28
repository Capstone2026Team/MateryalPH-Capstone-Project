// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auto_accept_policy_version.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AutoAcceptPolicyVersionChangeKindEnum
    _$autoAcceptPolicyVersionChangeKindEnum_CONFIGURED =
    const AutoAcceptPolicyVersionChangeKindEnum._('CONFIGURED');
const AutoAcceptPolicyVersionChangeKindEnum
    _$autoAcceptPolicyVersionChangeKindEnum_ALLOTMENT_UPDATED =
    const AutoAcceptPolicyVersionChangeKindEnum._('ALLOTMENT_UPDATED');
const AutoAcceptPolicyVersionChangeKindEnum
    _$autoAcceptPolicyVersionChangeKindEnum_PAUSED =
    const AutoAcceptPolicyVersionChangeKindEnum._('PAUSED');
const AutoAcceptPolicyVersionChangeKindEnum
    _$autoAcceptPolicyVersionChangeKindEnum_RESUMED =
    const AutoAcceptPolicyVersionChangeKindEnum._('RESUMED');
const AutoAcceptPolicyVersionChangeKindEnum
    _$autoAcceptPolicyVersionChangeKindEnum_EXHAUSTED =
    const AutoAcceptPolicyVersionChangeKindEnum._('EXHAUSTED');
const AutoAcceptPolicyVersionChangeKindEnum
    _$autoAcceptPolicyVersionChangeKindEnum_DISABLED =
    const AutoAcceptPolicyVersionChangeKindEnum._('DISABLED');

AutoAcceptPolicyVersionChangeKindEnum
    _$autoAcceptPolicyVersionChangeKindEnumValueOf(String name) {
  switch (name) {
    case 'CONFIGURED':
      return _$autoAcceptPolicyVersionChangeKindEnum_CONFIGURED;
    case 'ALLOTMENT_UPDATED':
      return _$autoAcceptPolicyVersionChangeKindEnum_ALLOTMENT_UPDATED;
    case 'PAUSED':
      return _$autoAcceptPolicyVersionChangeKindEnum_PAUSED;
    case 'RESUMED':
      return _$autoAcceptPolicyVersionChangeKindEnum_RESUMED;
    case 'EXHAUSTED':
      return _$autoAcceptPolicyVersionChangeKindEnum_EXHAUSTED;
    case 'DISABLED':
      return _$autoAcceptPolicyVersionChangeKindEnum_DISABLED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AutoAcceptPolicyVersionChangeKindEnum>
    _$autoAcceptPolicyVersionChangeKindEnumValues = BuiltSet<
        AutoAcceptPolicyVersionChangeKindEnum>(const <AutoAcceptPolicyVersionChangeKindEnum>[
  _$autoAcceptPolicyVersionChangeKindEnum_CONFIGURED,
  _$autoAcceptPolicyVersionChangeKindEnum_ALLOTMENT_UPDATED,
  _$autoAcceptPolicyVersionChangeKindEnum_PAUSED,
  _$autoAcceptPolicyVersionChangeKindEnum_RESUMED,
  _$autoAcceptPolicyVersionChangeKindEnum_EXHAUSTED,
  _$autoAcceptPolicyVersionChangeKindEnum_DISABLED,
]);

Serializer<AutoAcceptPolicyVersionChangeKindEnum>
    _$autoAcceptPolicyVersionChangeKindEnumSerializer =
    _$AutoAcceptPolicyVersionChangeKindEnumSerializer();

class _$AutoAcceptPolicyVersionChangeKindEnumSerializer
    implements PrimitiveSerializer<AutoAcceptPolicyVersionChangeKindEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'CONFIGURED': 'CONFIGURED',
    'ALLOTMENT_UPDATED': 'ALLOTMENT_UPDATED',
    'PAUSED': 'PAUSED',
    'RESUMED': 'RESUMED',
    'EXHAUSTED': 'EXHAUSTED',
    'DISABLED': 'DISABLED',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'CONFIGURED': 'CONFIGURED',
    'ALLOTMENT_UPDATED': 'ALLOTMENT_UPDATED',
    'PAUSED': 'PAUSED',
    'RESUMED': 'RESUMED',
    'EXHAUSTED': 'EXHAUSTED',
    'DISABLED': 'DISABLED',
  };

  @override
  final Iterable<Type> types = const <Type>[
    AutoAcceptPolicyVersionChangeKindEnum
  ];
  @override
  final String wireName = 'AutoAcceptPolicyVersionChangeKindEnum';

  @override
  Object serialize(
          Serializers serializers, AutoAcceptPolicyVersionChangeKindEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  AutoAcceptPolicyVersionChangeKindEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      AutoAcceptPolicyVersionChangeKindEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$AutoAcceptPolicyVersion extends AutoAcceptPolicyVersion {
  @override
  final int version;
  @override
  final AutoAcceptPolicyVersionChangeKindEnum changeKind;
  @override
  final bool enabled;
  @override
  final bool paused;
  @override
  final String? pauseReason;
  @override
  final String allotmentQuantity;
  @override
  final String remainingAllotmentQuantity;
  @override
  final String? maxUnitCount;
  @override
  final int? maxOrderAmountCentavos;
  @override
  final String? createdAt;
  @override
  final bool automated;
  @override
  final String actor;

  factory _$AutoAcceptPolicyVersion(
          [void Function(AutoAcceptPolicyVersionBuilder)? updates]) =>
      (AutoAcceptPolicyVersionBuilder()..update(updates))._build();

  _$AutoAcceptPolicyVersion._(
      {required this.version,
      required this.changeKind,
      required this.enabled,
      required this.paused,
      this.pauseReason,
      required this.allotmentQuantity,
      required this.remainingAllotmentQuantity,
      this.maxUnitCount,
      this.maxOrderAmountCentavos,
      this.createdAt,
      required this.automated,
      required this.actor})
      : super._();
  @override
  AutoAcceptPolicyVersion rebuild(
          void Function(AutoAcceptPolicyVersionBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AutoAcceptPolicyVersionBuilder toBuilder() =>
      AutoAcceptPolicyVersionBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AutoAcceptPolicyVersion &&
        version == other.version &&
        changeKind == other.changeKind &&
        enabled == other.enabled &&
        paused == other.paused &&
        pauseReason == other.pauseReason &&
        allotmentQuantity == other.allotmentQuantity &&
        remainingAllotmentQuantity == other.remainingAllotmentQuantity &&
        maxUnitCount == other.maxUnitCount &&
        maxOrderAmountCentavos == other.maxOrderAmountCentavos &&
        createdAt == other.createdAt &&
        automated == other.automated &&
        actor == other.actor;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, version.hashCode);
    _$hash = $jc(_$hash, changeKind.hashCode);
    _$hash = $jc(_$hash, enabled.hashCode);
    _$hash = $jc(_$hash, paused.hashCode);
    _$hash = $jc(_$hash, pauseReason.hashCode);
    _$hash = $jc(_$hash, allotmentQuantity.hashCode);
    _$hash = $jc(_$hash, remainingAllotmentQuantity.hashCode);
    _$hash = $jc(_$hash, maxUnitCount.hashCode);
    _$hash = $jc(_$hash, maxOrderAmountCentavos.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, automated.hashCode);
    _$hash = $jc(_$hash, actor.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AutoAcceptPolicyVersion')
          ..add('version', version)
          ..add('changeKind', changeKind)
          ..add('enabled', enabled)
          ..add('paused', paused)
          ..add('pauseReason', pauseReason)
          ..add('allotmentQuantity', allotmentQuantity)
          ..add('remainingAllotmentQuantity', remainingAllotmentQuantity)
          ..add('maxUnitCount', maxUnitCount)
          ..add('maxOrderAmountCentavos', maxOrderAmountCentavos)
          ..add('createdAt', createdAt)
          ..add('automated', automated)
          ..add('actor', actor))
        .toString();
  }
}

class AutoAcceptPolicyVersionBuilder
    implements
        Builder<AutoAcceptPolicyVersion, AutoAcceptPolicyVersionBuilder> {
  _$AutoAcceptPolicyVersion? _$v;

  int? _version;
  int? get version => _$this._version;
  set version(int? version) => _$this._version = version;

  AutoAcceptPolicyVersionChangeKindEnum? _changeKind;
  AutoAcceptPolicyVersionChangeKindEnum? get changeKind => _$this._changeKind;
  set changeKind(AutoAcceptPolicyVersionChangeKindEnum? changeKind) =>
      _$this._changeKind = changeKind;

  bool? _enabled;
  bool? get enabled => _$this._enabled;
  set enabled(bool? enabled) => _$this._enabled = enabled;

  bool? _paused;
  bool? get paused => _$this._paused;
  set paused(bool? paused) => _$this._paused = paused;

  String? _pauseReason;
  String? get pauseReason => _$this._pauseReason;
  set pauseReason(String? pauseReason) => _$this._pauseReason = pauseReason;

  String? _allotmentQuantity;
  String? get allotmentQuantity => _$this._allotmentQuantity;
  set allotmentQuantity(String? allotmentQuantity) =>
      _$this._allotmentQuantity = allotmentQuantity;

  String? _remainingAllotmentQuantity;
  String? get remainingAllotmentQuantity => _$this._remainingAllotmentQuantity;
  set remainingAllotmentQuantity(String? remainingAllotmentQuantity) =>
      _$this._remainingAllotmentQuantity = remainingAllotmentQuantity;

  String? _maxUnitCount;
  String? get maxUnitCount => _$this._maxUnitCount;
  set maxUnitCount(String? maxUnitCount) => _$this._maxUnitCount = maxUnitCount;

  int? _maxOrderAmountCentavos;
  int? get maxOrderAmountCentavos => _$this._maxOrderAmountCentavos;
  set maxOrderAmountCentavos(int? maxOrderAmountCentavos) =>
      _$this._maxOrderAmountCentavos = maxOrderAmountCentavos;

  String? _createdAt;
  String? get createdAt => _$this._createdAt;
  set createdAt(String? createdAt) => _$this._createdAt = createdAt;

  bool? _automated;
  bool? get automated => _$this._automated;
  set automated(bool? automated) => _$this._automated = automated;

  String? _actor;
  String? get actor => _$this._actor;
  set actor(String? actor) => _$this._actor = actor;

  AutoAcceptPolicyVersionBuilder() {
    AutoAcceptPolicyVersion._defaults(this);
  }

  AutoAcceptPolicyVersionBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _version = $v.version;
      _changeKind = $v.changeKind;
      _enabled = $v.enabled;
      _paused = $v.paused;
      _pauseReason = $v.pauseReason;
      _allotmentQuantity = $v.allotmentQuantity;
      _remainingAllotmentQuantity = $v.remainingAllotmentQuantity;
      _maxUnitCount = $v.maxUnitCount;
      _maxOrderAmountCentavos = $v.maxOrderAmountCentavos;
      _createdAt = $v.createdAt;
      _automated = $v.automated;
      _actor = $v.actor;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AutoAcceptPolicyVersion other) {
    _$v = other as _$AutoAcceptPolicyVersion;
  }

  @override
  void update(void Function(AutoAcceptPolicyVersionBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AutoAcceptPolicyVersion build() => _build();

  _$AutoAcceptPolicyVersion _build() {
    final _$result = _$v ??
        _$AutoAcceptPolicyVersion._(
          version: BuiltValueNullFieldError.checkNotNull(
              version, r'AutoAcceptPolicyVersion', 'version'),
          changeKind: BuiltValueNullFieldError.checkNotNull(
              changeKind, r'AutoAcceptPolicyVersion', 'changeKind'),
          enabled: BuiltValueNullFieldError.checkNotNull(
              enabled, r'AutoAcceptPolicyVersion', 'enabled'),
          paused: BuiltValueNullFieldError.checkNotNull(
              paused, r'AutoAcceptPolicyVersion', 'paused'),
          pauseReason: pauseReason,
          allotmentQuantity: BuiltValueNullFieldError.checkNotNull(
              allotmentQuantity,
              r'AutoAcceptPolicyVersion',
              'allotmentQuantity'),
          remainingAllotmentQuantity: BuiltValueNullFieldError.checkNotNull(
              remainingAllotmentQuantity,
              r'AutoAcceptPolicyVersion',
              'remainingAllotmentQuantity'),
          maxUnitCount: maxUnitCount,
          maxOrderAmountCentavos: maxOrderAmountCentavos,
          createdAt: createdAt,
          automated: BuiltValueNullFieldError.checkNotNull(
              automated, r'AutoAcceptPolicyVersion', 'automated'),
          actor: BuiltValueNullFieldError.checkNotNull(
              actor, r'AutoAcceptPolicyVersion', 'actor'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
